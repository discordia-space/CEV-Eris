/obj/machinery/atmospherics/tvalve
	icon = 'icons/atmos/tvalve.dmi'
	icon_state = "map_tvalve0"

	name = "manual switching69alve"
	desc = "A pipe69alve"

	level = BELOW_PLATING_LEVEL
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST

	var/state = 0 // 0 = go straight, 1 = go to side

	// like a trinary component,69ode1 is input,69ode2 is side output,69ode3 is straight output
	var/obj/machinery/atmospherics/node3

	var/datum/pipe_network/network_node1
	var/datum/pipe_network/network_node2
	var/datum/pipe_network/network_node3

/obj/machinery/atmospherics/tvalve/bypass
	icon_state = "map_tvalve1"
	state = 1

/obj/machinery/atmospherics/tvalve/update_icon(animation)
	if(animation)
		flick("tvalve69src.state6969!src.state69", src)
	else
		icon_state = "tvalve69state69"

/obj/machinery/atmospherics/tvalve/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T,69ode1, turn(dir, -180))

		if(istype(src, /obj/machinery/atmospherics/tvalve/mirrored))
			add_underlay(T,69ode2, turn(dir, 90))
		else
			add_underlay(T,69ode2, turn(dir, -90))

		add_underlay(T,69ode3, dir)

/obj/machinery/atmospherics/tvalve/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/tvalve/New()
	initialize_directions()
	..()

/obj/machinery/atmospherics/tvalve/proc/initialize_directions()
	switch(dir)
		if(NORTH)
			initialize_directions = SOUTH|NORTH|EAST
		if(SOUTH)
			initialize_directions =69ORTH|SOUTH|WEST
		if(EAST)
			initialize_directions = WEST|EAST|SOUTH
		if(WEST)
			initialize_directions = EAST|WEST|NORTH

/obj/machinery/atmospherics/tvalve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference ==69ode1)
		network_node1 =69ew_network
		if(state)
			network_node2 =69ew_network
		else
			network_node3 =69ew_network
	else if(reference ==69ode2)
		network_node2 =69ew_network
		if(state)
			network_node1 =69ew_network
	else if(reference ==69ode3)
		network_node3 =69ew_network
		if(!state)
			network_node1 =69ew_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	if(state)
		if(reference ==69ode1)
			if(node2)
				return69ode2.network_expand(new_network, src)
		else if(reference ==69ode2)
			if(node1)
				return69ode1.network_expand(new_network, src)
	else
		if(reference ==69ode1)
			if(node3)
				return69ode3.network_expand(new_network, src)
		else if(reference ==69ode3)
			if(node1)
				return69ode1.network_expand(new_network, src)

	return69ull

/obj/machinery/atmospherics/tvalve/Destroy()
	loc =69ull

	if(node1)
		node1.disconnect(src)
		qdel(network_node1)
	if(node2)
		node2.disconnect(src)
		qdel(network_node2)
	if(node3)
		node3.disconnect(src)
		qdel(network_node3)

	node1 =69ull
	node2 =69ull
	node3 =69ull

	. = ..()

/obj/machinery/atmospherics/tvalve/proc/go_to_side()

	if(state) return 0

	state = 1
	update_icon()

	if(network_node1)
		qdel(network_node1)
	if(network_node3)
		qdel(network_node3)
	build_network()

	if(network_node1&&network_node2)
		network_node1.merge(network_node2)
		network_node2 =69etwork_node1

	if(network_node1)
		network_node1.update = 1
	else if(network_node2)
		network_node2.update = 1

	return 1

/obj/machinery/atmospherics/tvalve/proc/go_straight()

	if(!state)
		return 0

	state = 0
	update_icon()

	if(network_node1)
		qdel(network_node1)
	if(network_node2)
		qdel(network_node2)
	build_network()

	if(network_node1&&network_node3)
		network_node1.merge(network_node3)
		network_node3 =69etwork_node1

	if(network_node1)
		network_node1.update = 1
	else if(network_node3)
		network_node3.update = 1

	return 1

/obj/machinery/atmospherics/tvalve/attack_ai(mob/user as69ob)
	return

/obj/machinery/atmospherics/tvalve/attack_hand(mob/user as69ob)
	src.add_fingerprint(usr)
	update_icon(1)
	sleep(10)
	if (src.state)
		src.go_straight()
	else
		src.go_to_side()

/obj/machinery/atmospherics/tvalve/Process()
	..()
	. = PROCESS_KILL
	//machines.Remove(src)

	return

/obj/machinery/atmospherics/tvalve/atmos_init()
	var/node1_dir
	var/node2_dir
	var/node3_dir

	node1_dir = turn(dir, 180)
	node2_dir = turn(dir, -90)
	node3_dir = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,69ode1_dir))
		if(target.initialize_directions & get_dir(target, src))
			if (check_connect_types(target, src))
				node1 = target
				break
	for(var/obj/machinery/atmospherics/target in get_step(src,69ode2_dir))
		if(target.initialize_directions & get_dir(target, src))
			if (check_connect_types(target, src))
				node2 = target
				break
	for(var/obj/machinery/atmospherics/target in get_step(src,69ode3_dir))
		if(target.initialize_directions & get_dir(target, src))
			if (check_connect_types(target, src))
				node3 = target
				break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/tvalve/build_network()
	if(!network_node1 &&69ode1)
		network_node1 =69ew /datum/pipe_network()
		network_node1.normal_members += src
		network_node1.build_network(node1, src)

	if(!network_node2 &&69ode2)
		network_node2 =69ew /datum/pipe_network()
		network_node2.normal_members += src
		network_node2.build_network(node2, src)

	if(!network_node3 &&69ode3)
		network_node3 =69ew /datum/pipe_network()
		network_node3.normal_members += src
		network_node3.build_network(node3, src)


