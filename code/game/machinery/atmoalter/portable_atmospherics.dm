/obj/machinery/portable_atmospherics
	name = "portable_atmospherics"
	icon = 'icons/obj/atmos.dmi'
	use_power = NO_POWER_USE
	anchored = FALSE

	///Stores the gas mixture of the portable component. Don't access this directly, use return_air() so you support the temporary processing it provides
	var/datum/gas_mixture/air_contents
	///Stores the reference of the connecting port
	var/obj/machinery/atmospherics/portables_connector/connected_port
	///Stores the reference of the tank the machine is holding
	var/obj/item/weapon/tank/holding
	///Volume (in L) of the inside of the machine
	var/volume = 0
	///Used to track if anything of note has happen while running process_atmos()
	var/excited = TRUE
	var/destroyed = 0

	var/start_pressure = ONE_ATMOSPHERE
	var/maximum_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/Initialize()
	. = ..()
	air_contents = new
	air_contents.volume = volume
	air_contents.temperature = T20C
	SSair.start_processing_machine(src)

	var/obj/machinery/atmospherics/portables_connector/port = locate() in loc
	if(port)
		connect(port)
		update_icon()

/obj/machinery/portable_atmospherics/Destroy()
	SSair.stop_processing_machine(src)

	qdel(holding)
	QDEL_NULL(air_contents)

	return ..()

/obj/machinery/portable_atmospherics/process_atmos()
	if(!connected_port) // Pipe network handles reactions if connected, and we can't stop processing if there's a port effecting our mix
		excited = (excited | air_contents.react(src))
		if(!excited)
			return PROCESS_KILL
	excited = FALSE

/obj/machinery/portable_atmospherics/return_air()
	SSair.start_processing_machine(src)
	return air_contents

/obj/machinery/portable_atmospherics/proc/StandardAirMix()
	return list(
		"oxygen" = O2STANDARD * MolesForPressure(),
		"nitrogen" = N2STANDARD *  MolesForPressure())

/obj/machinery/portable_atmospherics/proc/MolesForPressure(var/target_pressure = start_pressure)
	return (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

/obj/machinery/portable_atmospherics/on_update_icon()
	return null

/**
 * Allow the portable machine to be connected to a connector
 * Arguments:
 * * new_port - the connector that we trying to connect to
 */
/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return FALSE

	//Make sure are close enough for a valid connection
	if(new_port.loc != get_turf(src))
		return FALSE

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	connected_port.on = TRUE //Activate port updates
	// var/datum/pipeline/connected_port_parent = connected_port.parents[1]
	// connected_port_parent.reconcile_air()

	anchored = TRUE //Prevent movement
	pixel_x = new_port.pixel_x
	pixel_y = new_port.pixel_y

	//Actually enforce the air sharing, reconsile air but shit
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !network.gases.Find(air_contents))
		network.gases += air_contents
		network.update = 1

	SSair.start_processing_machine(src)
	update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/Move()
	. = ..()
	if(.)
		disconnect()

/**
 * Allow the portable machine to be disconnected from the connector
 */
/obj/machinery/portable_atmospherics/proc/disconnect()
	if(!connected_port)
		return FALSE
	anchored = FALSE
	connected_port.connected_device = null
	connected_port = null
	pixel_x = 0
	pixel_y = 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= air_contents

	SSair.start_processing_machine(src)
	update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/AltClick(mob/living/user)
	. = ..()
	if(!istype(user) || !can_interact(user)) // || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user))
		return
	if(!holding)
		return
	to_chat(user, "<span class='notice'>You remove [holding] from [src].</span>")
	replace_tank(user, TRUE)

/obj/machinery/portable_atmospherics/examine(mob/user)
	. = ..()
	if(!holding)
		return
	// . += "<span class='notice'>\The [src] contains [holding]. Alt-click [src] to remove it.</span>"+
	// 	"<span class='notice'>Click [src] with another gas tank to hot swap [holding].</span>"
	to_chat(user, list("<span class='notice'>\The [src] contains [holding]. Alt-click [src] to remove it.</span>"+\
		"<span class='notice'>Click [src] with another gas tank to hot swap [holding].</span>").Join("\n"))

/**
 * Allow the player to place a tank inside the machine.
 * Arguments:
 * * User: the player doing the act
 * * close_valve: used in the canister.dm file, check if the valve is open or not
 * * new_tank: the tank we are trying to put in the machine
 */
/obj/machinery/portable_atmospherics/proc/replace_tank(mob/living/user, close_valve, obj/item/weapon/tank/new_tank)
	if(!user)
		return FALSE
	if(holding)
		user.put_in_hands(holding)
		holding = null
	if(new_tank)
		holding = new_tank

	SSair.start_processing_machine(src)
	update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/tank))
		if(stat & BROKEN)
			return FALSE
		var/obj/item/weapon/tank/T = W
		if (isnull(src))
			T.forceMove(null)
		else
			T.forceMove(src)
		T.dropped() //src, silent)
		// if(!user.transferItemToLoc(T, src))
		// 	return FALSE
		to_chat(user, "<span class='notice'>[holding ? "In one smooth motion you pop [holding] out of [src]'s connector and replace it with [T]" : "You insert [T] into [src]"].</span>")
		investigate_log("had its internal [holding] swapped with [T] by [key_name(user)].", INVESTIGATE_ATMOS)
		replace_tank(user, FALSE, T)
		update_icon()

	if(QUALITY_BOLT_TURNING in W.tool_qualities) // wrench act
		if(W.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
			if(connected_port)
				investigate_log("was disconnected from [connected_port] by [key_name(user)].", INVESTIGATE_ATMOS)
				disconnect()
				user.visible_message( \
					"[user] disconnects [src].", \
					"<span class='notice'>You unfasten [src] from the port.</span>", \
					"<span class='hear'>You hear a ratchet.</span>")
				update_icon()
				return TRUE
			var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector) in loc
			if(!possible_port)
				to_chat(user, "<span class='notice'>Nothing happens.</span>")
				return FALSE
			if(!connect(possible_port))
				to_chat(user, "<span class='notice'>[name] failed to connect to the port.</span>")
				return FALSE
			user.visible_message( \
				"[user] connects [src].", \
				"<span class='notice'>You fasten [src] to the port.</span>", \
				"<span class='hear'>You hear a ratchet.</span>")
			update_icon()
			investigate_log("was connected to [possible_port] by [key_name(user)].", INVESTIGATE_ATMOS)
			return TRUE
		return
	return ..()

/obj/machinery/portable_atmospherics/proc/update_connected_network()
	if(!connected_port)
		return

	var/datum/pipe_network/network = connected_port.return_network(src)
	if (network)
		network.update = 1

/obj/machinery/portable_atmospherics/powered
	var/power_rating
	var/power_losses
	var/last_power_draw = 0
	var/obj/item/weapon/cell/large/cell

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
	if(istype(I, /obj/item/weapon/cell/large))
		if(cell)
			to_chat(user, "There is already a power cell installed.")
			return

		var/obj/item/weapon/cell/large/C = I

		user.drop_item()
		C.add_fingerprint(user)
		src.cell = C
		C.loc = src
		user.visible_message(SPAN_NOTICE("[user] opens the panel on [src] and inserts [C]."), SPAN_NOTICE("You open the panel on [src] and insert [C]."))
		power_change()
		return

	if ((istype(I, /obj/item/weapon/tank) && !( src.destroyed )))
		if (src.holding)
			return
		var/obj/item/weapon/tank/T = I
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
