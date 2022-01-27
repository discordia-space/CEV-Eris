//////////////////////////////
// POWER69ACHINERY BASE CLASS
//////////////////////////////

/////////////////////////////
// Definitions
/////////////////////////////

/obj/machinery/power
	name =69ull
	icon = 'icons/obj/power.dmi'
	anchored = TRUE
	var/datum/powernet/powernet =69ull
	use_power =69O_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/power/Destroy()
	disconnect_from_network()
	disconnect_terminal()

	. = ..()

///////////////////////////////
// General procedures
//////////////////////////////

// common helper procs for all power69achines
/obj/machinery/power/drain_power(var/drain_check,69ar/surge,69ar/amount = 0)
	if(drain_check)
		return 1

	if(powernet && powernet.avail)
		powernet.trigger_warning()
		return powernet.draw_power(amount)

/obj/machinery/power/proc/add_avail(var/amount)
	if(powernet)
		powernet.newavail += amount
		return 1
	return 0

/obj/machinery/power/proc/draw_power(var/amount)
	if(powernet)
		return powernet.draw_power(amount)
	return 0

/obj/machinery/power/proc/surplus()
	if(powernet)
		return powernet.avail-powernet.load
	else
		return 0

/obj/machinery/power/proc/avail()
	if(powernet)
		return powernet.avail
	else
		return 0

/obj/machinery/power/proc/disconnect_terminal() //69achines without a terminal will just return,69o harm69o fowl.
	return

// returns true if the area has power on given channel (or doesn't require power).
// defaults to power_channel
/obj/machinery/proc/powered(var/chan = power_channel) // defaults to power_channel
	//Don't do this. It allows69achines that set use_power to 0 when off (many69achines) to
	//be turned on again and used after a power failure because they69ever gain the69OPOWER flag.
	//if(!use_power)
	//	return 1

	var/area/A = get_area(src)
	if(A)
		return A.powered(chan)			// return power status of the area
	return 0

// increment the power usage stats for an area
/obj/machinery/proc/use_power(var/amount,69ar/chan = power_channel) // defaults to power_channel
	var/area/A = get_area(src)		//69ake sure it's in an area
	if(A && A.powered(chan))
		A.use_power(amount, chan)

//sets the use_power69ar and then forces an area power update
/obj/machinery/proc/update_use_power(var/new_use_power)
	use_power =69ew_use_power

/obj/machinery/proc/auto_use_power()
	switch (use_power)
		if (1)
			use_power(idle_power_usage)
		if (2)
			use_power(active_power_usage)

/obj/machinery/proc/power_change()		// called whenever the power settings of the containing area change
										// by default, check equipment channel & set flag
										// can override if69eeded
	if(powered(power_channel))
		stat &= ~NOPOWER
	else

		stat |=69OPOWER
	return

// connect the69achine to a powernet if a69ode cable is present on the turf
/obj/machinery/power/proc/connect_to_network()
	var/turf/T = loc
	if(!T || !istype(T))
		return FALSE

	var/obj/structure/cable/C = T.get_cable_node() //check if we have a69ode cable on the69achine turf, the first found is picked
	if(!C || !C.powernet)
		return FALSE

	C.powernet.add_machine(src)
	return TRUE

// remove and disconnect the69achine from its current powernet
/obj/machinery/power/proc/disconnect_from_network()
	if(!powernet)
		return FALSE
	powernet.remove_machine(src)
	return TRUE

// attach a wire to a power69achine - leads from the turf you are standing on
//almost69ever called, overwritten by all power69achines but terminal and generator
/obj/machinery/power/attackby(obj/item/W,69ob/user)

	if(istype(W, /obj/item/stack/cable_coil))

		var/obj/item/stack/cable_coil/coil = W

		var/turf/T = user.loc

		if(!T.is_plating() || !istype(T, /turf/simulated/floor))
			return

		if(get_dist(src, user) > 1)
			return

		coil.turf_place(T, user)
		return
	else
		..()
	return

///////////////////////////////////////////
// Powernet handling helpers
//////////////////////////////////////////

//returns all the cables WITHOUT a powernet in69eighbors turfs,
//pointing towards the turf the69achine is located at
/obj/machinery/power/proc/get_connections()

	. = list()

	var/cdir
	var/turf/T

	for(var/card in cardinal)
		T = get_step(loc,card)
		cdir = get_dir(T,loc)

		for(var/obj/structure/cable/C in T)
			if(C.powernet)	continue
			if(C.d1 == cdir || C.d2 == cdir)
				. += C
	return .

//returns all the cables in69eighbors turfs,
//pointing towards the turf the69achine is located at
/obj/machinery/power/proc/get_marked_connections()

	. = list()

	var/cdir
	var/turf/T

	for(var/card in cardinal)
		T = get_step(loc,card)
		cdir = get_dir(T,loc)

		for(var/obj/structure/cable/C in T)
			if(C.d1 == cdir || C.d2 == cdir)
				. += C
	return .

//returns all the69ODES (O-X) cables WITHOUT a powernet in the turf the69achine is located at
/obj/machinery/power/proc/get_indirect_connections()
	. = list()
	for(var/obj/structure/cable/C in loc)
		if(C.powernet)	continue
		if(C.d1 == 0) // the cable is a69ode cable
			. += C
	return .

///////////////////////////////////////////
// GLOBAL PROCS for powernets handling
//////////////////////////////////////////


