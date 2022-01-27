#define DEFAULT_PRESSURE_DELTA 10000

#define EXTERNAL_PRESSURE_BOUND ONE_ATMOSPHERE
#define INTERNAL_PRESSURE_BOUND 0
#define PRESSURE_CHECKS 1

#define PRESSURE_CHECK_EXTERNAL 1
#define PRESSURE_CHECK_INPUT 2
#define PRESSURE_CHECK_OUTPUT 4

/obj/machinery/atmospherics/binary/dp_vent_pump
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "map_dp_vent"

	//node2 is output port
	//node1 is input port

	name = "Dual Port Air69ent"
	desc = "Has a69alve and pump attached to it. There are two ports."

	level = BELOW_PLATING_LEVEL

	use_power =69O_POWER_USE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500			//7500 W ~ 10 HP

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER //connects to regular, supply and scrubbers pipes

	var/pump_direction = 1 //0 = siphoning, 1 = releasing

	var/external_pressure_bound = EXTERNAL_PRESSURE_BOUND
	var/input_pressure_min = INTERNAL_PRESSURE_BOUND
	var/output_pressure_max = DEFAULT_PRESSURE_DELTA

	var/frequency = 0
	var/id
	var/datum/radio_frequency/radio_connection

	var/pressure_checks = PRESSURE_CHECK_EXTERNAL
	//1: Do69ot pass external_pressure_bound
	//2: Do69ot pass input_pressure_min
	//4: Do69ot pass output_pressure_max

/obj/machinery/atmospherics/binary/dp_vent_pump/New()
	..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP
	icon =69ull

/obj/machinery/atmospherics/binary/dp_vent_pump/high_volume
	name = "Large Dual Port Air69ent"

/obj/machinery/atmospherics/binary/dp_vent_pump/high_volume/New()
	..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800

/obj/machinery/atmospherics/binary/dp_vent_pump/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	overlays.Cut()

	var/vent_icon = "vent"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(!T.is_plating() &&69ode1 &&69ode2 &&69ode1.level == BELOW_PLATING_LEVEL &&69ode2.level == BELOW_PLATING_LEVEL && istype(node1, /obj/machinery/atmospherics/pipe) && istype(node2, /obj/machinery/atmospherics/pipe))
		vent_icon += "h"

	if(!powered())
		vent_icon += "off"
	else
		vent_icon += "69use_power ? "69pump_direction ? "out" : "in"69" : "off"69"

	overlays += icon_manager.get_atmos_icon("device", , ,69ent_icon)

/obj/machinery/atmospherics/binary/dp_vent_pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() &&69ode1 &&69ode2 &&69ode1.level == BELOW_PLATING_LEVEL &&69ode2.level == BELOW_PLATING_LEVEL && istype(node1, /obj/machinery/atmospherics/pipe) && istype(node2, /obj/machinery/atmospherics/pipe))
			return
		else
			if (node1)
				add_underlay(T,69ode1, turn(dir, -180),69ode1.icon_connect_type)
			else
				add_underlay(T,69ode1, turn(dir, -180))
			if (node2)
				add_underlay(T,69ode2, dir,69ode2.icon_connect_type)
			else
				add_underlay(T,69ode2, dir)

/obj/machinery/atmospherics/binary/dp_vent_pump/hide(var/i)
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/binary/dp_vent_pump/Process()
	..()

	last_power_draw = 0
	last_flow_rate = 0

	if(stat & (NOPOWER|BROKEN) || !use_power)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1

	//Figure out the target pressure difference
	var/pressure_delta = get_pressure_delta(environment)

	if(pressure_delta > 0.5)
		if(pump_direction) //internal -> external
			if (node1 && (environment.temperature || air1.temperature))
				var/transfer_moles = calculate_transfer_moles(air1, environment, pressure_delta)
				power_draw = pump_gas(src, air1, environment, transfer_moles, power_rating)

				if(power_draw >= 0 &&69etwork1)
					network1.update = 1
		else //external -> internal
			if (node2 && (environment.temperature || air2.temperature))
				var/transfer_moles = calculate_transfer_moles(environment, air2, pressure_delta, (network2)?69etwork2.volume : 0)

				//limit flow rate from turfs
				transfer_moles =69in(transfer_moles, environment.total_moles*air2.volume/environment.volume)	//group_multiplier gets divided out here
				power_draw = pump_gas(src, environment, air2, transfer_moles, power_rating)

				if(power_draw >= 0 &&69etwork2)
					network2.update = 1

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

	return 1

