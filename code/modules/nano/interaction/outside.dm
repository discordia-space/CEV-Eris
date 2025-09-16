GLOBAL_DATUM_INIT(outside_state, /datum/nano_topic_state/default/outside, new)

/datum/nano_topic_state/default/outside/can_use_topic(src_object, mob/user)
	if(user in src_object)
		return STATUS_CLOSE
	return ..()
