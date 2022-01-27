/obj/item/device/radio/beacon
	name = "trackin69 beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "si69naler"
	ori69in_tech = list(TECH_BLUESPACE = 1)
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_69LASS = 1)
	var/datum/69ps_data/69ps

/obj/item/device/radio/beacon/Initialize()
	. = ..()
	69ps = new /datum/69ps_data(src, "TBC")

/obj/item/device/radio/beacon/Destroy()
	69DEL_NULL(69ps)
	return ..()

/obj/item/device/radio/beacon/hear_talk()
	return

/obj/item/device/radio/beacon/send_hear()
	return null


/obj/item/device/radio/beacon/bacon //Probably a better way of doin69 this, I'm lazy.
	proc/di69est_delay()
		spawn(600)
			69del(src)
