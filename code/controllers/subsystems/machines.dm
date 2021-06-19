#define SSMACHINES_PIPENETS      1
#define SSMACHINES_MACHINERY     2
#define SSMACHINES_POWERNETS     3
#define SSMACHINES_POWER_OBJECTS 4

SUBSYSTEM_DEF(machines)
	name = "Machines"
	init_order = INIT_ORDER_MACHINES
	flags = SS_KEEP_TIMING
	wait = 2 SECONDS

	var/cost_pipenets      = 0
	var/cost_machinery     = 0
	// var/cost_powernets     = 0
	var/cost_power_objects = 0

	var/list/pipenets      = list()
	var/list/machinery     = list()
	var/list/power_objects = list()

	var/list/processing = list()
	var/list/currentrun = list()
	var/list/powernets     = list()

/datum/controller/subsystem/machines/Initialize(timeofday)
	makepowernets()
	// setup_atmos_machinery(machinery) lol no
	setup_atmos_machinery(GLOB.machines)
	fire()
	return ..()

/datum/controller/subsystem/machines/fire(resumed = FALSE)
	if (!resumed)
		for(var/datum/powernet/Powernet in powernets)
			Powernet.reset() //reset the power state.
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/obj/machinery/thing = currentrun[currentrun.len]
		currentrun.len--
		if(!QDELETED(thing) && thing.process(wait * 0.1) != PROCESS_KILL)
			if(thing.use_power)
				thing.auto_use_power() //add back the power state
		else
			processing -= thing
			if (!QDELETED(thing))
				thing.datum_flags &= ~DF_ISPROCESSING
		if (MC_TICK_CHECK)
			return

// rebuild all power networks from scratch - only called at world creation or by the admin verb
// The above is a lie. Turbolifts also call this proc.
/datum/controller/subsystem/machines/proc/makepowernets()
	for(var/datum/powernet/PN in powernets)
		qdel(PN)
	powernets.Cut()
	setup_powernets_for_cables(GLOB.cable_list)

/datum/controller/subsystem/machines/proc/setup_powernets_for_cables(list/cables)
	for(var/obj/structure/cable/PC in cables)
		if(!PC.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(PC)
			propagate_network(PC,PC.powernet)

/datum/controller/subsystem/machines/proc/setup_atmos_machinery(list/machines)
	if(!Master.current_runlevel)//So it only does it at roundstart
		to_chat(admins, "<span class='boldannounce'>Initializing atmos machinery</span>")
	for(var/obj/machinery/atmospherics/A in machines)
		A.atmos_init()
		CHECK_TICK

	for(var/obj/machinery/atmospherics/unary/U in machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
		CHECK_TICK
	if(!Master.current_runlevel)//So it only does it at roundstart
		to_chat(admins, "<span class='boldannounce'>Initializing pipe networks</span>")
	for(var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()
		CHECK_TICK

/datum/controller/subsystem/machines/stat_entry(msg)
	var/list/msgL = list()
	msgL += "C:{"
	msgL += "PI:[round(cost_pipenets,1)]|"
	msgL += "MC:[round(cost_machinery,1)]|"
	// msg += "PN:[round(cost_powernets,1)]|"
	msgL += "PO:[round(cost_power_objects,1)]"
	msgL += "} "
	msgL += "PI:[pipenets.len]|"
	msgL += "MC:[machinery.len]|"
	msgL += "PN:[powernets.len]|"
	msgL += "PO:[power_objects.len]|"
	msgL += "MC/MS:[round((cost ? machinery.len/cost : 0),0.1)]"
	msg = jointext(msgL, null)
	return ..()

// /datum/controller/subsystem/machines/proc/process_pipenets(resumed = 0)
// 	if (!resumed)
// 		src.current_run = pipenets.Copy()
// 	//cache for sanic speed (lists are references anyways)
// 	var/list/current_run = src.current_run
// 	while(current_run.len)
// 		var/datum/pipe_network/PN = current_run[1]
// 		current_run.Cut(1, 2)
// 		if(istype(PN) && !QDELETED(PN))
// 			PN.Process(wait)
// 		else
// 			pipenets.Remove(PN)
// 			PN.is_processing = null
// 		if(MC_TICK_CHECK)
// 			return


// /datum/controller/subsystem/machines/proc/process_machinery(resumed = 0)
// 	if (!resumed)
// 		src.current_run = machinery.Copy()

// 	var/list/current_run = src.current_run
// 	while(current_run.len)
// 		var/obj/machinery/M = current_run[1]
// 		current_run.Cut(1, 2)
// 		if(istype(M) && !QDELETED(M) && !(M.Process(wait) == PROCESS_KILL))
// 			if(M.use_power)
// 				M.auto_use_power()
// 		else
// 			machinery.Remove(M)
// 			M.is_processing = null
// 		if(MC_TICK_CHECK)
// 			return

// /datum/controller/subsystem/machines/proc/process_powernets(resumed = 0)
// 	if (!resumed)
// 		src.current_run = powernets.Copy()

// 	var/list/current_run = src.current_run
// 	while(current_run.len)
// 		var/datum/powernet/PN = current_run[1]
// 		current_run.Cut(1, 2)
// 		if(istype(PN) && !QDELETED(PN))
// 			PN.reset(wait)
// 		else
// 			powernets.Remove(PN)
// 			PN.is_processing = null
// 		if(MC_TICK_CHECK)
// 			return


// /datum/controller/subsystem/machines/proc/process_power_objects(resumed = 0)
// 	if (!resumed)
// 		src.current_run = power_objects.Copy()

// 	var/list/current_run = src.current_run
// 	while(current_run.len)
// 		var/obj/item/I = current_run[current_run.len]
// 		current_run.len--
// 		if(!I.pwr_drain(wait)) // 0 = Process Kill, remove from processing list.
// 			power_objects.Remove(I)
// 			I.is_processing = null
// 		if(MC_TICK_CHECK)
// 			return

/datum/controller/subsystem/machines/Recover()
	if (istype(SSmachines.pipenets))
		pipenets = SSmachines.pipenets
	if (istype(GLOB.machines))
		machinery = GLOB.machines
	if (istype(SSmachines.processing))
		processing = SSmachines.processing
	if (istype(SSmachines.powernets))
		powernets = SSmachines.powernets
	if (istype(SSmachines.power_objects))
		power_objects = SSmachines.power_objects

#undef SSMACHINES_PIPENETS
#undef SSMACHINES_MACHINERY
#undef SSMACHINES_POWERNETS
#undef SSMACHINES_POWER_OBJECTS
