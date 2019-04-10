/mob/living/silicon/robot/slip_chance(var/prob_slip)
	if(module && module.no_slip)
		return 0
	..(prob_slip)

/mob/living/silicon/robot/allow_spacemove(var/check_drift = 0)

	//Do we have a working jetpack?
	var/obj/item/weapon/tank/jetpack/thrust = get_jetpack()

	if(thrust)
		//The cost for stabilization is paid later
		if (check_drift)
			if (thrust.stabilization_on)
				inertia_dir = 0
				return TRUE
			return FALSE
		else if(thrust.allow_thrust(JETPACK_MOVE_COST, src))
			inertia_dir = 0
			return TRUE

	//If no working jetpack then use the other checks
	if (is_component_functioning("actuator"))
		. = ..()



/mob/living/silicon/robot/movement_delay()
	var/tally = ..()
	tally += speed //This var is a placeholder
	if(module_active && istype(module_active,/obj/item/borg/combat/mobility)) //And so is this silly check
		tally-=1
	tally /= speed_factor
	return tally


/mob/living/silicon/robot/SelfMove(turf/n, direct)
	if (!is_component_functioning("actuator"))
		return 0

	var/datum/robot_component/actuator/A = get_component("actuator")
	if (cell_use_power(A.active_usage))
		return ..()