#define DEFAULT_PRESSURE_DELTA 10000

#define EXTERNAL_PRESSURE_BOUND ONE_ATMOSPHERE
#define INTERNAL_PRESSURE_BOUND 0
#define PRESSURE_CHECKS 1

#define PRESSURE_CHECK_EXTERNAL 1
#define PRESSURE_CHECK_INTERNAL 2

/obj/machinery/atmospherics/unary/vent_pump
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "map_vent"

	name = "air vent"
	desc = "Has a valve and pump attached to it"
	use_power = NO_POWER_USE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 12000		//12000 W ~ 16 HP

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY //connects to regular and supply pipes

	level = BELOW_PLATING_LEVEL
	layer = GAS_SCRUBBER_LAYER

	var/area/initial_loc
	var/area_uid
	var/id_tag

	var/pump_direction = 1 //0 = siphoning, 1 = releasing
	var/expanded_range = FALSE

	var/external_pressure_bound = EXTERNAL_PRESSURE_BOUND
	var/internal_pressure_bound = INTERNAL_PRESSURE_BOUND

	var/pressure_checks = PRESSURE_CHECKS
	//1: Do not pass external_pressure_bound
	//2: Do not pass internal_pressure_bound
	//3: Do not pass either

	// Used when handling incoming radio signals requesting default settings
	var/external_pressure_bound_default = EXTERNAL_PRESSURE_BOUND
	var/internal_pressure_bound_default = INTERNAL_PRESSURE_BOUND
	var/pressure_checks_default = PRESSURE_CHECKS

	var/welded = FALSE // Added for aliens -- TLE

	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/radio_filter_out
	var/radio_filter_in

/obj/machinery/atmospherics/unary/vent_pump/on
	use_power = IDLE_POWER_USE
	icon_state = "map_vent_out"

/obj/machinery/atmospherics/unary/vent_pump/siphon
	pump_direction = 0

/obj/machinery/atmospherics/unary/vent_pump/siphon/on
	use_power = IDLE_POWER_USE
	icon_state = "map_vent_in"

/obj/machinery/atmospherics/unary/vent_pump/siphon/on/atmos
	use_power = IDLE_POWER_USE
	icon_state = "map_vent_in"
	external_pressure_bound = 0
	external_pressure_bound_default = 0
	internal_pressure_bound = 2000
	internal_pressure_bound_default = 2000
	pressure_checks = 2
	pressure_checks_default = 2

/obj/machinery/atmospherics/unary/vent_pump/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2

	initial_loc = get_area(loc)
	area_uid = initial_loc.uid
	if (!id_tag)
		assign_uid()
		id_tag = num2text(uid)

/obj/machinery/atmospherics/unary/vent_pump/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/unary/vent_pump/high_volume
	name = "Large Air Vent"
	power_channel = STATIC_EQUIP
	power_rating = 15000	//15 kW ~ 20 HP

/obj/machinery/atmospherics/unary/vent_pump/high_volume/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800

/obj/machinery/atmospherics/unary/vent_pump/engine
	name = "Engine Core Vent"
	power_channel = STATIC_ENVIRON
	power_rating = 30000	//15 kW ~ 20 HP

/obj/machinery/atmospherics/unary/vent_pump/engine/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500 //meant to match air injector

/obj/machinery/atmospherics/unary/vent_pump/update_icon(safety = 0)
	if(!node1)
		use_power = NO_POWER_USE

	if(welded)
		icon_state = "weld"
	else if(!powered() || !use_power)
		icon_state = "off"
	else
		icon_state = pump_direction ? "out" : "in"
		if(expanded_range)
			icon_state += "_expanded"

/obj/machinery/atmospherics/unary/vent_pump/update_underlays()
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

/obj/machinery/atmospherics/unary/vent_pump/hide()
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/vent_pump/Process()
	..()

	if (!node1)
		use_power = NO_POWER_USE
		return

	if(!use_power)
		return 0

	if(stat & (NOPOWER|BROKEN))
		return 0

	if(welded)
		return 0

	var/list/environments = get_target_environments(src, expanded_range)
	if(!length(environments))
		return 0

	var/power_draw = 0
	var/transfer_happened = FALSE

	for(var/e in environments)
		var/datum/gas_mixture/environment = e
		if (!environment)
			continue

		if (!environment.total_moles && !air_contents.total_moles)
			continue

		//Figure out the target pressure difference
		var/pressure_delta = get_pressure_delta(environment)
		//src.visible_message("DEBUG >>> [src]: pressure_delta = [pressure_delta]")

		if(pressure_delta > 0.5)
			if(pump_direction) //internal -> external
				var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
				power_draw += pump_gas(src, air_contents, environment, transfer_moles, power_rating)
			else //external -> internal
				var/transfer_moles = calculate_transfer_moles(environment, air_contents, pressure_delta, (network)? network.volume : 0)

				//limit flow rate from turfs
				transfer_moles = min(transfer_moles, environment.total_moles*air_contents.volume/environment.volume)	//group_multiplier gets divided out here
				power_draw += pump_gas(src, environment, air_contents, transfer_moles, power_rating)
			transfer_happened = TRUE

	if(transfer_happened)
		last_power_draw = power_draw
		use_power(power_draw)
		if(network)
			network.update = 1

	return 1

/obj/machinery/atmospherics/unary/vent_pump/proc/get_pressure_delta(datum/gas_mixture/environment)
	var/pressure_delta = DEFAULT_PRESSURE_DELTA
	var/environment_pressure = environment.return_pressure()

	if(pump_direction) //internal -> external
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, external_pressure_bound - environment_pressure) //increasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, air_contents.return_pressure() - internal_pressure_bound) //decreasing the pressure here
	else //external -> internal
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, environment_pressure - external_pressure_bound) //decreasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, internal_pressure_bound - air_contents.return_pressure()) //increasing the pressure here

	return pressure_delta

