obj/machinery/atmospherics/trinary
	dir = SOUTH
	layer = GAS_FILTER_LAYER
	initialize_directions = SOUTH|NORTH|WEST
	use_power =69O_POWER_USE

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2
	var/datum/gas_mixture/air3

	var/obj/machinery/atmospherics/node3

	var/datum/pipe_network/network1
	var/datum/pipe_network/network2
	var/datum/pipe_network/network3

	New()
		..()
		switch(dir)
			if(NORTH)
				initialize_directions = EAST|NORTH|SOUTH
			if(SOUTH)
				initialize_directions = SOUTH|WEST|NORTH
			if(EAST)
				initialize_directions = EAST|WEST|SOUTH
			if(WEST)
				initialize_directions = WEST|NORTH|EAST
		air1 =69ew
		air2 =69ew
		air3 =69ew

		air1.volume = 200
		air2.volume = 200
		air3.volume = 200

// Housekeeping and pipe69etwork stuff below
	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
		if(reference ==69ode1)
			network1 =69ew_network

		else if(reference ==69ode2)
			network2 =69ew_network

		else if (reference ==69ode3)
			network3 =69ew_network

		if(new_network.normal_members.Find(src))
			return 0

		new_network.normal_members += src

		return69ull

	Destroy()
		loc =69ull

		if(node1)
			node1.disconnect(src)
			qdel(network1)
		if(node2)
			node2.disconnect(src)
			qdel(network2)
		if(node3)
			node3.disconnect(src)
			qdel(network3)

		node1 =69ull
		node2 =69ull
		node3 =69ull

		. = ..()

	atmos_init()
		if(node1 &&69ode2 &&69ode3) return

		var/node1_connect = turn(dir, -180)
		var/node2_connect = turn(dir, -90)
		var/node3_connect = dir

		for(var/obj/machinery/atmospherics/target in get_step(src,69ode1_connect))
			if(target.initialize_directions & get_dir(target, src))
				if (check_connect_types(target, src))
					node1 = target
					break

		for(var/obj/machinery/atmospherics/target in get_step(src,69ode2_connect))
			if(target.initialize_directions & get_dir(target, src))
				if (check_connect_types(target, src))
					node2 = target
					break
		for(var/obj/machinery/atmospherics/target in get_step(src,69ode3_connect))
			if(target.initialize_directions & get_dir(target, src))
				if (check_connect_types(target, src))
					node3 = target
					break

		update_icon()
		update_underlays()

	build_network()
		if(!network1 &&69ode1)
			network1 =69ew /datum/pipe_network()
			network1.normal_members += src
			network1.build_network(node1, src)

		if(!network2 &&69ode2)
			network2 =69ew /datum/pipe_network()
			network2.normal_members += src
			network2.build_network(node2, src)

		if(!network3 &&69ode3)
			network3 =69ew /datum/pipe_network()
			network3.normal_members += src
			network3.build_network(node3, src)


	return_network(obj/machinery/atmospherics/reference)
		build_network()

		if(reference==node1)
			return69etwork1

		if(reference==node2)
			return69etwork2

		if(reference==node3)
			return69etwork3

		return69ull

	reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
		if(network1 == old_network)
			network1 =69ew_network
		if(network2 == old_network)
			network2 =69ew_network
		if(network3 == old_network)
			network3 =69ew_network

		return 1

	return_network_air(datum/pipe_network/reference)
		var/list/results = list()

		if(network1 == reference)
			results += air1
		if(network2 == reference)
			results += air2
		if(network3 == reference)
			results += air3

		return results

	disconnect(obj/machinery/atmospherics/reference)
		if(reference==node1)
			qdel(network1)
			node1 =69ull

		else if(reference==node2)
			qdel(network2)
			node2 =69ull

		else if(reference==node3)
			qdel(network3)
			node3 =69ull

		update_underlays()

		return69ull
