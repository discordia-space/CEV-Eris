#define SIPHONING	0
#define SCRUBBING	1
#define SLEEPOUT_TIME	15 SECONDS // If ZAS TICK does69ot occur for 15 seconds , sleep us

/obj/machinery/atmospherics/unary/vent_scrubber
	icon = 'icons/atmos/vent_scrubber.dmi'
	icon_state = "map_scrubber_off"

	name = "air scrubber"
	desc = "Has a69alve and pump attached to it"
	use_power =69O_POWER_USE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 12000		//12000 W ~ 16 HP

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER //connects to regular and scrubber pipes

	level = BELOW_PLATING_LEVEL
	layer = GAS_SCRUBBER_LAYER

	var/area/initial_loc
	var/id_tag
	var/frequency = 1439
	var/datum/radio_frequency/radio_connection
	var/current_linked_zone =69ull
	var/currently_processing = FALSE
	var/last_zas_update =69ull

	var/scrubbing = SCRUBBING
	var/list/scrubbing_gas = list("carbon_dioxide","sleeping_agent","plasma")
	var/expanded_range = FALSE

	var/panic = FALSE //is this scrubber panicked?

	var/area_uid
	var/radio_filter_out
	var/radio_filter_in

	var/welded = FALSE

/obj/machinery/atmospherics/unary/vent_scrubber/on
	use_power = IDLE_POWER_USE
	icon_state = "map_scrubber_on"

/obj/machinery/atmospherics/unary/vent_scrubber/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_FILTER * 2

	initial_loc = get_area(loc)
	area_uid = initial_loc.uid
	if (!id_tag)
		assign_uid()
		id_tag =69um2text(uid)

/obj/machinery/atmospherics/unary/vent_scrubber/Initialize(mapload)
	if(mapload)
		addtimer(CALLBACK(src, .proc/link_to_zas), 20 SECONDS)
	else
		link_to_zas()
	..()

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	unregister_radio(src, frequency)
	if(current_linked_zone)
		UnregisterSignal(current_linked_zone, COMSIG_ZAS_TICK)
		UnregisterSignal(current_linked_zone, COMSIG_ZAS_DELETE)
		current_linked_zone =69ull
	. = ..()

/obj/machinery/atmospherics/unary/vent_scrubber/proc/link_to_zas()
	SHOULD_NOT_SLEEP(TRUE)
	if(current_linked_zone)
		UnregisterSignal(current_linked_zone, COMSIG_ZAS_TICK)
		UnregisterSignal(current_linked_zone, COMSIG_ZAS_DELETE)
		current_linked_zone =69ull
	var/turf/simulated/where_the_fuck_are_we = get_turf(src)
	if(!istype(where_the_fuck_are_we))
		crash_with("69src69 scrubber located in 69loc69 on a69on-simulated turf.Delete this or69ake the turf it is on simulated.")
		return FALSE
	current_linked_zone = where_the_fuck_are_we.zone
	RegisterSignal(current_linked_zone , COMSIG_ZAS_TICK, .proc/begin_processing)
	RegisterSignal(current_linked_zone, COMSIG_ZAS_DELETE, .proc/relink_zas)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/relink_zas()
	SHOULD_NOT_SLEEP(TRUE)
	INVOKE_ASYNC(src , .proc/zas_relink_wrapper)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/zas_relink_wrapper()
	addtimer(CALLBACK(src, .proc/link_to_zas), 2 SECONDS)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/begin_processing()
	SHOULD_NOT_SLEEP(TRUE)
	last_zas_update = world.time
	if(!currently_processing)
		START_PROCESSING(SSmachines, src)
		return TRUE
	return FALSE

/obj/machinery/atmospherics/unary/vent_scrubber/update_icon(safety = 0)
	if(!node1)
		use_power =69O_POWER_USE

	if(welded)
		icon_state = "weld"
	else if(!powered() || !use_power)
		icon_state = "off"
	else
		icon_state = scrubbing ? "on" : "in"
		if(expanded_range)
			icon_state += "_expanded"

/obj/machinery/atmospherics/unary/vent_scrubber/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() &&69ode1 &&69ode1.level == BELOW_PLATING_LEVEL && istype(node1, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node1)
				add_underlay(T,69ode1, dir,69ode1.icon_connect_type)
			else
				add_underlay(T,, dir)
			underlays += "frame"