/obj/machinery/atmospherics/unary/vent_pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"area" = src.area_uid,
		"tag" = src.id_tag,
		"device" = "AVP",
		"power" = use_power,
		"direction" = pump_direction?("release"):("siphon"),
		"expanded_range" = expanded_range,
		"checks" = pressure_checks,
		"internal" = internal_pressure_bound,
		"external" = external_pressure_bound,
		"timestamp" = world.time,
		"sigtype" = "status",
		"power_draw" = last_power_draw,
		"flow_rate" = last_flow_rate,
	)

	if(!initial_loc.air_vent_names[id_tag])
		var/new_name = "[initial_loc.name] Vent Pump #[initial_loc.air_vent_names.len+1]"
		initial_loc.air_vent_names[id_tag] = new_name
		src.name = new_name
	initial_loc.air_vent_info[id_tag] = signal.data

	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1


/obj/machinery/atmospherics/unary/vent_pump/atmos_init()
	..()

	//some vents work his own special way
	radio_filter_in = frequency==1439?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==1439?(RADIO_TO_AIRALARM):null
	if(frequency)
		radio_connection = register_radio(src, frequency, frequency, radio_filter_in)
		src.broadcast_status()

/obj/machinery/atmospherics/unary/vent_pump/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return

	//log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/atmospherics/unary/vent_pump/receive_signal([signal.debug_print()])")
	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return 0

	if(signal.data["purge"] != null)
		pressure_checks &= ~1
		pump_direction = 0

	if(signal.data["stabalize"] != null)
		pressure_checks |= 1
		pump_direction = 1

	if(signal.data["power"] != null)
		use_power = text2num(signal.data["power"])

	if(signal.data["power_toggle"] != null)
		use_power = !use_power

	if(signal.data["checks"] != null)
		if (signal.data["checks"] == "default")
			pressure_checks = pressure_checks_default
		else
			pressure_checks = text2num(signal.data["checks"])

	if(signal.data["checks_toggle"] != null)
		pressure_checks = (pressure_checks?0:3)

	if(signal.data["direction"] != null)
		pump_direction = text2num(signal.data["direction"])

	if(signal.data["expanded_range"])
		expanded_range = text2num(signal.data["expanded_range"])
	if(signal.data["toggle_expanded_range"])
		expanded_range = !expanded_range

	if(signal.data["set_internal_pressure"] != null)
		if (signal.data["set_internal_pressure"] == "default")
			internal_pressure_bound = internal_pressure_bound_default
		else
			internal_pressure_bound = between(
				0,
				text2num(signal.data["set_internal_pressure"]),
				ONE_ATMOSPHERE*50
			)

	if(signal.data["set_external_pressure"] != null)
		if (signal.data["set_external_pressure"] == "default")
			external_pressure_bound = external_pressure_bound_default
		else
			external_pressure_bound = between(
				0,
				text2num(signal.data["set_external_pressure"]),
				ONE_ATMOSPHERE*50
			)

	if(signal.data["adjust_internal_pressure"] != null)
		internal_pressure_bound = between(
			0,
			internal_pressure_bound + text2num(signal.data["adjust_internal_pressure"]),
			ONE_ATMOSPHERE*50
		)

	if(signal.data["adjust_external_pressure"] != null)
		external_pressure_bound = between(
			0,
			external_pressure_bound + text2num(signal.data["adjust_external_pressure"]),
			ONE_ATMOSPHERE*50
		)

	if(signal.data["init"] != null)
		name = signal.data["init"]
		return

	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

		//log_admin("DEBUG \[[world.timeofday]\]: vent_pump/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_pump/attackby(obj/item/I, mob/user)

	var/tool_type = I.get_tool_type(user, list(QUALITY_WELDING, QUALITY_BOLT_TURNING), src)
	switch(tool_type)

		if(QUALITY_WELDING)
			to_chat(user, SPAN_NOTICE("Now welding the vent."))
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				if(!welded)
					user.visible_message(SPAN_NOTICE("\The [user] welds the vent shut."), SPAN_NOTICE("You weld the vent shut."), "You hear welding.")
					welded = 1
					update_icon()
				else
					user.visible_message(SPAN_NOTICE("[user] unwelds the vent."), SPAN_NOTICE("You unweld the vent."), "You hear welding.")
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
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				user.visible_message( \
					SPAN_NOTICE("\The [user] unfastens \the [src]."), \
					SPAN_NOTICE("You have unfastened \the [src]."), \
					"You hear a ratchet.")
				new /obj/item/pipe(loc, make_from=src)
				qdel(src)
				return
			return

		if(ABORT_CHECK)
			return

	return

/obj/machinery/atmospherics/unary/vent_pump/examine(mob/user)
	var/description = ""
	if(get_dist(user, src) <= 2)
		description += "A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; [round(last_power_draw)] W \n"
	else
		description += "You are too far away to read the gauge. \n"
	if(welded)
		description += "It seems welded shut"
	..(user, 1, afterDesc = description)

/obj/machinery/atmospherics/unary/vent_pump/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/unary/vent_pump/Destroy()
	if(initial_loc)
		initial_loc.air_vent_info -= id_tag
		initial_loc.air_vent_names -= id_tag
	return ..()

#undef DEFAULT_PRESSURE_DELTA

#undef EXTERNAL_PRESSURE_BOUND
#undef INTERNAL_PRESSURE_BOUND
#undef PRESSURE_CHECKS

#undef PRESSURE_CHECK_EXTERNAL
#undef PRESSURE_CHECK_INTERNAL
