/obj/item/device/radio/beacon
	name = "tracking beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "signaler"
	origin_tech = list(TECH_BLUESPACE = 1)
	matter = list(MATERIAL_STEEL = 3, MATERIAL_GLASS = 1)

/obj/item/device/radio/beacon/Initialize()
	. = ..()
	AddComponent(/datum/component/gps, "TBC")

/obj/item/device/radio/beacon/hear_talk()
	return

/obj/item/device/radio/beacon/send_hear()
	return null

/// Probably a better way of doing this, I'm lazy.
/obj/item/device/radio/beacon/bacon/proc/digest_delay()
	QDEL_IN(src, 600)