/obj/machinery/atmospherics/binary/dp_vent_pump/proc/get_pressure_delta(datum/gas_mixture/environment)
	var/pressure_delta = DEFAULT_PRESSURE_DELTA
	var/environment_pressure = environment.return_pressure()

	if(pump_direction) //internal -> external
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta =69in(pressure_delta, external_pressure_bound - environment_pressure) //increasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INPUT)
			pressure_delta =69in(pressure_delta, air1.return_pressure() - input_pressure_min) //decreasing the pressure here
	else //external -> internal
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta =69in(pressure_delta, environment_pressure - external_pressure_bound) //decreasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_OUTPUT)
			pressure_delta =69in(pressure_delta, output_pressure_max - air2.return_pressure()) //increasing the pressure here

	return pressure_delta


//Radio remote control

/obj/machinery/atmospherics/binary/dp_vent_pump/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency =69ew_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/dp_vent_pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal =69ew
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "ADVP",
		"power" = use_power,
		"direction" = pump_direction?("release"):("siphon"),
		"checks" = pressure_checks,
		"input" = input_pressure_min,
		"output" = output_pressure_max,
		"external" = external_pressure_bound,
		"sigtype" = "status"
	)
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/dp_vent_pump/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/dp_vent_pump/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A small gauge in the corner reads 69round(last_flow_rate, 0.1)69 L/s; 69round(last_power_draw)69 W")


/obj/machinery/atmospherics/unary/vent_pump/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/binary/dp_vent_pump/receive_signal(datum/signal/signal)
	if(!signal.data69"tag"69 || (signal.data69"tag"69 != id) || (signal.data69"sigtype"69!="command"))
		return 0
	if(signal.data69"power"69)
		use_power = text2num(signal.data69"power"69)

	if(signal.data69"power_toggle"69)
		use_power = !use_power

	if(signal.data69"direction"69)
		pump_direction = text2num(signal.data69"direction"69)

	if(signal.data69"checks"69)
		pressure_checks = text2num(signal.data69"checks"69)

	if(signal.data69"purge"69)
		pressure_checks &= ~1
		pump_direction = 0

	if(signal.data69"stabalize"69)
		pressure_checks |= 1
		pump_direction = 1

	if(signal.data69"set_input_pressure"69)
		input_pressure_min = between(
			0,
			text2num(signal.data69"set_input_pressure"69),
			ONE_ATMOSPHERE*50
		)

	if(signal.data69"set_output_pressure"69)
		output_pressure_max = between(
			0,
			text2num(signal.data69"set_output_pressure"69),
			ONE_ATMOSPHERE*50
		)

	if(signal.data69"set_external_pressure"69)
		external_pressure_bound = between(
			0,
			text2num(signal.data69"set_external_pressure"69),
			ONE_ATMOSPHERE*50
		)

	if(signal.data69"status"69)
		spawn(2)
			broadcast_status()
		return //do69ot update_icon

	spawn(2)
		broadcast_status()
	update_icon()

#undef DEFAULT_PRESSURE_DELTA

#undef EXTERNAL_PRESSURE_BOUND
#undef INTERNAL_PRESSURE_BOUND
#undef PRESSURE_CHECKS

#undef PRESSURE_CHECK_EXTERNAL
#undef PRESSURE_CHECK_INPUT
#undef PRESSURE_CHECK_OUTPUT
