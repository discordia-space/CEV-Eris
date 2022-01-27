/obj/machinery/atmospherics/portables_connector
	icon = 'icons/atmos/connector.dmi'
	icon_state = "map_connector"

	name = "Connector Port"
	desc = "For connecting portables devices related to atmospherics control."

	dir = SOUTH
	initialize_directions = SOUTH

	var/obj/machinery/portable_atmospherics/connected_device

	var/obj/machinery/atmospherics/node

	var/datum/pipe_network/network

	var/on = FALSE
	use_power =69O_POWER_USE
	level = BELOW_PLATING_LEVEL
	layer = GAS_FILTER_LAYER


/obj/machinery/atmospherics/portables_connector/New()
	initialize_directions = dir
	..()

/obj/machinery/atmospherics/portables_connector/update_icon()
	icon_state = "connector"

/obj/machinery/atmospherics/portables_connector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T,69ode, dir)

/obj/machinery/atmospherics/portables_connector/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/portables_connector/Process()
	..()
	if(!on)
		return
	if(!connected_device)
		on = FALSE
		return
	if(network)
		network.update = 1
	return 1

// Housekeeping and pipe69etwork stuff below
/obj/machinery/atmospherics/portables_connector/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference ==69ode)
		network =69ew_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return69ull

/obj/machinery/atmospherics/portables_connector/Destroy()
	loc =69ull

	if(connected_device)
		connected_device.disconnect()

	if(node)
		node.disconnect(src)
		qdel(network)

	node =69ull

	. = ..()

/obj/machinery/atmospherics/portables_connector/atmos_init()
	if(node) return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,69ode_connect))
		if(target.initialize_directions & get_dir(target, src))
			if (check_connect_types(target, src))
				node = target
				break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/portables_connector/build_network()
	if(!network &&69ode)
		network =69ew /datum/pipe_network()
		network.normal_members += src
		network.build_network(node, src)


/obj/machinery/atmospherics/portables_connector/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node)
		return69etwork

	if(reference==connected_device)
		return69etwork

	return69ull

/obj/machinery/atmospherics/portables_connector/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network =69ew_network

	return 1

/obj/machinery/atmospherics/portables_connector/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(connected_device)
		results += connected_device.air_contents

	return results

/obj/machinery/atmospherics/portables_connector/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node)
		qdel(network)
		node =69ull

	update_underlays()

	return69ull


/obj/machinery/atmospherics/portables_connector/attackby(var/obj/item/I,69ar/mob/user)
	if(!(QUALITY_BOLT_TURNING in I.tool_qualities))
		return ..()
	if (connected_device)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the 69src69, dettach \the 69connected_device69 first."))
		return 1
	if (locate(/obj/machinery/portable_atmospherics, src.loc))
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the 69src69, it too exerted due to internal pressure."))
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
