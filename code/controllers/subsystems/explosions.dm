#define TURFS_PER_PROCESS_LIMIT 999
#define SPARE_HASH_LISTS 200
#define HASH_MODULO (world.maxx + world.maxy*world.maxy)
#define EXPLO_HASH(x,y) (round((x+y*world.maxy)%HASH_MODULO))

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
		var/z = 0
		while(z < 3)
			z++
			while(length(explodey.current_turf_queue))
				turfs_processed++
				var/turf/target = explodey.current_turf_queue[length(explodey.current_turf_queue)]
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
				//if(MC_TICK_CHECK && turfs_processed > TURFS_PER_PROCESS_LIMIT)
				//	return
			//for(var/turf/remove_visuals_from as anything in explodey.remove_effects)
			//	remove_visuals_from.vis_contents -= explosion_fire
			//explodey.remove_effects = list()
			explodey.iterations++
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
			// Trash the list for a new one, with a pre-set size because we want to avoid resizing
			explodey.turf_queue = list()
			current_run -= explodey
	current_run = explode_queue.Copy()


/datum/controller/subsystem/explosions/proc/start_explosion(turf/epicenter, power, falloff)
	var/reference = new /explosion_handler(epicenter, power, falloff)
	explode_queue += reference

/turf/proc/explosion_act(target_power)
	var/severity = 3
	if(target_power > 60)
		severity = 1
	else if(target_power > 40)
		severity = 2
	for(var/atom/movable/thing as anything in contents)
		if(thing.simulated && isobj(thing))
			thing.ex_act(severity)
	ex_act(severity)
	if(density)
		return 20
	else
		return 0

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

explosion_handler/New(turf/loc, power, falloff)
	..()
	turf_queue += loc
	var/turf_key = EXPLO_HASH(loc.x, loc.y)
	src.epicenter = loc
	src.power = power
	src.falloff = falloff
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
		hashed_visited = new /list(HASH_MODULO)
	if(!length(hashed_power))
		hashed_power = new /list(HASH_MODULO)
	hashed_power[turf_key] = power
	//message_admins("EXPLOSION HANDLER CREATED WITHOUT ANY AVAILABLE HASH LIST, CURRENT LIMIT IS [SPARE_HASH_LISTS], Doing a slow initialization. If this is frequent developers should be informed.")
	//hashed_visited = /list(HASH_MODULO, null)

/turf/proc/test_explosion()
	var/power
	var/falloff
	power = input(usr, "Explo power", "Explodeee", 100) as num
	falloff = input(usr,"Explo falloff", "Exploodee",20) as num
	SSexplosions.start_explosion(src, power, falloff)

/*
/datum/explosion_handler/proc/Run()
	var/target_power
	var/list/new_turf_queue = list()
	var/list/new_directions = list()
	//var/center_angle
	for(var/turf/target as anything in turf_queue)
		target_power = turf_queue[target] - falloff
		if(target_power < 10)
			continue
		visited[target] = world.time + 0.3 SECOND
		target_power -= target.explosion_act(target_power)
		if(target_power < 10)
			continue
		for(var/atom/movable/thing in target.contents)
			if(thing.anchored)
				continue
			//throwing_queue[thing] += list(round(target_power/falloff), direction_list[target])
		for(var/dir in list(NORTH,SOUTH,EAST,WEST))
			var/turf/next = get_step(target,dir)
			if(visited[next] > world.time )
				continue
			new_turf_queue[next] = target_power
			new_directions[next] = get_dir(target, next)
	turf_queue = new_turf_queue
	direction_list = new_directions
*/

/*
/datum/explosion_handler/proc/Run()
	var/list/immediate_queue = list()
	var/list/temporary_queue = list()
	var/list/replacement_queue = list()
	// Prep for first turf handling
	var/turf/target = turf_queue[length(turf_queue)]
	var/target_power = turf_queue[target] - falloff
	var/center_to_turf_angle = Get_Angle(epicenter, target)
	if(target_power > 10)
		immediate_queue += get_step(target,angle2dir(center_to_turf_angle - 90))
		immediate_queue += get_step(target,angle2dir(center_to_turf_angle))
		immediate_queue += get_step(target,angle2dir(center_to_turf_angle + 90))
	// Actual handling of all turfs except last one
	for(var/i = 1; i < length(turf_queue); i++)
		target = turf_queue[i]
		// retrieve power using the turf ref!
		target_power = turf_queue[target] - falloff
		// todo - add to a separate queue that gets cleared on each iteration to check for implosion
		if(target_power < 10)
			continue
		target_power -= target.explosion_act(target_power)
		if(target.density)
			target_power -= 50
		if(target_power < 10)
			continue
		for(var/atom/movable/moving_stuff in target)
			SSexplosions.throwing_queue[moving_stuff] = get_turf_away_from_target_simple(target, epicenter, min(power / 25, 1))
		center_to_turf_angle = Get_Angle(epicenter, target)
		//message_admins("[angle2dir(center_to_turf_angle - 90)] | [angle2dir(center_to_turf_angle)] | [angle2dir(center_to_turf_angle + 90)]")
		temporary_queue = list()
		temporary_queue += get_step(target,angle2dir(center_to_turf_angle - 90))
		temporary_queue += get_step(target,angle2dir(center_to_turf_angle))
		temporary_queue += get_step(target,angle2dir(center_to_turf_angle + 90))
		temporary_queue -= temporary_queue & immediate_queue
		immediate_queue = temporary_queue
		for(var/turf_ref in temporary_queue)
			replacement_queue[turf_ref] = target_power
		if(target.color == COLOR_RED)
			target.color = COLOR_BLUE
		else if(target.color == COLOR_AMBER)
			target.color = COLOR_RED
		else
			target.color = COLOR_AMBER
	// Special handling for last one , since it "loops" around , or would in  worst case scenario
	target = turf_queue[1]
	target_power = turf_queue[target] - falloff
	if(target_power > 10)
		center_to_turf_angle = Get_Angle(epicenter, target)
		immediate_queue += get_step(target,angle2dir(center_to_turf_angle - 90))
		immediate_queue += get_step(target,angle2dir(center_to_turf_angle))
		immediate_queue += get_step(target,angle2dir(center_to_turf_angle + 90))
	target = turf_queue[length(turf_queue)]
	target_power = turf_queue[target] - falloff
	target_power -= target.explosion_act(target_power)
	if(target_power > 10)
		center_to_turf_angle = Get_Angle(epicenter, target)
		temporary_queue = list()
		temporary_queue += get_step(target,angle2dir(center_to_turf_angle - 90))
		temporary_queue += get_step(target,angle2dir(center_to_turf_angle))
		temporary_queue += get_step(target,angle2dir(center_to_turf_angle + 90))
		temporary_queue -= temporary_queue & immediate_queue
		for(var/turf_ref in temporary_queue)
			replacement_queue[turf_ref] = target_power
		if(target.color == COLOR_RED)
			target.color = COLOR_BLUE
		else if(target.color == COLOR_AMBER)
			target.color = COLOR_RED
		else
			target.color = COLOR_AMBER

	// replace the queue with the new list
	turf_queue = replacement_queue
*/

