#define EVENT_ENABLED           3
#define EVENT_DISABLED          4
#define EVENT_RECONFIGURED      5
#define PASSIVE_SCAN_RANGE      6
#define PASSIVE_SCAN_PERIOD     3 SECONDS
#define PULSE_PROGRESS_TIME    30  // in decisecond
#define ACTIVE_SCAN_RANGE      10
#define ACTIVE_SCAN_DURATION   30 SECONDS

var/list/ship_scanners = list()

/obj/machinery/power/long_range_scanner
	name = "long range scanner"
	desc = "An advanced long range scanner with heavy-duty capacitor, capable of scanning celestial anomalies at large distances."
	icon = 'icons/obj/machines/conduit_of_soul.dmi'
	icon_state = "core_inactive"
	density = TRUE
	anchored = FALSE

	circuit = /obj/item/electronics/circuitboard/long_range_scanner



	var/needs_update = FALSE //If true, will update in process

	var/datum/wires/long_range_scanner/wires
	var/list/event_log = list()			// List of relevant events for this shield
	var/max_log_entries = 200			// A safety to prevent players generating endless logs and69aybe endangering server69emory

	var/scanner_modes = 0				// Enabled scanner69ode flags
	var/as_duration_multiplier = 1.0    // Active scan duration69ultiplier (improve internal components)
	var/as_energy_multiplier = 1.0      // Active scan energy cost69ultiplier (improve internal components)

	var/max_energy = 0					//69aximal stored energy. In joules. Depends on the type of used SMES coil when constructing this scanner.
	var/current_energy = 0				// Current stored energy.
	var/running = SCANNER_OFF			// Whether the scanner is enabled or69ot.
	var/input_cap = 169EGAWATTS			// Currently set input limit. Set to 0 to disable limits altogether. The shield will try to input this69alue per tick at69ost
	var/upkeep_power_usage = 0			// Upkeep power usage last tick.
	var/power_usage = 0					// Total power usage last tick.
	var/overloaded = 0					// Whether the field has overloaded and shut down to regenerate.
	var/offline_for = 0					// The scanner will be inoperable for this duration in ticks.
	var/input_cut = 0					// Whether the input wire is cut.
	var/mode_changes_locked = 0			// Whether the control wire is cut, locking out changes.
	var/ai_control_disabled = 0			// Whether the AI control is disabled.
	var/emergency_shutdown = FALSE		// Whether the scanner is currently recovering from an emergency shutdown
	var/list/default_modes = list()
	var/generatingShield = FALSE //true when shield tiles are in process of being generated

	var/obj/effect/overmap/ship/linked_ship =69ull // To access position of Eris on the overmap

	var/list/tendrils = list()
	var/list/tendril_dirs = list(NORTH, EAST, WEST)
	var/tendrils_deployed = FALSE				// Whether the dummy capacitors are currently extended


/obj/machinery/power/long_range_scanner/update_icon()
	cut_overlays()
	if(running)
		set_light(1, 1, "#82C2D8")
		icon_state = "core_warmup"
		spawn(20)
			set_light(2, 2, "#82C2D8")
			icon_state = "core_active"
	else
		set_light(1, 1, "#82C2D8")
		icon_state = "core_shutdown"
		spawn(20)
			set_light(0)
			icon_state = "core_inactive"

	for (var/obj/machinery/scanner_conduit/S in tendrils)
		if (running)
			S.dim_light()
			S.icon_state = "warmup"
			S.update_icon()
			spawn(20)
				S.bright_light()
				S.icon_state = "speen"
				S.update_icon()

		else
			S.dim_light()
			S.icon_state = "shutdown"
			S.update_icon()
			spawn(20)
				S.no_light()
				S.icon_state = "inactive"
				S.update_icon()


/obj/machinery/power/long_range_scanner/Initialize()
	. = ..()
	connect_to_network()
	wires =69ew(src)
	ship_scanners += src
	var/obj/effect/overmap/ship/S =69ap_sectors69"69z69"69
	if(istype(S))
		S.scanners |= src

	// Link to Eris object on the overmap
	linked_ship = (locate(/obj/effect/overmap/ship/eris) in GLOB.ships)

/obj/machinery/power/long_range_scanner/Destroy()
	toggle_tendrils(FALSE)
	QDEL_NULL(wires)
	ship_scanners -= src
	var/obj/effect/overmap/ship/S =69ap_sectors69"69z69"69
	if(istype(S))
		S.scanners -= src
	. = ..()


