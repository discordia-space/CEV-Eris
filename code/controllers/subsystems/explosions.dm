#define EFLAG_EXPONENTIALFALLOFF 1
#define EFLAG_ADDITIVEFALLOFF 2
#define EFLAG_HALVEFALLOFF 4

#define EXPLOSION_MINIMUM_THRESHOLD 10
#define EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD 500

#define SPARE_HASH_LISTS 400
#define HASH_MODULO (world.maxx + world.maxx*world.maxy)
#define EXPLO_HASH(x,y) (round((x+y*world.maxx)%HASH_MODULO))

/*
A subsystem for handling explosions in a tick-based manner
Basic functioning
Explosions initialize with a cache of X hash lists , as many as are put in the define , each of these lists is immense
and has a slot for every turf on a map. This is done like this because as a explosion gets bigger , its look-up using its own reference becomes exponentially higher.
With hashing the lookup its at O(1)
Unlike other SS, it doesn't use the MC resume system , instead if just keeps processing current_run until its all done and makes up a new queue itself

The Fire() proc.
Each explosion handler(which is created for every explosion , no matter the size) is processed twice
A process involves checking its current turf queue, which could have leftovers from the last tick which might've not fully processed and running the explosion checks for each turf inside
Each turf will call explosion_act on its own turf , Explosion_act is expected to only return a value if it should reduce the explosion power for the future spread(Shield , Door, Barricade , etc etc)
^This is not done in a queued manner , every item will receive the same explosion_act with the same power , the return value will just reduce it for the neighbouring turfs.
After the explosion_act , the remaining power of the explosion is checked , if its above the defined minimum, it will check adjaecent turfs and upper and above turfs
Each turf to spread towards is checked for being visited before , and if not , added to the visited list, along with the power it should have. They add themselves to the visited list at this step to prevent
double-turfs, which you get when 2 turfs share the same corner
If the turfs to spread to are fully valid , they are added to the turf_queue , which will eventually replace the current turf queue on the explosion handler as soon as its empty.
For upper and lower turfs , the explosion handler grabs extra lists from the SS as needed when spreading to them, it also reduces the power by the explosion_ztransfer  threshold define. Ideally you'd want explosions
to spread up and down freely , but due to memory constraints ive limited it with a reduction of 100 in its power
If the turf queue of a handler is empty after processing, it will be removed from the queue, and have the hashed lists returned to the SS stack.

As an end note , there are still possible optimizations to do, more specifically
Remove the need for multiple visited hash list , and just use binary representations for each z-level (can support up to 32 this way without extra memory usage in 1 list)
Make the obj fire effect use vis_Contents without losing them on turf change
Optimize turf changes/updates ,make turf proc/take_damage() detached from the source(set src = null) so it can continue executing after the original turf gets deleted(and so it can take out lattices)






*/


SUBSYSTEM_DEF(explosions)
	name = "Explosions"
	wait = 1 // very small
	priority = FIRE_PRIORITY_EXPLOSIONS
	init_order = INIT_ORDER_EXPLOSIONS
	flags = SS_KEEP_TIMING
	var/list/explode_queue = list()
	var/list/current_run = list()
	var/list/throwing_queue = list()
	var/list/available_hash_lists

/datum/controller/subsystem/explosions/Initialize(timeoftheworld)
	// Each hashed list is extremly huge , as it stands today each one would be
	// 0.250~ MB(roughly 2 million bits)
	// As long as this doesnt go over 12 MB , it should be fine as it still fits in CPU caches
	// So memory allocated for explosion management * SPARE_HASH_LIST
	// For 20 , we get 5 MB allocated to this(not a whole lot) , but generally we shouldn't need more than 100 spare lists(who expects 50 explosions to happen at once ?)
	// For 200 its 50 MB , so not that much.
	available_hash_lists = new /list(SPARE_HASH_LISTS)
	for(var/i = 1,i <= SPARE_HASH_LISTS,i++)
		available_hash_lists[i] = new /list(HASH_MODULO)
	return ..()

