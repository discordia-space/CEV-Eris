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

	/// Open tguis owned by this datum
	/// Lazy, since this case is semi rare
	var/list/open_uis

	/// Active timers with this datum as the target
	var/list/_active_timers

	var/tmp/is_processing = FALSE

	/**
	  * Components attached to this datum
	  *
	  * Lazy associated list in the structure of `type:component/list of components`
	  */
	var/list/_datum_components
	/**
	  * Any datum registered to receive signals from this datum is in this list
	  *
	  * Lazy associated list in the structure of `[signal] = list(registered_objects)`
	  */
	var/list/_listen_lookup
	/// Lazy associated list in the structure of `[target][signal] = proc)` that are run when the datum receives that signal
	var/list/list/datum/callback/_signal_procs

	var/signal_enabled = FALSE

	/// Datum level flags
	var/datum_flags = NONE

	/// A weak reference to another datum
	var/datum/weakref/weak_reference

	/*
	* Lazy associative list of currently active cooldowns.
	*
	* cooldowns [ COOLDOWN_INDEX ] = add_timer()
	* add_timer() returns the truthy value of -1 when not stoppable, and else a truthy numeric index
	*/
	var/list/cooldowns


#ifdef REFERENCE_TRACKING
	var/running_find_references
	var/last_find_references = 0
	#ifdef REFERENCE_TRACKING_DEBUG
	///Stores info about where refs are found, used for sanity checks and testing
	var/list/found_refs
	#endif
#endif

/**
 * Default implementation of clean-up code.
 *
 * This should be overridden to remove all references pointing to the object being destroyed, if
 * you do override it, make sure to call the parent and return it's return value by default
 *
 * Return an appropriate [QDEL_HINT][QDEL_HINT_QUEUE] to modify handling of your deletion;
 * in most cases this is [QDEL_HINT_QUEUE].
 *
 * The base case is responsible for doing the following
 * * Erasing timers pointing to this datum
 * * Erasing compenents on this datum
 * * Notifying datums listening to signals from this datum that we are going away
 *
 * Returns [QDEL_HINT_QUEUE]
 */
/datum/proc/Destroy(force=FALSE)
	// TODO: Apparently this is a good thing to have but our codebase currently has like 200~ instances of things not calling the parent destroy proc. ~Chen
	// SHOULD_CALL_PARENT(TRUE)
	// SHOULD_NOT_SLEEP(TRUE)
	tag = null
	datum_flags &= ~DF_USE_TAG //In case something tries to REF us
	weak_reference = null //ensure prompt GCing of weakref.

	if(_active_timers)
		var/list/timers = _active_timers
		_active_timers = null
		for(var/datum/timedevent/timer as anything in timers)
			if (timer.spent && !(timer.flags & TIMER_DELETE_ME))
				continue
			qdel(timer)
	SSnano.close_uis(src)
	SStgui.close_uis(src)

	#ifdef REFERENCE_TRACKING
	#ifdef REFERENCE_TRACKING_DEBUG
	found_refs = null
	#endif
	#endif

	//BEGIN: ECS SHIT
	var/list/dc = _datum_components
	if(dc)
		for(var/component_key in dc)
			var/component_or_list = dc[component_key]
			if(islist(component_or_list))
				for(var/datum/component/component as anything in component_or_list)
					qdel(component, FALSE)
			else
				var/datum/component/C = component_or_list
				qdel(C, FALSE)
		dc.Cut()

	_clear_signal_refs()
	//END: ECS SHIT

	_clear_signal_refs()

	return QDEL_HINT_QUEUE

///Only override this if you know what you're doing. You do not know what you're doing
///This is a threat
/datum/proc/_clear_signal_refs()
	var/list/lookup = _listen_lookup
	if(lookup)
		for(var/sig in lookup)
			var/list/comps = lookup[sig]
			if(length(comps))
				for(var/datum/component/comp as anything in comps)
					comp.UnregisterSignal(src, sig)
			else
				var/datum/component/comp = comps
				comp.UnregisterSignal(src, sig)
		_listen_lookup = lookup = null

	for(var/target in _signal_procs)
		UnregisterSignal(target, _signal_procs[target])

/// Return a list of data which can be used to investigate the datum, also ensure that you set the semver in the options list
/datum/proc/serialize_list(list/options, list/semvers)
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	.["tag"] = tag

	SET_SERIALIZATION_SEMVER(semvers, "1.0.0")
	return .

///Accepts a LIST from deserialize_datum. Should return whether or not the deserialization was successful.
/datum/proc/deserialize_list(json, list/options)
	SHOULD_CALL_PARENT(TRUE)
	return TRUE

