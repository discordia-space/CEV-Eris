
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

/obj/item/device/gps/proc/get_coordinates()
	var/turf/T = get_turf(src)
	return T ? "[T.x].[rand(0,9)]:[T.y].[rand(0,9)]:[T.z].[rand(0,9)]" : "N/A"

/obj/item/device/gps/examine(var/mob/user)
	..()
	to_chat(user, "<span class='notice'>\The [src]'s screen shows: <i>[get_coordinates()]</i>.</span>")

/obj/item/device/gps/attack_self(var/mob/user as mob)
	to_chat(user, "<span class='notice'>\icon[src] \The [src] flashes <i>[get_coordinates()]</i>.</span>")


/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Status"))
		var/obj/item/device/gps/L = locate() in src
		if(L)
			stat("Coordinates:", "[L.get_coordinates()]")

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
