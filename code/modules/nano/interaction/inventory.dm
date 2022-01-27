/*
	This state checks that the src_object is somewhere in the user's first-level inventory (in hands, on ear, etc.), but69ot further down (such as in bags).
*/
GLOBAL_DATUM_INIT(inventory_state, /datum/topic_state/inventory_state,69ew)

/datum/topic_state/inventory_state/can_use_topic(var/src_object,69ar/mob/user)
	if(!(src_object in user))
		return STATUS_CLOSE

	return user.shared_nano_interaction()