///Serializes into JSON. Does not encode type.
/datum/proc/serialize_json(list/options)
	. = serialize_list(options, list())
	if(!islist(.))
		. = null
	else
		. = json_encode(.)

///Deserializes from JSON. Does not parse type.
/datum/proc/deserialize_json(list/input, list/options)
	var/list/jsonlist = json_decode(input)
	. = deserialize_list(jsonlist)
	if(!istype(., /datum))
		. = null

///Convert a datum into a json blob
/proc/json_serialize_datum(datum/D, list/options)
	if(!istype(D))
		return
	var/list/jsonlist = D.serialize_list(options)
	if(islist(jsonlist))
		jsonlist["DATUM_TYPE"] = D.type
	return json_encode(jsonlist)

/**
 * Callback called by a timer to end an associative-list-indexed cooldown.
 *
 * Arguments:
 * * source - datum storing the cooldown
 * * index - string index storing the cooldown on the cooldowns associative list
 *
 * This sends a signal reporting the cooldown end.
 */
/proc/end_cooldown(datum/source, index)
	if(QDELETED(source))
		return
	SEND_SIGNAL(source, COMSIG_CD_STOP(index))
	TIMER_COOLDOWN_END(source, index)


/**
 * Proc used by stoppable timers to end a cooldown before the time has ran out.
 *
 * Arguments:
 * * source - datum storing the cooldown
 * * index - string index storing the cooldown on the cooldowns associative list
 *
 * This sends a signal reporting the cooldown end, passing the time left as an argument.
 */
/proc/reset_cooldown(datum/source, index)
	if(QDELETED(source))
		return
	SEND_SIGNAL(source, COMSIG_CD_RESET(index), S_TIMER_COOLDOWN_TIMELEFT(source, index))
	TIMER_COOLDOWN_END(source, index)

/datum/proc/CanProcCall(procname)
	return TRUE

/datum/proc/can_vv_get(var_name)
	if(var_name == NAMEOF(src, vars))
		return FALSE
	return TRUE

/// Called when a var is edited with the new value to change to
/datum/proc/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, vars))
		return FALSE
	vars[var_name] = var_value
	datum_flags |= DF_VAR_EDITED
	return TRUE

/datum/proc/vv_get_var(var_name)
	switch(var_name)
		if (NAMEOF(src, vars))
			return debug_variable(var_name, list(), 0, src)
	return debug_variable(var_name, vars[var_name], 0, src)

/datum/proc/can_vv_mark()
	return TRUE

/**
 * Gets all the dropdown options in the vv menu.
 * When overriding, make sure to call . = ..() first and appent to the result, that way parent items are always at the top and child items are further down.
 * Add seperators by doing VV_DROPDOWN_OPTION("", "---")
 */
/datum/proc/vv_get_dropdown()
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_CALLPROC, "Call Proc")
	VV_DROPDOWN_OPTION(VV_HK_MARK, "Mark Object")
	VV_DROPDOWN_OPTION(VV_HK_TAG, "Tag Datum")
	VV_DROPDOWN_OPTION(VV_HK_DELETE, "Delete")
	VV_DROPDOWN_OPTION(VV_HK_EXPOSE, "Show VV To Player")
	VV_DROPDOWN_OPTION(VV_HK_ADDCOMPONENT, "Add Component/Element")
	VV_DROPDOWN_OPTION(VV_HK_REMOVECOMPONENT, "Remove Component/Element")
	VV_DROPDOWN_OPTION(VV_HK_MASS_REMOVECOMPONENT, "Mass Remove Component/Element")

/**
 * This proc is only called if everything topic-wise is verified. The only verifications that should happen here is things like permission checks!
 * href_list is a reference, modifying it in these procs WILL change the rest of the proc in topic.dm of admin/view_variables!
 * This proc is for "high level" actions like admin heal/set species/etc/etc. The low level debugging things should go in admin/view_variables/topic_basic.dm incase this runtimes.
 */
/datum/proc/vv_do_topic(list/href_list)
	if(!usr || !usr.client || !usr.client.holder || !check_rights(NONE))
		return FALSE //This is VV, not to be called by anything else.
	if(SEND_SIGNAL(src, COMSIG_VV_TOPIC, usr, href_list) & COMPONENT_VV_HANDLED)
		return FALSE
	// if(href_list[VV_HK_MODIFY_TRAITS])
	// 	usr.client.holder.modify_traits(src)
	return TRUE

/datum/proc/vv_get_header()
	. = list()
	if(("name" in vars) && !isatom(src))
		. += "<b>[vars["name"]]</b><br>"
