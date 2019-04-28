/*
 * Contains
 * /obj/item/mecha_parts/mecha_equipment/thruster
 */
/obj/item/mecha_parts/mecha_equipment/thruster
	name = "gas thruster system"
	desc = "Uses highly pressurised gas to allow movement in zero G, and limited flight capabilities in a gravity environment."
	icon_state = "jetpack"
	matter = list(MATERIAL_STEEL = 20, MATERIAL_GLASS = 5)
	equip_cooldown = 5
	energy_drain = 50
	var/wait = 0
	var/obj/item/weapon/tank/jetpack/mecha/thrust
	equip_ready = FALSE

/obj/item/mecha_parts/mecha_equipment/thruster/New()
	thrust = new/obj/item/weapon/tank/jetpack/mecha(src)

/obj/item/mecha_parts/mecha_equipment/thruster/can_attach(obj/mecha/M as obj)
	.=..()
	if(M.thruster)
		return FALSE

/obj/item/mecha_parts/mecha_equipment/thruster/attach(obj/mecha/M as obj)
	..()
	M.thruster = src
	thrust.gastank = chassis.internal_tank
	//We pass the chassis as the object to track, and the jetpack as the thing to check for jetpack stuff
	thrust.trail.set_up(chassis, thrust)


/obj/item/mecha_parts/mecha_equipment/thruster/detach(obj/mecha/M as obj)
	..()
	M.thruster = null
	thrust.gastank = null
	thrust.trail.set_up(src, thrust)

//Attempts to turn on the jetpack
//Mecha thrusters have always-on stabilisation, it can't be individually toggled
/obj/item/mecha_parts/mecha_equipment/thruster/proc/toggle()
	if(!chassis)
		return
	equip_ready ? turn_off() : turn_on()
	return equip_ready

/obj/item/mecha_parts/mecha_equipment/thruster/proc/turn_on()

	//Make sure enabling both thrust and stabilisation works, otherwise turn off and abort
	if (!(thrust.enable_thruster() && thrust.enable_stabilizer()))
		turn_off()
		return
	set_ready_state(TRUE)
	occupant_message("Activated")
	log_message("Activated")

/obj/item/mecha_parts/mecha_equipment/thruster/proc/turn_off()
	set_ready_state(FALSE)

	//No checks here, these can never fail
	thrust.disable_stabilizer()
	thrust.disable_thruster()

	occupant_message("Deactivated")
	log_message("Deactivated")

/obj/item/mecha_parts/mecha_equipment/thruster/proc/do_move(var/direction, var/turn)
	if (!equip_ready)
		return FALSE

	if (thrust.allow_thrust(user = chassis, stabilization_check = turn))
		return TRUE
	turn_off()
	return FALSE


/obj/item/mecha_parts/mecha_equipment/thruster/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] \[<a href=\"?src=\ref[src];toggle=1\">Toggle</a>\]"



/obj/item/mecha_parts/mecha_equipment/thruster/Topic(href,href_list)
	..()
	if(href_list["toggle"])
		toggle()
