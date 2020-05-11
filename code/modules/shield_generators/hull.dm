//The main hull shield. Moving a few variables here to make it easier to branch off the parent for shortrange bubble shields and such
/obj/machinery/power/shield_generator/hull
	name = "hull shield core"
	report_integrity = TRUE
	default_modes = list(MODEFLAG_HYPERKINETIC, MODEFLAG_HULL, MODEFLAG_MULTIZ)
	// Foolproof defaults for a hull shield to block meteors

	//This is all of the modes
	allowed_modes = list(MODEFLAG_HYPERKINETIC,
							MODEFLAG_PHOTONIC,
							MODEFLAG_NONHUMANS,
							MODEFLAG_HUMANOIDS,
							MODEFLAG_ANORGANIC,
							MODEFLAG_ATMOSPHERIC,
							MODEFLAG_HULL,
							MODEFLAG_BYPASS,
							MODEFLAG_OVERCHARGE,
							MODEFLAG_MODULATE,
							MODEFLAG_MULTIZ,
							MODEFLAG_EM)

	input_cap = 0.1 MEGAWATTS //By default, the shield charges at a uselessly slow speed, so that it won't drain the station of power
	//This should be increased as soon as you get the engine started
	var/list/tendrils = list()
	var/list/tendril_dirs = list(NORTH, EAST, WEST)
	var/tendrils_deployed = FALSE				// Whether the dummy capacitors are currently extended


//This subtype comes pre-deployed and partially charged
/obj/machinery/power/shield_generator/hull/installed/Initialize()
	. = ..()
	anchored = toggle_tendrils(TRUE)
	current_energy = max_energy * 0.30


/obj/machinery/power/shield_generator/hull/update_icon()
	..() //Parent calls overlays.Cut()
	if (tendrils_deployed)
		for (var/D in tendril_dirs)
			var/I = image(icon,"capacitor_connected", dir = D)
			overlays += I

	for (var/obj/machinery/shield_conduit/S in tendrils)
		if (running)
			S.icon_state = "conduit_1"
		else
			S.icon_state = "conduit_0"



//New shield generators don't use capacitors anymore. But capacitors still looked cool
//So this proc will create dummy objects around the shield generator just for visuals and to make it suitably large
/obj/machinery/power/shield_generator/hull/proc/toggle_tendrils(var/on = null)
	//This can be called with true, false or null. to set the tendrils to deployed, retracted, or the opposite of their current state

	var/target_state
	if (!isnull(on))
		target_state = on //If a specific target was passed, we aim for that
	else
		target_state = ~tendrils_deployed //Otherwise we're toggling

	if (target_state == tendrils_deployed)
		//Don't try to do what's already done
		return


	//If we're extending them
	if (target_state == TRUE)

		//First check that we have space to deploy
		for (var/D in tendril_dirs)
			var/turf/T = get_step(src, D)
			if (!turf_clear(T))
				visible_message(SPAN_DANGER("The [src] buzzes an insistent warning as it lacks the space to deploy"))
				playsound(src.loc, "/sound/machines/buzz-two", 100, 1, 5)
				tendrils_deployed = FALSE
				update_icon()
				return FALSE

		//Now deploy
		for (var/D in tendril_dirs)
			var/turf/T = get_step(src, D)
			var/obj/machinery/shield_conduit/SC = new(T)
			tendrils.Add(SC)
			SC.face_atom(src)
			SC.anchored = TRUE

		tendrils_deployed = TRUE
		update_icon()

		return TRUE

	else if (target_state == FALSE)
		for (var/obj/machinery/shield_conduit/SC in tendrils)
			tendrils.Remove(SC)
			qdel(SC)
		tendrils_deployed = FALSE
		update_icon()

		return FALSE

/obj/machinery/power/shield_generator/hull/Process()
	if (anchored)
		return ..()
	else
		return

/obj/machinery/power/shield_generator/hull/Topic(href, href_list)
	if (anchored)
		return ..(href, href_list)

/obj/machinery/shield_conduit
	name = "shield conduit"
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "conduit_0"
	desc = "A combined conduit and capacitor that transfers and stores massive amounts of energy."
	description_info = "This is purely visual. They are created and removed when you wrench/unwrench the shield generator"
	density = TRUE
	anchored = FALSE //Will be set true just after deploying


/obj/machinery/power/shield_generator/hull/wrench(var/user, var/obj/item/O)
	if(O.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			to_chat(user, SPAN_NOTICE("You unsecure the [src] from the floor!"))
			toggle_tendrils(FALSE)
			anchored = FALSE
		else
			if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
			if ((toggle_tendrils(TRUE)))
				to_chat(user, SPAN_NOTICE("You secure the [src] to the floor!"))
				anchored = TRUE
		return