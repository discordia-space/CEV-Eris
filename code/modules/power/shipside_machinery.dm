//File created to collect all of the shared code between shield generator, long range scanner and their conduits
//Maybe used for future uses too

/obj/machinery/power/shipside
	name = "heavy shipside machinery"
	desc = "A heavy-duty unknown piece of machinery used for the basic functions of the ship."
	description_info = "Shouldn't really appear anywhere, please notify admins"
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "baygenerator0"
	density = TRUE
	anchored = FALSE

	circuit = null

	var/list/event_log = list()			// List of relevant events for this machine
	var/max_log_entries = 200			// A safety to prevent players generating endless logs and maybe endangering server memory

	var/max_energy = 0					// Maximal stored energy. In joules. Depends on the type of used SMES coil when constructing this machinery.
	var/current_energy = 0				// Current stored energy.
	var/running = null 					// Whether the machinery is enabled or not.
	var/input_cap = 1 MEGAWATTS			// Currently set input limit. Set to 0 to disable limits altogether. The machine will try to input this value per tick at most
	var/upkeep_power_usage = 0			// Upkeep power usage last tick.
	var/power_usage = 0					// Total power usage last tick.
	var/overloaded = 0					// Whether the machinery has overloaded and shut down to regenerate.
	var/offline_for = 0					// The machinery will be inoperable for this duration in ticks.
	var/input_cut = 0					// Whether the input wire is cut.
	var/mode_changes_locked = 0			// Whether the control wire is cut, locking out changes.
	var/ai_control_disabled = 0			// Whether the AI control is disabled.
	var/emergency_shutdown = FALSE		// Whether the machinery is currently recovering from an emergency shutdown

	var/obj/effect/overmap/ship/linked_ship = null // To access position of Eris on the overmap

	var/list/tendrils = list()
	var/list/tendril_dirs = list()
	var/tendrils_deployed = FALSE				// Whether the capacitors are currently extended


/obj/machinery/power/shipside/Destroy()
	for(var/obj/machinery/power/conduit/C in tendrils)
		C.disconnect()
	. = ..()

/obj/machinery/power/shipside/proc/shutdown_machine()
	return

/obj/machinery/power/shipside/proc/build_tendril_dirs()
	tendril_dirs = list()
	if(tendrils.len < 1)
		return FALSE
	for (var/obj/machinery/power/conduit/C in tendrils)
		tendril_dirs.Add(turn(C.dir, 180))
	return TRUE

/obj/machinery/power/shipside/proc/spawn_tendrils(dirs = list(NORTH, EAST, WEST))
	for (var/D in dirs)
		var/turf/T = get_step(src, D)
		var/obj/machinery/power/conduit/tendril = locate(T)
		if(!tendril)
			tendril = new(T)
		tendril.connect(src)
		tendril.face_atom(src)
		tendril.anchored = TRUE
		tendrils_deployed = TRUE
	build_tendril_dirs()
	update_icon()

/obj/machinery/power/shipside/proc/log_event(event_type, atom/origin_atom)
	return

/obj/machinery/power/shipside/verb/toggle_tendrils_verb()
	set category = "Object"
	set name = "Toggle conduits"
	set src in view(1)

	if(running != 0)
		to_chat(usr, SPAN_NOTICE("[src] has to be toggled off first!"))
		return
	toggle_tendrils()

/obj/machinery/power/shipside/proc/toggle_tendrils(forced_state)
	var/target_state
	if (isnull(forced_state))
		target_state = tendrils_deployed ? FALSE : TRUE
	else
		target_state = forced_state

	if (target_state == tendrils_deployed)
		return
	//If we're extending them
	if (target_state == TRUE)
		if(!anchored)
			visible_message(SPAN_DANGER("The [src] buzzes an insistent warning as it needs to be properly anchored to deploy"))
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 100, 1, 5)
			tendrils_deployed = FALSE
			update_icon()
			return FALSE
		if(!build_tendril_dirs())
			visible_message(SPAN_DANGER("The [src] buzzes an insistent warning as it has no conduits to deploy"))
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 100, 1, 5)
			return FALSE
		for (var/D in tendril_dirs)
			var/turf/T = get_step(src, D)
			if (!turf_clear_ignore_cables(T))
				visible_message(SPAN_DANGER("The [src] buzzes an insistent warning as it lacks the space to deploy"))
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 100, 1, 5)
				tendrils_deployed = FALSE
				update_icon()
				return FALSE

		//Now deploy
		for (var/obj/machinery/power/conduit/C in tendrils)
			var/turf/T = get_step(src, turn(C.dir, 180))
			C.forceMove(T)
			C.connect(src)
			C.anchored = TRUE
			C.connect_to_network()
		tendrils_deployed = TRUE
		update_icon()

		to_chat(usr, SPAN_NOTICE("You deployed [src] conduits."))
		return TRUE

	else if (target_state == FALSE)
		for (var/obj/machinery/power/conduit/C in tendrils)
			C.disconnect_from_network()
			C.forceMove(src)
		tendrils_deployed = FALSE
		update_icon()

		to_chat(usr, SPAN_NOTICE("You retracted [src] conduits."))
		return FALSE

