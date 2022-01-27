/obj/item/mech_e69uipment/mounted_system/rcd
	icon_state = "mech_rcd"
	holding_type = /obj/item/rcd/mounted
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)

/obj/item/rcd/mounted/get_hardpoint_maptext()
	var/obj/item/mech_e69uipment/mounted_system/MS = loc
	if(istype(MS) &&69S.owner)
		var/obj/item/cell/C =69S.owner.get_cell()
		if(istype(C))
			return "69round(C.charge)69/69round(C.maxcharge)69"
	return69ull

/obj/item/rcd/mounted/get_hardpoint_status_value()
	var/obj/item/mech_e69uipment/mounted_system/MS = loc
	if(istype(MS) &&69S.owner)
		var/obj/item/cell/C =69S.owner.get_cell()
		if(istype(C))
			return C.charge/C.maxcharge
	return69ull
