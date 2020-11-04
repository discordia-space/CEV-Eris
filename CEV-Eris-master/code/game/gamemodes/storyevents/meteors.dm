/datum/storyevent/meteors
	id = "meteor"
	processing = TRUE

	max_cost = 25
	min_cost = 35

	req_crew = -1
	req_heads = -1
	req_sec = -1
	req_eng = 2
	req_med = 1
	req_sci = -1

	req_stage = 2

	spawn_times_max = 2

	var/list/meteor_types

	var/waves = 5
	var/hard = FALSE

	var/meteors_min = 4
	var/meteors_max = 16
	var/meteors = 8

	var/delay_min = 10 SECONDS
	var/delay_max = 90 SECONDS

	var/timer = 0

/datum/storyevent/meteors/announce()
	command_announcement.Announce("Meteors have been detected on collision course with the ship.", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')

/datum/storyevent/meteors/announce_end()
	command_announcement.Announce("The ship has cleared the meteor storm.", "Meteor Alert")

/datum/storyevent/meteors/spawn_event()
	if(prob(10))
		hard = TRUE
	if(hard)
		waves = rand(8,19)
	else
		waves = rand(4,14)

	if(hard)
		meteor_types = prob(20) ? meteors_catastrophic : meteors_threatening
	else
		meteor_types = prob(30) ? meteors_threatening : meteors_normal

/datum/storyevent/meteors/is_ended()
	return waves <= 0

/datum/storyevent/meteors/Process()
	if(waves && world.time > timer)
		waves--
		spawn()
			spawn_meteors(rand(meteors_min,meteors_max), meteor_types, pick(NORTH;180, SOUTH;60, EAST, WEST))
		timer = world.time + rand(delay_min,delay_max)



