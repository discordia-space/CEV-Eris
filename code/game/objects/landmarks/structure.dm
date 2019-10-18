/obj/landmark/structure
	invisibility = 0
	delete_me = TRUE

/obj/landmark/structure/secequipment
	name = "secequipment"
	icon = 'icons/obj/closet.dmi' //replace with transparent static marker
	icon_state = "sec"

/obj/landmark/structure/secequipment/Initialize(mapload)
	..()
	GLOB.secequipment += loc
	return INITIALIZE_HINT_QDEL
