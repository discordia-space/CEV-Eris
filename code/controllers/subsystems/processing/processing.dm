//Used to process objects. Fires once every second.

SUBSYSTEM_DEF(processing)
	name = "Processing"
	priority = SS_PRIORITY_PROCESSING
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT
	wait = 1 SECONDS

	var/list/processing = list()
	var/process_proc = /datum/proc/Process

	var/debug_last_thing
	var/debug_original_process_proc // initial() does not work with procs
	var/nextProcessingListPosition = 0 //position of next thing to be processed, inside of currently processed list

/datum/controller/subsystem/processing/stopProcessingWrapper(var/D) //called before a thing stops being processed
	if (!nextProcessingListPosition) //0 position means currently processed list is not paused or running, no point in adjusting last position due to removals from list
		return
	var/position = processing.Find(D) //find exact position in list
	if (position)
		if (position < nextProcessingListPosition) //removals from list are only relevant to currently processed position if they are on the left side of it, otherwise they do not alter order of processing
			nextProcessingListPosition-- //adjust current position to compensate for removed thing

/datum/controller/subsystem/processing/stat_entry()
	..(processing.len)

/datum/controller/subsystem/processing/fire(resumed = 0)
	if (!resumed)
		nextProcessingListPosition = 1 //fresh start, otherwise from saved posisition

	//localizations
	var/times_fired = src.times_fired
	var/list/local_list = processing
	var/datum/thing
	var/wait = src.wait

	var/tickCheckPeriod = round(local_list.len/16+1) //pause process at most every 1/16th length of list
	while(nextProcessingListPosition && (nextProcessingListPosition <= local_list.len)) //until position is valid
		thing = local_list[nextProcessingListPosition]
		nextProcessingListPosition++

		if(QDELETED(thing) || (call(thing, process_proc)(wait, times_fired, src) == PROCESS_KILL))
			if(thing)
				thing.is_processing = null
			processing -= thing
			nextProcessingListPosition-- //removing processed thing from list moves the queue to the left, adjust accordingly

		if(!(nextProcessingListPosition%tickCheckPeriod)) //pauses only every tickCheckPeriod-th processed thing
			if (MC_TICK_CHECK)
				return

	nextProcessingListPosition = 0 //entire list was processed

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

/datum/proc/DebugSubsystemProcess(var/wait, var/times_fired, var/datum/controller/subsystem/processing/subsystem)
	subsystem.debug_last_thing = src
	var/start_tick = world.time
	var/start_tick_usage = world.tick_usage
	. = call(src, subsystem.debug_original_process_proc)(wait, times_fired)

	var/tick_time = world.time - start_tick
	var/tick_use_limit = world.tick_usage - start_tick_usage - 100 // Current tick use - starting tick use - 100% (a full tick excess)
	if(tick_time > 0)
		crash_with("[log_info_line(subsystem.debug_last_thing)] slept during processing. Spent [tick_time] tick\s.")
	if(tick_use_limit > 0)
		crash_with("[log_info_line(subsystem.debug_last_thing)] took longer than a tick to process. Exceeded with [tick_use_limit]%")
