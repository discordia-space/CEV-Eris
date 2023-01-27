/obj/item/mech_component/propulsion
	name = "exosuit legs"
	pixel_y = 12
	icon_state = "loader_legs"
	power_use = 50
	matter = list(MATERIAL_STEEL = 8)
	var/move_delay = 5
	var/turn_delay = 5
	var/obj/item/robot_parts/robot_component/actuator/motivator
	var/mech_turn_sound = 'sound/mechs/Mech_Rotation.ogg'
	var/mech_step_sound = 'sound/mechs/Mech_Step.ogg'
	var/can_strafe = TRUE

/obj/item/mech_component/propulsion/Destroy()
	QDEL_NULL(motivator)
	. = ..()

/obj/item/mech_component/propulsion/show_missing_parts(var/mob/user)
	if(!motivator)
		to_chat(user, SPAN_WARNING("It is missing an actuator."))

/obj/item/mech_component/propulsion/ready_to_install()
	return motivator

/obj/item/mech_component/propulsion/update_components()
	motivator = locate() in src

/obj/item/mech_component/propulsion/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, SPAN_WARNING("\The [src] already has an actuator installed."))
			return
		if(insert_item(I, user))
			motivator = I
	else
		return ..()

/obj/item/mech_component/propulsion/prebuild()
	motivator = new(src)

/obj/item/mech_component/propulsion/proc/can_move_on(var/turf/location, var/turf/target_loc)
	if(!location) //Unsure on how that'd even work
		return 0
	if(!istype(location))
		return 1 // Inside something, assume you can get out.
	if(!istype(target_loc))
		return 0 // What are you even doing.
	return 1

/obj/item/mech_component/propulsion/return_diagnostics(mob/user)
	..()
	if(motivator)
		to_chat(user, SPAN_NOTICE(" Actuator Integrity: <b>[round((((motivator.max_dam - motivator.total_dam) / motivator.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Actuator Missing or Non-functional."))

/obj/item/mech_component/propulsion/cheap
	name = "lifter exosuit legs"
	exosuit_desc_string = "reinforced lifter legs"
	desc = "Wide and stable, but not particularly fast."
	max_damage = 95
	move_delay = 3 // Slow and chunky
	turn_delay = 3
	power_use = 10

/obj/item/mech_component/propulsion/light
	name = "light legs"
	exosuit_desc_string = "aerodynamic electromechanic legs"
	desc = "The electrical systems driving these legs are almost totally silent. Unfortunately, slamming a plate of metal against the ground is not."
	icon_state = "light_legs"
	move_delay = 1.5 // Very fast
	turn_delay = 2 // Too fast to turn at drifting speed
	max_damage = 45
	power_use = 20
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 5)

/obj/item/mech_component/propulsion/combat
	name = "combat legs"
	exosuit_desc_string = "sleek hydraulic legs"
	desc = "These combat legs are both fast and durable, thanks to a generous plasteel reinforcement and aerodynamic design."
	icon_state = "combat_legs"
	move_delay = 3
	turn_delay = 2
	max_damage = 125
	power_use = 25
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTEEL = 7, MATERIAL_DIAMOND = 2) // Expensive because durable.

/obj/item/mech_component/propulsion/heavy
	name = "heavy legs"
	exosuit_desc_string = "heavy legs"
	desc = "Exosuit actuators struggle to move these armored legs, and they're even worse at turning."
	icon_state = "heavy_legs"
	move_delay = 5
	turn_delay = 3
	max_damage = 250
	power_use = 100
	matter = list(MATERIAL_STEEL = 20, MATERIAL_URANIUM = 8)
