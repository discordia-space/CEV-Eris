/obj/item/mech_component/sensors
	name = "exosuit head"
	icon_state = "loader_head"
	gender = NEUTER

	var/vision_flags = NONE
	var/see_invisible = 0
	var/active_sensors = FALSE

	var/obj/item/robot_parts/robot_component/radio/radio
	var/obj/item/robot_parts/robot_component/camera/camera
	has_hardpoints = list(HARDPOINT_HEAD)
	power_use = 15
	matter = list(MATERIAL_STEEL = 5, MATERIAL_GLASS = 4)

/obj/item/mech_component/sensors/Destroy()
	QDEL_NULL(camera)
	QDEL_NULL(radio)
	. = ..()

/obj/item/mech_component/sensors/show_missing_parts(var/mob/user)
	if(!radio)
		to_chat(user, SPAN_WARNING("It is missing a radio."))
	if(!camera)
		to_chat(user, SPAN_WARNING("It is missing a camera."))

/obj/item/mech_component/sensors/prebuild()
	radio = new(src)
	camera = new(src)

/obj/item/mech_component/sensors/update_components()
	radio = locate() in src
	camera = locate() in src

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
	return (radio && camera)

/obj/item/mech_component/sensors/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/robot_parts/robot_component/radio))
		if(radio)
			to_chat(user, SPAN_WARNING("\The [src] already has a radio installed."))
			return
		if(insert_item(I, user))
			radio = I
	else if(istype(I, /obj/item/robot_parts/robot_component/camera))
		if(camera)
			to_chat(user, SPAN_WARNING("\The [src] already has a camera installed."))
			return
		if(insert_item(I, user))
			camera = I
	else
		return ..()
