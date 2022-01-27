/obj/item/mech_component/sensors
	name = "exosuit head"
	icon_state = "loader_head"
	gender =69EUTER

	has_hardpoints = list(HARDPOINT_HEAD)
	power_use = 15
	matter = list(MATERIAL_STEEL = 5,69ATERIAL_GLASS = 4)
	var/vision_flags =69ONE
	var/see_invisible = 0
	var/active_sensors = FALSE

	var/obj/item/robot_parts/robot_component/radio/radio
	var/obj/item/robot_parts/robot_component/camera/camera

/obj/item/mech_component/sensors/Destroy()
	QDEL_NULL(camera)
	QDEL_NULL(radio)
	. = ..()

/obj/item/mech_component/sensors/show_missing_parts(var/mob/user)
	if(!radio)
		to_chat(user, SPAN_WARNING("It is69issing a radio."))
	if(!camera)
		to_chat(user, SPAN_WARNING("It is69issing a camera."))

/obj/item/mech_component/sensors/prebuild()
	radio =69ew(src)
	camera =69ew(src)

/obj/item/mech_component/sensors/update_components()
	radio = locate() in src
	camera = locate() in src

/obj/item/mech_component/sensors/proc/get_sight()
	var/flags = 0
	if(total_damage >= 0.8 *69ax_damage)
		flags |= BLIND
	else if(active_sensors)
		flags |=69ision_flags

	return flags

/obj/item/mech_component/sensors/proc/get_invisible()
	var/invisible = 0
	if((total_damage <= 0.8 *69ax_damage) && active_sensors)
		invisible = see_invisible
	return invisible


/obj/item/mech_component/sensors/ready_to_install()
	return (radio && camera)

/obj/item/mech_component/sensors/attackby(obj/item/I,69ob/living/user)
	if(istype(I, /obj/item/robot_parts/robot_component/radio))
		if(radio)
			to_chat(user, SPAN_WARNING("\The 69src69 already has a radio installed."))
			return
		if(insert_item(I, user))
			radio = I
	else if(istype(I, /obj/item/robot_parts/robot_component/camera))
		if(camera)
			to_chat(user, SPAN_WARNING("\The 69src69 already has a camera installed."))
			return
		if(insert_item(I, user))
			camera = I
	else
		return ..()
