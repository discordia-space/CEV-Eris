/obj/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH
	var/datum/gas_mixture/air_contents
	var/datum/pipe_network/network


/obj/machinery/atmospherics/unary/LateInitialize()
	initialize_directions = dir
	air_contents = new
	air_contents.volume = 200
	..()

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/unary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network = new_network

	if(new_network.normal_members.Find(src))
		return FALSE

	new_network.normal_members += src


/obj/machinery/atmospherics/unary/Destroy()
	loc = null
	if(node1)
		node1.disconnect(src)
		QDEL_NULL(network)
		node1 = null
	..()


/obj/machinery/atmospherics/unary/atmos_init()
	if(node1)
		return

	for(var/obj/machinery/atmospherics/target in get_step(src, dir))
		if(target.initialize_directions & get_dir(target, src))
			if(check_connect_types(target, src))
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
	if(reference == node1 || reference == src)
		return network


/obj/machinery/atmospherics/unary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network = new_network
	return TRUE


/obj/machinery/atmospherics/unary/return_network_air(datum/pipe_network/reference)
	if(network == reference)
		. += air_contents


/obj/machinery/atmospherics/unary/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		qdel(network)
		node1 = null

	update_icon()
	update_underlays()
