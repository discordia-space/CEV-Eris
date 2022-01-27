/obj/item/mech_component/propulsion
	name = "exosuit legs"
	pixel_y = 12
	icon_state = "loader_legs"
	power_use = 50
	matter = list(MATERIAL_STEEL = 8)
	var/move_delay = 5
	var/turn_delay = 5
	var/obj/item/robot_parts/robot_component/actuator/motivator
	var/mech_turn_sound = 'sound/mechs/mechturn.ogg'
	var/mech_step_sound = 'sound/mechs/mechstep.ogg'

/obj/item/mech_component/propulsion/Destroy()
	QDEL_NULL(motivator)
	. = ..()

/obj/item/mech_component/propulsion/show_missing_parts(var/mob/user)
	if(!motivator)
		to_chat(user, SPAN_WARNING("It is69issing an actuator."))

/obj/item/mech_component/propulsion/ready_to_install()
	return69otivator

/obj/item/mech_component/propulsion/update_components()
	motivator = locate() in src

/obj/item/mech_component/propulsion/attackby(obj/item/I,69ob/living/user)
	if(istype(I, /obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, SPAN_WARNING("\The 69src69 already has an actuator installed."))
			return
		if(insert_item(I, user))
			motivator = I
	else
		return ..()

/obj/item/mech_component/propulsion/prebuild()
	motivator =69ew(src)

/obj/item/mech_component/propulsion/proc/can_move_on(var/turf/location,69ar/turf/target_loc)
	if(!location) //Unsure on how that'd even work
		return 0
	if(!istype(location))
		return 1 // Inside something, assume you can get out.
	if(!istype(target_loc))
		return 0 // What are you even doing.
	return 1