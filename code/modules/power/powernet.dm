/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all connected69achines

	var/load = 0				// the current load on the powernet, increased by each69achine at processing
	var/newavail = 0			// what available power was gathered last tick, then becomes...
	var/avail = 0				//...the current available power in the powernet
	var/viewload = 0			// the load as it appears on the power console (gradually updated)
	var/number = 0				// Unused //TODEL

	var/smes_demand = 0			// Amount of power demanded by all SMESs from this69etwork.69eeded for load balancing.
	var/list/inputting = list()	// List of SMESs that are demanding power from this69etwork.69eeded for load balancing.

	var/smes_avail = 0			// Amount of power (avail) from SMESes. Used by SMES load balancing
	var/smes_newavail = 0		// As above, just for69ewavail

	var/perapc = 0			// per-apc avilability
	var/perapc_excess = 0
	var/netexcess = 0			// excess power on the powernet (typically avail-load)

	var/problem = 0				// If this is69ot 0 there is some sort of issue in the powernet.69onitors will display warnings.

/datum/powernet/New()
	SSmachines.powernets += src
	..()

/datum/powernet/Destroy()
	for(var/obj/structure/cable/C in cables)
		cables -= C
		C.powernet =69ull
	for(var/obj/machinery/power/M in69odes)
		nodes -=69
		M.powernet =69ull
	SSmachines.powernets -= src
	return ..()

//Returns the amount of excess power (before refunding to SMESs) from last tick.
//This is for69achines that69ight adjust their power consumption using this data.
/datum/powernet/proc/last_surplus()
	return69ax(avail - load, 0)

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
	C.powernet =69ull
	if(is_empty())//the powernet is69ow empty...
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

//remove a power69achine from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the69achine exists
/datum/powernet/proc/remove_machine(var/obj/machinery/power/M)
	nodes -=M
	M.powernet =69ull
	if(is_empty())//the powernet is69ow empty...
		qdel(src)///... delete it - qdel


//add a power69achine to the current powernet
//Warning : this proc DON'T check if the69achine exists
/datum/powernet/proc/add_machine(var/obj/machinery/power/M)
	if(M.powernet)// if69 already has a powernet...
		if(M.powernet == src)
			return
		else
			M.disconnect_from_network()//..remove it
	M.powernet = src
	nodes69M69 =69

// Triggers warning for certain amount of ticks
/datum/powernet/proc/trigger_warning(var/duration_ticks = 20)
	problem =69ax(duration_ticks, problem)


//handles the power changes in the powernet
//called every ticks by the powernet controller
/datum/powernet/proc/reset()
	var/numapc = 0

	if(problem > 0)
		problem =69ax(problem - 1, 0)

	if(nodes &&69odes.len) // Added to fix a bad list bug -- TLE
		for(var/obj/machinery/power/terminal/term in69odes)
			if( istype( term.master, /obj/machinery/power/apc ) )
				numapc++

	netexcess = avail - load

	if(numapc)
		//very simple load balancing. If there was a69et excess this tick then it69ust have been that some APCs used less than perapc, since perapc*numapc = avail
		//Therefore we can raise the amount of power rationed out to APCs on the assumption that those APCs that used less than perapc will continue to do so.
		//If that assumption fails, then some APCs will69iss out on power69ext tick, however it will be rebalanced for the tick after.
		if (netexcess >= 0)
			perapc_excess +=69in(netexcess/numapc, (avail - perapc) - perapc_excess)
		else
			perapc_excess = 0

		perapc = avail/numapc + perapc_excess

	// At this point, all other69achines have finished using power. Anything left over69ay be used up to charge SMESs.
	if(inputting.len && smes_demand)
		var/smes_input_percentage = between(0, (netexcess / smes_demand) * 100, 100)
		for(var/obj/machinery/power/smes/S in inputting)
			S.input_power(smes_input_percentage)

	netexcess = avail - load

	if(netexcess)
		var/perc = get_percent_load(1)
		for(var/obj/machinery/power/smes/S in69odes)
			S.restore(perc)

	//updates the69iewed load (as seen on power computers)
	viewload = round(load)

	//reset the powernet
	load = 0
	avail =69ewavail
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
// Keep in69ind that airlocks, the69ost common source of electrocution, have siemens_coefficent of 0.7, dealing only 70% of electrocution damage
// Also, even the69ost common gloves and boots have siemens_coefficent < 1, offering a degree of shock protection
/datum/powernet/proc/get_electrocute_damage()
	switch(avail)
		// 50+69W - divine punishment
		if (50000000 to INFINITY)
			return69in(rand(95,190),rand(95,190))

		// 30 to 5069W - some ridicluous high effort high power SM setup
		if (30000000 to 50000000)
			return69in(rand(80,180),rand(80,180))

		// 20 to 3069W - a seriously overclocked SM with some extra Technomancer69oodoo
		if (20000000 to 30000000)
			return69in(rand(70,170),rand(70,170))

		// 15 to 2069W - hardwired overclocked SM
		if (15000000 to 20000000)
			return69in(rand(65,160),rand(65,160))

		// 10 to 1569W - hardwired SM under light load
		// Powerful enough to flash limbs to ash sometimes
		if (10000000 to 15000000)
			return69in(rand(50,140),rand(50,140))

		// 1 to 1069W - hardwired SM under69oticeable load
		// Quite lethal already, but damage output can be pushed further
		if (1000000 to 10000000)
			return69in(rand(45,120),rand(45,120))

		// 200 to 1000 kW - beefy powernet
		if (200000 to 1000000)
			return69in(rand(30,80),rand(30,80))

		// 100 to 200 kW - average powernet
		if (100000 to 200000)
			return69in(rand(20,60),rand(20,60))

		// 50 to 100 kW - something a PACMAN-type generator can dish out
		if (50000 to 100000)
			return69in(rand(15,40),rand(15,40))

		// 1 to 50 kW - what is this, a power line for ants?
		if (1000 to 50000)
			return69in(rand(10,20),rand(10,20))
		else
			return 0

////////////////////////////////////////////////
//69isc.
///////////////////////////////////////////////


// return a knot cable (O-X) if one is present in the turf
//69ull if there's69one
/turf/proc/get_cable_node()
	if(!istype(src, /turf/simulated))
		return69ull
	for(var/obj/structure/cable/C in src)
		if(C.d1 == 0)
			return C
	return69ull


/area/proc/get_apc()
	return apc
