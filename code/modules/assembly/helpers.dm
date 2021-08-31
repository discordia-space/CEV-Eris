/proc/is_assembly(O)
	if(istype(O, /obj/item/device/assembly))
		return TRUE
	return FALSE

/proc/is_igniter(O)
	if(istype(O, /obj/item/device/assembly/igniter))
		return TRUE
	return FALSE

/proc/is_infrared(O)
	if(istype(O, /obj/item/device/assembly/infra))
		return TRUE
	return FALSE

/proc/is_proximity_sensor(O)
	if(istype(O, /obj/item/device/assembly/prox_sensor))
		return TRUE
	return FALSE

/proc/is_signaler(O)
	if(istype(O, /obj/item/device/assembly/signaler))
		return TRUE
	return FALSE

/proc/is_timer(O)
	if(istype(O, /obj/item/device/assembly/timer))
		return TRUE
	return FALSE
