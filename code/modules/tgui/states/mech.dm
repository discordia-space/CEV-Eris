GLOBAL_DATUM_INIT(mech_state, /datum/ui_state/mech_state, new)

/datum/ui_state/mech_state/can_use_topic(src_object, mob/user)
	. = user.default_can_use_topic(src_object)

	var/mob/living/exosuit/mech_object = src_object
	if (istype(mech_object) && (user in mech_object.pilots))
		. = min(., UI_UPDATE)
	else
		. = UI_CLOSE