/obj/machinery/power/long_range_scanner/RefreshParts()
	max_energy = 0
	for(var/obj/item/stock_parts/smes_coil/S in component_parts)
		max_energy += (S.ChargeCapacity / CELLRATE)
	current_energy = between(0, current_energy,69ax_energy)

	// Better69icro lasers increase the duration of the active scan69ode
	as_duration_multiplier = 1.0 + 0.5 *69ax_part_rating(/obj/item/stock_parts/micro_laser)
	as_duration_multiplier = between(initial(as_duration_multiplier), as_duration_multiplier, 10.0)

	// Better capacitors diminish the energy consumption of the active scan69ode
	as_energy_multiplier = 1.0 - 0.1 *69ax_part_rating(/obj/item/stock_parts/capacitor)
	as_energy_multiplier = between(0.0, as_energy_multiplier, initial(as_energy_multiplier))


// Shuts down the long range scanner
/obj/machinery/power/long_range_scanner/proc/shutdown_scanner()
	running = SCANNER_OFF
	update_icon()


/obj/machinery/power/long_range_scanner/Process()
	upkeep_power_usage = 0
	power_usage = 0

	if (!anchored)
		return
	if(offline_for)
		offline_for =69ax(0, offline_for - 1)
		if (offline_for <= 0)
			emergency_shutdown = FALSE

	// We are shutting down, therefore our stored energy disperses faster than usual.
	else if(running == SCANNER_DISCHARGING)
		if (offline_for <= 0)
			shutdown_scanner() //We've finished the winding down period and69ow turn off
			offline_for += 30 //Another69inute before it can be turned back on again
		return

	upkeep_power_usage = ENERGY_UPKEEP_SCANNER

	if(powernet && !input_cut && (running == SCANNER_RUNNING || running == SCANNER_OFF))
		var/energy_buffer = 0
		energy_buffer = draw_power(min(upkeep_power_usage, input_cap))
		power_usage += round(energy_buffer)

		if(energy_buffer < upkeep_power_usage)
			current_energy -= round(upkeep_power_usage - energy_buffer)	// If we don't have enough energy from the grid, take it from the internal battery instead.

		//69ow try to recharge our internal energy.
		var/energy_to_demand
		if(input_cap)
			energy_to_demand = between(0,69ax_energy - current_energy, input_cap - upkeep_power_usage)
		else
			energy_to_demand =69ax(0,69ax_energy - current_energy)
		energy_buffer = draw_power(energy_to_demand)
		power_usage += energy_buffer
		current_energy += round(energy_buffer)
	else
		current_energy -= round(upkeep_power_usage)	// We are shutting down, or we lack external power connection. Use energy from internal source instead.

	if(current_energy <= 0)
		energy_failure()

	if (charge_level() > 5)
		overloaded = 0


/obj/machinery/power/long_range_scanner/attackby(obj/item/O as obj,69ob/user as69ob)
	// Prevents dismantle-rebuild tactics to reset the emergency shutdown timer.
	if(running)
		to_chat(user, "Turn off \the 69src69 first!")
		return
	if(offline_for)
		to_chat(user, "Wait until \the 69src69 cools down from emergency shutdown first!")
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


/obj/machinery/power/long_range_scanner/proc/energy_failure()
	if(running == SCANNER_DISCHARGING)
		shutdown_scanner()
	else
		if (current_energy < 0)
			current_energy = 0
		overloaded = 1


/obj/machinery/power/long_range_scanner/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/data69069

	data69"running"69 = running
	data69"logs"69 = get_logs()
	data69"overloaded"69 = overloaded
	data69"max_energy"69 = round(max_energy / 1000000, 0.1)
	data69"current_energy"69 = round(current_energy / 1000000, 0.1)
	data69"input_cap_kw"69 = round(input_cap / 1000)
	data69"upkeep_power_usage"69 = round(upkeep_power_usage / 1000, 0.1)
	data69"power_usage"69 = round(power_usage / 1000)
	data69"offline_for"69 = offline_for * 2
	data69"shutdown"69 = emergency_shutdown


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "lrscanner.tmpl", src.name, 650, 800)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/power/long_range_scanner/attack_hand(var/mob/user)
	ui_interact(user)
	if(panel_open)
		wires.Interact(user)


