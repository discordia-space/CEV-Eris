SUBSYSTEM_DEF(machines)
	name = "Machines"
	init_order = INIT_ORDER_MACHINES
	priority = SS_PRIORITY_MACHINERY
	flags = SS_KEEP_TIMING
	wait = 2 SECONDS
	var/list/processing = list()
	var/list/currentrun = list()
	var/list/powernets  = list()

/datum/controller/subsystem/machines/Initialize()
	makepowernets()
	fire()
	return ..()

/datum/temp_counter_debug
	var/associated_typepath = null
	var/count = 0

/datum/controller/subsystem/machines/proc/Debug_Processing()
	var/list/holy_fuck_this_is_big = processing.Copy() // Cache
	var/list/typepath_associative_list = list()
	for(var/atom/A in holy_fuck_this_is_big)
		var/found_match = FALSE
		var/typepath_Atom = A.type
		for(var/datum/temp_counter_debug/our_counter in typepath_associative_list)
			if(our_counter.associated_typepath == typepath_Atom)
				found_match = TRUE
				our_counter.count++
				break
		if(!found_match)
			var/datum/temp_counter_debug/debugg = new
			debugg.associated_typepath = typepath_Atom
			debugg.count = 1
			typepath_associative_list.Add(debugg)
	for(var/datum/temp_counter_debug/debugger in typepath_associative_list)
		message_admins("MC Machine debug data : [debugger.associated_typepath] |||| [debugger.count]")

/datum/controller/subsystem/machines/proc/makepowernets()
	for(var/datum/powernet/power_network as anything in powernets)
		qdel(power_network)
	powernets.Cut()

	for(var/obj/structure/cable/power_cable as anything in GLOB.cable_list)
		if(!power_cable.powernet)
			var/datum/powernet/new_powernet = new()
			new_powernet.add_cable(power_cable)
			propagate_network(power_cable, power_cable.powernet)

/datum/controller/subsystem/machines/stat_entry()
	..("M:[processing.len]|PN:[powernets.len]")

/datum/controller/subsystem/machines/fire(resumed = FALSE)
	if (!resumed)
		for(var/datum/powernet/powernet as anything in powernets)
			powernet.reset() //reset the power state.
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	var/seconds = wait * 0.1
	while(currentrun.len)
		var/obj/machinery/thing = currentrun[currentrun.len]
		currentrun.len--
		if (QDELETED(thing) || thing.Process(seconds) == PROCESS_KILL)
			processing -= thing
			thing.is_processing = FALSE
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/setup_template_powernets(list/cables)
	for(var/A in cables)
		var/obj/structure/cable/PC = A
		if(!PC.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(PC)
			propagate_network(PC,PC.powernet)

/datum/controller/subsystem/machines/Recover()
	if (istype(SSmachines.processing))
		processing = SSmachines.processing
	if (istype(SSmachines.powernets))
		powernets = SSmachines.powernets
