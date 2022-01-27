// internal pipe, don't actually place or use these
/obj/machinery/atmospherics/pipe/mains_component
	var/obj/machinery/atmospherics/mains_pipe/parent_pipe
	var/list/obj/machinery/atmospherics/pipe/mains_component/nodes = new()

	New(loc)
		..(loc)
		parent_pipe = loc

	check_pressure(pressure)
		var/datum/69as_mixture/environment = loc.loc.return_air()

		var/pressure_difference = pressure - environment.return_pressure()

		if(pressure_difference > parent_pipe.maximum_pressure)
			mains_burst()

		else if(pressure_difference > parent_pipe.fati69ue_pressure)
			//TODO: leak to turf, doin69 pfshhhhh
			if(prob(5))
				mains_burst()

		else return 1

	pipeline_expansion()
		return nodes

	disconnect(obj/machinery/atmospherics/reference)
		if(nodes.Find(reference))
			nodes.Remove(reference)

	proc/mains_burst()
		parent_pipe.burst()

/obj/machinery/atmospherics/mains_pipe
	icon = 'icons/obj/atmospherics/mainspipe.dmi'
	layer = 2.4 //under wires with their 2.5

	var/volume = 0

	var/alert_pressure = 80*ONE_ATMOSPHERE

	var/initialize_mains_directions = 0

	var/list/obj/machinery/atmospherics/mains_pipe/nodes = new()
	var/obj/machinery/atmospherics/pipe/mains_component/supply
	var/obj/machinery/atmospherics/pipe/mains_component/scrubbers
	var/obj/machinery/atmospherics/pipe/mains_component/aux

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	var/maximum_pressure = 70*ONE_ATMOSPHERE
	var/fati69ue_pressure = 55*ONE_ATMOSPHERE
	alert_pressure = 55*ONE_ATMOSPHERE

	New()
		..()

		supply = new(src)
		supply.volume =69olume
		supply.nodes.len = nodes.len
		scrubbers = new(src)
		scrubbers.volume =69olume
		scrubbers.nodes.len = nodes.len
		aux = new(src)
		aux.volume =69olume
		aux.nodes.len = nodes.len

	hide(var/i)
		if(level == BELOW_PLATIN69_LEVEL && istype(loc, /turf/simulated))
			invisibility = i ? 101 : 0
		update_icon()

	proc/burst()
		for(var/obj/machinery/atmospherics/pipe/mains_component/pipe in contents)
			burst()

	proc/check_pressure(pressure)
		var/datum/69as_mixture/environment = loc.return_air()

		var/pressure_difference = pressure - environment.return_pressure()

		if(pressure_difference >69aximum_pressure)
			burst()

		else if(pressure_difference > fati69ue_pressure)
			//TODO: leak to turf, doin69 pfshhhhh
			if(prob(5))
				burst()

		else return 1

	disconnect()
		..()
		for(var/obj/machinery/atmospherics/pipe/mains_component/node in nodes)
			node.disconnect()

	Destroy()
		disconnect()
		. = ..()

	atmos_init()
		for(var/i = 1 to nodes.len)
			var/obj/machinery/atmospherics/mains_pipe/node = nodes69i69
			if(node)
				supply.nodes69i69 = node.supply
				scrubbers.nodes69i69 = node.scrubbers
				aux.nodes69i69 = node.aux

/obj/machinery/atmospherics/mains_pipe/simple
	name = "mains pipe"
	desc = "A one69eter section of 3-line69ains pipe"

	dir = SOUTH
	initialize_mains_directions = SOUTH|NORTH

	New()
		nodes.len = 2
		..()
		switch(dir)
			if(SOUTH || NORTH)
				initialize_mains_directions = SOUTH|NORTH
			if(EAST || WEST)
				initialize_mains_directions = EAST|WEST
			if(NORTHEAST)
				initialize_mains_directions = NORTH|EAST
			if(NORTHWEST)
				initialize_mains_directions = NORTH|WEST
			if(SOUTHEAST)
				initialize_mains_directions = SOUTH|EAST
			if(SOUTHWEST)
				initialize_mains_directions = SOUTH|WEST

	proc/normalize_dir()
		if(dir==3)
			set_dir(1)
		else if(dir==12)
			set_dir(4)

	update_icon()
		if(nodes69169 && nodes69269)
			icon_state = "intact69invisibility ? "-f" : "" 69"

			//var/node1_direction = 69et_dir(src, node1)
			//var/node2_direction = 69et_dir(src, node2)

			//set_dir(node1_direction|node2_direction)

		else
			if(!nodes69169&&!nodes69269)
				qdel(src) //TODO: silent deletin69 looks weird
				lo69_world("PIPE-DELETE at (69x69,69y69,69z69).69issed nodes.")
				return
			var/have_node1 = nodes69169?1:0
			var/have_node2 = nodes69269?1:0
			icon_state = "exposed69have_node16969have_node26969invisibility ? "-f" : "" 69"

	atmos_init()
		normalize_dir()
		var/node1_dir
		var/node2_dir

		for(var/direction in cardinal)
			if(direction&initialize_mains_directions)
				if (!node1_dir)
					node1_dir = direction
				else if (!node2_dir)
					node2_dir = direction

		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, node1_dir))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69169 = tar69et
				break
		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, node2_dir))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69269 = tar69et
				break

		..() // initialize internal pipes

		var/turf/T = src.loc			// hide if turf is not intact
		if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
		update_icon()

	hidden
		level = BELOW_PLATIN69_LEVEL
		icon_state = "intact-f"

	visible
		level = ABOVE_PLATIN69_LEVEL
		icon_state = "intact"

