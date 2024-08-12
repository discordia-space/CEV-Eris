#define EVENT_ENABLED           3
#define EVENT_DISABLED          4
#define EVENT_RECONFIGURED      5
#define PASSIVE_SCAN_RANGE      6
#define PASSIVE_SCAN_PERIOD     3 SECONDS
#define PULSE_PROGRESS_TIME    30  // in decisecond
#define ACTIVE_SCAN_RANGE      10
#define ACTIVE_SCAN_DURATION   10 SECONDS

var/list/ship_scanners = list()

/obj/machinery/power/shipside/long_range_scanner
	name = "long range scanner"
	desc = "An advanced long range scanner with heavy-duty capacitor, capable of scanning celestial anomalies at large distances."
	description_info = "Can be moved by retracting the power conduits with the appropiate right-click verb"
	icon = 'icons/obj/machines/conduit_of_soul.dmi'
	icon_state = "core_inactive"
	density = TRUE
	anchored = FALSE

	circuit = /obj/item/electronics/circuitboard/long_range_scanner

	var/datum/wires/long_range_scanner/wires
	list/event_log = list()			// List of relevant events for this scanner
	max_log_entries = 200			// A safety to prevent players generating endless logs and maybe endangering server memory

	var/as_duration_multiplier = 1.0    // Active scan duration multiplier (improve internal components)
	var/as_energy_multiplier = 1.0      // Active scan energy cost multiplier (improve internal components)

	max_energy = 0					// Maximal stored energy. In joules. Depends on the type of used SMES coil when constructing this scanner.
	var/input_maxcap = 0			// Maximal level of input by the scanner. Set by RefreshParts()
	current_energy = 0				// Current stored energy.
	running = SCANNER_OFF			// Whether the scanner is enabled or not.
	input_cap = 1 MEGAWATTS			// Currently set input limit. Set to 0 to disable limits altogether. The scanner will try to input this value per tick at most
	upkeep_power_usage = 0			// Upkeep power usage last tick.
	power_usage = 0					// Total power usage last tick.
	offline_for = 0					// The scanner will be inoperable for this duration in ticks.
	input_cut = 0					// Whether the input wire is cut.
	mode_changes_locked = 0			// Whether the control wire is cut, locking out changes.
	ai_control_disabled = 0			// Whether the AI control is disabled.
	emergency_shutdown = FALSE		// Whether the scanner is currently recovering from an emergency shutdown

	obj/effect/overmap/ship/linked_ship = null // To access position of Eris on the overmap

	list/tendrils = list()
	list/tendril_dirs = list()
	tendrils_deployed = FALSE				// Whether the capacitors are currently extended


/obj/machinery/power/shipside/long_range_scanner/update_icon()
	if(running)
		set_light(1, 1, "#82C2D8")
		flick("core_warmup", src)
		icon_state = "core_active"
		spawn(6)
			set_light(2, 2, "#82C2D8")
	else
		set_light(1, 1, "#82C2D8")
		flick("core_shutdown", src)
		icon_state = "core_inactive"
		spawn(5)
			set_light(0)

	for (var/obj/machinery/power/conduit/scanner_conduit/S in tendrils)
		if (running)
			S.dim_light()
			flick("warmup", S)
			S.icon_state = "speen"
			spawn(19)
				S.bright_light()
		else
			S.dim_light()
			flick("shutdown", S)
			S.icon_state = "inactive"
			spawn(5)
				S.no_light()


/obj/machinery/power/shipside/long_range_scanner/Initialize()
	. = ..()
	wires = new(src)
	ship_scanners += src
	var/obj/effect/overmap/ship/S = map_sectors["[z]"]
	if(istype(S))
		S.scanners |= src

	// Link to Eris object on the overmap
	linked_ship = (locate(/obj/effect/overmap/ship/eris) in GLOB.ships)

/obj/machinery/power/shipside/long_range_scanner/Destroy()
	QDEL_NULL(wires)
	ship_scanners -= src
	var/obj/effect/overmap/ship/S = map_sectors["[z]"]
	if(istype(S))
		S.scanners -= src
	. = ..()


/obj/machinery/power/shipside/long_range_scanner/RefreshParts()
	max_energy = 0
	input_maxcap = 0
	for(var/obj/machinery/power/conduit/scanner_conduit/SC in tendrils)
		for(var/obj/item/stock_parts/smes_coil/S in SC.component_parts)
			max_energy += (S.ChargeCapacity / CELLRATE) / 3					//Divide by 3 because three default conduits
			input_maxcap += S.IOCapacity									//Around 2.25 MEGAWATTS with default parts
	current_energy = between(0, current_energy, max_energy)					//Yes, same as the shieldgen.
	input_cap = between(0, input_cap, input_maxcap)

	// Better scanners increase the duration of the active scan mode
	var/scan_rating = 0
	as_duration_multiplier = max(1, 1.0 * tendrils.len)
	for(var/obj/item/stock_parts/scanning_module/S in component_parts)
		scan_rating += S.rating
	as_duration_multiplier *= scan_rating / 2
	for(var/obj/item/bluespace_crystal/artificial/A in component_parts)
		as_duration_multiplier /= 2											//Halves duration if you use cheep crystal. Miser pays twice!

	// Better capacitors diminish the energy consumption of the active scan mode
	as_energy_multiplier = 1.15
	for(var/obj/machinery/power/conduit/scanner_conduit/SC in tendrils)
		as_energy_multiplier -= 0.05 * SC.rating

