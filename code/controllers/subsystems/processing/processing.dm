//Used to process objects. Fires once every second.

SUBSYSTEM_DEF(processing)
	name = "Processing"
	priority = SS_PRIORITY_PROCESSING
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT
	wait = 1 SECONDS

	var/list/processing = list()
	var/list/currentrun = list()

	/// Eris-specific process debugger
	var/process_proc = "Process"
	var/debug_last_thing
	var/debug_original_process_proc // initial() does not work with procs

/datum/controller/subsystem/processing/stat_entry()
	..("P:[length(processing)]")

/datum/controller/subsystem/processing/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing))
			processing -= thing
		// equivalent to `else if(thing.process(wait * 0.1))`
		else if((call(thing, process_proc)(wait * 0.1) == PROCESS_KILL))
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, thing)
		if (MC_TICK_CHECK)
			return

/**
 * This proc is called on a datum on every "cycle" if it is being processed by a subsystem. The time between each cycle is determined by the subsystem's "wait" setting.
 * You can start and stop processing a datum using the START_PROCESSING and STOP_PROCESSING defines.
 *
 * Since the wait setting of a subsystem can be changed at any time, it is important that any rate-of-change that you implement in this proc is multiplied by the delta_time that is sent as a parameter,
 * Additionally, any "prob" you use in this proc should instead use the DT_PROB define to make sure that the final probability per second stays the same even if the subsystem's wait is altered.
 * Examples where this must be considered:
 * - Implementing a cooldown timer, use `mytimer -= delta_time`, not `mytimer -= 1`. This way, `mytimer` will always have the unit of seconds
 * - Damaging a mob, do `L.adjustFireLoss(20 * delta_time)`, not `L.adjustFireLoss(20)`. This way, the damage per second stays constant even if the wait of the subsystem is changed
 * - Probability of something happening, do `if(DT_PROB(25, delta_time))`, not `if(prob(25))`. This way, if the subsystem wait is e.g. lowered, there won't be a higher chance of this event happening per second
 *
 * If you override this do not call parent, as it will return PROCESS_KILL. This is done to prevent objects that dont override process() from staying in the processing list
 */
/datum/proc/Process(delta_time)
	set waitfor = 0
	return PROCESS_KILL

///
/// ERIS PROCESS DEBUGGER
///

/datum/controller/subsystem/processing/proc/toggle_debug()
	if(!check_rights(R_DEBUG))
		return

	if(debug_original_process_proc)
		process_proc = debug_original_process_proc
		debug_original_process_proc = null
	else
		debug_original_process_proc	= process_proc
		process_proc = /datum/proc/DebugSubsystemProcess

	to_chat(usr, "[name] - Debug mode [debug_original_process_proc ? "en" : "dis"]abled")
	log_world("[usr] [debug_original_process_proc ? "en" : "dis"]abled [name] debug mode")

/datum/proc/DebugSubsystemProcess(wait)
	SSprocessing.debug_last_thing = src
	var/start_tick = world.time
	var/start_tick_usage = world.tick_usage
	. = call(src, SSprocessing.debug_original_process_proc)(wait)

	var/tick_time = world.time - start_tick
	var/tick_use_limit = world.tick_usage - start_tick_usage - 100 // Current tick use - starting tick use - 100% (a full tick excess)
	if(tick_time > 0)
		CRASH("[log_info_line(SSprocessing.debug_last_thing)] slept during processing. Spent [tick_time] tick\s.")
	if(tick_use_limit > 0)
		CRASH("[log_info_line(SSprocessing.debug_last_thing)] took longer than a tick to process. Exceeded with [tick_use_limit]%")
