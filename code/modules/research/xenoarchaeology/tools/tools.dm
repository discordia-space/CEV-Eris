
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Miscellaneous xenoarchaeology tools
/obj/item/device/gps
	name = "relay positioning device"
	desc = "Pinpoints your location using the ship navigation system."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	//item_state = "locator"

	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1)
	rarity_value = 15

	var/gps_prefix = "COM"
	var/turf/locked_location

/obj/item/device/gps/Initialize()
	. = ..()
	add_gps_component()

/// Adds the GPS component to this item.
/obj/item/device/gps/proc/add_gps_component()
	AddComponent(/datum/component/gps/item, gps_prefix)

/obj/item/device/gps/science
	icon_state = "gps-s"
	gps_prefix = "SCI"

/obj/item/device/gps/engineering
	icon_state = "gps-e"
	gps_prefix = "ENG"

/obj/item/device/gps/mining
	icon_state = "gps-m"
	gps_prefix = "MIN"
	desc = "A positioning system helpful for rescuing trapped or injured miners. Keeping one on you at all times while mining might just save your life."

// Looks like a normal GPS, but displays PDA GPS and such
/obj/item/device/gps/traitor
	spawn_blacklisted = TRUE

// Locator
// A GPS device that tracks beacons and implants
/obj/item/device/gps/locator
	name = "locator"
	desc = "A device used to locate tracking beacons and people with tracking implants."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	gps_prefix = "SEC"


/obj/item/device/gps/locator/add_gps_component()
	AddComponent(/datum/component/gps/item, gps_prefix, list("SEC", "LOC", "TBC"))

/obj/item/device/measuring_tape
	name = "measuring tape"
	desc = "A coiled metallic tape used to check dimensions and lengths."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "measuring"
	w_class = ITEM_SIZE_SMALL

//todo: dig site tape

/obj/item/storage/bag/fossils
	name = "Fossil Satchel"
	desc = "Transports delicate fossils in suspension so they don't break during transit."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEM_SIZE_NORMAL
	max_storage_space = 100
	max_w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/fossil)
