/obj/item/mech_component/sensors
	name = "exosuit head"
	icon_state = "loader_head"
	gender = NEUTER

	var/vision_flags = NONE
	var/see_invisible = 0
	var/obj/item/robot_parts/robot_component/radio/radio
	var/obj/item/robot_parts/robot_component/camera/camera
	var/obj/item/mech_component/control_module/software
	has_hardpoints = list(HARDPOINT_HEAD)
	var/active_sensors = 0
	power_use = 15
	matter = list(MATERIAL_STEEL = 5)

/obj/item/mech_component/sensors/Destroy()
	QDEL_NULL(camera)
	QDEL_NULL(radio)
	QDEL_NULL(software)
	. = ..()

/obj/item/mech_component/sensors/show_missing_parts(var/mob/user)
	if(!radio)
		to_chat(user, SPAN_WARNING("It is missing a radio."))
	if(!camera)
		to_chat(user, SPAN_WARNING("It is missing a camera."))
	if(!software)
		to_chat(user, SPAN_WARNING("It is missing a control module."))

/obj/item/mech_component/sensors/prebuild()
	radio = new(src)
	camera = new(src)
	software = new(src)

/obj/item/mech_component/sensors/update_components()
	radio = locate() in src
	camera = locate() in src
	software = locate() in src

/obj/item/mech_component/sensors/proc/get_sight()
	var/flags = 0
	if(total_damage >= 0.8 * max_damage)
		flags |= BLIND
	else if(active_sensors)
		flags |= vision_flags

	return flags

/obj/item/mech_component/sensors/proc/get_invisible()
	var/invisible = 0
	if((total_damage <= 0.8 * max_damage) && active_sensors)
		invisible = see_invisible
	return invisible


/obj/item/mech_component/sensors/ready_to_install()
	return (radio && camera && software)

/obj/item/mech_component/sensors/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/mech_component/control_module))
		if(software)
			to_chat(user, SPAN_WARNING("\The [src] already has a control modules installed."))
			return
		if(install_component(thing, user)) software = thing
	else if(istype(thing,/obj/item/robot_parts/robot_component/radio))
		if(radio)
			to_chat(user, SPAN_WARNING("\The [src] already has a radio installed."))
			return
		if(install_component(thing, user)) radio = thing
	else if(istype(thing,/obj/item/robot_parts/robot_component/camera))
		if(camera)
			to_chat(user, SPAN_WARNING("\The [src] already has a camera installed."))
			return
		if(install_component(thing, user)) camera = thing
	else
		return ..()