/obj/machinery/power/shipside/attackby(obj/item/O, mob/user)
	// Prevents dismantle-rebuild tactics to reset the emergency shutdown timer.
	if(running)
		to_chat(user, "Turn off \the [src] first!")
		return
	if(offline_for)
		to_chat(user, "Wait until \the [src] cools down from emergency shutdown first!")
		return

	if(default_deconstruction(O, user))
		return
	if(default_part_replacement(O, user))
		return

	//TODO: Implement unwrenching in a proper centralised location. Having to copypaste this around sucks
	if(QUALITY_BOLT_TURNING in O.tool_qualities)
		wrench(user, O)
		return

	if(istool(O))
		return src.attack_hand(user)

/obj/machinery/power/shipside/proc/wrench(user, obj/item/I)
	if(running != 0)
		to_chat(usr, SPAN_NOTICE("[src] has to be toggled off first!"))
		return
	if(tendrils_deployed)
		to_chat(usr, SPAN_NOTICE("Retract conduits first!"))
		return
	if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			to_chat(user, SPAN_NOTICE("You unsecure the [src] from the floor!"))
			toggle_tendrils(FALSE)
			anchored = FALSE
		else
			if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
			to_chat(user, SPAN_NOTICE("You secure the [src] to the floor!"))
			anchored = TRUE
		return


/obj/machinery/power/conduit //Da parent of all the conduits, shouldn't really appear anywhere
	name = "general conduit"
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shieldsparkles"
	desc = "A combined conduit and capacitor that transfers and stores massive amounts of energy."
	density = TRUE
	anchored = FALSE //Will be set true just after deploying
	circuit = null
	var/obj/machinery/power/shipside/base

/obj/machinery/power/conduit/Initialize()
	. = ..()
	add_statverb(/datum/statverb/connect_conduit)

/obj/machinery/power/conduit/proc/connect(target)
	if(base || !target)
		return FALSE
	base = target
	base.tendrils.Add(src)
	anchored = TRUE
	connect_to_network()
	base.RefreshParts()
	base.build_tendril_dirs()
	base.update_icon()

/obj/machinery/power/conduit/proc/disconnect()
	if(!base)
		return FALSE
	if(base.running != 0 && !base.emergency_shutdown)
		base.offline_for += 300
		base.shutdown_machine()
		base.emergency_shutdown = TRUE
		base.log_event(0, base)
	base.tendrils.Remove(src)
	base.build_tendril_dirs()
	base.RefreshParts()
	base.update_icon()
	base = null
	no_light()
	disconnect_from_network()

/obj/machinery/power/conduit/proc/no_light()
	set_light(0)

/obj/machinery/power/conduit/proc/bright_light()
	set_light(2, 2, "#ff0000")

/obj/machinery/power/conduit/Destroy()
	if(base)
		disconnect()
	. = ..()

/obj/machinery/power/conduit/on_deconstruction()
	disconnect()
	. = ..()
	
/obj/machinery/power/conduit/RefreshParts()
	. = ..()
	if(base)
		base.RefreshParts()

/obj/machinery/power/conduit/attackby(obj/item/O, mob/user)
	// Prevents whatever unholy things can happen if you touch conduits mid-work.
	if(base)
		if(base.running)
			to_chat(user, "Turn off \the [base] first!")
			return
		if(base.offline_for)
			to_chat(user, "Wait until \the [base] cools down from emergency shutdown first!")
			return

	if(default_deconstruction(O, user))
		return
	if(default_part_replacement(O, user))
		if(base)
			base.RefreshParts()
		return

	//TODO: Implement unwrenching in a proper centralised location. Having to copypaste this around sucks
	if(QUALITY_BOLT_TURNING in O.tool_qualities)
		wrench(user, O)
		return

	if(istool(O))
		return src.attack_hand(user)

/obj/machinery/power/conduit/proc/wrench(user, obj/item/I)
	if(base)
		to_chat(usr, SPAN_NOTICE("Disconnect [src] from the [base] first!"))
		return
	if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			to_chat(user, SPAN_NOTICE("You unsecure the [src] from the floor!"))
			anchored = FALSE
		else
			if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
			to_chat(user, SPAN_NOTICE("You secure the [src] to the floor!"))
			anchored = TRUE
		return

/obj/machinery/power/conduit/verb/rotate() //copied from emitter.dm
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr.stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1