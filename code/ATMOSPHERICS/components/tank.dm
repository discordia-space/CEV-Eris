/obj/machinery/atmospherics/tank
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air_map"

	name = "Pressure Tank"
	desc = "A large vessel containing pressurized gas."

	var/datum/gas_mixture/air_temporary // used when reconstructing a pipeline that broke
	var/volume = 10000 //in liters, 1 meters by 1 meters by 2 meters ~tweaked it a little to simulate a pressure tank without needing to recode them yet
	var/start_pressure = 25*ONE_ATMOSPHERE

	level = BELOW_PLATING_LEVEL
	dir = SOUTH
	initialize_directions = SOUTH
	density = TRUE
	layer = ABOVE_WINDOW_LAYER

	var/obj/machinery/atmospherics/node

	var/datum/pipe_network/network

	var/on = FALSE
	use_power = NO_POWER_USE

/obj/machinery/atmospherics/tank/New()
	icon_state = "air"
	initialize_directions = dir
	..()

/obj/machinery/atmospherics/tank/Process()
	..()
	if(network)
		network.update = 1
	return 1

/obj/machinery/atmospherics/tank/Destroy()
    if(air_temporary)
        loc.assume_air(air_temporary)
        QDEL_NULL(air_temporary)

    ..()
    loc = null

    if(node)
        node.disconnect(src)
        qdel(network)

    node = null

    return QDEL_HINT_QUEUE

/obj/machinery/atmospherics/tank/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node, dir)

/obj/machinery/atmospherics/tank/hide()
	update_underlays()

/obj/machinery/atmospherics/tank/atmos_init()
	if(node) return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, node_connect))
		if(target.initialize_directions & get_dir(target, src))
			if (check_connect_types(target, src))
				node = target
				break

	update_underlays()

/obj/machinery/atmospherics/tank/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node)
		qdel(network)
		node = null

	update_underlays()

	return null

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/tank/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node)
		network = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/tank/build_network()
	if(!network && node)
		network = new /datum/pipe_network()
		network.normal_members += src
		network.build_network(node, src)

/obj/machinery/atmospherics/tank/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node)
		return network


	return null

/obj/machinery/atmospherics/tank/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network = new_network

	return 1

/obj/machinery/atmospherics/tank/return_network_air(datum/pipe_network/reference)
	return air_temporary

/obj/machinery/atmospherics/tank/return_air()
    return air_temporary

/obj/machinery/atmospherics/tank/air
	name = "Pressure Tank (Air)"
	icon_state = "air_map"

/obj/machinery/atmospherics/tank/air/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_multi("oxygen",  (start_pressure*O2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature), \
	                           "nitrogen",(start_pressure*N2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))


	..()
	icon_state = "air"

/obj/machinery/atmospherics/tank/oxygen
	name = "Pressure Tank (Oxygen)"
	icon_state = "o2_map"

/obj/machinery/atmospherics/tank/oxygen/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas("oxygen", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "o2"

/obj/machinery/atmospherics/tank/nitrogen
	name = "Pressure Tank (Nitrogen)"
	icon_state = "n2_map"

/obj/machinery/atmospherics/tank/nitrogen/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas("nitrogen", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "n2"

/obj/machinery/atmospherics/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"
	icon_state = "co2_map"

/obj/machinery/atmospherics/tank/carbon_dioxide/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas("carbon_dioxide", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "co2"

/obj/machinery/atmospherics/tank/plasma
	name = "Pressure Tank (Plasma)"
	description_antag = "Will blind people if they do not wear face-covering gear"
	icon_state = "plasma_map"

/obj/machinery/atmospherics/tank/plasma/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas("plasma", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "plasma"

/obj/machinery/atmospherics/tank/nitrous_oxide
	name = "Pressure Tank (Nitrous Oxide)"
	icon_state = "n2o_map"

/obj/machinery/atmospherics/tank/nitrous_oxide/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T0C

	air_temporary.adjust_gas("sleeping_agent", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "n2o"