/obj/machinery/power/long_range_scanner/CanUseTopic(var/mob/user)
	if(issilicon(user) && !Adjacent(user) && ai_control_disabled)
		return STATUS_UPDATE
	return ..()


/obj/machinery/power/long_range_scanner/Topic(href, href_list)
	if(..())
		return 1
	if(!anchored)
		return
	//Doesn't respond while disabled
	if(offline_for)
		return

	if(href_list69"begin_shutdown"69)
		if(running != SCANNER_RUNNING)
			return
		running = SCANNER_DISCHARGING
		offline_for += 30 //It'll take one69inute to shut down
		. = 1
		log_event(EVENT_DISABLED, src)

	if(href_list69"start_generator"69)
		running = SCANNER_RUNNING
		update_icon()
		log_event(EVENT_ENABLED, src)
		offline_for = 3 //This is to prevent cases where you startup the shield and then turn it off again immediately while spamclicking
		. = 1

	// Instantly drops the shield, but causes a cooldown before it69ay be started again. Also carries a risk of EMP at high charge.
	if(href_list69"emergency_shutdown"69)
		if(!running)
			return

		var/choice = input(usr, "Are you sure that you want to initiate an emergency shutdown? This will instantly power off the long range scanner, and69ay result in unstable release of stored electromagnetic energy. Proceed at your own risk.") in list("Yes", "No")
		if((choice != "Yes") || !running)
			return

		var/temp_integrity = charge_level()

		offline_for += 300 //569inutes, given that procs happen every 2 seconds
		shutdown_scanner()
		emergency_shutdown = TRUE
		log_event(EVENT_DISABLED, src)
		if(prob(temp_integrity - 50) * 1.75)
			spawn()
				empulse(src, 7, 14)
		. = 1

	if(mode_changes_locked || offline_for)
		return 1

	if(href_list69"set_input_cap"69)
		var/new_cap = round(input(usr, "Enter69ew input cap (in kW). Enter 0 or69othing to disable input cap.", "Generator Power Control", round(input_cap / 1000)) as69um)
		if(!new_cap)
			input_cap = 0
			return
		input_cap =69ax(0,69ew_cap) * 1000
		log_event(EVENT_RECONFIGURED, src)
		. = 1

	ui_interact(usr)

/obj/machinery/power/long_range_scanner/proc/charge_level()
	if(max_energy)
		return (current_energy /69ax_energy) * 100
	return 0


// Checks whether specific flags are enabled
/obj/machinery/power/long_range_scanner/proc/check_flag(var/flag)
	return (scanner_modes & flag)


/obj/machinery/power/long_range_scanner/proc/get_logs()
	var/list/all_logs = list()
	for(var/i = event_log.len; i > 1; i--)
		all_logs.Add(list(list(
			"entry" = event_log69i69
		)))
	return all_logs


