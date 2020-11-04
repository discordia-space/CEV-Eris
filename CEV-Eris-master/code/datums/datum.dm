/datum
	var/tmp/gc_destroyed //Time when this object was destroyed.
	var/tmp/is_processing = FALSE
	var/list/datum_components //for /datum/components
	var/list/comp_lookup //it used to be for looking up components which had registered a signal but now anything can register
	var/list/list/datum/callback/signal_procs
	var/signal_enabled = FALSE

#ifdef TESTING
	var/tmp/running_find_references
	var/tmp/last_find_references = 0
#endif

/*
// The following vars cannot be edited by anyone
/datum/VV_static()
	return ..() + list("gc_destroyed", "is_processing")
*/

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	tag = null
	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent)
			continue
		qdel(timer)
	SSnano.close_uis(src)

	//BEGIN: ECS SHIT
	signal_enabled = FALSE

	var/list/dc = datum_components
	if(dc)
		var/all_components = dc[/datum/component]
		if(length(all_components))
			for(var/I in all_components)
				var/datum/component/C = I
				qdel(C, FALSE, TRUE)
		else
			var/datum/component/C = all_components
			qdel(C, FALSE, TRUE)
		dc.Cut()

	var/list/lookup = comp_lookup
	if(lookup)
		for(var/sig in lookup)
			var/list/comps = lookup[sig]
			if(length(comps))
				for(var/i in comps)
					var/datum/component/comp = i
					comp.UnregisterSignal(src, sig)
			else
				var/datum/component/comp = comps
				comp.UnregisterSignal(src, sig)
		comp_lookup = lookup = null

	for(var/target in signal_procs)
		UnregisterSignal(target, signal_procs[target])
	//END: ECS SHIT

	return QDEL_HINT_QUEUE

/datum/proc/Process()
	set waitfor = 0
	return PROCESS_KILL
