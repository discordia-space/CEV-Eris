/**
 * The absolute base class for everything
 *
 * A datum instantiated has no physical world prescence, use an atom if you want something
 * that actually lives in the world
 *
 * Be very mindful about adding variables to this class, they are inherited by every single
 * thing in the entire game, and so you can easily cause memory usage to rise a lot with careless
 * use of variables at this level
 */
/datum
	/**
	  * Tick count time when this object was destroyed.
	  *
	  * If this is non zero then the object has been garbage collected and is awaiting either
	  * a hard del by the GC subsystme, or to be autocollected (if it has no references)
	  */
	var/gc_destroyed

	/// Active timers with this datum as the target
	var/list/active_timers

	var/tmp/is_processing = FALSE

	/**
	  * Components attached to this datum
	  *
	  * Lazy associated list in the structure of `type:component/list of components`
	  */
	var/list/datum_components
	/**
	  * Any datum registered to receive signals from this datum is in this list
	  *
	  * Lazy associated list in the structure of `[signal] = list(registered_objects)`
	  */
	var/list/comp_lookup
	/// Lazy associated list in the structure of `[target][signal] = proc)` that are run when the datum receives that signal
	var/list/list/datum/callback/signal_procs

	var/signal_enabled = FALSE

	/// Datum level flags
	var/datum_flags = NONE

	/// A weak reference to another datum
	var/datum/weakref/weak_reference

#ifdef REFERENCE_TRACKING
	var/running_find_references
	var/last_find_references = 0
	#ifdef REFERENCE_TRACKING_DEBUG
	///Stores info about where refs are found, used for sanity checks and testing
	var/list/found_refs
	#endif
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
	var/list/timers = active_timers
	active_timers = null
	tag = null
	datum_flags &= ~DF_USE_TAG //In case something tries to REF us
	weak_reference = null //ensure prompt GCing of weakref.
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

