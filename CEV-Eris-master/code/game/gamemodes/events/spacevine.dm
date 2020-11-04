/*
	Spawns a rapidly expanding plant that can grow through doors.
	The plant is vulnerable to fire and cutting weapons

	It's not really dangerous, it doesn't eat you like the blob, so it has a lower cost
*/
/datum/storyevent/spacevine
	id = "spacevine"
	name = "rampant flora"


	event_type = /datum/event/spacevine
	event_pools = list(EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR*0.6)

	tags = list(TAG_DESTRUCTIVE, TAG_NEGATIVE, TAG_COMBAT)

/var/global/spacevines_spawned = 0

/datum/event/spacevine
	announceWhen	= 120

/datum/event/spacevine/start()

	//This is located in hydroponics/spreading/spacevine.dm because it uses defines in _hydro_setup.dm which are later undefined
	spacevine_infestation()

	spacevines_spawned = 1

/datum/event/spacevine/announce()
	level_seven_announcement()