/datum/controller/subsystem/explosions/proc/retrieveHashList()
	var/i = length(SSexplosions.available_hash_lists) + 1
	while(i > 1)
		i--
		if(SSexplosions.available_hash_lists[i] == null)
			continue
		. = SSexplosions.available_hash_lists[i]
		SSexplosions.available_hash_lists[i] = null
		return
	message_admins("ExplosionSS didn't have any free hash list, creating a temporary one.")
	return new /list(HASH_MODULO)

/datum/controller/subsystem/explosions/proc/returnHashList(listref)
	if(listref == null)
		return
	var/i = length(SSexplosions.available_hash_lists) + 1
	while(i > 1)
		i--
		if(SSexplosions.available_hash_lists[i] != null)
			continue
		SSexplosions.available_hash_lists[i] = listref
		return
	message_admins("ExplosionSS didn't have any free spot to return a hashlist")


/datum/controller/subsystem/explosions/fire(resumed = FALSE)
	var/target_power = 0
	var/turf_key = null
	for(var/explosion_handler/explodey as anything in current_run)
		var/times_ticked = 0
		// Go twice, so the stress on ZAS rebuilding zones is reduced.
		while(times_ticked < 2)
			times_ticked++
			// Explosion processing itself.
			while(length(explodey.current_turf_queue))
				var/turf/target = explodey.current_turf_queue[length(explodey.current_turf_queue)]
				// Invalid turf??
				if(!target || QDELETED(target))
					explodey.current_turf_queue -= target
					continue
				turf_key = EXPLO_HASH(target.x, target.y)
				target_power = explodey.hashed_power[target.z][turf_key]
				explodey.current_turf_queue -= target
				explodey.hashed_visited[target.z][turf_key] = TRUE
				target_power -= target.explosion_act(target_power, explodey) + explodey.falloff
				if(explodey.flags & EFLAG_HALVEFALLOFF)
					target_power /= 2
				new /obj/effect/explosion_fire(target)
				if(target_power < EXPLOSION_MINIMUM_THRESHOLD)
					continue
				// Run these first so the ones coming from below/above don't get calculated first.
				if(target_power > EXPLOSION_MINIMUM_THRESHOLD)
					for(var/dir in list(NORTH,SOUTH,EAST,WEST))
						var/turf/next = get_step(target,dir)
						if(QDELETED(next))
							continue
						var/temp_key = EXPLO_HASH(next.x, next.y)
						if(explodey.hashed_visited[next.z][temp_key])
							continue
						explodey.turf_queue += next
						explodey.hashed_power[next.z][temp_key] = target_power
						explodey.hashed_visited[next.z][temp_key] = TRUE
				// For Up and Down , we use the turf  key since its valid
				target_power -= EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD
				if(target_power > EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD)
					var/turf/checking = GetAbove(target)
					if(!QDELETED(checking) && istype(checking, /turf/simulated/open))
						// Startup for first time, kind of ineefficient , but better than distributing the lists willy nilly
						if(explodey.hashed_visited[checking.z] == null)
							explodey.hashed_visited[checking.z] = SSexplosions.retrieveHashList()
							explodey.hashed_power[checking.z] = SSexplosions.retrieveHashList()
							if(checking.z > explodey.maximum_z)
								explodey.maximum_z = checking.z
						// Actual spread code
						if(!explodey.hashed_visited[checking.z][turf_key])
							explodey.hashed_visited[checking.z][turf_key] = TRUE
							explodey.hashed_power[checking.z][turf_key] = target_power
							explodey.turf_queue += checking
					if(istype(target, /turf/simulated/open))
						checking = GetBelow(target)
						if(!QDELETED(checking))
							// Startup for first time
							if(explodey.hashed_visited[checking.z] == null)
								explodey.hashed_visited[checking.z] = SSexplosions.retrieveHashList()
								explodey.hashed_power[checking.z] = SSexplosions.retrieveHashList()
								if(checking.z < explodey.minimum_z)
									explodey.minimum_z = checking.z
							// Acual spread code
							if(!explodey.hashed_visited[checking.z][turf_key])
								explodey.hashed_visited[checking.z][turf_key] = TRUE
								explodey.hashed_power[checking.z][turf_key] = target_power
								explodey.turf_queue += checking
			// For funky explosive options, end of explosion anyway
			explodey.iterations++
			if(explodey.flags & EFLAG_EXPONENTIALFALLOFF)
				explodey.falloff ^= 2
			if(explodey.flags & EFLAG_ADDITIVEFALLOFF)
				explodey.falloff += explodey.initial_falloff

			// Explosion is done , nothing else left to iterate , cleanup and etc.
			if(!length(explodey.turf_queue))

				explode_queue -= explodey
				for(var/cleaner = 1; cleaner <= HASH_MODULO; cleaner++)
					for(var/cur_z = explodey.minimum_z , cur_z <= explodey.maximum_z, cur_z++)
						explodey.hashed_visited[cur_z][cleaner] = 0
						explodey.hashed_power[cur_z][cleaner] = 0
				for(var/cur_z = explodey.minimum_z , cur_z <= explodey.maximum_z, cur_z++)
					SSexplosions.returnHashList(explodey.hashed_visited[cur_z])
					SSexplosions.returnHashList(explodey.hashed_power[cur_z])
				qdel(explodey)
				break
			// If explosion is not done , just copy the turf queue , and keep it for the next run.
			explodey.current_turf_queue = explodey.turf_queue.Copy()
			explodey.turf_queue = list()
			current_run -= explodey
	current_run = explode_queue.Copy()


