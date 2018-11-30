/*
	A storyevent that does nothing.
	Sometimes nothing happening is an interesting change of pace
*/
/datum/storyevent/nothing
	id = "nothing"
	name = "nothing"
	weight = 2
	event_type = /datum/event/nothing
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE,
	EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE,
	EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR)

	tags = list()