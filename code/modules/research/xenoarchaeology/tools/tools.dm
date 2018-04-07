
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Miscellaneous xenoarchaeology tools

/obj/item/device/gps
	name = "relay positioning device"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	item_state = "locator"
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1)
	w_class = ITEM_SIZE_SMALL

/obj/item/device/gps/attack_self(var/mob/user as mob)
	var/turf/T = get_turf(src)
	user << "\blue \icon[src] [src] flashes <i>[T.x].[rand(0,9)]:[T.y].[rand(0,9)]:[T.z].[rand(0,9)]</i>."

/obj/item/device/measuring_tape
	name = "measuring tape"
	desc = "A coiled metallic tape used to check dimensions and lengths."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "measuring"
	w_class = ITEM_SIZE_SMALL

//todo: dig site tape

/obj/item/weapon/storage/bag/fossils
	name = "Fossil Satchel"
	desc = "Transports delicate fossils in suspension so they don't break during transit."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEM_SIZE_NORMAL
	max_storage_space = 100
	max_w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/weapon/fossil)
