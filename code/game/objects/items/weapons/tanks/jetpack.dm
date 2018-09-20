//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/tank/jetpack
	name = "jetpack (empty)"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	gauge_icon = null
	w_class = ITEM_SIZE_LARGE
	item_state = "jetpack"
	force = WEAPON_FORCE_PAINFULL
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/datum/effect/effect/system/ion_trail_follow/ion_trail
	var/on = 0.0
	var/stabilization_on = 0
	var/volume_rate = 500              //Needed for borg jetpack transfer
	action_button_name = "Toggle Jetpack"

/obj/item/weapon/tank/jetpack/New()
	..()
	src.ion_trail = new /datum/effect/effect/system/ion_trail_follow()
	src.ion_trail.set_up(src)

/obj/item/weapon/tank/jetpack/Destroy()
	qdel(ion_trail)
	. = ..()

/obj/item/weapon/tank/jetpack/examine(mob/user)
	. = ..()
	if(air_contents.total_moles < 5)
		user << SPAN_DANGER("The meter on \the [src] indicates you are almost out of gas!")
		playsound(user, 'sound/effects/alert.ogg', 50, 1)

/obj/item/weapon/tank/jetpack/verb/toggle_rockets()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"
	src.stabilization_on = !( src.stabilization_on )
	usr << "You toggle the stabilization [stabilization_on? "on":"off"]."

/obj/item/weapon/tank/jetpack/verb/toggle()
	set name = "Toggle Jetpack"
	set category = "Object"

	on = !on
	if(on)
		icon_state = "[icon_state]-on"
		ion_trail.start()
	else
		icon_state = initial(icon_state)
		ion_trail.stop()

	if (ismob(usr))
		var/mob/M = usr
		M.update_inv_back()
		M.update_action_buttons()

	usr << "You toggle the thrusters [on? "on":"off"]."

/obj/item/weapon/tank/jetpack/proc/allow_thrust(num, mob/living/user as mob)
	if(!(src.on))
		return 0
	if((num < 0.005 || src.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = src.air_contents.remove(num)

	var/allgases = G.gas["carbon_dioxide"] + G.gas["nitrogen"] + G.gas["oxygen"] + G.gas["plasma"]
	if(allgases >= 0.005)
		return 1

	qdel(G)
	return


//A check only version of the above, does not alter any values
/obj/item/weapon/tank/jetpack/proc/check_thrust(num, mob/living/user as mob)
	if(!(src.on))
		return FALSE
	if((src.air_contents.total_moles < num))
		return FALSE

	return TRUE

/obj/item/weapon/tank/jetpack/ui_action_click()
	toggle()


/obj/item/weapon/tank/jetpack/void
	name = "void jetpack (oxygen)"
	desc = "It works well in a void."
	icon_state = "jetpack-void"
	item_state =  "jetpack-void"

/obj/item/weapon/tank/jetpack/void/New()
	..()
	air_contents.adjust_gas("oxygen", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return

/obj/item/weapon/tank/jetpack/oxygen
	name = "jetpack (oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state = "jetpack"

/obj/item/weapon/tank/jetpack/oxygen/New()
	..()
	air_contents.adjust_gas("oxygen", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return

/obj/item/weapon/tank/jetpack/carbondioxide
	name = "jetpack (carbon dioxide)"
	desc = "A tank of compressed carbon dioxide for use as propulsion in zero-gravity areas. Painted black to indicate that it should not be used as a source for internals."
	distribute_pressure = 0
	icon_state = "jetpack-black"
	item_state =  "jetpack-black"

/obj/item/weapon/tank/jetpack/carbondioxide/New()
	..()
	air_contents.adjust_gas("carbon_dioxide", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return

/obj/item/weapon/tank/jetpack/rig
	name = "jetpack"
	var/obj/item/weapon/rig/holder

/obj/item/weapon/tank/jetpack/rig/examine()
	usr << "It's a jetpack. If you can see this, report it on the bug tracker."
	return 0

/obj/item/weapon/tank/jetpack/rig/allow_thrust(num, mob/living/user as mob)

	if(!(src.on))
		return 0

	if(!istype(holder) || !holder.air_supply)
		return 0

	var/obj/item/weapon/tank/pressure_vessel = holder.air_supply

	if((num < 0.005 || pressure_vessel.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = pressure_vessel.air_contents.remove(num)

	var/allgases = G.gas["carbon_dioxide"] + G.gas["nitrogen"] + G.gas["oxygen"] + G.gas["plasma"]
	if(allgases >= 0.005)
		return 1
	qdel(G)
	return


/obj/item/weapon/tank/jetpack/rig/check_thrust(num, mob/living/user as mob)
	if(!(src.on))
		return 0

	if(!istype(holder) || !holder.air_supply)
		return 0

	var/obj/item/weapon/tank/pressure_vessel = holder.air_supply

	if((num < 0.005 || pressure_vessel.air_contents.total_moles < num))
		return 0

	return 1

/proc/GetJetpack(var/mob/living/L)
	// Search the human for a jetpack. Either on back or on a RIG that's on
	// on their back.
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		// Skip sanity check for H.back, as istype can safely handle a null.
		if (istype(H.back, /obj/item/weapon/tank/jetpack))
			return H.back
		else if (istype(H.s_store, /obj/item/weapon/tank/jetpack))
			return H.s_store
		else if (istype(H.back, /obj/item/weapon/rig))
			var/obj/item/weapon/rig/rig = H.back
			for (var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				return module.jets
	// See if we have a robot instead, and look for their jetpack.
	else if (isrobot(L))
		var/mob/living/silicon/robot/R = L
		if (R.module)
			for (var/obj/item/weapon/tank/jetpack/J in R.module.modules)
				return J
		// Synthetic jetpacks don't install into modules. They go into contents.
		for (var/obj/item/weapon/tank/jetpack/J in R.contents)
			return J

	return null