/obj/machinery/power/long_range_scanner/proc/wrench(var/user,69ar/obj/item/O)
	if(O.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			to_chat(user, SPAN_NOTICE("You unsecure the 69src69 from the floor!"))
			anchored = FALSE
		else
			if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
			to_chat(user, SPAN_NOTICE("You secure the 69src69 to the floor!"))
			anchored = TRUE
		return

//This proc keeps an internal log of shield impacts, activations, deactivations, and a69ague log of config changes
/obj/machinery/power/long_range_scanner/proc/log_event(var/event_type,69ar/atom/origin_atom)
	var/logstring = "69stationtime2text()69: "
	switch (event_type)

		if (EVENT_ENABLED to EVENT_RECONFIGURED)
			switch (event_type)
				if (EVENT_ENABLED)
					logstring += "Shield powered up"
				if (EVENT_DISABLED)
					logstring += "Shield powered down"
				if (EVENT_RECONFIGURED)
					logstring += "Configuration altered"
				else
					return

			if (origin_atom == src)
				logstring += "69ia Physical Access"
			else
				logstring += " from console at"
				var/area/A = get_area(origin_atom)
				if (A)
					logstring += " 69strip_improper(A.name)69"
				else
					logstring += " Unknown Area"

				if (origin_atom)
					logstring += ", 69origin_atom.x ? origin_atom.x : "unknown"69,69origin_atom.y ? origin_atom.y : "unknown"69,69origin_atom.z ? origin_atom.z : "unknown"69"


	if (logstring != "")
		//Insert this string into the log
		event_log.Add(logstring)

		//If we're over the limit, cut the oldest entry
		if (event_log.len >69ax_log_entries)
			event_log.Cut(1,2)

/obj/machinery/scanner_conduit
	name = "scanner conduit"
	icon = 'icons/obj/machines/conduit_of_soul.dmi'
	icon_state = "inactive"
	desc = "A combined conduit and capacitor that transfers and stores69assive amounts of energy."
	density = TRUE
	anchored = FALSE //Will be set true just after deploying
	var/obj/machinery/power/long_range_scanner/scanner

/obj/machinery/scanner_conduit/proc/connect(sca)
	scanner = sca

/obj/machinery/scanner_conduit/proc/no_light()
	set_light(0)

/obj/machinery/scanner_conduit/proc/dim_light()
	set_light(1, 1, "#82C2D8")

/obj/machinery/scanner_conduit/proc/bright_light()
	set_light(2, 2, "#82C2D8")

/obj/machinery/scanner_conduit/Destroy()
	if(scanner)
		scanner.toggle_tendrils(FALSE)
		if(scanner.running != SCANNER_OFF && !scanner.emergency_shutdown)
			scanner.offline_for += 300
			scanner.shutdown_scanner()
			scanner.emergency_shutdown = TRUE
			scanner.log_event(EVENT_DISABLED, scanner)
	. = ..()

/obj/machinery/power/long_range_scanner/wrench(user, obj/item/I)
	if(running != SCANNER_OFF)
		to_chat(usr, SPAN_NOTICE("Scanner has to be toggled off first!"))
		return
	if(tendrils_deployed)
		to_chat(usr, SPAN_NOTICE("Retract conduits first!"))
		return
	if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			to_chat(user, SPAN_NOTICE("You unsecure the 69src69 from the floor!"))
			toggle_tendrils(FALSE)
			anchored = FALSE
		else
			if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
			to_chat(user, SPAN_NOTICE("You secure the 69src69 to the floor!"))
			anchored = TRUE
		return

/obj/machinery/power/long_range_scanner/verb/toggle_tendrils_verb()
	set category = "Object"
	set69ame = "Toggle conduits"
	set src in69iew(1)

	if(running != SCANNER_OFF)
		to_chat(usr, SPAN_NOTICE("Scanner has to be toggled off first!"))
		return
	toggle_tendrils()

/obj/machinery/power/long_range_scanner/proc/toggle_tendrils(on =69ull)
	var/target_state
	if (!isnull(on))
		target_state = on
	else
		target_state = tendrils_deployed ? FALSE : TRUE //Otherwise we're toggling

	if (target_state == tendrils_deployed)
		return
	//If we're extending them
	if (target_state == TRUE)
		for (var/D in tendril_dirs)
			var/turf/T = get_step(src, D)
			var/obj/machinery/scanner_conduit/SC = locate(/obj/machinery/scanner_conduit) in T
			if(SC)
				continue
			if (!turf_clear(T))
				visible_message(SPAN_DANGER("The 69src69 buzzes an insistent warning as it lacks the space to deploy"))
				playsound(src.loc, "/sound/machines/buzz-two", 100, 1, 5)
				tendrils_deployed = FALSE
				update_icon()
				return FALSE

		//Now deploy
		for (var/D in tendril_dirs)
			var/turf/T = get_step(src, D)
			var/obj/machinery/scanner_conduit/SC = locate(/obj/machinery/scanner_conduit) in T
			if(!SC) SC =69ew(T)
			SC.connect(src)
			tendrils.Add(SC)
			SC.face_atom(src)
			SC.anchored = TRUE
		tendrils_deployed = TRUE
		update_icon()

		to_chat(usr, SPAN_NOTICE("You deployed 69src69 conduits."))
		return TRUE

	else if (target_state == FALSE)
		for (var/obj/machinery/scanner_conduit/SC in tendrils)
			tendrils.Remove(SC)
			qdel(SC)
		tendrils_deployed = FALSE
		update_icon()

		to_chat(usr, SPAN_NOTICE("You retracted 69src69 conduits."))
		return FALSE

/obj/machinery/power/long_range_scanner/proc/consume_energy_scan()
	if(current_energy > round(ENERGY_PER_SCAN * as_energy_multiplier))
		current_energy -= round(ENERGY_PER_SCAN * as_energy_multiplier)
		return TRUE
	return FALSE

#undef EVENT_ENABLED
#undef EVENT_DISABLED
#undef EVENT_RECONFIGURED
