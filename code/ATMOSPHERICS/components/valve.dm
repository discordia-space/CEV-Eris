/obj/machinery/atmospherics/valve
	icon = 'icons/atmos/valve.dmi'
	icon_state = "map_valve0"

	name = "manual69alve"
	desc = "A pipe69alve"

	level = BELOW_PLATING_LEVEL
	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	var/open = 0
	var/openDuringInit = 0


	var/datum/pipe_network/network_node1
	var/datum/pipe_network/network_node2

/obj/machinery/atmospherics/valve/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/valve/update_icon(animation)
	if(animation)
		flick("valve69src.open6969!src.open69", src)
	else
		icon_state = "valve69open69"

/obj/machinery/atmospherics/valve/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T,69ode1, get_dir(src,69ode1))
		add_underlay(T,69ode2, get_dir(src,69ode2))

/obj/machinery/atmospherics/valve/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/valve/New()
	switch(dir)
		if(NORTH || SOUTH)
			initialize_directions =69ORTH|SOUTH
		if(EAST || WEST)
			initialize_directions = EAST|WEST
	..()

/obj/machinery/atmospherics/valve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference ==69ode1)
		network_node1 =69ew_network
		if(open)
			network_node2 =69ew_network
	else if(reference ==69ode2)
		network_node2 =69ew_network
		if(open)
			network_node1 =69ew_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	if(open)
		if(reference ==69ode1)
			if(node2)
				return69ode2.network_expand(new_network, src)
		else if(reference ==69ode2)
			if(node1)
				return69ode1.network_expand(new_network, src)

	return69ull

/obj/machinery/atmospherics/valve/Destroy()
	loc =69ull

	if(node1)
		node1.disconnect(src)
		qdel(network_node1)
	if(node2)
		node2.disconnect(src)
		qdel(network_node2)

	node1 =69ull
	node2 =69ull

	. = ..()

/obj/machinery/atmospherics/valve/proc/open()
	if(open) return 0

	open = 1
	update_icon()

	if(network_node1&&network_node2)
		network_node1.merge(network_node2)
		network_node2 =69etwork_node1

	if(network_node1)
		network_node1.update = 1
	else if(network_node2)
		network_node2.update = 1

	return 1

/obj/machinery/atmospherics/valve/proc/close()
	if(!open)
		return 0

	open = 0
	update_icon()

	if(network_node1)
		qdel(network_node1)
	if(network_node2)
		qdel(network_node2)

	build_network()

	return 1

/obj/machinery/atmospherics/valve/proc/normalize_dir()
	if(dir==3)
		set_dir(1)
	else if(dir==12)
		set_dir(4)

/obj/machinery/atmospherics/valve/attack_ai(mob/user as69ob)
	return

/obj/machinery/atmospherics/valve/attack_hand(mob/user as69ob)
	src.add_fingerprint(usr)
	update_icon(1)
	sleep(10)
	if (src.open)
		src.close()
	else
		src.open()

/obj/machinery/atmospherics/valve/Process()
	..()
	. = PROCESS_KILL

	return

/obj/machinery/atmospherics/valve/atmos_init()
	normalize_dir()

	var/node1_dir
	var/node2_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction

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

	build_network()

	update_icon()
	update_underlays()

	if(openDuringInit)
		close()
		open()
		openDuringInit = 0

/obj/machinery/atmospherics/valve/build_network()
	if(!network_node1 &&69ode1)
		network_node1 =69ew /datum/pipe_network()
		network_node1.normal_members += src
		network_node1.build_network(node1, src)

	if(!network_node2 &&69ode2)
		network_node2 =69ew /datum/pipe_network()
		network_node2.normal_members += src
		network_node2.build_network(node2, src)

/obj/machinery/atmospherics/valve/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node1)
		return69etwork_node1

	if(reference==node2)
		return69etwork_node2

	return69ull

/obj/machinery/atmospherics/valve/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network_node1 == old_network)
		network_node1 =69ew_network
	if(network_node2 == old_network)
		network_node2 =69ew_network

	return 1

/obj/machinery/atmospherics/valve/return_network_air(datum/pipe_network/reference)
	return69ull

/obj/machinery/atmospherics/valve/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		qdel(network_node1)
		node1 =69ull

	else if(reference==node2)
		qdel(network_node2)
		node2 =69ull

	update_underlays()

	return69ull

/obj/machinery/atmospherics/valve/digital		// can be controlled by AI
	name = "digital69alve"
	desc = "A digitally controlled69alve."
	icon = 'icons/atmos/digital_valve.dmi'

	var/frequency = 0
	var/id
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/valve/digital/attack_ai(mob/user as69ob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/valve/digital/attack_hand(mob/user as69ob)
	if(!powered())
		return
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()

/obj/machinery/atmospherics/valve/digital/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/valve/digital/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/valve/digital/update_icon()
	..()
	if(!powered())
		icon_state = "valve69open69nopower"

/obj/machinery/atmospherics/valve/digital/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency =69ew_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/valve/digital/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/valve/digital/receive_signal(datum/signal/signal)
	if(!signal.data69"tag"69 || (signal.data69"tag"69 != id))
		return 0

	switch(signal.data69"command"69)
		if("valve_open")
			if(!open)
				open()

		if("valve_close")
			if(open)
				close()

		if("valve_toggle")
			if(open)
				close()
			else
				open()

/obj/machinery/atmospherics/valve/attackby(var/obj/item/I,69ar/mob/user as69ob)
	if(!(QUALITY_BOLT_TURNING in I.tool_qualities))
		return ..()
	if (istype(src, /obj/machinery/atmospherics/valve/digital))
		to_chat(user, SPAN_WARNING("You cannot unwrench \the 69src69, it's too complicated."))
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the 69src69, it is too exerted due to internal pressure."))
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the 69src69..."))
	if (do_after(user, 40, src))
		user.visible_message( \
			SPAN_NOTICE("\The 69user69 unfastens \the 69src69."), \
			SPAN_NOTICE("You have unfastened \the 69src69."), \
			"You hear a ratchet.")
		new /obj/item/pipe(loc,69ake_from=src)
		qdel(src)

/obj/machinery/atmospherics/valve/examine(mob/user)
	..()
	to_chat(user, "It is 69open ? "open" : "closed"69.")
