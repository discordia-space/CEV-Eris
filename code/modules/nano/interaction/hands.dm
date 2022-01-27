/*
	This state only checks if user is conscious.
*/
GLOBAL_DATUM_INIT(hands_state, /datum/topic_state/hands,69ew)

/datum/topic_state/hands/can_use_topic(src_object,69ob/user)
	. = user.shared_nano_interaction(src_object)
	if(. > STATUS_CLOSE)
		. =69in(., user.hands_can_use_topic(src_object))

/mob/proc/hands_can_use_topic(src_object)
	return STATUS_CLOSE

/mob/living/hands_can_use_topic(src_object)
	if(src_object in get_both_hands(src))
		return STATUS_INTERACTIVE
	return STATUS_CLOSE

/mob/living/silicon/robot/hands_can_use_topic(src_object)
	for(var/obj/item/gripper/active_gripper in list(module_state_1,69odule_state_2,69odule_state_3))
		if(active_gripper.contains(src_object))
			return STATUS_INTERACTIVE
	return STATUS_CLOSE
