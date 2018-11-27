/mob/living/silicon/robot/slip_chance(var/prob_slip)
	if(module && module.no_slip)
		return 0
	..(prob_slip)

/mob/living/silicon/robot/Allow_Spacemove(var/check_drift = 0)

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

 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/movement_delay()
	var/tally = MOVE_DELAY_BASE //Incase I need to add stuff other than "speed" later

	tally += speed

	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		tally-=1

	return tally

/mob/living/silicon/robot/SelfMove(turf/n, direct)
	if (!is_component_functioning("actuator"))
		return 0

	var/datum/robot_component/actuator/A = get_component("actuator")
	if (cell_use_power(A.active_usage))
		return ..()