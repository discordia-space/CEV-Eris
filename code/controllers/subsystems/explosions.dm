SUBSYSTEM_DEF(explosions)
	name = "explosions"
	wait = 1 MINUTES
	priority = SS_PRIORITY_INACTIVITY
	var/list/datum/explosion_handler/explode_queue = list()
	var/list/throwing_queue = list()

/datum/controller/subsystem/explosions/fire(resumed = FALSE)
	for(var/datum/explosion_handler/explodey as anything in explode_queue)
		throwing_queue = list()
		explodey.Run()
		for(var/atom/movable/to_throw as anything in throwing_queue)
			to_throw.throw_at(throwing_queue[to_throw], get_dist(to_throw, throwing_queue[to_throw]), 5, "Explosion")

/datum/controller/subsystem/explosions/stat_entry()

/turf/proc/explosion_act()
	return TRUE

/datum/explosion_handler
	var/turf/epicenter
	var/power
	var/falloff
	var/list/turf/turf_queue = list()
	var/list/turf/immediate_queue = list()

/datum/explosion_handler/proc/Run()
	immediate_queue = list()
	var/list/temporary_queue = list()
	var/list/replacement_queue = list()
	// Prep for first turf handling
	var/turf/target = turf_queue[length(turf_queue)]
	var/target_power = power - get_dist(epicenter, target) * falloff
	var/center_to_turf_angle = Get_Angle(epicenter, target)
	if(target_power > 10)
		immediate_queue += get_step(epicenter,angle2dir(center_to_turf_angle + 90))
		immediate_queue += get_step(epicenter,angle2dir(center_to_turf_angle))
		immediate_queue += get_step(epicenter,angle2dir(center_to_turf_angle - 90))
	// Actual handling of all turfs except last one
	for(var/i = 1; i < length(turf_queue); i++)
		target = turf_queue[i]
		// todo - atmos check
		target_power = power - get_dist(epicenter, target) * falloff
		// todo - add to a separate queue that gets cleared on each iteration to check for implosion
		if(target_power < 10)
			continue
		target_power -= target.explosion_act(target_power)
		if(target_power < 10)
			continue
		for(var/atom/movable/moving_stuff in target)
			SSexplosions.throwing_queue[moving_stuff] = get_turf_away_from_target_simple(target, epicenter, min(power / 25, 1))
		center_to_turf_angle = Get_Angle(epicenter, target)
		temporary_queue += get_step(epicenter,angle2dir(center_to_turf_angle + 90))
		temporary_queue += get_step(epicenter,angle2dir(center_to_turf_angle))
		temporary_queue += get_step(epicenter,angle2dir(center_to_turf_angle - 90))
		temporary_queue -= temporary_queue | immediate_queue
		immediate_queue = temporary_queue
		replacement_queue = replacement_queue + temporary_queue
	// Special handling for last one , since it "loops" around , or would in  worst case scenario
	target = turf_queue[1]
	target_power = power - get_dist(epicenter, target) * falloff
	if(target_power > 10)
		center_to_turf_angle = Get_Angle(epicenter, target)
		immediate_queue += get_step(epicenter,angle2dir(center_to_turf_angle + 90))
		immediate_queue += get_step(epicenter,angle2dir(center_to_turf_angle))
		immediate_queue += get_step(epicenter,angle2dir(center_to_turf_angle - 90))
	target = turf_queue[length(turf_queue)]
	target_power = power - get_dist(epicenter, target) * falloff
	center_to_turf_angle = Get_Angle(epicenter, target)
	temporary_queue += get_step(epicenter,angle2dir(center_to_turf_angle + 90))
	temporary_queue += get_step(epicenter,angle2dir(center_to_turf_angle))
	temporary_queue += get_step(epicenter,angle2dir(center_to_turf_angle - 90))
	temporary_queue -= temporary_queue | immediate_queue
	replacement_queue = replacement_queue + temporary_queue

	// replace the queue with the new list
	turf_queue = replacement_queue