/datum/controller/subsystem/explosions/proc/start_explosion(turf/epicenter, power, falloff, explosion_flags)
	var/reference = new /explosion_handler(epicenter, power, falloff, explosion_flags)
	explode_queue += reference

/turf/proc/take_damage(target_power, damage_type)
	return 0

// Explosion action proc , should never SLEEP, and should avoid icon updates , overlays and other visual stuff as much as possible , since they cause massive time delays
// in processing.
/turf/explosion_act(target_power, explosion_handler/handler)
	var/power_reduction = 0
	for(var/atom/movable/thing as anything in contents)
		if(thing.simulated)
			power_reduction += thing.explosion_act(target_power, handler)
			if(!QDELETED(thing) && isobj(thing) && !thing.anchored)
				thing.throw_at(get_turf_away_from_target_simple(src, islist(handler.epicenter ? handler.epicenter[1] : handler.epicenter)), round(target_power / 30))
	var/turf/to_propagate = GetAbove(src)
	if(to_propagate && target_power - EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD > EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD)
		to_propagate.take_damage(target_power - EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD, BLAST)

	return power_reduction


explosion_handler
	// Source turf
	var/turf/epicenter
	// Starting power
	var/power
	// Falloff per tile
	var/falloff
	// Initial falloff that wont change
	var/initial_falloff
	// Used for cleanup
	var/maximum_z = 0
	var/minimum_z = 0
	// Queue holding the next turfs to process
	var/list/turf_queue = list()
	// Lists using hashed keys for accesing
	var/list/hashed_power
	var/list/hashed_visited
	/// Used for letting us know how many iterations were already ran
	var/iterations = 0
	// Queue holding currently processing turfs
	var/list/current_turf_queue
	/// Various flags
	var/flags

explosion_handler/New(turf/loc, power, falloff, flags)
	..()
	src.epicenter = loc
	src.power = power
	src.falloff = falloff
	initial_falloff = falloff
	src.flags = flags
	hashed_power = new /list(world.maxz)
	hashed_visited = new /list(world.maxz)
	if(!islist(loc))
		turf_queue += loc
		hashed_power[loc.z] = SSexplosions.retrieveHashList()
		hashed_visited[loc.z] = SSexplosions.retrieveHashList()
		hashed_power[loc.z][EXPLO_HASH(loc.x, loc.y)] = power
	else
		var/list/locations = loc
		for(var/turf/target in locations)
			turf_queue += target
			if(hashed_power[target.z] == null)
				hashed_power[target.z] = SSexplosions.retrieveHashList()
			if(hashed_visited[target.z] == null)
				hashed_visited[target.z] = SSexplosions.retrieveHashList()
			hashed_power[target.z][EXPLO_HASH(target.x, target.y)] = power
	maximum_z = minimum_z = loc.z

/turf/proc/test_explosion()
	var/power
	var/falloff
	power = input(usr, "Explo power", "Explodeee", 100) as num
	falloff = input(usr,"Explo falloff", "Exploodee",20) as num
	SSexplosions.start_explosion(src, power, falloff)