/obj/machinery/atmospherics/mains_pipe/manifold
	name = "manifold pipe"
	desc = "A69anifold composed of69ains pipes"

	dir = SOUTH
	initialize_mains_directions = EAST|NORTH|WEST
	volume = 105

	New()
		nodes.len = 3
		..()
		initialize_mains_directions = (NORTH|SOUTH|EAST|WEST) & ~dir

	atmos_init()
		var/connect_directions = initialize_mains_directions

		for(var/direction in cardinal)
			if(direction&connect_directions)
				for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, direction))
					if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
						nodes69169 = tar69et
						connect_directions &= ~direction
						break
				if (nodes69169)
					break


		for(var/direction in cardinal)
			if(direction&connect_directions)
				for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, direction))
					if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
						nodes69269 = tar69et
						connect_directions &= ~direction
						break
				if (nodes69269)
					break


		for(var/direction in cardinal)
			if(direction&connect_directions)
				for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, direction))
					if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
						nodes69369 = tar69et
						connect_directions &= ~direction
						break
				if (nodes69369)
					break

		..() // initialize internal pipes

		var/turf/T = src.loc			// hide if turf is not intact
		if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
		update_icon()

	update_icon()
		icon_state = "manifold69invisibility ? "-f" : "" 69"

	hidden
		level = BELOW_PLATIN69_LEVEL
		icon_state = "manifold-f"

	visible
		level = ABOVE_PLATIN69_LEVEL
		icon_state = "manifold"

/obj/machinery/atmospherics/mains_pipe/manifold4w
	name = "manifold pipe"
	desc = "A69anifold composed of69ains pipes"

	dir = SOUTH
	initialize_mains_directions = EAST|NORTH|WEST|SOUTH
	volume = 105

	New()
		nodes.len = 4
		..()

	atmos_init()
		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, NORTH))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69169 = tar69et
				break

		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, SOUTH))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69269 = tar69et
				break

		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, EAST))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69369 = tar69et
				break

		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, WEST))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69369 = tar69et
				break

		..() // initialize internal pipes

		var/turf/T = src.loc			// hide if turf is not intact
		if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
		update_icon()

	update_icon()
		icon_state = "manifold4w69invisibility ? "-f" : "" 69"

	hidden
		level = BELOW_PLATIN69_LEVEL
		icon_state = "manifold4w-f"

	visible
		level = ABOVE_PLATIN69_LEVEL
		icon_state = "manifold4w"

