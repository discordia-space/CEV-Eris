/obj/machinery/atmospherics/trinary/filter
	icon = 'icons/atmos/filter.dmi'
	icon_state = "map"
	density = FALSE
	level = BELOW_PLATING_LEVEL

	name = "Gas filter"

	use_power = IDLE_POWER_USE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500	//This also doubles as a69easure of how powerful the filter is, in Watts. 7500 W ~ 10 HP

	var/temp =69ull // -- TLE

	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER

	/*
	Filter types:
	-1:69othing
	 0: Plasma: Plasma, Oxygen Agent B
	 1: Oxygen: Oxygen ONLY
	 2:69itrogen:69itrogen ONLY
	 3: Carbon Dioxide: Carbon Dioxide ONLY
	 4: Sleeping Agent (N2O)
	*/
	var/filter_type = -1
	var/list/filtered_out = list()


	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/trinary/filter/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency =69ew_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/trinary/filter/New()
	..()
	switch(filter_type)
		if(0) //removing hydrocarbons
			filtered_out = list("plasma")
		if(1) //removing O2
			filtered_out = list("oxygen")
		if(2) //removing692
			filtered_out = list("nitrogen")
		if(3) //removing CO2
			filtered_out = list("carbon_dioxide")
		if(4)//removing692O
			filtered_out = list("sleeping_agent")

	air1.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air2.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air3.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/trinary/filter/update_icon()
	if(istype(src, /obj/machinery/atmospherics/trinary/filter/m_filter))
		icon_state = "m"
	else
		icon_state = ""

	if(!powered())
		icon_state += "off"
	else if(node2 &&69ode3 &&69ode1)
		icon_state += use_power ? "on" : "off"
	else
		icon_state += "off"
		use_power =69O_POWER_USE

/obj/machinery/atmospherics/trinary/filter/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return

		add_underlay(T,69ode1, turn(dir, -180))

		if(istype(src, /obj/machinery/atmospherics/trinary/filter/m_filter))
			add_underlay(T,69ode2, turn(dir, 90))
		else
			add_underlay(T,69ode2, turn(dir, -90))

		add_underlay(T,69ode3, dir)

/obj/machinery/atmospherics/trinary/filter/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/trinary/filter/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/trinary/filter/Process()
	..()

	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	//Figure out the amount of69oles to transfer
	var/transfer_moles = (set_flow_rate/air1.volume)*air1.total_moles

	var/power_draw = -1
	if (transfer_moles >69INIMUM_MOLES_TO_FILTER)
		power_draw = filter_gas(src, filtered_out, air1, air2, air3, transfer_moles, power_rating)

		if(network2)
			network2.update = 1

		if(network3)
			network3.update = 1

		if(network1)
			network1.update = 1

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

	return 1

/obj/machinery/atmospherics/trinary/filter/atmos_init()
	set_frequency(frequency)
	..()

/obj/machinery/atmospherics/trinary/filter/attackby(var/obj/item/I,69ar/mob/user)
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
			"You hear a ratchet.")
		new /obj/item/pipe(loc,69ake_from=src)
		qdel(src)


/obj/machinery/atmospherics/trinary/filter/attack_hand(user as69ob) // -- TLE
	if(..())
		return

	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/dat
	var/current_filter_type
	switch(filter_type)
		if(0)
			current_filter_type = "Plasma"
		if(1)
			current_filter_type = "Oxygen"
		if(2)
			current_filter_type = "Nitrogen"
		if(3)
			current_filter_type = "Carbon Dioxide"
		if(4)
			current_filter_type = "Nitrous Oxide"
		if(-1)
			current_filter_type = "Nothing"
		else
			current_filter_type = "ERROR - Report this bug to the admin, please!"

	dat += {"
			<b>Power: </b><a href='?src=\ref69src69;power=1'>69use_power?"On":"Off"69</a><br>
			<b>Filtering: </b>69current_filter_type69<br><HR>
			<h4>Set Filter Type:</h4>
			<A href='?src=\ref69src69;filterset=0'>Plasma</A><BR>
			<A href='?src=\ref69src69;filterset=1'>Oxygen</A><BR>
			<A href='?src=\ref69src69;filterset=2'>Nitrogen</A><BR>
			<A href='?src=\ref69src69;filterset=3'>Carbon Dioxide</A><BR>
			<A href='?src=\ref69src69;filterset=4'>Nitrous Oxide</A><BR>
			<A href='?src=\ref69src69;filterset=-1'>Nothing</A><BR>
			<HR>
			<B>Set Flow Rate Limit:</B>
			69src.set_flow_rate69L/s | <a href='?src=\ref69src69;set_flow_rate=1'>Change</a><BR>
			<B>Flow rate: </B>69round(last_flow_rate, 0.1)69L/s
			"}

	user << browse("<HEAD><TITLE>69src.name69 control</TITLE></HEAD><TT>69dat69</TT>", "window=atmo_filter")
	onclose(user, "atmo_filter")
	return

/obj/machinery/atmospherics/trinary/filter/Topic(href, href_list) // -- TLE
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list69"filterset"69)
		filter_type = text2num(href_list69"filterset"69)

		filtered_out.Cut()	//no69eed to create69ew lists unnecessarily
		switch(filter_type)
			if(0) //removing hydrocarbons
				filtered_out += "plasma"
			if(1) //removing O2
				filtered_out += "oxygen"
			if(2) //removing692
				filtered_out += "nitrogen"
			if(3) //removing CO2
				filtered_out += "carbon_dioxide"
			if(4)//removing692O
				filtered_out += "sleeping_agent"

	if (href_list69"temp"69)
		src.temp =69ull
	if(href_list69"set_flow_rate"69)
		var/new_flow_rate = input(usr, "Enter69ew flow rate (0-69air1.volume69L/s)", "Flow Rate Control", src.set_flow_rate) as69um
		src.set_flow_rate =69ax(0,69in(air1.volume,69ew_flow_rate))
	if(href_list69"power"69)
		use_power=!use_power
	src.update_icon()
	src.updateUsrDialog()
/*
	for(var/mob/M in69iewers(1, src))
		if ((M.client &&69.machine == src))
			src.attack_hand(M)
*/
	return

/obj/machinery/atmospherics/trinary/filter/m_filter
	icon_state = "mmap"

	dir = SOUTH
	initialize_directions = SOUTH|NORTH|EAST

obj/machinery/atmospherics/trinary/filter/m_filter/New()
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

/obj/machinery/atmospherics/trinary/filter/m_filter/atmos_init()
	set_frequency(frequency)

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
