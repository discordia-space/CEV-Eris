/datum/event/meteor_wave
	startWhen		= 5
	endWhen 		= 7
	var/next_meteor = 6
	var/waves = 1
	var/start_side
	var/next_meteor_lower = 10
	var/next_meteor_upper = 15

/datum/event/meteor_wave/setup()
	waves = severity * rand(1,3)
	start_side = pick(cardinal)
	endWhen = worst_case_end()

/datum/event/meteor_wave/announce()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Meteors have been detected on collision course with the ship.", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')
		else
			command_announcement.Announce("The ship is now in a meteor shower.", "Meteor Alert")

/datum/event/meteor_wave/tick()
	if(waves && activeFor >= next_meteor)
		var/pick_side = prob(80) ? start_side : (prob(50) ? turn(start_side, 90) : turn(start_side, -90))

		spawn() spawn_meteors(severity * rand(1,2), get_meteors(), pick_side)
		next_meteor += rand(next_meteor_lower, next_meteor_upper) / severity
		waves--
		endWhen = worst_case_end()

/datum/event/meteor_wave/proc/worst_case_end()
	return activeFor + ((30 / severity) * waves) + 10

/datum/event/meteor_wave/end()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("The ship has cleared the meteor storm.", "Meteor Alert")
		else
			command_announcement.Announce("The ship has cleared the meteor shower", "Meteor Alert")

/datum/event/meteor_wave/proc/get_meteors()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			return meteors_catastrophic
		if(EVENT_LEVEL_MODERATE)
			return meteors_threatening
		else
			return meteors_normal


/datum/event/meteor_wave/overmap
	next_meteor_lower = 5
	next_meteor_upper = 10
	next_meteor = 0
	var/obj/effect/overmap/ship/victim

/datum/event/meteor_wave/overmap/Destroy()
	victim = null
	. = ..()

/*
/datum/event/meteor_wave/overmap/worst_case_end()
	if(endWhen == INFINITY)
		return INFINITY
	else
		return ..()
*/

/datum/event/meteor_wave/overmap/tick()
	if(victim && !victim.is_still()) //Meteors mostly fly in your face
		start_side = prob(90) ? victim.fore_dir : pick(cardinal)
	else //Unless you're standing
		start_side = pick(cardinal)
	..()
