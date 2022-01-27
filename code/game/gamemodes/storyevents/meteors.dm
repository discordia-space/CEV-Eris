/datum/storyevent/meteors
	id = "meteor"
	processing = TRUE

	max_cost = 25
	min_cost = 35

	re69_crew = -1
	re69_heads = -1
	re69_sec = -1
	re69_eng = 2
	re69_med = 1
	re69_sci = -1

	re69_stage = 2

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
	command_announcement.Announce("The ship has cleared the69eteor storm.", "Meteor Alert")

/datum/storyevent/meteors/spawn_event()
	if(prob(10))
		hard = TRUE
	if(hard)
		waves = rand(8,19)
	else
		waves = rand(4,14)

	if(hard)
		meteor_types = prob(20) ?69eteors_catastrophic :69eteors_threatening
	else
		meteor_types = prob(30) ?69eteors_threatening :69eteors_normal

/datum/storyevent/meteors/is_ended()
	return waves <= 0

/datum/storyevent/meteors/Process()
	if(waves && world.time > timer)
		waves--
		spawn()
			spawn_meteors(rand(meteors_min,meteors_max),69eteor_types, pick(NORTH;180, SOUTH;60, EAST, WEST))
		timer = world.time + rand(delay_min,delay_max)



