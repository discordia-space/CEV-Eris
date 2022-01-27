#define DEFAULT_PRESSURE_DELTA 10000

#define EXTERNAL_PRESSURE_BOUND ONE_ATMOSPHERE
#define INTERNAL_PRESSURE_BOUND 0
#define PRESSURE_CHECKS 1

#define PRESSURE_CHECK_EXTERNAL 1
#define PRESSURE_CHECK_INTERNAL 2

/obj/machinery/atmospherics/unary/vent_pump
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "map_vent"

	name = "air69ent"
	desc = "Has a69alve and pump attached to it"
	use_power =69O_POWER_USE
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
	//1: Do69ot pass external_pressure_bound
	//2: Do69ot pass internal_pressure_bound
	//3: Do69ot pass either

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
		id_tag =69um2text(uid)

/obj/machinery/atmospherics/unary/vent_pump/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/unary/vent_pump/high_volume
	name = "Large Air69ent"
	power_channel = STATIC_EQUIP
	power_rating = 15000	//15 kW ~ 20 HP

/obj/machinery/atmospherics/unary/vent_pump/high_volume/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800

/obj/machinery/atmospherics/unary/vent_pump/engine
	name = "Engine Core69ent"
	power_channel = STATIC_ENVIRON
	power_rating = 30000	//15 kW ~ 20 HP

/obj/machinery/atmospherics/unary/vent_pump/engine/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500 //meant to69atch air injector

