/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all connected machines

	var/load = 0				// the current load on the powernet, increased by each machine at processing
	var/newavail = 0			// what available power was gathered last tick, then becomes...
	var/avail = 0				//...the current available power in the powernet
	var/viewload = 0			// the load as it appears on the power console (gradually updated)
	var/number = 0				// Unused //TODEL

	var/smes_demand = 0			// Amount of power demanded by all SMESs from this network. Needed for load balancing.
	var/list/inputting = list()	// List of SMESs that are demanding power from this network. Needed for load balancing.

	var/smes_avail = 0			// Amount of power (avail) from SMESes. Used by SMES load balancing
	var/smes_newavail = 0		// As above, just for newavail

	var/perapc = 0			// per-apc avilability
	var/perapc_excess = 0
	var/netexcess = 0			// excess power on the powernet (typically avail-load)

	var/problem = 0				// If this is not 0 there is some sort of issue in the powernet. Monitors will display warnings.

/datum/powernet/New()
	SSmachines.powernets += src
	..()

/datum/powernet/Destroy()
	for(var/obj/structure/cable/C in cables)
		cables -= C
		C.powernet = null
	for(var/obj/machinery/power/M in nodes)
		nodes -= M
		M.powernet = null
	SSmachines.powernets -= src
	return ..()

//Returns the amount of excess power (before refunding to SMESs) from last tick.
//This is for machines that might adjust their power consumption using this data.
/datum/powernet/proc/last_surplus()
	return max(avail - load, 0)

/datum/powernet/proc/draw_power(var/amount)
	var/draw = between(0, amount, avail - load)
	load += draw
	return draw

/datum/powernet/proc/is_empty()
	return !cables.len && !nodes.len

//remove a cable from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/remove_cable(var/obj/structure/cable/C)
	cables -= C
	C.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it

//add a cable to the current powernet
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/add_cable(var/obj/structure/cable/C)
	if(C.powernet)// if C already has a powernet...
		if(C.powernet == src)
			return
		else
			C.powernet.remove_cable(C) //..remove it
	C.powernet = src
	cables +=C

//remove a power machine from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/remove_machine(var/obj/machinery/power/M)
	nodes -=M
	M.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it - qdel


//add a power machine to the current powernet
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/add_machine(var/obj/machinery/power/M)
	if(M.powernet)// if M already has a powernet...
		if(M.powernet == src)
			return
		else
			M.disconnect_from_network()//..remove it
	M.powernet = src
	nodes[M] = M

// Triggers warning for certain amount of ticks
/datum/powernet/proc/trigger_warning(var/duration_ticks = 20)
	problem = max(duration_ticks, problem)


//handles the power changes in the powernet
//called every ticks by the powernet controller
/datum/powernet/proc/reset()
	var/numapc = 0

	if(problem > 0)
		problem = max(problem - 1, 0)

	if(nodes && nodes.len) // Added to fix a bad list bug -- TLE
		for(var/obj/machinery/power/terminal/term in nodes)
			if( istype( term.master, /obj/machinery/power/apc ) )
				numapc++

	netexcess = avail - load

	if(numapc)
		//very simple load balancing. If there was a net excess this tick then it must have been that some APCs used less than perapc, since perapc*numapc = avail
		//Therefore we can raise the amount of power rationed out to APCs on the assumption that those APCs that used less than perapc will continue to do so.
		//If that assumption fails, then some APCs will miss out on power next tick, however it will be rebalanced for the tick after.
		if (netexcess >= 0)
			perapc_excess += min(netexcess/numapc, (avail - perapc) - perapc_excess)
		else
			perapc_excess = 0

		perapc = avail/numapc + perapc_excess

	// At this point, all other machines have finished using power. Anything left over may be used up to charge SMESs.
	if(inputting.len && smes_demand)
		var/smes_input_percentage = between(0, (netexcess / smes_demand) * 100, 100)
		for(var/obj/machinery/power/smes/S in inputting)
			S.input_power(smes_input_percentage)

	netexcess = avail - load

	if(netexcess)
		var/perc = get_percent_load(1)
		for(var/obj/machinery/power/smes/S in nodes)
			S.restore(perc)

	//updates the viewed load (as seen on power computers)
	viewload = round(load)

	//reset the powernet
	load = 0
	avail = newavail
	smes_avail = smes_newavail
	inputting.Cut()
	smes_demand = 0
	newavail = 0
	smes_newavail = 0

/datum/powernet/proc/get_percent_load(var/smes_only = 0)
	if(smes_only)
		var/smes_used = load - (avail - smes_avail) 			// SMESs are always last to provide power
		if(!smes_used || smes_used < 0 || !smes_avail)			// SMES power isn't available or being used at all, SMES load is therefore 0%
			return 0
		return between(0, (smes_used / smes_avail) * 100, 100)	// Otherwise return percentage load of SMESs.
	else
		if(!load)
			return 0
		return between(0, (avail / load) * 100, 100)

// Calculation of powernet shock damage
// Keep in mind that airlocks, the most common source of electrocution, have siemens_coefficent of 0.7, dealing only 70% of electrocution damage
// Also, even the most common gloves and boots have siemens_coefficent < 1, offering a degree of shock protection
/datum/powernet/proc/get_electrocute_damage()
	switch(avail)
		// 50+ MW - divine punishment
		if (50000000 to INFINITY)
			return min(rand(95,190),rand(95,190))

		// 30 to 50 MW - some ridicluous high effort high power SM setup
		if (30000000 to 50000000)
			return min(rand(80,180),rand(80,180))

		// 20 to 30 MW - a seriously overclocked SM with some extra Technomancer voodoo
		if (20000000 to 30000000)
			return min(rand(70,170),rand(70,170))

		// 15 to 20 MW - hardwired overclocked SM
		if (15000000 to 20000000)
			return min(rand(65,160),rand(65,160))

		// 10 to 15 MW - hardwired SM under light load
		// Powerful enough to flash limbs to ash sometimes
		if (10000000 to 15000000)
			return min(rand(50,140),rand(50,140))

		// 1 to 10 MW - hardwired SM under noticeable load
		// Quite lethal already, but damage output can be pushed further
		if (1000000 to 10000000)
			return min(rand(45,120),rand(45,120))

		// 200 to 1000 kW - beefy powernet
		if (200000 to 1000000)
			return min(rand(30,80),rand(30,80))

		// 100 to 200 kW - average powernet
		if (100000 to 200000)
			return min(rand(20,60),rand(20,60))

		// 50 to 100 kW - something a PACMAN-type generator can dish out
		if (50000 to 100000)
			return min(rand(15,40),rand(15,40))

		// 1 to 50 kW - what is this, a power line for ants?
		if (1000 to 50000)
			return min(rand(10,20),rand(10,20))
		else
			return 0

////////////////////////////////////////////////
// Misc.
///////////////////////////////////////////////


// return a knot cable (O-X) if one is present in the turf
// null if there's none
/turf/proc/get_cable_node()
	if(!istype(src, /turf))
		return null
	for(var/obj/structure/cable/C in src)
		if(C.d1 == 0)
			return C
	return null


/area/proc/get_apc()
	return apc
