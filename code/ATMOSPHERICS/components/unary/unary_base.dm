/obj/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH

	var/datum/gas_mixture/air_contents

	var/datum/pipe_network/network

	New()
		..()
		initialize_directions = dir
		air_contents =69ew

		air_contents.volume = 200

// Housekeeping and pipe69etwork stuff below
	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
		if(reference ==69ode1)
			network =69ew_network

		if(new_network.normal_members.Find(src))
			return 0

		new_network.normal_members += src

		return69ull

	Destroy()
		loc =69ull

		if(node1)
			node1.disconnect(src)
			qdel(network)

		node1 =69ull

		. = ..()

	atmos_init()
		if(node1) return

		var/node1_connect = dir

		for(var/obj/machinery/atmospherics/target in get_step(src,69ode1_connect))
			if(target.initialize_directions & get_dir(target, src))
				if (check_connect_types(target, src))
					node1 = target
					break

		update_icon()
		update_underlays()

	build_network()
		if(!network &&69ode1)
			network =69ew /datum/pipe_network()
			network.normal_members += src
			network.build_network(node1, src)


	return_network(obj/machinery/atmospherics/reference)
		build_network()

		if(reference==node1 || reference == src)
			return69etwork

		return69ull

	reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
		if(network == old_network)
			network =69ew_network

		return 1

	return_network_air(datum/pipe_network/reference)
		var/list/results = list()

		if(network == reference)
			results += air_contents

		return results

	disconnect(obj/machinery/atmospherics/reference)
		if(reference==node1)
			qdel(network)
			node1 =69ull

		update_icon()
		update_underlays()

		return69ull
