//Hivemind is rogue AI that uses unknown nanotech to follow some strange objective
//In fact, it's just hostile structures, wireweeds spreading event with some mobs
//Requires hard teamwork at late stages, but easily can be handled at the beginning

//All code stored in modules/hivemind


/datum/storyevent/hivemind
	id = "hivemind"
	name = "Hivemind Invasion"


	event_type = /datum/event/hivemind
	event_pools = list(EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR*0.80)
	tags = list(TAG_COMMUNAL, TAG_DESTRUCTIVE, TAG_NEGATIVE, TAG_SCARY)
//============================================

/datum/event/hivemind
	announceWhen	= 300


/datum/event/hivemind/announce()
	level_seven_announcement()


/datum/event/hivemind/start()
	var/turf/start_location
	for(var/i=1 to 100)
		var/area/A = random_ship_area(filter_players = TRUE, filter_maintenance = TRUE, filter_critical = TRUE)
		start_location = A.random_space()
		if(!start_location && i == 100)
			log_and_message_admins("Hivemind failed to find a viable turf.")
			kill()
			return
		if(start_location)
			break

	message_admins("Hivemind spawned at \the [jumplink(start_location)]")
	new /obj/machinery/hivemind_machine/node(start_location)