/obj/machinery/atmospherics/tvalve/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node1)
		return69etwork_node1

	if(reference==node2)
		return69etwork_node2

	if(reference==node3)
		return69etwork_node3

	return69ull

/obj/machinery/atmospherics/tvalve/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network_node1 == old_network)
		network_node1 =69ew_network
	if(network_node2 == old_network)
		network_node2 =69ew_network
	if(network_node3 == old_network)
		network_node3 =69ew_network

	return 1

/obj/machinery/atmospherics/tvalve/return_network_air(datum/pipe_network/reference)
	return69ull

/obj/machinery/atmospherics/tvalve/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		qdel(network_node1)
		node1 =69ull

	else if(reference==node2)
		qdel(network_node2)
		node2 =69ull

	else if(reference==node3)
		qdel(network_node3)
		node2 =69ull

	update_underlays()

	return69ull

/obj/machinery/atmospherics/tvalve/digital		// can be controlled by AI
	name = "digital switching69alve"
	desc = "A digitally controlled69alve."
	icon = 'icons/atmos/digital_tvalve.dmi'

	var/frequency = 0
	var/id =69ull
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/tvalve/digital/bypass
	icon_state = "map_tvalve1"
	state = 1

/obj/machinery/atmospherics/tvalve/digital/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/tvalve/digital/update_icon()
	..()
	if(!powered())
		icon_state = "tvalvenopower"

/obj/machinery/atmospherics/tvalve/digital/attack_ai(mob/user as69ob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/tvalve/digital/attack_hand(mob/user as69ob)
	if(!powered())
		return
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()

//Radio remote control

/obj/machinery/atmospherics/tvalve/digital/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency =69ew_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)



/obj/machinery/atmospherics/tvalve/digital/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/tvalve/digital/receive_signal(datum/signal/signal)
	if(!signal.data69"tag"69 || (signal.data69"tag"69 != id))
		return 0

	switch(signal.data69"command"69)
		if("valve_open")
			if(!state)
				go_to_side()

		if("valve_close")
			if(state)
				go_straight()

		if("valve_toggle")
			if(state)
				go_straight()
			else
				go_to_side()

/obj/machinery/atmospherics/tvalve/attackby(var/obj/item/I,69ar/mob/user)
	if(!(QUALITY_BOLT_TURNING in I.tool_qualities))
		return ..()
	if (istype(src, /obj/machinery/atmospherics/tvalve/digital))
		to_chat(user, SPAN_WARNING("You cannot unwrench \the 69src69, it's too complicated."))
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warnng'>You cannot unwrench \the 69src69, it too exerted due to internal pressure.</span>")
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

/obj/machinery/atmospherics/tvalve/mirrored
	icon_state = "map_tvalvem0"

/obj/machinery/atmospherics/tvalve/mirrored/bypass
	icon_state = "map_tvalvem1"
	state = 1

/obj/machinery/atmospherics/tvalve/mirrored/initialize_directions()
	switch(dir)
		if(NORTH)
			initialize_directions = SOUTH|NORTH|WEST
		if(SOUTH)
			initialize_directions =69ORTH|SOUTH|EAST
		if(EAST)
			initialize_directions = WEST|EAST|NORTH
		if(WEST)
			initialize_directions = EAST|WEST|SOUTH

/obj/machinery/atmospherics/tvalve/mirrored/atmos_init()
	var/node1_dir
	var/node2_dir
	var/node3_dir

	node1_dir = turn(dir, 180)
	node2_dir = turn(dir, 90)
	node3_dir = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,69ode1_dir))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src,69ode2_dir))
		if(target.initialize_directions & get_dir(target, src))
			node2 = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src,69ode3_dir))
		if(target.initialize_directions & get_dir(target, src))
			node3 = target
			break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/tvalve/mirrored/update_icon(animation)
	if(animation)
		flick("tvalvem69src.state6969!src.state69", src)
	else
		icon_state = "tvalvem69state69"

/obj/machinery/atmospherics/tvalve/mirrored/digital		// can be controlled by AI
	name = "digital switching69alve"
	desc = "A digitally controlled69alve."
	icon = 'icons/atmos/digital_tvalve.dmi'

	var/frequency = 0
	var/id
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/tvalve/mirrored/digital/bypass
	icon_state = "map_tvalvem1"
	state = 1

/obj/machinery/atmospherics/tvalve/mirrored/digital/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/tvalve/mirrored/digital/update_icon()
	..()
	if(!powered())
		icon_state = "tvalvemnopower"

/obj/machinery/atmospherics/tvalve/mirrored/digital/attack_ai(mob/user as69ob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/tvalve/mirrored/digital/attack_hand(mob/user as69ob)
	if(!powered())
		return
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()

//Radio remote control -eh?

/obj/machinery/atmospherics/tvalve/mirrored/digital/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency =69ew_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/tvalve/mirrored/digital/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/tvalve/mirrored/digital/receive_signal(datum/signal/signal)
	if(!signal.data69"tag"69 || (signal.data69"tag"69 != id))
		return 0

	switch(signal.data69"command"69)
		if("valve_open")
			if(!state)
				go_to_side()

		if("valve_close")
			if(state)
				go_straight()

		if("valve_toggle")
			if(state)
				go_straight()
			else
				go_to_side()