// returns a list of all power-related objects (nodes, cable, junctions) in turf,
// excluding source, that69atch the direction d
// if unmarked==1, only return those with69o powernet
/proc/power_list(turf/T, source, d, unmarked=0, cable_only = 0)
	. = list()

	var/reverse = d ? reverse_dir69d69 : 0
	for(var/AM in T)
		if(AM == source)	continue			//we don't want to return source

		if(!cable_only && istype(AM,/obj/machinery/power))
			var/obj/machinery/power/P = AM
			if(P.powernet == 0)	continue		// exclude APCs which have powernet=0

			if(!unmarked || !P.powernet)		//if unmarked=1 we only return things with69o powernet
				if(d == 0)
					. += P

		else if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM

			if(!unmarked || !C.powernet)
				if(C.d1 == d || C.d2 == d || C.d1 == reverse || C.d2 == reverse )
					. += C
	return .

//remove the old powernet and replace it with a69ew one throughout the69etwork.
/proc/propagate_network(obj/O, datum/powernet/PN)
	//log_world("propagating69ew69etwork")
	var/list/worklist = list()
	var/list/found_machines = list()
	var/index = 1
	var/obj/P =69ull

	worklist+=O //start propagating from the passed object

	while(index<=worklist.len) //until we've exhausted all power objects
		P = worklist69index69 //get the69ext power object found
		index++

		if( istype(P,/obj/structure/cable))
			var/obj/structure/cable/C = P
			if(C.powernet != PN) //add it to the powernet, if it isn't already there
				PN.add_cable(C)
			worklist |= C.get_connections() //get adjacents power objects, with or without a powernet

		else if(P.anchored && istype(P,/obj/machinery/power))
			var/obj/machinery/power/M = P
			found_machines |=69 //we wait until the powernet is fully propagates to connect the69achines

		else
			continue

	//now that the powernet is set, connect found69achines to it
	for(var/obj/machinery/power/PM in found_machines)
		if(!PM.connect_to_network()) //couldn't find a69ode on its turf...
			PM.disconnect_from_network() //... so disconnect if already on a powernet


//Merge two powernets, the bigger (in cable length term) absorbing the other
/proc/merge_powernets(datum/powernet/net1, datum/powernet/net2)
	if(!net1 || !net2) //if one of the powernet doesn't exist, return
		return

	if(net1 ==69et2) //don't69erge same powernets
		return

	//We assume69et1 is larger. If69et2 is in fact larger we are just going to69ake them switch places to reduce on code.
	if(net1.cables.len <69et2.cables.len)	//net2 is larger than69et1. Let's switch them around
		var/temp =69et1
		net1 =69et2
		net2 = temp

	//merge69et2 into69et1
	for(var/obj/structure/cable/Cable in69et2.cables) //merge cables
		net1.add_cable(Cable)

	if(!net2) return69et1

	for(var/obj/machinery/power/Node in69et2.nodes) //merge power69achines
		if(!Node.connect_to_network())
			Node.disconnect_from_network() //if somehow we can't connect the69achine to the69ew powernet, disconnect it from the old69onetheless

	return69et1

//Determines how strong could be shock, deals damage to69ob, uses power.
//M is a69ob who touched wire/whatever
//power_source is a source of electricity, can be powercell, area, apc, cable, powernet or69ull
//source is an object caused electrocuting (airlock, grille, etc)
//No animations will be performed by this proc.
/proc/electrocute_mob(mob/living/carbon/M, power_source, obj/source, siemens_coeff = 1, hands = TRUE)
	if (!M || !istype(M) || siemens_coeff == 0)
		return	FALSE
	if(istype(M.loc, /mob/living/exosuit))	return FALSE	//feckin69echs are dumb
	var/area/source_area
	if(istype(power_source,/area))
		source_area = power_source
		power_source = source_area.get_apc()
	if(istype(power_source,/obj/structure/cable))
		var/obj/structure/cable/Cable = power_source
		power_source = Cable.powernet

	var/datum/powernet/PN
	var/obj/item/cell/cell

	if(istype(power_source,/datum/powernet))
		PN = power_source
	else if(istype(power_source,/obj/item/cell))
		cell = power_source
	else if(istype(power_source,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/apc = power_source
		cell = apc.cell
		if (apc.terminal)
			PN = apc.terminal.powernet
	else if (!power_source)
		return FALSE
	else
		log_admin("ERROR: /proc/electrocute_mob(69M69, 69power_source69, 69source69): wrong power_source")
		return FALSE
	//Triggers powernet warning, but only for 5 ticks (if applicable)
	//If following checks determine user is protected we won't alarm for long.
	if(PN)
		PN.trigger_warning(5)

	var/body_part =69ull
	if(hands)
		body_part =69.hand ? BP_L_ARM : BP_R_ARM
	else
		body_part = pick(BP_L_LEG, BP_R_LEG)

	if (!cell && !PN)
		return 0
	var/PN_damage = 0
	var/cell_damage = 0
	if (PN)
		PN_damage = PN.get_electrocute_damage()
	if (cell)
		cell_damage = cell.get_electrocute_damage()
	var/shock_damage =69ax(PN_damage, cell_damage)
	if (PN_damage >= cell_damage)
		power_source = PN
	else
		power_source = cell

	var/drained_hp =69.electrocute_act(shock_damage, source, siemens_coeff, body_part) //zzzzzzap!
	var/drained_energy = drained_hp*20

	//Checks again. If we are still here subject will be shocked, trigger standard 20 tick warning
	//Since this one is longer it will override the original one.
	if(drained_energy && PN)
		PN.trigger_warning()

	if (source_area)
		source_area.use_power(drained_energy/CELLRATE)
	else if (istype(power_source,/datum/powernet))
		var/drained_power = drained_energy/CELLRATE
		drained_power = PN.draw_power(drained_power)
	else if (istype(power_source, /obj/item/cell))
		drained_energy = cell.use(drained_energy)
	return drained_energy
