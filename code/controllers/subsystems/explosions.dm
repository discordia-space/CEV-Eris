#define TURFS_PER_PROCESS_LIMIT 30

SUBSYSTEM_DEF(explosions)
	name = "explosions"
	wait = 1 // very small
	priority = FIRE_PRIORITY_EXPLOSIONS
	var/list/explode_queue = list()
	var/list/current_run = list()
	var/list/throwing_queue = list()

/datum/controller/subsystem/explosions/fire(resumed = FALSE)
	var/target_power = 0
	var/list/new_turf_queue = list()
	var/list/new_directions = list()
	var/turfs_processed = 0
	for(var/explosion_handler/explodey as anything in current_run)
		while(length(explodey.current_turf_queue))
			turfs_processed++
			var/turf/target = explodey.current_turf_queue[length(explodey.current_turf_queue)]
			target_power = explodey.current_turf_queue[target]
			explodey.current_turf_queue -= target
			explodey.visited[target] = TRUE
			target_power -= target.explosion_act(target_power)
			if(target_power < 10)
				continue
			/*
			for(var/atom/movable/thing in target.contents)
				if(thing.anchored)
					continue
				thing.throw_at(get_turf_away_from_target_complex(explodey.epicenter, target, target_power/explodey.falloff),  target_power/explodey.falloff, target_power/10, "explosion")
			*/
			if(target_power - explodey.falloff > 10)
				for(var/dir in list(NORTH,SOUTH,EAST,WEST))
					var/turf/next = get_step(target,dir)
					if(explodey.visited[next] > world.time )
						continue
					explodey.turf_queue[next] = target_power - explodey.falloff
			if(MC_TICK_CHECK && turfs_processed > TURFS_PER_PROCESS_LIMIT)
				return
		explodey.iterations++
		if(!length(explodey.turf_queue))
			explode_queue -= explodey
			qdel(explodey)
		explodey.current_turf_queue = explodey.turf_queue.Copy()
		// Trash the list for a new one, with a pre-set size because we want to avoid resizing
		explodey.turf_queue = list()
		current_run -= explodey
	current_run = explode_queue.Copy()


		/*
		new_turf_queue = list()
		new_directions = list()
		//var/center_angle
		for(var/turf/target as anything in explodey.turf_queue)
			target_power = explodey.turf_queue[target] - explodey.falloff
			if(target_power < 10)
				continue
			explodey.visited[target] = world.time + 0.3 SECOND
			target_power -= target.explosion_act(target_power)
			if(target_power < 10)
				continue
			for(var/atom/movable/thing in target.contents)
				if(thing.anchored)
					continue
				//throwing_queue[thing] += list(round(target_power/falloff), direction_list[target])
			for(var/dir in list(NORTH,SOUTH,EAST,WEST))
				var/turf/next = get_step(target,dir)
				if(explodey.visited[next] > world.time )
					continue
				new_turf_queue[next] = target_power
				//new_directions[next] = get_dir(target, next)
			if(MC_TICK_CHECK)
				return
		explodey.turf_queue = new_turf_queue
		*/
		//explodey.direction_list = new_directions
		// get rid of last queue
		//throwing_queue = list()
		//explodey.Run()
		/*
		for(var/atom/movable/to_throw as anything in throwing_queue)
			if(to_throw.anchored)
				continue
			spawn(0)
				to_throw.throw_at(throwing_queue[to_throw], get_dist(to_throw, throwing_queue[to_throw]), 5, "Explosion")

		if(!length(explodey.turf_queue))
			explode_queue -= explodey
			qdel(explodey)
		*/


///datum/controller/subsystem/explosions/stat_entry()

/datum/controller/subsystem/explosions/proc/start_explosion(turf/epicenter, power, falloff)
	var/reference = new /explosion_handler(epicenter, power, falloff)
	explode_queue += reference

/turf/proc/explosion_act(target_power)
	var/severity = 3
	if(target_power > 60)
		severity = 1
	else if(target_power > 40)
		severity = 2
	ex_act(severity)
	for(var/atom/movable/thing as anything in contents)
		if(thing.simulated && isobj(thing))
			thing.ex_act(severity)
	if(density)
		return 20
	else
		return 0

explosion_handler
	var/turf/epicenter
	var/power
	var/falloff
	var/list/turf_queue = list()
	//var/list/direction_list[50]
	var/list/visited = list()
	/// Used for letting us know how many iterations were already ran
	var/iterations = 0
	var/list/current_turf_queue
	//var/list/current_direction_list[50]
	//var/list/turf/immediate_queue = list()

explosion_handler/New(turf/loc, power, falloff)
	..()
	for(var/dir in list(NORTH, EAST, SOUTH , WEST))
		turf_queue[get_step(loc, dir)] = power
	turf_queue[loc] = power
	src.epicenter = loc
	src.power = power
	src.falloff = falloff

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

