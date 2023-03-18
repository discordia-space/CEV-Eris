#define EFLAG_EXPONENTIALFALLOFF 1
#define EFLAG_ADDITIVEFALLOFF 2

#define SPARE_HASH_LISTS 200
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
				target_power = explodey.hashed_power[turf_key]
				explodey.current_turf_queue -= target
				explodey.hashed_visited[turf_key] = TRUE
				new /obj/effect/explosion_fire(target)
				target_power -= target.explosion_act(target_power)
				if(target_power < 10)
					continue
				if(target_power - explodey.falloff > 10)
					for(var/dir in list(NORTH,SOUTH,EAST,WEST))
						var/turf/next = get_step(target,dir)
						if(!next)
							continue
						var/temp_key = EXPLO_HASH(next.x, next.y)
						if(explodey.hashed_visited[temp_key])
							continue
						explodey.turf_queue += next
						explodey.hashed_power[temp_key] = target_power - explodey.falloff
						explodey.hashed_visited[temp_key] = TRUE
			explodey.iterations++
			if(explodey.flags & EFLAG_EXPONENTIALFALLOFF)
				explodey.falloff *= 2
			if(explodey.flags & EFLAG_ADDITIVEFALLOFF)
				explodey.falloff += explodey.falloff

			// Explosion is done , nothing else left to iterate , cleanup and etc.
			if(!length(explodey.turf_queue))

				explode_queue -= explodey
				var/i = length(available_hash_lists) + 1
				for(var/cleaner = 1; cleaner <= HASH_MODULO; cleaner++)
					explodey.hashed_visited[cleaner] = 0
					explodey.hashed_power[cleaner] = 0
				while(i > 1)
					i--
					if(available_hash_lists[i] != null)
						continue
					if(explodey.hashed_visited != null)
						available_hash_lists[i] = explodey.hashed_visited
						explodey.hashed_visited = null
					else if(explodey.hashed_power != null)
						available_hash_lists[i] = explodey.hashed_power
						explodey.hashed_power = null
					else break
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

	return power_reduction

explosion_handler
	var/turf/epicenter
	var/power
	var/falloff
	var/list/turf_queue = list()
	var/list/hashed_power
	var/list/hashed_visited
	/// Used for letting us know how many iterations were already ran
	var/iterations = 0
	var/list/current_turf_queue
	var/flags

explosion_handler/New(turf/loc, power, falloff)
	..()
	turf_queue += loc
	/* Blame BYOND , putting it up here gives you a EEOS/expected end  of statement error .
	var/turf_key = round((loc.x + loc.y*world.maxy))
	turf_key = turf_key % HASH_MODULO
	*/
	src.epicenter = loc
	src.power = power
	src.falloff = falloff
	src.flags = flags
	var/turf_key = EXPLO_HASH(loc.x, loc.y)
	var/i = length(SSexplosions.available_hash_lists) + 1
	while(i > 1)
		i--
		if(SSexplosions.available_hash_lists[i] == null)
			continue
		if(hashed_visited == null)
			hashed_visited = SSexplosions.available_hash_lists[i]
			// We reserve it for ourselves
			SSexplosions.available_hash_lists[i] = null
		else if(hashed_power == null)
			hashed_power = SSexplosions.available_hash_lists[i]
			SSexplosions.available_hash_lists[i] = null
		else break
	if(!length(hashed_visited))
		message_admins("Explosion created a visit list")
		hashed_visited = new /list(HASH_MODULO)
	if(!length(hashed_power))
		message_admins("Explosion created a power list")
		hashed_power = new /list(HASH_MODULO)
	hashed_power[turf_key] = power

/turf/proc/test_explosion()
	var/power
	var/falloff
	power = input(usr, "Explo power", "Explodeee", 100) as num
	falloff = input(usr,"Explo falloff", "Exploodee",20) as num
	SSexplosions.start_explosion(src, power, falloff)

