GLOBAL_DATUM_INIT(machinery_state, /datum/ui_state/machinery, new)

/datum/ui_state/machinery/can_use_topic(obj/machinery/src_object, mob/user)
	ASSERT(istype(src_object))

	if(src_object.stat & (BROKEN | NOPOWER))
		return FALSE

	return user.default_can_use_topic(src_object)
