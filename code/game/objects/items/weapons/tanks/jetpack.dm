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
	var/datum/effect/effect/system/trail/jet/trail
	var/on = 0.0
	var/stabilization_on = 0
	var/volume_rate = 500              //Needed for borg jetpack transfer
	action_button_name = "Toggle Jetpack"


	//Vars used for stabilisation visual effects
	var/stabilize_delay = 6
	var/lastmove_tolerance = 5

	var/stabilize_done = FALSE
	//This is set false when a stabilisation check is queued, and set true when it resolves
	//Used to prevent multiple scheduled checks in a row from resolving, and causing the effect+cost to happen many times


	//Used for ztravelling effects
	var/doing_zmove = FALSE //used for visual effects when travelling between zlevels with a jetpack


	//Used for normal jet thrust effects
	var/thrust_fx_done = FALSE

/obj/item/weapon/tank/jetpack/New()
	..()
	src.trail = new /datum/effect/effect/system/trail/jet()
	src.trail.set_up(src)

/obj/item/weapon/tank/jetpack/Destroy()
	qdel(trail)
	. = ..()

/obj/item/weapon/tank/jetpack/examine(mob/user)
	. = ..()
	if(air_contents.total_moles < 5)
		user << SPAN_DANGER("The meter on \the [src] indicates you are almost out of gas!")
		playsound(user, 'sound/effects/alert.ogg', 50, 1)

/obj/item/weapon/tank/jetpack/verb/toggle_rockets()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"

	world << "Toggling stabilisation, current state is [stabilization_on]"
	//Turning off stabilisation always works
	if (stabilization_on == TRUE)
		stabilization_on = FALSE

	//Turning it on requires you to have enough gas to do so, and it will immediately stabilise you
	else if (stabilize(usr, usr.l_move_time, TRUE))
		stabilization_on = TRUE

	else
		usr << "The [src] doesnt have enough gas to enable the stabiliser."
		return

	usr << "You toggle the stabilization [stabilization_on? "on":"off"]."

/obj/item/weapon/tank/jetpack/verb/toggle()
	set name = "Toggle Jetpack"
	set category = "Object"

	on = !on
	if(on)
		icon_state = "[icon_state]-on"
		trail.start()
	else
		icon_state = initial(icon_state)
		trail.stop()

	if (ismob(usr))
		var/mob/M = usr
		M.update_inv_back()
		M.update_action_buttons()

	usr << "You toggle the thrusters [on? "on":"off"]."

/obj/item/weapon/tank/jetpack/proc/allow_thrust(num, mob/living/user as mob, var/stabilization_check = FALSE)
	world << "Jetpack allowthrust [num], [user]"
	if(!(src.on) || !user) //Someone has to be wearing it
		return 0
	if((num < 0.005 || src.air_contents.total_moles < num))
		src.trail.stop()
		return 0

	//Setup a stabilize check, but only if this isn't already from one
	if (!stabilization_check)
		stabilize_done = FALSE
		addtimer(CALLBACK(src, .proc/stabilize, user, world.time), stabilize_delay)

	var/datum/gas_mixture/G = src.air_contents.remove(num)

	//We've used some thrust. This will allow our trail to make a particle effect
	thrust_fx_done = FALSE

	var/allgases = G.gas["carbon_dioxide"] + G.gas["nitrogen"] + G.gas["oxygen"] + G.gas["plasma"]
	if(allgases >= 0.005)
		return 1

	//If we've run out of gas, turn off stabilisation
	stabilization_on = FALSE
	qdel(G)
	return

/*
	This stabilize proc serves two functions:
	1. When the user is trying to enable jetpack stabilisation, it ensures that they can.
	Including checking that they have enough thrust

	2. Every time the user does a normal move with the jetpack, it will run a short while after.
	If the user has stopped moving, then it will do a stabilising visual effect and deduct the cost
		This replaces an allow thrust call in human movement, meaning that stabilisation costs are only
		paid once, when you attempt to stop moving. And not with every step as previous

		stabilisation_on is still checked in human movement and used to prevent inertia. It will take
		some proper refactoring of the movement system to fix that

*/
/obj/item/weapon/tank/jetpack/proc/stabilize(var/mob/living/user, var/schedule_time, var/enable_stabilize = FALSE)
	world << "Stabilize running [user], [last_move], [enable_stabilize]"
	//First up, lets check we still have the user and they're still wearing this jetpack
	if (!user || loc != user)
		world << "No user"
		return FALSE

	//If this is true then this stabilisation is already resolved and paid for.
	if (stabilize_done)
		world << "Stabilize already done"
		return FALSE

	//If we're not currently trying to turn stabilisation on, then we do some additional checks
	if (!enable_stabilize)

		//In that case it needs to be already turned on
		if (!stabilization_on)
			world << "Stabilization disabled"
			return FALSE

		//Now lets check if they've stopped moving
		//If too much time passed between the last move, and the time this check was scheduled
		//Then the user must have moved again shortly after the schedule, they never really stopped
		//In this case, another check will already be scheduled and maybe THAT one will resolve correctly
		//But this one is done, return false
		if (abs(user.l_move_time - schedule_time) > lastmove_tolerance)
			world << "[user.l_move_time] Too long after [schedule_time]"
			return FALSE

	//Ok now lets be sure we have enough gas to do stabilisation
	if (!allow_thrust(JETPACK_MOVE_COST, user, stabilization_check = TRUE))
		world << "Not enough thrust"
		return FALSE

	//Great, everything works fine, the user is now stable
	user.inertia_dir = 0

	//Lets do a little visual effect, a burst of thrust which opposes the user's last movement
	trail.do_effect(get_step(user, user.last_move), user.last_move)
	stabilize_done = TRUE
	return TRUE



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
		src.trail.stop()
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