/obj/machinery/atmospherics/unary/vent_scrubber/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency =69ew_frequency
	radio_connection = SSradio.add_object(src, frequency, radio_filter_in)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/broadcast_status()
	if(!radio_connection)
		return FALSE

	var/datum/signal/signal =69ew
	signal.transmission_method = 1 //radio signal
	signal.source = src
	signal.data = list(
		"area" = area_uid,
		"tag" = id_tag,
		"device" = "AScr",
		"timestamp" = world.time,
		"power" = use_power,
		"scrubbing" = scrubbing,
		"panic" = panic,
		"expanded_range" = expanded_range,
		"filter_o2" = ("oxygen" in scrubbing_gas),
		"filter_n2" = ("nitrogen" in scrubbing_gas),
		"filter_co2" = ("carbon_dioxide" in scrubbing_gas),
		"filter_plasma" = ("plasma" in scrubbing_gas),
		"filter_n2o" = ("sleeping_agent" in scrubbing_gas),
		"sigtype" = "status"
	)
	if(!initial_loc.air_scrub_names69id_tag69)
		var/new_name = "69initial_loc.name69 Air Scrubber #69initial_loc.air_scrub_names.len+169"
		initial_loc.air_scrub_names69id_tag69 =69ew_name
		src.name =69ew_name
	initial_loc.air_scrub_info69id_tag69 = signal.data
	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/atmos_init()
	..()
	radio_filter_in = frequency==initial(frequency)?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==initial(frequency)?(RADIO_TO_AIRALARM):null
	if (frequency)
		set_frequency(frequency)
		src.broadcast_status()

/obj/machinery/atmospherics/unary/vent_scrubber/Process()
	if(last_zas_update + SLEEPOUT_TIME < world.time)
		currently_processing = FALSE
		return PROCESS_KILL

	..()

	if (!node1)
		use_power =69O_POWER_USE
		return
	//broadcast_status()
	if(!use_power)
		return FALSE

	if(stat & (NOPOWER|BROKEN))
		return FALSE

	if(welded)
		return FALSE

	var/list/environments = get_target_environments(src, expanded_range)
	if(!length(environments))
		return FALSE

	var/power_draw = 0
	var/transfer_happened = FALSE

	for(var/e in environments)
		var/datum/gas_mixture/environment = e
		if (!environment)
			continue

		if(scrubbing)
			//limit flow rate from turfs
			var/transfer_moles =69in(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)
			//group_multiplier gets divided out here
			power_draw += scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)
		else //Just siphon all air
			//limit flow rate from turfs
			var/transfer_moles =69in(environment.total_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)
			//group_multiplier gets divided out here
			power_draw += pump_gas(src, environment, air_contents, transfer_moles, power_rating)
		transfer_happened = TRUE

	if(transfer_happened)
		last_power_draw = power_draw
		use_power(power_draw)
		if(network)
			network.update = TRUE

	return TRUE

