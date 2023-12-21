PROCESSING_SUBSYSTEM_DEF(humans)
	name = "Humans"
	priority = SS_PRIORITY_HUMAN
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	process_proc = /mob/proc/Life

	var/list/mob_list

/datum/controller/subsystem/processing/humans/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/mob/living/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing))
			processing -= thing
		// equivalent to `else if(thing.process(wait * 0.1))`
		else if(thing.Life(wait * 0.1) == PROCESS_KILL)
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, thing)
		if (MC_TICK_CHECK)
			return


/datum/controller/subsystem/processing/humans/PreInit()
	mob_list = processing // Simply setups a more recognizable var name than "processing"
