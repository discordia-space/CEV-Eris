#define SIPHONING	0
#define SCRUBBING	1
#define SLEEPOUT_TIME	15 SECONDS // If ZAS TICK does not occur for 15 seconds , sleep us

/obj/machinery/atmospherics/unary/vent_scrubber
	icon = 'icons/atmos/vent_scrubber.dmi'
	icon_state = "map_scrubber_off"

	name = "air scrubber"
	desc = "Has a valve and pump attached to it"
	use_power = NO_POWER_USE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 12000		//12000 W ~ 16 HP

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER //connects to regular and scrubber pipes

	level = BELOW_PLATING_LEVEL
	layer = GAS_SCRUBBER_LAYER

	var/area/initial_loc
	var/id_tag
	var/frequency = 1439
	var/datum/radio_frequency/radio_connection
	var/current_linked_zone = null
	var/currently_processing = FALSE
	var/last_zas_update = null

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
		id_tag = num2text(uid)

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/unary/vent_scrubber/update_icon(safety = 0)
	if(!node1)
		use_power = NO_POWER_USE

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
		if(!T.is_plating() && node1 && node1.level == BELOW_PLATING_LEVEL && istype(node1, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node1)
				add_underlay(T, node1, dir, node1.icon_connect_type)
			else
				add_underlay(T,, dir)
			underlays += "frame"

/obj/machinery/atmospherics/unary/vent_scrubber/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, radio_filter_in)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/broadcast_status()
	if(!radio_connection)
		return FALSE

	var/datum/signal/signal = new
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
	if(!initial_loc.air_scrub_names[id_tag])
		var/new_name = "[initial_loc.name] Air Scrubber #[initial_loc.air_scrub_names.len+1]"
		initial_loc.air_scrub_names[id_tag] = new_name
		src.name = new_name
	initial_loc.air_scrub_info[id_tag] = signal.data
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
	..()

	if (!node1)
		use_power = NO_POWER_USE
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
			var/transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)
			//group_multiplier gets divided out here
			power_draw += scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)
		else //Just siphon all air
			//limit flow rate from turfs
			var/transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)
			//group_multiplier gets divided out here
			power_draw += pump_gas(src, environment, air_contents, transfer_moles, power_rating)
		transfer_happened = TRUE

	if(transfer_happened)
		last_power_draw = power_draw
		use_power(power_draw)
		if(network)
			network.update = TRUE

	return TRUE

/obj/machinery/atmospherics/unary/vent_scrubber/hide(var/i) //to make the little pipe section invisible, the icon changes.
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/vent_scrubber/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return
	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return 0

	if(signal.data["power"] != null)
		use_power = text2num(signal.data["power"])
	if(signal.data["power_toggle"] != null)
		use_power = !use_power

	if(signal.data["panic_siphon"] || signal.data["toggle_panic_siphon"])
		if(signal.data["panic_siphon"])
			panic = text2num(signal.data["panic_siphon"])
		else
			panic = !panic

		if(panic)
			use_power = IDLE_POWER_USE
			scrubbing = SIPHONING
		else
			scrubbing = SCRUBBING

	if(signal.data["expanded_range"])
		expanded_range = text2num(signal.data["expanded_range"])
	if(signal.data["toggle_expanded_range"])
		expanded_range = !expanded_range

	if(signal.data["scrubbing"] != null)
		scrubbing = text2num(signal.data["scrubbing"])
		if(scrubbing)
			panic = FALSE
	if(signal.data["toggle_scrubbing"])
		scrubbing = !scrubbing
		if(scrubbing)
			panic = FALSE

	var/list/toggle = list()

	if(!isnull(signal.data["o2_scrub"]) && text2num(signal.data["o2_scrub"]) != ("oxygen" in scrubbing_gas))
		toggle += "oxygen"
	else if(signal.data["toggle_o2_scrub"])
		toggle += "oxygen"

	if(!isnull(signal.data["n2_scrub"]) && text2num(signal.data["n2_scrub"]) != ("nitrogen" in scrubbing_gas))
		toggle += "nitrogen"
	else if(signal.data["toggle_n2_scrub"])
		toggle += "nitrogen"

	if(!isnull(signal.data["co2_scrub"]) && text2num(signal.data["co2_scrub"]) != ("carbon_dioxide" in scrubbing_gas))
		toggle += "carbon_dioxide"
	else if(signal.data["toggle_co2_scrub"])
		toggle += "carbon_dioxide"

	if(!isnull(signal.data["tox_scrub"]) && text2num(signal.data["tox_scrub"]) != ("plasma" in scrubbing_gas))
		toggle += "plasma"
	else if(signal.data["toggle_tox_scrub"])
		toggle += "plasma"

	if(!isnull(signal.data["n2o_scrub"]) && text2num(signal.data["n2o_scrub"]) != ("sleeping_agent" in scrubbing_gas))
		toggle += "sleeping_agent"
	else if(signal.data["toggle_n2o_scrub"])
		toggle += "sleeping_agent"

	scrubbing_gas ^= toggle

	if(signal.data["init"] != null)
		name = signal.data["init"]
		return

	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

//			log_admin("DEBUG \[[world.timeofday]\]: vent_scrubber/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_scrubber/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/unary/vent_scrubber/attackby(var/obj/item/I, var/mob/user as mob)
	var/tool_type = I.get_tool_type(user, list(QUALITY_WELDING, QUALITY_BOLT_TURNING), src)
	switch(tool_type)

		if(QUALITY_WELDING)
			to_chat(user, SPAN_NOTICE("Now welding the vent."))
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				if(!welded)
					user.visible_message(SPAN_NOTICE("\The [user] welds the scrubber shut."), SPAN_NOTICE("You weld the vent scrubber."), "You hear welding.")
					welded = 1
					update_icon()
				else
					user.visible_message(SPAN_NOTICE("[user] unwelds the scrubber."), SPAN_NOTICE("You unweld the scrubber."), "You hear welding.")
					welded = 0
					update_icon()
					return
			return

		if(QUALITY_BOLT_TURNING)
			if (!(stat & NOPOWER) && use_power)
				to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], turn it off first."))
				return 1
			var/turf/T = src.loc
			if (node1 && node1.level==1 && isturf(T) && !T.is_plating())
				to_chat(user, SPAN_WARNING("You must remove the plating first."))
				return 1
			var/datum/gas_mixture/int_air = return_air()
			var/datum/gas_mixture/env_air = loc.return_air()
			if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
				to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
				add_fingerprint(user)
				return 1
			to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
			if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				user.visible_message( \
					SPAN_NOTICE("\The [user] unfastens \the [src]."), \
					SPAN_NOTICE("You have unfastened \the [src]."), \
					"You hear a ratchet.")
				new /obj/item/pipe(loc, make_from=src)
				qdel(src)
		else
			return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/examine(mob/user)
	var/description = ""
	if(get_dist(user, src) <= 2)
		description += "A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; [round(last_power_draw)] W"
	else
		description += "You are too far away to read the gauge."
	..(user, 1, afterDesc = description)

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	if(initial_loc)
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag
	return ..()

#undef SIPHONING
#undef SCRUBBING
#undef SLEEPOUT_TIME