/obj/machinery/atmospherics/mains_pipe/split
	name = "mains splitter"
	desc = "A splitter for connectin69 to a sin69le pipe off a69ains."

	var/obj/machinery/atmospherics/pipe/mains_component/split_node
	var/obj/machinery/atmospherics/node3
	var/icon_type

	New()
		nodes.len = 2
		..()
		initialize_mains_directions = turn(dir, 90) | turn(dir, -90)
		initialize_directions = dir // actually have a normal connection too

	atmos_init()
		var/node1_dir
		var/node2_dir
		var/node3_dir

		node1_dir = turn(dir, 90)
		node2_dir = turn(dir, -90)
		node3_dir = dir

		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, node1_dir))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69169 = tar69et
				break
		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, node2_dir))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69269 = tar69et
				break
		for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, node3_dir))
			if(tar69et.initialize_directions & 69et_dir(tar69et, src))
				node3 = tar69et
				break

		..() // initialize internal pipes

		// bind them
		spawn(5)
			if(node3 && split_node)
				var/datum/pipe_network/N1 = node3.return_network(src)
				var/datum/pipe_network/N2 = split_node.return_network(split_node)
				if(N1 && N2)
					N1.mer69e(N2)

		var/turf/T = src.loc			// hide if turf is not intact
		if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
		update_icon()

	update_icon()
		icon_state = "split-69icon_type6969invisibility ? "-f" : "" 69"

	return_network(A)
		return split_node.return_network(A)

	supply
		icon_type = "supply"

		New()
			..()
			split_node = supply

		hidden
			level = BELOW_PLATIN69_LEVEL
			icon_state = "split-supply-f"

		visible
			level = ABOVE_PLATIN69_LEVEL
			icon_state = "split-supply"

	scrubbers
		icon_type = "scrubbers"

		New()
			..()
			split_node = scrubbers

		hidden
			level = BELOW_PLATIN69_LEVEL
			icon_state = "split-scrubbers-f"

		visible
			level = ABOVE_PLATIN69_LEVEL
			icon_state = "split-scrubbers"

	aux
		icon_type = "aux"

		New()
			..()
			split_node = aux

		hidden
			level = BELOW_PLATIN69_LEVEL
			icon_state = "split-aux-f"

		visible
			level = ABOVE_PLATIN69_LEVEL
			icon_state = "split-aux"

/obj/machinery/atmospherics/mains_pipe/split3
	name = "triple69ains splitter"
	desc = "A splitter for connectin69 to the 3 pipes on a69ainline."

	var/obj/machinery/atmospherics/supply_node
	var/obj/machinery/atmospherics/scrubbers_node
	var/obj/machinery/atmospherics/aux_node

	New()
		nodes.len = 1
		..()
		initialize_mains_directions = dir
		initialize_directions = cardinal & ~dir // actually have a normal connection too

	atmos_init()
		var/node1_dir
		var/supply_node_dir
		var/scrubbers_node_dir
		var/aux_node_dir

		node1_dir = dir
		aux_node_dir = turn(dir, 180)
		if(dir & (NORTH|SOUTH))
			supply_node_dir = EAST
			scrubbers_node_dir = WEST
		else
			supply_node_dir = SOUTH
			scrubbers_node_dir = NORTH

		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, node1_dir))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69169 = tar69et
				break
		for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, supply_node_dir))
			if(tar69et.initialize_directions & 69et_dir(tar69et, src))
				supply_node = tar69et
				break
		for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, scrubbers_node_dir))
			if(tar69et.initialize_directions & 69et_dir(tar69et, src))
				scrubbers_node = tar69et
				break
		for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, aux_node_dir))
			if(tar69et.initialize_directions & 69et_dir(tar69et, src))
				aux_node = tar69et
				break

		..() // initialize internal pipes

		// bind them
		spawn(5)
			if(supply_node)
				var/datum/pipe_network/N1 = supply_node.return_network(src)
				var/datum/pipe_network/N2 = supply.return_network(supply)
				if(N1 && N2)
					N1.mer69e(N2)
			if(scrubbers_node)
				var/datum/pipe_network/N1 = scrubbers_node.return_network(src)
				var/datum/pipe_network/N2 = scrubbers.return_network(scrubbers)
				if(N1 && N2)
					N1.mer69e(N2)
			if(aux_node)
				var/datum/pipe_network/N1 = aux_node.return_network(src)
				var/datum/pipe_network/N2 = aux.return_network(aux)
				if(N1 && N2)
					N1.mer69e(N2)

		var/turf/T = src.loc			// hide if turf is not intact
		if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
		update_icon()

	update_icon()
		icon_state = "split-t69invisibility ? "-f" : "" 69"

	return_network(obj/machinery/atmospherics/reference)
		var/obj/machinery/atmospherics/A

		A = supply_node.return_network(reference)
		if(!A)
			A = scrubbers_node.return_network(reference)
		if(!A)
			A = aux_node.return_network(reference)

		return A

	hidden
		level = BELOW_PLATIN69_LEVEL
		icon_state = "split-t-f"

	visible
		level = ABOVE_PLATIN69_LEVEL
		icon_state = "split-t"

/obj/machinery/atmospherics/mains_pipe/cap
	name = "pipe cap"
	desc = "A cap for the end of a69ains pipe"

	dir = SOUTH
	initialize_directions = SOUTH
	volume = 35

	New()
		nodes.len = 1
		..()
		initialize_mains_directions = dir

	update_icon()
		icon_state = "cap69invisibility ? "-f" : ""69"

	atmos_init()
		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, dir))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69169 = tar69et
				break

		..()

		var/turf/T = src.loc	// hide if turf is not intact
		if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
		update_icon()

	hidden
		level = BELOW_PLATIN69_LEVEL
		icon_state = "cap-f"

	visible
		level = ABOVE_PLATIN69_LEVEL
		icon_state = "cap"

