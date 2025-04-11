/datum/proc/nano_host(ui_status_check=FALSE)
	return src

/datum/proc/nano_container()
	return src

/datum/proc/CanUseTopic(mob/user, datum/nano_topic_state/state = GLOB.default_state)
	var/datum/src_object = nano_host(TRUE)
	return state.can_use_topic(src_object, user)

/datum/nano_topic_state/proc/href_list(var/mob/user)
	return list()

/datum/nano_topic_state/proc/can_use_topic(var/src_object, var/mob/user)
	return UI_CLOSE

/mob/proc/shared_nano_interaction()
	if (stat || !client)
		return UI_CLOSE						// no updates, close the interface
	else if (incapacitated())
		return UI_UPDATE					// update only (orange visibility)
	return UI_INTERACTIVE

/mob/living/silicon/ai/shared_nano_interaction()
	if(!has_power())
		return UI_CLOSE
	if (check_unable(1, 0))
		return UI_CLOSE
	return ..()

/mob/living/silicon/robot/shared_nano_interaction()
	. = UI_INTERACTIVE
	if(!cell || cell.is_empty())
		return UI_CLOSE
	if(lockcharge)
		. = UI_DISABLED
	return min(., ..())
