/obj/machinery/portable_atmospherics
	name = "atmoalter"
	use_power = NO_POWER_USE
	var/datum/gas_mixture/air_contents = new

	var/obj/machinery/atmospherics/portables_connector/connected_port
	var/obj/item/tank/holding

	var/volume = 0
	var/destroyed = 0

	var/start_pressure = ONE_ATMOSPHERE
	var/maximum_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/New()
	..()

	air_contents.volume = volume
	air_contents.temperature = T20C

	return 1

/obj/machinery/portable_atmospherics/Destroy()
	qdel(air_contents)
	qdel(holding)
	. = ..()

/obj/machinery/portable_atmospherics/Initialize()
	. = ..()
	spawn()
		var/obj/machinery/atmospherics/portables_connector/port = locate() in loc
		if(port)
			connect(port)
			update_icon()

/obj/machinery/portable_atmospherics/Process()
	if(!connected_port) //only react when pipe_network will ont it do it for you
		//Allow for reactions
		air_contents.react()
	else
		update_icon()

/obj/machinery/portable_atmospherics/Destroy()
	qdel(air_contents)

	. = ..()

/obj/machinery/portable_atmospherics/proc/StandardAirMix()
	return list(
		"oxygen" = O2STANDARD * MolesForPressure(),
		"nitrogen" = N2STANDARD *  MolesForPressure())

/obj/machinery/portable_atmospherics/proc/MolesForPressure(var/target_pressure = start_pressure)
	return (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

/obj/machinery/portable_atmospherics/on_update_icon()
	return null

/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	connected_port.on = TRUE //Activate port updates

	anchored = TRUE //Prevent movement

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !network.gases.Find(air_contents))
		network.gases += air_contents
		network.update = 1

	return 1

/obj/machinery/portable_atmospherics/proc/disconnect()
	if(!connected_port)
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= air_contents

	anchored = FALSE

	connected_port.connected_device = null
	connected_port = null

	return 1

/obj/machinery/portable_atmospherics/proc/update_connected_network()
	if(!connected_port)
		return

	var/datum/pipe_network/network = connected_port.return_network(src)
	if (network)
		network.update = 1

/obj/machinery/portable_atmospherics/attackby(var/obj/item/I, var/mob/user)
	if ((istype(I, /obj/item/tank) && !( src.destroyed )))
		if (src.holding)
			return
		var/obj/item/tank/T = I
		user.drop_item()
		T.loc = src
		src.holding = T
		playsound(usr.loc, 'sound/machines/Custom_extin.ogg', 100, 1)
		update_icon()
		return

	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
			if(connected_port)
				disconnect()
				to_chat(user, SPAN_NOTICE("You disconnect \the [src] from the port."))
				update_icon()
				return
			else
				var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector/) in loc
				if(possible_port)
					if(connect(possible_port))
						to_chat(user, SPAN_NOTICE("You connect \the [src] to the port."))
						update_icon()
						return
					else
						to_chat(user, SPAN_NOTICE("\The [src] failed to connect to the port."))
						return
				else
					to_chat(user, SPAN_NOTICE("Nothing happens."))
					return
	return



/obj/machinery/portable_atmospherics/powered
	var/power_rating
	var/power_losses
	var/last_power_draw = 0
	var/obj/item/cell/large/cell

/obj/machinery/portable_atmospherics/powered/powered()
	if(use_power) //using area power
		return ..()
	if(cell && cell.charge)
		return 1
	return 0

/obj/machinery/portable_atmospherics/powered/get_cell()
	return cell

/obj/machinery/portable_atmospherics/powered/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/machinery/portable_atmospherics/powered/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell/large))
		if(cell)
			to_chat(user, "There is already a power cell installed.")
			return

		var/obj/item/cell/large/C = I

		user.drop_item()
		C.add_fingerprint(user)
		src.cell = C
		C.loc = src
		user.visible_message(SPAN_NOTICE("[user] opens the panel on [src] and inserts [C]."), SPAN_NOTICE("You open the panel on [src] and insert [C]."))
		power_change()
		return

	if ((istype(I, /obj/item/tank) && !( src.destroyed )))
		if (src.holding)
			return
		var/obj/item/tank/T = I
		user.drop_item()
		T.loc = src
		src.holding = T
		playsound(usr.loc, 'sound/machines/Custom_extin.ogg', 100, 1)
		update_icon()
		return

	var/tool_type = I.get_tool_type(user, list(QUALITY_SHOVELING, QUALITY_CUTTING, QUALITY_BOLT_TURNING), src)
	switch(tool_type)

		if(QUALITY_SCREW_DRIVING)
			if(!cell)
				to_chat(user, SPAN_WARNING("There is no power cell installed."))
				return
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				user.visible_message(SPAN_NOTICE("[user] opens the panel on [src] and removes [cell]."), SPAN_NOTICE("You open the panel on [src] and remove [cell]."))
				cell.add_fingerprint(user)
				cell.loc = src.loc
				cell = null
				power_change()
				return
			return

		if(QUALITY_BOLT_TURNING)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				if(connected_port)
					disconnect()
					to_chat(user, SPAN_NOTICE("You disconnect \the [src] from the port."))
					update_icon()
					return
				else
					var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector/) in loc
					if(possible_port)
						if(connect(possible_port))
							to_chat(user, SPAN_NOTICE("You connect \the [src] to the port."))
							update_icon()
							return
						else
							to_chat(user, SPAN_NOTICE("\The [src] failed to connect to the port."))
							return
					else
						to_chat(user, SPAN_NOTICE("Nothing happens."))
						return
			return

		if(ABORT_CHECK)
			return

	return

/obj/machinery/portable_atmospherics/proc/log_open()
	if(air_contents.gas.len == 0)
		return

	var/gases = ""
	for(var/gas in air_contents.gas)
		if(gases)
			gases += ", [gas]"
		else
			gases = gas
	log_admin("[usr] ([usr.ckey]) opened '[src.name]' containing [gases].")
	message_admins("[usr] ([usr.ckey]) opened '[src.name]' containing [gases].")
