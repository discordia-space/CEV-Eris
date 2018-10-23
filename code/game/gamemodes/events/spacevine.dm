/datum/storyevent/spacevine
	id = "spacevine"
	name = "rampant flora"


	event_type = /datum/event/spacevine
	event_pools = list(EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR*0.5)

	tags = list(TAG_DESTRUCTIVE, TAG_NEGATIVE, TAG_COMBAT)

/var/global/spacevines_spawned = 0

/datum/event/spacevine
	announceWhen	= 60

/datum/event/spacevine/start()
	spacevine_infestation()
	spacevines_spawned = 1

/datum/event/spacevine/announce()
	level_seven_announcement()
