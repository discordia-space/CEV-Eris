/obj/machinery/atmospherics/trinary/mixer
	icon = 'icons/atmos/mixer.dmi'
	icon_state = "map"
	density = FALSE
	level = BELOW_PLATING_LEVEL

	name = "Gas69ixer"

	use_power = IDLE_POWER_USE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 3700	//This also doubles as a69easure of how powerful the69ixer is, in Watts. 3700 W ~ 5 HP

	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_MIXER
	var/list/mixing_inputs

	//for69apping
	var/node1_concentration = 0.5
	var/node2_concentration = 0.5

	//node 3 is the outlet,69odes 1 & 2 are intakes

/obj/machinery/atmospherics/trinary/mixer/update_icon(var/safety = 0)
	if(istype(src, /obj/machinery/atmospherics/trinary/mixer/m_mixer))
		icon_state = "m"
	else if(istype(src, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
		icon_state = "t"
	else
		icon_state = ""

	if(!powered())
		icon_state += "off"
	else if(node2 &&69ode3 &&69ode1)
		icon_state += use_power ? "on" : "off"
	else
		icon_state += "off"
		use_power =69O_POWER_USE

/obj/machinery/atmospherics/trinary/mixer/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return

		if(istype(src, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
			add_underlay(T,69ode1, turn(dir, -90))
		else
			add_underlay(T,69ode1, turn(dir, -180))

		if(istype(src, /obj/machinery/atmospherics/trinary/mixer/m_mixer) || istype(src, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
			add_underlay(T,69ode2, turn(dir, 90))
		else
			add_underlay(T,69ode2, turn(dir, -90))

		add_underlay(T,69ode3, dir)

/obj/machinery/atmospherics/trinary/mixer/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/trinary/mixer/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/trinary/mixer/New()
	..()
	air1.volume = ATMOS_DEFAULT_VOLUME_MIXER
	air2.volume = ATMOS_DEFAULT_VOLUME_MIXER
	air3.volume = ATMOS_DEFAULT_VOLUME_MIXER * 1.5

	if (!mixing_inputs)
		mixing_inputs = list(src.air1 =69ode1_concentration, src.air2 =69ode2_concentration)

/obj/machinery/atmospherics/trinary/mixer/Process()
	..()

	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	//Figure out the amount of69oles to transfer
	var/transfer_moles = (set_flow_rate*mixing_inputs69air169/air1.volume)*air1.total_moles + (set_flow_rate*mixing_inputs69air169/air2.volume)*air2.total_moles

	var/power_draw = -1
	if (transfer_moles >69INIMUM_MOLES_TO_FILTER)
		power_draw =69ix_gas(src,69ixing_inputs, air3, transfer_moles, power_rating)

		if(network1 &&69ixing_inputs69air169)
			network1.update = 1

		if(network2 &&69ixing_inputs69air269)
			network2.update = 1

		if(network3)
			network3.update = 1

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

	return 1

/obj/machinery/atmospherics/trinary/mixer/attackby(var/obj/item/I,69ar/mob/user as69ob)
	if(!(QUALITY_BOLT_TURNING in I.tool_qualities))
		return ..()
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
			"You hear ratchet.")
		new /obj/item/pipe(loc,69ake_from=src)
		qdel(src)

/obj/machinery/atmospherics/trinary/mixer/attack_hand(user as69ob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	usr.set_machine(src)
	var/dat = {"<b>Power: </b><a href='?src=\ref69src69;power=1'>69use_power?"On":"Off"69</a><br>
				<b>Set Flow Rate Limit: </b>
				69set_flow_rate69L/s | <a href='?src=\ref69src69;set_press=1'>Change</a>
				<br>
				<b>Flow Rate: </b>69round(last_flow_rate, 0.1)69L/s
				<br><hr>
				<b>Node 1 Concentration:</b>
				<a href='?src=\ref69src69;node1_c=-0.1'><b>-</b></a>
				<a href='?src=\ref69src69;node1_c=-0.01'>-</a>
				69mixing_inputs69air16969(69mixing_inputs69air169*10069%)
				<a href='?src=\ref69src69;node1_c=0.01'><b>+</b></a>
				<a href='?src=\ref69src69;node1_c=0.1'>+</a>
				<br>
				<b>Node 2 Concentration:</b>
				<a href='?src=\ref69src69;node2_c=-0.1'><b>-</b></a>
				<a href='?src=\ref69src69;node2_c=-0.01'>-</a>
				69mixing_inputs69air26969(69mixing_inputs69air269*10069%)
				<a href='?src=\ref69src69;node2_c=0.01'><b>+</b></a>
				<a href='?src=\ref69src69;node2_c=0.1'>+</a>
				"}

	user << browse("<HEAD><TITLE>69src.name69 control</TITLE></HEAD><TT>69dat69</TT>", "window=atmo_mixer")
	onclose(user, "atmo_mixer")
	return

/obj/machinery/atmospherics/trinary/mixer/Topic(href, href_list)
	if(..()) return 1
	if(href_list69"power"69)
		use_power = !use_power
	if(href_list69"set_press"69)
		var/max_flow_rate =69in(air1.volume, air2.volume)
		var/new_flow_rate = input(usr, "Enter69ew flow rate limit (0-69max_flow_rate69L/s)", "Flow Rate Control", src.set_flow_rate) as69um
		src.set_flow_rate =69ax(0,69in(max_flow_rate,69ew_flow_rate))
	if(href_list69"node1_c"69)
		var/value = text2num(href_list69"node1_c"69)
		src.mixing_inputs69air169 =69ax(0,69in(1, src.mixing_inputs69air169 +69alue))
		src.mixing_inputs69air269 = 1 -69ixing_inputs69air169
	if(href_list69"node2_c"69)
		var/value = text2num(href_list69"node2_c"69)
		src.mixing_inputs69air269 =69ax(0,69in(1, src.mixing_inputs69air269 +69alue))
		src.mixing_inputs69air169 = 1 -69ixing_inputs69air269
	src.update_icon()
	src.updateUsrDialog()
	return

obj/machinery/atmospherics/trinary/mixer/t_mixer
	icon_state = "tmap"

	dir = SOUTH
	initialize_directions = SOUTH|EAST|WEST

	//node 3 is the outlet,69odes 1 & 2 are intakes

obj/machinery/atmospherics/trinary/mixer/t_mixer/New()
	..()
	switch(dir)
		if(NORTH)
			initialize_directions = EAST|NORTH|WEST
		if(SOUTH)
			initialize_directions = SOUTH|WEST|EAST
		if(EAST)
			initialize_directions = EAST|NORTH|SOUTH
		if(WEST)
			initialize_directions = WEST|NORTH|SOUTH

obj/machinery/atmospherics/trinary/mixer/t_mixer/atmos_init()
	..()
	if(node1 &&69ode2 &&69ode3) return

	var/node1_connect = turn(dir, -90)
	var/node2_connect = turn(dir, 90)
	var/node3_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,69ode1_connect))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,69ode2_connect))
		if(target.initialize_directions & get_dir(target, src))
			node2 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,69ode3_connect))
		if(target.initialize_directions & get_dir(target, src))
			node3 = target
			break

	update_icon()
	update_underlays()

obj/machinery/atmospherics/trinary/mixer/m_mixer
	icon_state = "mmap"

	dir = SOUTH
	initialize_directions = SOUTH|NORTH|EAST

	//node 3 is the outlet,69odes 1 & 2 are intakes

obj/machinery/atmospherics/trinary/mixer/m_mixer/New()
	..()
	switch(dir)
		if(NORTH)
			initialize_directions = WEST|NORTH|SOUTH
		if(SOUTH)
			initialize_directions = SOUTH|EAST|NORTH
		if(EAST)
			initialize_directions = EAST|WEST|NORTH
		if(WEST)
			initialize_directions = WEST|SOUTH|EAST

obj/machinery/atmospherics/trinary/mixer/m_mixer/atmos_init()
	..()
	if(node1 &&69ode2 &&69ode3) return

	var/node1_connect = turn(dir, -180)
	var/node2_connect = turn(dir, 90)
	var/node3_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,69ode1_connect))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,69ode2_connect))
		if(target.initialize_directions & get_dir(target, src))
			node2 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,69ode3_connect))
		if(target.initialize_directions & get_dir(target, src))
			node3 = target
			break

	update_icon()
	update_underlays()
