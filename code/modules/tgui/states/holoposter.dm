GLOBAL_DATUM_INIT(holoposter_state, /datum/ui_state/holoposter_state, new)

/datum/ui_state/holoposter_state/can_use_topic(obj/machinery/holoposter/src_object, mob/user)
	ASSERT(istype(src_object))

	if(src_object.stat & NOPOWER)
		return UI_CLOSE

	if(isobserver(user) || issilicon(user))
		return user.default_can_use_topic(src_object)

	if(!istype(user.get_active_hand(), /obj/item/tool/multitool))
		return UI_CLOSE

	return user.default_can_use_topic(src_object)
