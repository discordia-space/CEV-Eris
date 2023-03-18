#define EFLAG_EXPONENTIALFALLOFF 1
#define EFLAG_ADDITIVEFALLOFF 2

#define EXPLOSION_MINIMUM_THRESHOLD 10
#define EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD 100

#define SPARE_HASH_LISTS 400
#define HASH_MODULO (world.maxx + world.maxx*world.maxy)
#define EXPLO_HASH(x,y) (round((x+y*world.maxx)%HASH_MODULO))


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
	var/turfs_processed = 0
	var/turf_key = null
	for(var/explosion_handler/explodey as anything in current_run)
		var/times_ticked = 0
		// Go twice, so the stress on ZAS rebuilding is reduced.
		while(times_ticked < 2)
			times_ticked++
			// Explosion processing itself.
			while(length(explodey.current_turf_queue))
				turfs_processed++
				var/turf/target = explodey.current_turf_queue[length(explodey.current_turf_queue)]
				if(!target || QDELETED(target))
					explodey.current_turf_queue -= target
					continue
				turf_key = EXPLO_HASH(target.x, target.y)
				target_power = explodey.hashed_power[target.z][turf_key]
				explodey.current_turf_queue -= target
				explodey.hashed_visited[target.z][turf_key] = TRUE
				new /obj/effect/explosion_fire(target)
				target_power -= target.explosion_act(target_power)
				if(target_power < EXPLOSION_MINIMUM_THRESHOLD)
					continue
				// Run these first so the ones coming from below/above don't get calculated first.
				if(target_power - explodey.falloff > EXPLOSION_MINIMUM_THRESHOLD)
					for(var/dir in list(NORTH,SOUTH,EAST,WEST))
						var/turf/next = get_step(target,dir)
						if(QDELETED(next))
							continue
						var/temp_key = EXPLO_HASH(next.x, next.y)
						if(explodey.hashed_visited[next.z][temp_key])
							continue
						explodey.turf_queue += next
						explodey.hashed_power[next.z][temp_key] = target_power - explodey.falloff
						explodey.hashed_visited[next.z][temp_key] = TRUE
				// For Up and Down , we use the turf  key since its valid
				if(target_power - explodey.falloff - EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD > EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD)
					var/turf/checking = GetAbove(target)
					if(!QDELETED(checking) && istype(checking, /turf/simulated/open))
						// Startup for first time
						if(explodey.hashed_visited[checking.z] == null)
							explodey.hashed_visited[checking.z] = SSexplosions.retrieveHashList()
							explodey.hashed_power[checking.z] = SSexplosions.retrieveHashList()
							if(checking.z > explodey.maximum_z)
								explodey.maximum_z = checking.z
						// Actual spread code
						if(!explodey.hashed_visited[checking.z][turf_key])
							explodey.hashed_visited[checking.z][turf_key] = TRUE
							explodey.hashed_power[checking.z][turf_key] = target_power - explodey.falloff - EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD
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
								explodey.hashed_power[checking.z][turf_key] = target_power - explodey.falloff - EXPLOSION_ZTRANSFER_MINIMUM_THRESHOLD
								explodey.turf_queue += checking

			explodey.iterations++
			if(explodey.flags & EFLAG_EXPONENTIALFALLOFF)
				explodey.falloff *= 2
			if(explodey.flags & EFLAG_ADDITIVEFALLOFF)
				explodey.falloff += explodey.falloff

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

			explodey.current_turf_queue = explodey.turf_queue.Copy()
			explodey.turf_queue = list()
			current_run -= explodey
	current_run = explode_queue.Copy()


/datum/controller/subsystem/explosions/proc/start_explosion(turf/epicenter, power, falloff)
	var/reference = new /explosion_handler(epicenter, power, falloff)
	explode_queue += reference

/turf/explosion_act(target_power)
	var/power_reduction = 0
	for(var/atom/movable/thing as anything in contents)
		if(thing.simulated && isobj(thing))
			power_reduction += thing.explosion_act(target_power)
	/*
	var/turf/to_propagate = GetAbove(src)
	if(to_propagate)
		to_propagate.explosion_act_below(target_power)
	to_propagate = GetBelow(src)
	if(to_propagate)
		to_propagate.explosion_act_above(target_power)
	*/



	return power_reduction
/*
/turf/proc/explosion_act_below(target_power)
	return 0

/turf/proc/explosion_act_above(target_power)
	return 0
*/

explosion_handler
	var/turf/epicenter
	var/power
	var/falloff
	var/maximum_z = 0
	var/minimum_z = 0
	var/list/turf_queue = list()
	var/list/hashed_power
	var/list/hashed_visited
	/// Used for letting us know how many iterations were already ran
	var/iterations = 0
	var/list/current_turf_queue
	/// When we traverse Z-levels , we create a new handler.
	var/flags

explosion_handler/New(turf/loc, power, falloff, flags)
	..()
	turf_queue += loc
	src.epicenter = loc
	src.power = power
	src.falloff = falloff
	src.flags = flags
	hashed_power = new /list(world.maxz)
	hashed_visited = new /list(world.maxz)

	hashed_power[loc.z] = SSexplosions.retrieveHashList()
	hashed_visited[loc.z] = SSexplosions.retrieveHashList()
	hashed_power[loc.z][EXPLO_HASH(loc.x, loc.y)] = power
	maximum_z = minimum_z = loc.z

/turf/proc/test_explosion()
	var/power
	var/falloff
	power = input(usr, "Explo power", "Explodeee", 100) as num
	falloff = input(usr,"Explo falloff", "Exploodee",20) as num
	SSexplosions.start_explosion(src, power, falloff)

