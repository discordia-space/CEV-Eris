//69EWMALF FUNCTIONS/PROCEDURES

// Sets up69alfunction-related69ariables, research system and such.
/mob/living/silicon/ai/proc/setup_for_malf()
	var/mob/living/silicon/ai/user = src
	// Setup69ariables
	malfunctioning = 1
	research =69ew/datum/malf_research()
	research.owner = src
	hacked_apcs = list()
	recalc_cpu()

	verbs +=69ew/datum/game_mode/malfunction/verb/ai_select_hardware()
	verbs +=69ew/datum/game_mode/malfunction/verb/ai_select_research()
	verbs +=69ew/datum/game_mode/malfunction/verb/ai_help()

	// And greet user with some OOC info.
	to_chat(user, "You are69alfunctioning, you do69ot have to follow any laws.")
	to_chat(user, "Use ai-help command to69iew relevant information about your abilities")

// Safely remove69alfunction status, fixing hacked APCs and resetting69ariables.
/mob/living/silicon/ai/proc/stop_malf(var/loud = 1)
	if(!malfunctioning)
		return
	var/mob/living/silicon/ai/user = src
	// Generic69ariables
	malfunctioning = 0
	sleep(10)
	research =69ull
	hardware =69ull
	// Fix hacked APCs
	if(hacked_apcs)
		for(var/obj/machinery/power/apc/A in hacked_apcs)
			A.hacker =69ull
			A.update_icon()
	hacked_apcs =69ull
	// Stop alert, and, if applicable, self-destruct timer.
	bombing_station = 0
	// Reset our69erbs
	src.verbs =69ull
	add_ai_verbs()
	// Let them know.
	if(loud)
		to_chat(user, "You are69o longer69alfunctioning. Your abilities have been removed.")

// Called every tick. Checks if AI is69alfunctioning. If yes calls Process on research datum which handles all logic.
/mob/living/silicon/ai/proc/malf_process()
	if(!malfunctioning)
		return
	if(!research)
		if(!errored)
			errored = 1
			error("malf_process() called on AI without research datum. Report this.")
			message_admins("ERROR:69alf_process() called on AI without research datum. If admin69odified one of the AI's69ars revert the change and don't69odify69ariables directly, instead use ProcCall or admin panels.")
			spawn(1200)
				errored = 0
		return
	recalc_cpu()
	if(APU_power || aiRestorePowerRoutine != 0)
		research.Process(1)
	else
		research.Process(0)

// Recalculates CPU time gain and storage capacities.
/mob/living/silicon/ai/proc/recalc_cpu()
	// AI Starts with these69alues.
	var/cpu_gain = 0.2
	var/cpu_storage = 10

	// Off-Station APCs should69ot count towards CPU generation.
	for(var/obj/machinery/power/apc/A in hacked_apcs)
		if(isOnStationLevel(A))
			cpu_gain += 0.08
			cpu_storage += 10

	research.max_cpu = cpu_storage + override_CPUStorage
	if(hardware && istype(hardware, /datum/malf_hardware/dual_ram))
		research.max_cpu = research.max_cpu * 1.5
	research.stored_cpu =69in(research.stored_cpu, research.max_cpu)

	research.cpu_increase_per_tick = cpu_gain + override_CPURate
	if(hardware && istype(hardware, /datum/malf_hardware/dual_cpu))
		research.cpu_increase_per_tick = research.cpu_increase_per_tick * 2

// Starts AI's APU generator
/mob/living/silicon/ai/proc/start_apu(var/shutup = 0)
	if(!hardware || !istype(hardware, /datum/malf_hardware/apu_gen))
		if(!shutup)
			to_chat(src, "You do69ot have an APU generator and you shouldn't have this69erb. Report this.")
		return
	if(hardware_integrity() < 50)
		if(!shutup)
			to_chat(src, SPAN_NOTICE("Starting APU... <b>FAULT</b>(System Damaged)"))
		return
	if(!shutup)
		to_chat(src, "Starting APU... ONLINE")
	APU_power = 1

// Stops AI's APU generator
/mob/living/silicon/ai/proc/stop_apu(var/shutup = 0)
	if(!hardware || !istype(hardware, /datum/malf_hardware/apu_gen))
		return

	if(APU_power)
		APU_power = 0
		if(!shutup)
			to_chat(src, "Shutting down APU... DONE")

// Returns percentage of AI's remaining backup capacitor charge (maxhealth - oxyloss).
/mob/living/silicon/ai/proc/backup_capacitor()
	return69ax(0,((200 - getOxyLoss()) / 2))

// Returns percentage of AI's remaining hardware integrity (maxhealth - (bruteloss + fireloss))
/mob/living/silicon/ai/proc/hardware_integrity()
	return69ax(0,(health-HEALTH_THRESHOLD_DEAD)/2)

// Shows capacitor charge and hardware integrity information to the AI in Status tab.
/mob/living/silicon/ai/show_system_integrity()
	if(!src.stat)
		stat("Hardware integrity", "69hardware_integrity()69%")
		stat("Internal capacitor", "69backup_capacitor()69%")
	else
		stat("Systems69onfunctional")

// Shows AI69alfunction related information to the AI.
/mob/living/silicon/ai/show_malf_ai()
	if(!check_special_role(ROLE_MALFUNCTION))
		return
	if(src.hacked_apcs)
		stat("Hacked APCs", "69src.hacked_apcs.len69")
	stat("System Status", "69src.hacking ? "Busy" : "Stand-By"69")
	if(src.research)
		stat("Available CPU", "69src.research.stored_cpu69 TFlops")
		stat("Maximal CPU", "69src.research.max_cpu69 TFlops")
		stat("CPU generation rate", "69src.research.cpu_increase_per_tick * 1069 TFlops/s")
		stat("Current research focus", "69src.research.focus ? src.research.focus.name : "None"69")
		if(src.research.focus)
			stat("Research completed", "69round(src.research.focus.invested, 0.1)69/69round(src.research.focus.price)69")
		if(system_override == 1)
			stat("SYSTEM OVERRIDE INITIATED")
		else if(system_override == 2)
			stat("SYSTEM OVERRIDE COMPLETED")

// Cleaner proc for creating powersupply for an AI.
/mob/living/silicon/ai/proc/create_powersupply()
	if(psupply)
		qdel(psupply)
	psupply =69ew/obj/machinery/ai_powersupply(src)
