/obj/machinery/atmospherics/binary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	use_power = IDLE_POWER_USE
	layer = GAS_PUMP_LAYER

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2

	var/datum/pipe_network/network1
	var/datum/pipe_network/network2


/obj/machinery/atmospherics/binary/LateInitialize()
	switch(dir)
		if(SOUTH, NORTH)
			initialize_directions = SOUTH|NORTH
		if(EAST, WEST)
			initialize_directions = EAST|WEST
		if(NORTHEAST)
			initialize_directions = NORTH|EAST
		if(NORTHWEST)
			initialize_directions = NORTH|WEST
		if(SOUTHEAST)
			initialize_directions = SOUTH|EAST
		if(SOUTHWEST)
			initialize_directions = SOUTH|WEST

	air1 = new
	air2 = new
	air1.volume = 200
	air2.volume = 200
	..()

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/binary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network1 = new_network

	else if(reference == node2)
		network2 = new_network

	if(new_network.normal_members.Find(src))
		return FALSE

	new_network.normal_members += src


/obj/machinery/atmospherics/binary/Destroy()
	loc = null
	if(node1)
		node1.disconnect(src)
		QDEL_NULL(network1)
		node1 = null
	if(node2)
		node2.disconnect(src)
		QDEL_NULL(network2)
		node2 = null
	..()


/obj/machinery/atmospherics/binary/atmos_init()
	if(node1 && node2)
		return

	var/node2_connect = dir
	var/node1_connect = turn(dir, 180)

	for(var/obj/machinery/atmospherics/target in get_step(src, node1_connect))
		if(target.initialize_directions & get_dir(target, src))
			if(check_connect_types(target, src))
				node1 = target
				break

	for(var/obj/machinery/atmospherics/target in get_step(src, node2_connect))
		if(target.initialize_directions & get_dir(target, src))
			if(check_connect_types(target, src))
				node2 = target
				break


/obj/machinery/atmospherics/binary/update_icon()

/obj/machinery/atmospherics/binary/update_underlays()

/obj/machinery/atmospherics/binary/build_network()
	if(!network1 && node1)
		network1 = new /datum/pipe_network()
		network1.normal_members += src
		network1.build_network(node1, src)

	if(!network2 && node2)
		network2 = new /datum/pipe_network()
		network2.normal_members += src
		network2.build_network(node2, src)


/obj/machinery/atmospherics/binary/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference == node1)
		return network1

	if(reference == node2)
		return network2


/obj/machinery/atmospherics/binary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network1 == old_network)
		network1 = new_network
	if(network2 == old_network)
		network2 = new_network

	return TRUE


/obj/machinery/atmospherics/binary/return_network_air(datum/pipe_network/reference)
	. = list()

	if(network1 == reference)
		. += air1
	if(network2 == reference)
		. += air2


/obj/machinery/atmospherics/binary/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		qdel(network1)
		node1 = null

	else if(reference==node2)
		qdel(network2)
		node2 = null

	update_icon()
	update_underlays()
