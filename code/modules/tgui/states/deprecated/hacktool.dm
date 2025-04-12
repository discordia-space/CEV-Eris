/datum/ui_state/default/must_hack
	var/obj/item/tool/multitool/hacktool/hacktool

/datum/ui_state/default/must_hack/New(hacktool)
	src.hacktool = hacktool
	..()

/datum/ui_state/default/must_hack/Destroy()
	hacktool = null
	return ..()

/datum/ui_state/default/must_hack/can_use_topic(src_object, mob/user)
	if(!hacktool || !hacktool.in_hack_mode || !(src_object in hacktool.known_targets))
		return UI_CLOSE
	return ..()