// Shuts down the long range scanner
/obj/machinery/power/shipside/long_range_scanner/shutdown_machine()
	running = SCANNER_OFF
	update_icon()

/obj/machinery/power/shipside/long_range_scanner/spawn_tendrils(dirs = list(NORTH, EAST, WEST))
	for (var/D in dirs)
		var/turf/T = get_step(src, D)
		var/obj/machinery/power/conduit/scanner_conduit/tendril = locate(T)
		if(!tendril)
			tendril = new(T)
		tendril.connect(src)
		tendril.face_atom(src)
		tendril.anchored = TRUE
		tendrils_deployed = TRUE
	build_tendril_dirs()
	update_icon()

/obj/machinery/power/shipside/long_range_scanner/Process()
	upkeep_power_usage = 0
	power_usage = 0

	if (!anchored)
		return
	if(offline_for)
		offline_for = max(0, offline_for - 1)
		if (offline_for <= 0)
			emergency_shutdown = FALSE

	// We are shutting down, therefore our stored energy disperses faster than usual.
	else if(running == SCANNER_DISCHARGING)
		if (offline_for <= 0)
			shutdown_machine() //We've finished the winding down period and now turn off
			offline_for += 30 //Another minute before it can be turned back on again
		return

	if(running == SCANNER_RUNNING)
		upkeep_power_usage = ENERGY_UPKEEP_SCANNER

	if(tendrils_deployed && !input_cut && (running == SCANNER_RUNNING || running == SCANNER_OFF))
		var/energy_buffer = 0
		for(var/obj/machinery/power/conduit/scanner_conduit/SC in tendrils)
			energy_buffer += SC.draw_power(input_cap / tendrils.len)
		power_usage += round(energy_buffer)
		current_energy += energy_buffer - upkeep_power_usage //if grid energy is lower than upkeep - negative number will be added
	else
		current_energy -= round(upkeep_power_usage)	// We are shutting down, or we lack external power connection. Use energy from internal source instead.

	if(current_energy <= 0)
		energy_failure()


/obj/machinery/power/shipside/long_range_scanner/proc/energy_failure()
	offline_for += 150
	shutdown_machine()
	emergency_shutdown = TRUE
	if (current_energy < 0)
		current_energy = 0


/obj/machinery/power/shipside/long_range_scanner/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	var/data[0]

	data["running"] = running
	data["logs"] = get_logs()
	data["max_energy"] = round(max_energy / 1000000, 0.1)
	data["current_energy"] = round(current_energy / 1000000, 0.1)
	data["input_cap_kw"] = round(input_cap / 1000)
	data["upkeep_power_usage"] = round(upkeep_power_usage / 1000, 0.1)
	data["power_usage"] = round(power_usage / 1000)
	data["offline_for"] = offline_for * 2
	data["shutdown"] = emergency_shutdown


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "lrscanner.tmpl", src.name, 650, 800)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/power/shipside/long_range_scanner/attack_hand(var/mob/user)
	nano_ui_interact(user)
	if(panel_open)
		wires.Interact(user)


/obj/machinery/power/shipside/long_range_scanner/CanUseTopic(var/mob/user)
	if(issilicon(user) && !Adjacent(user) && ai_control_disabled)
		return STATUS_UPDATE
	return ..()


