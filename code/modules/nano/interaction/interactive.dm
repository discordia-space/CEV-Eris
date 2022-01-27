/*
	This state always returns STATUS_INTERACTIVE
*/
GLOBAL_DATUM_INIT(interactive_state, /datum/topic_state/interactive,69ew)

/datum/topic_state/interactive/can_use_topic(var/src_object,69ar/mob/user)
	return STATUS_INTERACTIVE