/obj/machinery/atmospherics/unary/vent_pump/update_icon(safety = 0)
	if(!node1)
		use_power =69O_POWER_USE

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
		if(!T.is_plating() &&69ode1 &&69ode1.level == BELOW_PLATING_LEVEL && istype(node1, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node1)
				add_underlay(T,69ode1, dir,69ode1.icon_connect_type)
			else
				add_underlay(T,, dir)
			underlays += "frame"

/obj/machinery/atmospherics/unary/vent_pump/hide()
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/vent_pump/Process()
	..()

	if (!node1)
		use_power =69O_POWER_USE
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
		//src.visible_message("DEBUG >>> 69src69: pressure_delta = 69pressure_delta69")

		if(pressure_delta > 0.5)
			if(pump_direction) //internal -> external
				var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
				power_draw += pump_gas(src, air_contents, environment, transfer_moles, power_rating)
			else //external -> internal
				var/transfer_moles = calculate_transfer_moles(environment, air_contents, pressure_delta, (network)?69etwork.volume : 0)

				//limit flow rate from turfs
				transfer_moles =69in(transfer_moles, environment.total_moles*air_contents.volume/environment.volume)	//group_multiplier gets divided out here
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
			pressure_delta =69in(pressure_delta, external_pressure_bound - environment_pressure) //increasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta =69in(pressure_delta, air_contents.return_pressure() - internal_pressure_bound) //decreasing the pressure here
	else //external -> internal
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta =69in(pressure_delta, environment_pressure - external_pressure_bound) //decreasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta =69in(pressure_delta, internal_pressure_bound - air_contents.return_pressure()) //increasing the pressure here

	return pressure_delta

/obj/machinery/atmospherics/unary/vent_pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal =69ew
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

	if(!initial_loc.air_vent_names69id_tag69)
		var/new_name = "69initial_loc.name6969ent Pump #69initial_loc.air_vent_names.len+169"
		initial_loc.air_vent_names69id_tag69 =69ew_name
		src.name =69ew_name
	initial_loc.air_vent_info69id_tag69 = signal.data

	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1


/obj/machinery/atmospherics/unary/vent_pump/atmos_init()
	..()

	//some69ents work his own special way
	radio_filter_in = frequency==1439?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==1439?(RADIO_TO_AIRALARM):null
	if(frequency)
		radio_connection = register_radio(src, frequency, frequency, radio_filter_in)
		src.broadcast_status()

/obj/machinery/atmospherics/unary/vent_pump/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return

	//log_admin("DEBUG \6969world.timeofday69\69: /obj/machinery/atmospherics/unary/vent_pump/receive_signal(69signal.debug_print()69)")
	if(!signal.data69"tag"69 || (signal.data69"tag"69 != id_tag) || (signal.data69"sigtype"69!="command"))
		return 0

	if(signal.data69"purge"69 !=69ull)
		pressure_checks &= ~1
		pump_direction = 0

	if(signal.data69"stabalize"69 !=69ull)
		pressure_checks |= 1
		pump_direction = 1

	if(signal.data69"power"69 !=69ull)
		use_power = text2num(signal.data69"power"69)

	if(signal.data69"power_toggle"69 !=69ull)
		use_power = !use_power

	if(signal.data69"checks"69 !=69ull)
		if (signal.data69"checks"69 == "default")
			pressure_checks = pressure_checks_default
		else
			pressure_checks = text2num(signal.data69"checks"69)

	if(signal.data69"checks_toggle"69 !=69ull)
		pressure_checks = (pressure_checks?0:3)

	if(signal.data69"direction"69 !=69ull)
		pump_direction = text2num(signal.data69"direction"69)

	if(signal.data69"expanded_range"69)
		expanded_range = text2num(signal.data69"expanded_range"69)
	if(signal.data69"toggle_expanded_range"69)
		expanded_range = !expanded_range

	if(signal.data69"set_internal_pressure"69 !=69ull)
		if (signal.data69"set_internal_pressure"69 == "default")
			internal_pressure_bound = internal_pressure_bound_default
		else
			internal_pressure_bound = between(
				0,
				text2num(signal.data69"set_internal_pressure"69),
				ONE_ATMOSPHERE*50
			)

	if(signal.data69"set_external_pressure"69 !=69ull)
		if (signal.data69"set_external_pressure"69 == "default")
			external_pressure_bound = external_pressure_bound_default
		else
			external_pressure_bound = between(
				0,
				text2num(signal.data69"set_external_pressure"69),
				ONE_ATMOSPHERE*50
			)

	if(signal.data69"adjust_internal_pressure"69 !=69ull)
		internal_pressure_bound = between(
			0,
			internal_pressure_bound + text2num(signal.data69"adjust_internal_pressure"69),
			ONE_ATMOSPHERE*50
		)

	if(signal.data69"adjust_external_pressure"69 !=69ull)
		external_pressure_bound = between(
			0,
			external_pressure_bound + text2num(signal.data69"adjust_external_pressure"69),
			ONE_ATMOSPHERE*50
		)

	if(signal.data69"init"69 !=69ull)
		name = signal.data69"init"69
		return

	if(signal.data69"status"69 !=69ull)
		spawn(2)
			broadcast_status()
		return //do69ot update_icon

		//log_admin("DEBUG \6969world.timeofday69\69:69ent_pump/receive_signal: unknown command \"69signal.data69"command"6969\"\n69signal.debug_print()69")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_pump/attackby(obj/item/I,69ob/user)

	var/tool_type = I.get_tool_type(user, list(QUALITY_WELDING, QUALITY_BOLT_TURNING), src)
	switch(tool_type)

		if(QUALITY_WELDING)
			to_chat(user, SPAN_NOTICE("Now welding the69ent."))
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				if(!welded)
					user.visible_message(SPAN_NOTICE("\The 69user69 welds the69ent shut."), SPAN_NOTICE("You weld the69ent shut."), "You hear welding.")
					welded = 1
					update_icon()
				else
					user.visible_message(SPAN_NOTICE("69user69 unwelds the69ent."), SPAN_NOTICE("You unweld the69ent."), "You hear welding.")
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
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				user.visible_message( \
					SPAN_NOTICE("\The 69user69 unfastens \the 69src69."), \
					SPAN_NOTICE("You have unfastened \the 69src69."), \
					"You hear a ratchet.")
				new /obj/item/pipe(loc,69ake_from=src)
				qdel(src)
				return
			return

		if(ABORT_CHECK)
			return

	return

/obj/machinery/atmospherics/unary/vent_pump/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A small gauge in the corner reads 69round(last_flow_rate, 0.1)69 L/s; 69round(last_power_draw)69 W")
	else
		to_chat(user, "You are too far away to read the gauge.")
	if(welded)
		to_chat(user, "It seems welded shut.")

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