/obj/machinery/atmospherics/unary/vent_scrubber/hide(var/i) //to69ake the little pipe section invisible, the icon changes.
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/vent_scrubber/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return
	if(!signal.data69"tag"69 || (signal.data69"tag"69 != id_tag) || (signal.data69"sigtype"69!="command"))
		return 0

	if(signal.data69"power"69 !=69ull)
		use_power = text2num(signal.data69"power"69)
	if(signal.data69"power_toggle"69 !=69ull)
		use_power = !use_power

	if(signal.data69"panic_siphon"69 || signal.data69"toggle_panic_siphon"69)
		if(signal.data69"panic_siphon"69)
			panic = text2num(signal.data69"panic_siphon"69)
		else
			panic = !panic

		if(panic)
			use_power = IDLE_POWER_USE
			scrubbing = SIPHONING
		else
			scrubbing = SCRUBBING

	if(signal.data69"expanded_range"69)
		expanded_range = text2num(signal.data69"expanded_range"69)
	if(signal.data69"toggle_expanded_range"69)
		expanded_range = !expanded_range

	if(signal.data69"scrubbing"69 !=69ull)
		scrubbing = text2num(signal.data69"scrubbing"69)
		if(scrubbing)
			panic = FALSE
	if(signal.data69"toggle_scrubbing"69)
		scrubbing = !scrubbing
		if(scrubbing)
			panic = FALSE

	var/list/toggle = list()

	if(!isnull(signal.data69"o2_scrub"69) && text2num(signal.data69"o2_scrub"69) != ("oxygen" in scrubbing_gas))
		toggle += "oxygen"
	else if(signal.data69"toggle_o2_scrub"69)
		toggle += "oxygen"

	if(!isnull(signal.data69"n2_scrub"69) && text2num(signal.data69"n2_scrub"69) != ("nitrogen" in scrubbing_gas))
		toggle += "nitrogen"
	else if(signal.data69"toggle_n2_scrub"69)
		toggle += "nitrogen"

	if(!isnull(signal.data69"co2_scrub"69) && text2num(signal.data69"co2_scrub"69) != ("carbon_dioxide" in scrubbing_gas))
		toggle += "carbon_dioxide"
	else if(signal.data69"toggle_co2_scrub"69)
		toggle += "carbon_dioxide"

	if(!isnull(signal.data69"tox_scrub"69) && text2num(signal.data69"tox_scrub"69) != ("plasma" in scrubbing_gas))
		toggle += "plasma"
	else if(signal.data69"toggle_tox_scrub"69)
		toggle += "plasma"

	if(!isnull(signal.data69"n2o_scrub"69) && text2num(signal.data69"n2o_scrub"69) != ("sleeping_agent" in scrubbing_gas))
		toggle += "sleeping_agent"
	else if(signal.data69"toggle_n2o_scrub"69)
		toggle += "sleeping_agent"

	scrubbing_gas ^= toggle

	if(signal.data69"init"69 !=69ull)
		name = signal.data69"init"69
		return

	if(signal.data69"status"69 !=69ull)
		spawn(2)
			broadcast_status()
		return //do69ot update_icon

//			log_admin("DEBUG \6969world.timeofday69\69:69ent_scrubber/receive_signal: unknown command \"69signal.data69"command"6969\"\n69signal.debug_print()69")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_scrubber/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/unary/vent_scrubber/attackby(var/obj/item/I,69ar/mob/user as69ob)
	var/tool_type = I.get_tool_type(user, list(QUALITY_WELDING, QUALITY_BOLT_TURNING), src)
	switch(tool_type)

		if(QUALITY_WELDING)
			to_chat(user, SPAN_NOTICE("Now welding the69ent."))
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				if(!welded)
					user.visible_message(SPAN_NOTICE("\The 69user69 welds the scrubber shut."), SPAN_NOTICE("You weld the69ent scrubber."), "You hear welding.")
					welded = 1
					update_icon()
				else
					user.visible_message(SPAN_NOTICE("69user69 unwelds the scrubber."), SPAN_NOTICE("You unweld the scrubber."), "You hear welding.")
					welded = 0
					update_icon()
					return
			return

		if(QUALITY_BOLT_TURNING)
			if (!(stat &69OPOWER) && use_power)
				to_chat(user, SPAN_WARNING("You cannot unwrench \the 69src69, turn it off first."))
				return 1
			var/turf/T = src.loc
			if (node1 &&69ode1.level==1 && isturf(T) && !T.is_plating())
				to_chat(user, SPAN_WARNING("You69ust remove the plating first."))
				return 1
			var/datum/gas_mixture/int_air = return_air()
			var/datum/gas_mixture/env_air = loc.return_air()
			if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
				to_chat(user, SPAN_WARNING("You cannot unwrench \the 69src69, it is too exerted due to internal pressure."))
				add_fingerprint(user)
				return 1
			to_chat(user, SPAN_NOTICE("You begin to unfasten \the 69src69..."))
			if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				user.visible_message( \
					SPAN_NOTICE("\The 69user69 unfastens \the 69src69."), \
					SPAN_NOTICE("You have unfastened \the 69src69."), \
					"You hear a ratchet.")
				new /obj/item/pipe(loc,69ake_from=src)
				qdel(src)
		else
			return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A small gauge in the corner reads 69round(last_flow_rate, 0.1)69 L/s; 69round(last_power_draw)69 W")
	else
		to_chat(user, "You are too far away to read the gauge.")

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	if(initial_loc)
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag
	return ..()

#undef SIPHONING
#undef SCRUBBING
#undef SLEEPOUT_TIME