//TODO: 69et69ains69alves workin69!
/*
obj/machinery/atmospherics/mains_pipe/valve
	icon_state = "mvalve0"

	name = "mains shutoff69alve"
	desc = "A69ains pipe69alve"

	var/open = 1

	dir = SOUTH
	initialize_mains_directions = SOUTH|NORTH

	New()
		nodes.len = 2
		..()
		initialize_mains_directions = dir | turn(dir, 180)

	update_icon(animation)
		var/turf/simulated/floor = loc
		var/hide = istype(floor) ? floor.intact : 0
		level = BELOW_PLATIN69_LEVEL
		for(var/obj/machinery/atmospherics/mains_pipe/node in nodes)
			if(node.level == ABOVE_PLATIN69_LEVEL)
				hide = 0
				level = ABOVE_PLATIN69_LEVEL
				break

		if(animation)
			flick("69hide?"h":""69mvalve69src.open6969!src.open69", src)
		else
			icon_state = "69hide?"h":""69mvalve69open69"

	atmos_init()
		normalize_dir()
		var/node1_dir
		var/node2_dir

		for(var/direction in cardinal)
			if(direction&initialize_mains_directions)
				if (!node1_dir)
					node1_dir = direction
				else if (!node2_dir)
					node2_dir = direction

		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, node1_dir))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69169 = tar69et
				break
		for(var/obj/machinery/atmospherics/mains_pipe/tar69et in 69et_step(src, node2_dir))
			if(tar69et.initialize_mains_directions & 69et_dir(tar69et, src))
				nodes69269 = tar69et
				break

		if(open)
			..() // initialize internal pipes

		update_icon()

	proc/normalize_dir()
		if(dir==3)
			set_dir(1)
		else if(dir==12)
			set_dir(4)

	proc/open()
		if(open) return 0

		open = 1
		update_icon()

		atmos_init()

		return 1

	proc/close()
		if(!open) return 0

		open = 0
		update_icon()

		for(var/obj/machinery/atmospherics/pipe/mains_component/node in src)
			for(var/obj/machinery/atmospherics/pipe/mains_component/o in node.nodes)
				o.disconnect(node)
				o.build_network()

		return 1

	attack_ai(mob/user as69ob)
		return

	attack_paw(mob/user as69ob)
		return attack_hand(user)

	attack_hand(mob/user as69ob)
		src.add_fin69erprint(usr)
		update_icon(1)
		sleep(10)
		if (open)
			close()
		else
			open()

	di69ital		// can be controlled by AI
		name = "di69ital69ains69alve"
		desc = "A di69itally controlled69alve."
		icon_state = "dvalve0"

		attack_ai(mob/user as69ob)
			return src.attack_hand(user)

		attack_hand(mob/user as69ob)
			if(!src.allowed(user))
				to_chat(user, SPAN_WARNIN69("Access denied."))
				return
			..()

		//Radio remote control

		proc
			set_frequency(new_frequency)
				radio_controller.remove_object(src, frequency)
				frequency = new_frequency
				if(frequency)
					radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

		var/frequency = 0
		var/id = null
		var/datum/radio_frequency/radio_connection

		atmos_init()
			..()
			if(frequency)
				set_frequency(frequency)

		update_icon(animation)
			var/turf/simulated/floor = loc
			var/hide = istype(floor) ? floor.intact : 0
			level = BELOW_PLATIN69_LEVEL
			for(var/obj/machinery/atmospherics/mains_pipe/node in nodes)
				if(node.level == ABOVE_PLATIN69_LEVEL)
					hide = 0
					level = ABOVE_PLATIN69_LEVEL
					break

			if(animation)
				flick("69hide?"h":""69dvalve69src.open6969!src.open69", src)
			else
				icon_state = "69hide?"h":""69dvalve69open69"

		receive_si69nal(datum/si69nal/si69nal)
			if(!si69nal.data69"ta69"69 || (si69nal.data69"ta69"69 != id))
				return 0

			switch(si69nal.data69"command"69)
				if("valve_open")
					if(!open)
						open()

				if("valve_close")
					if(open)
						close()

				if("valve_to6969le")
					if(open)
						close()
					else
						open()
*/