/obj/machinery/power/shipside/long_range_scanner/Topic(href, href_list)
	if(..())
		return 1
	if(!anchored)
		return
	//Doesn't respond while disabled
	if(offline_for)
		return

	if(href_list["begin_shutdown"])
		if(running != SCANNER_RUNNING)
			return
		running = SCANNER_DISCHARGING
		offline_for += 30 //It'll take one minute to shut down
		. = 1
		log_event(EVENT_DISABLED, src)

	if(href_list["start_generator"])
		if(tendrils_deployed == FALSE)
			visible_message(SPAN_DANGER("The [src] buzzes an insistent warning as it needs to have it's conduits deployed first to operate"))
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 100, 1, 5)
			return
		running = SCANNER_RUNNING
		update_icon()
		log_event(EVENT_ENABLED, src)
		offline_for = 3 //This is to prevent cases where you startup the scanner and then turn it off again immediately while spamclicking
		. = 1

	// Instantly drops the scanner, but causes a cooldown before it may be started again. Also carries a risk of EMP at high charge.
	if(href_list["emergency_shutdown"])
		if(!running)
			return

		var/choice = input(usr, "Are you sure that you want to initiate an emergency shutdown? This will instantly power off the long range scanner, and may result in unstable release of stored electromagnetic energy. Proceed at your own risk.") in list("Yes", "No")
		if((choice != "Yes") || !running)
			return

		var/temp_integrity = charge_level()

		offline_for += 300 //5 minutes, given that procs happen every 2 seconds
		shutdown_machine()
		emergency_shutdown = TRUE
		log_event(EVENT_DISABLED, src)
		if(prob(temp_integrity - 50) * 1.75)
			spawn()
				empulse(src, 7, 14)
		. = 1

	if(mode_changes_locked || offline_for)
		return 1

	if(href_list["set_input_cap"])
		var/new_cap = round(input(usr, "Enter new input cap (in kW). Current maximal input cap is [input_maxcap / 1000] kW", "Scanner Power Control", round(input_cap / 1000)) as num)
		if(!new_cap)
			return
		input_cap = between(1, new_cap, input_maxcap / 1000) * 1000
		log_event(EVENT_RECONFIGURED, src)
		. = 1

	nano_ui_interact(usr)

/obj/machinery/power/shipside/long_range_scanner/proc/charge_level()
	if(max_energy)
		return (current_energy / max_energy) * 100
	return 0



/obj/machinery/power/shipside/long_range_scanner/proc/get_logs()
	var/list/all_logs = list()
	for(var/i = event_log.len; i > 1; i--)
		all_logs.Add(list(list(
			"entry" = event_log[i]
		)))
	return all_logs

//This proc keeps an internal log of scanner activations, deactivations, and a vague log of config changes
/obj/machinery/power/shipside/long_range_scanner/log_event(var/event_type, var/atom/origin_atom)
	var/logstring = "[stationtime2text()]: "
	switch (event_type)

		if (EVENT_ENABLED to EVENT_RECONFIGURED)
			switch (event_type)
				if (EVENT_ENABLED)
					logstring += "Scanner powered up"
				if (EVENT_DISABLED)
					logstring += "Scanner powered down"
				if (EVENT_RECONFIGURED)
					logstring += "Configuration altered"
				else
					return

			if (origin_atom == src)
				logstring += " via Physical Access"
			else
				logstring += " from console at"
				var/area/A = get_area(origin_atom)
				if (A)
					logstring += " [strip_improper(A.name)]"
				else
					logstring += " Unknown Area"

				if (origin_atom)
					logstring += ", [origin_atom.x ? origin_atom.x : "unknown"],[origin_atom.y ? origin_atom.y : "unknown"],[origin_atom.z ? origin_atom.z : "unknown"]"


	if (logstring != "")
		//Insert this string into the log
		event_log.Add(logstring)

		//If we're over the limit, cut the oldest entry
		if (event_log.len > max_log_entries)
			event_log.Cut(1,2)

/obj/machinery/power/shipside/long_range_scanner/proc/consume_energy_scan()
	if(current_energy > round(ENERGY_PER_SCAN * as_energy_multiplier))
		current_energy -= round(ENERGY_PER_SCAN * as_energy_multiplier)
		return TRUE
	return FALSE


/obj/machinery/power/conduit/scanner_conduit
	name = "scanner conduit"
	icon = 'icons/obj/machines/conduit_of_soul.dmi'
	icon_state = "inactive"
	desc = "A combined conduit and capacitor that transfers and stores massive amounts of energy while also increasing the efficiency of connected long range scanner."
	density = TRUE
	anchored = FALSE //Will be set true just after deploying
	circuit = /obj/item/electronics/circuitboard/scanner_conduit
	var/rating //average rating of all capacitors
	
/obj/machinery/power/conduit/scanner_conduit/no_light()
	set_light(0)

/obj/machinery/power/conduit/scanner_conduit/proc/dim_light()
	set_light(1, 1, "#82C2D8")

/obj/machinery/power/conduit/scanner_conduit/bright_light()
	set_light(2, 2, "#82C2D8")

/obj/machinery/power/conduit/scanner_conduit/RefreshParts()
	rating = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		rating += C.rating
	rating /= 2
	. = ..()

/obj/machinery/power/conduit/scanner_conduit/disconnect()
	if(!base)
		return FALSE
	if(base.running != 0 && !base.emergency_shutdown)
		base.offline_for += 300
		base.shutdown_machine()
		base.emergency_shutdown = TRUE
		base.log_event(EVENT_DISABLED, base)
	base.tendrils.Remove(src)
	base.build_tendril_dirs()
	base.RefreshParts()
	base.update_icon()
	base = null
	no_light()
	disconnect_from_network()

#undef EVENT_ENABLED
#undef EVENT_DISABLED
#undef EVENT_RECONFIGURED
