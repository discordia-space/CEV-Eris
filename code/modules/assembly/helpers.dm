/proc/is_assembly(O)
	if(istype(O, /obj/item/device/assembly))
		return 1
	return 0

/proc/is_igniter(O)
	if(istype(O, /obj/item/device/assembly/igniter))
		return 1
	return 0

/proc/is_infrared(O)
	if(istype(O, /obj/item/device/assembly/infra))
		return 1
	return 0

/proc/is_proximity_sensor(O)
	if(istype(O, /obj/item/device/assembly/prox_sensor))
		return 1
	return 0

/proc/is_signaler(O)
	if(istype(O, /obj/item/device/assembly/signaler))
		return 1
	return 0

/proc/is_timer(O)
	if(istype(O, /obj/item/device/assembly/timer))
		return 1
	return 0
