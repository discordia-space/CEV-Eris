/obj/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH

	var/datum/gas_mixture/air_contents

	var/datum/pipe_network/network

/obj/machinery/atmospherics/unary/New()
	..()
	initialize_directions = dir
	air_contents = new

	air_contents.volume = 200

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/unary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/unary/Destroy()
	loc = null

	if(node1)
		node1.disconnect(src)
		QDEL_NULL(network)
		node1 = null

	. = ..()

/obj/machinery/atmospherics/unary/atmos_init()
	if(node1) return

	var/node1_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, node1_connect))
		if(target.initialize_directions & get_dir(target, src))
			if (check_connect_types(target, src))
				node1 = target
				break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/build_network()
	if(!network && node1)
		network = new /datum/pipe_network()
		network.normal_members += src
		network.build_network(node1, src)


/obj/machinery/atmospherics/unary/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node1 || reference == src)
		return network

	return null

/obj/machinery/atmospherics/unary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network = new_network

	return 1

/obj/machinery/atmospherics/unary/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(network == reference)
		results += air_contents

	return results

/obj/machinery/atmospherics/unary/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		qdel(network)
		node1 = null

	update_icon()
	update_underlays()

	return null
