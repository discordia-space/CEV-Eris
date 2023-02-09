/// This subsystem could also be reworked to use global lists instead of explosion datums
/// Which could allow for explosions to interact with eachother and affect eachother

SUBSYSTEM_DEF(explosions)
	name = "explosions"
	wait = 1 // very small
	priority = FIRE_PRIORITY_EXPLOSIONS
	var/list/datum/explosion_handler/explode_queue = list()
	var/list/throwing_queue = list()

/datum/controller/subsystem/explosions/fire(resumed = FALSE)
	for(var/datum/explosion_handler/explodey as anything in explode_queue)
		if(MC_TICK_CHECK)
			return
		explodey.Run()
		if(!length(explodey.turf_queue))
			explode_queue -= explodey
			qdel(explodey)


///datum/controller/subsystem/explosions/stat_entry()

/datum/controller/subsystem/explosions/proc/start_explosion(turf/epicenter, power, falloff)
	var/reference = new /datum/explosion_handler(epicenter, power, falloff)
	explode_queue += reference

/turf/proc/explosion_act(explosion_power)
	var/severity = explosion_power / 20
	if(severity > 3)
		severity = 3
	else if(severity < 1)
		severity = 1
	severity = round(severity)
	for(var/atom/stuff in contents)
		stuff.ex_act(severity)
	ex_act(severity)
	if(density)
		return 20
	else
		return 0

/datum/explosion_handler
	var/turf/epicenter
	var/power
	var/falloff
	var/list/turf_queue[50]
	var/list/direction_list[50]
	var/list/visited[100]
	//var/list/turf/immediate_queue = list()

/datum/explosion_handler/New(turf/loc, power, falloff)
	..()
	for(var/dir in list(NORTH, EAST, SOUTH , WEST))
		turf_queue[get_step(loc, dir)] = power
	src.epicenter = loc
	src.power = power
	src.falloff = falloff

/turf/proc/test_explosion()
	SSexplosions.start_explosion(src, 100, 5)

/datum/explosion_handler/proc/Run()
	var/target_power
	var/list/new_turf_queue = list()
	var/list/new_directions = list()
	//var/center_angle
	for(var/turf/target as anything in turf_queue)
		target_power = turf_queue[target] - falloff
		if(target_power < 10)
			continue
		visited[target] = TRUE
		target_power -= target.explosion_act(target_power)
		if(target_power < 10)
			continue
		for(var/atom/movable/thing in target.contents)
			if(thing.anchored)
				continue
			var/to_throw_at = get_turf_away_from_target_complex(target, get_step(target, turn(direction_list[target], 180)), target_power/falloff)
			thing.throw_at(to_throw_at, target_power/falloff, target_power/10, "explosion")
			//throwing_queue[thing] += list(round(target_power/falloff), direction_list[target])
		for(var/dir in list(NORTH,SOUTH,EAST,WEST))
			var/turf/next = get_step(target,dir)
			if(visited[next] > world.time )
				continue
			new_turf_queue[next] = target_power
			new_directions[next] = get_dir(target, next)
	turf_queue = new_turf_queue
	direction_list = new_directions

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

