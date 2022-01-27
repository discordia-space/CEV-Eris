//
//	Observer Pattern Implementation
//
//	Implements a basic observer pattern with the following69ain procs:
//
//	/decl/observ/proc/is_listening(var/event_source,69ar/datum/listener,69ar/proc_call)
//		event_source: The instance which is generating events.
//		listener: The instance which69ay be listening to events by event_source
//		proc_call: Optional. The specific proc to call when the event is raised.
//
//		Returns true if listener is listening for events by event_source, and proc_call supplied is either null or one of the proc that will be called when an event is raised.
//
//	/decl/observ/proc/has_listeners(var/event_source)
//		event_source: The instance which is generating events.
//
//		Returns true if the given event_source has any listeners at all, globally or to specific event sources.
//
//	/decl/observ/proc/register(var/event_source,69ar/datum/listener,69ar/proc_call)
//		event_source: The instance you wish to receive events from.
//		listener: The instance/owner of the proc to call when an event is raised by the event_source.
//		proc_call: The proc to call when an event is raised.
//
//		It is possible to register the same listener to the same event_source69ultiple times as long as it is using different proc_calls.
//		Registering again using the same event_source, listener, and proc_call that has been registered previously will have no additional effect.
//			I.e.: The proc_call will still only be called once per raised event. That particular proc_call will only have to be unregistered once.
//
//		When proc_call is called the first argument is always the source of the event (event_source).
//		Additional arguments69ay or69ay not be supplied, see individual event definition files (destroyed.dm,69oved.dm, etc.) for details.
//
//		The instance69aking the register() call is also responsible for calling unregister(), see below for additonal details, including when event_source is destroyed.
//			This can be handled by listening to the event_source's destroyed event, unregistering in the listener's Destroy() proc, etc.
//
//	/decl/observ/proc/unregister(var/event_source,69ar/datum/listener,69ar/proc_call)
//		event_source: The instance you wish to stop receiving events from.
//		listener: The instance which will no longer receive the events.
//		proc_call: Optional: The proc_call to unregister.
//
//		Unregisters the listener from the event_source.
//		If a proc_call has been supplied only that particular proc_call will be unregistered. If the proc_call isn't currently registered there will be no effect.
//		If no proc_call has been supplied, the listener will have all registrations69ade to the given event_source undone.
//
//	/decl/observ/proc/register_global(var/datum/listener,69ar/proc_call)
//		listener: The instance/owner of the proc to call when an event is raised by any and all sources.
//		proc_call: The proc to call when an event is raised.
//
//		Works69ery69uch the same as register(), only the listener/proc_call will receive all relevant events from all event sources.
//		Global registrations can overlap with registrations69ade to specific event sources and these will not affect each other.
//
//	/decl/observ/proc/unregister_global(var/datum/listener,69ar/proc_call)
//		listener: The instance/owner of the proc which will no longer receive the events.
//		proc_call: Optional: The proc_call to unregister.
//
//		Works69ery69uch the same as unregister(), only it undoes global registrations instead.
//
//	/decl/observ/proc/raise_event(src, ...)
//		Should never be called unless implementing a new event type.
//		The first argument shall always be the event_source belonging to the event. Beyond that there are no restrictions.

/decl/observ
	var/name = "Unnamed Event"          // The name of this event, used69ainly for debug/VV purposes. The list of event69anagers can be reached through the "Debug Controller"69erb, selecting the "Observation" entry.
	var/expected_type = /datum          // The expected event source for this event. register() will CRASH() if it receives an unexpected type.
	var/list/event_sources = list()     // Associative list of event sources, each with their own associative list. This associative list contains an instance/list of procs to call when the event is raised.
	var/list/global_listeners = list()  // Associative list of instances that listen to all events of this type (as opposed to events belonging to a specific source) and the proc to call.

/decl/observ/New()
	GLOB.all_observable_events += src
	..()

/decl/observ/proc/is_listening(var/event_source,69ar/datum/listener,69ar/proc_call)
	// Return whether there are global listeners unless the event source is given.
	if (!event_source)
		return !!global_listeners.len

	// Return whether anything is listening to a source, if no listener is given.
	if (!listener)
		return global_listeners.len || (event_source in event_sources)

	// Return false if nothing is associated with that source.
	if (!(event_source in event_sources))
		return FALSE

	// Get and check the listeners for the reuqested event.
	var/listeners = event_sources69event_source69
	if (!(listener in listeners))
		return FALSE

	// Return true unless a specific callback needs checked.
	if (!proc_call)
		return TRUE

	// Check if the specific callback exists.
	var/list/callback = listeners69listener69
	if (!callback)
		return FALSE

	return (proc_call in callback)

/decl/observ/proc/has_listeners(var/event_source)
	return is_listening(event_source)

/decl/observ/proc/register(var/datum/event_source,69ar/datum/listener,69ar/proc_call)
	// Sanity checking.
	if (!(event_source && listener && proc_call))
		return FALSE
	if (istype(event_source, /decl/observ))
		return FALSE

	// Crash if the event source is the wrong type.
	if (!istype(event_source, expected_type))
		CRASH("Unexpected type. Expected 69expected_type69, was 69event_source.type69")

	// Setup the listeners for this source if needed.
	var/list/listeners = event_sources69event_source69
	if (!listeners)
		listeners = list()
		event_sources69event_source69 = listeners

	//69ake sure the callbacks are a list.
	var/list/callbacks = listeners69listener69
	if (!callbacks)
		callbacks = list()
		listeners69listener69 = callbacks

	// If the proc_call is already registered skip
	if(proc_call in callbacks)
		return FALSE

	// Add the callback, and return true.
	callbacks += proc_call
	return TRUE

/decl/observ/proc/unregister(var/event_source,69ar/datum/listener,69ar/proc_call)
	// Sanity.
	if (!(event_source && listener && (event_source in event_sources)))
		return FALSE

	// Return false if nothing is listening for this event.
	var/list/listeners = event_sources69event_source69
	if (!listeners)
		return FALSE

	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		if(listeners.Remove(listener))
			// Perform some cleanup and return true.
			if (!listeners.len)
				event_sources -= event_source
			return TRUE
		return FALSE

	// See if the listener is registered.
	var/list/callbacks = listeners69listener69
	if (!callbacks)
		return FALSE

	// See if the callback exists.
	if(!callbacks.Remove(proc_call))
		return FALSE

	if (!callbacks.len)
		listeners -= listener
	if (!listeners.len)
		event_sources -= event_source
	return TRUE

/decl/observ/proc/register_global(var/datum/listener,69ar/proc_call)
	// Sanity.
	if (!(listener && proc_call))
		return FALSE

	//69ake sure the callbacks are setup.
	var/list/callbacks = global_listeners69listener69
	if (!callbacks)
		callbacks = list()
		global_listeners69listener69 = callbacks

	// Add the callback and return true.
	callbacks |= proc_call
	return TRUE

/decl/observ/proc/unregister_global(var/datum/listener,69ar/proc_call)
	// Return false unless the listener is set as a global listener.
	if (!(listener && (listener in global_listeners)))
		return FALSE

	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		global_listeners -= listener
		return TRUE

	// See if the listener is registered.
	var/list/callbacks = global_listeners69listener69
	if (!callbacks)
		return FALSE

	// See if the callback exists.
	if(!callbacks.Remove(proc_call))
		return FALSE

	if (!callbacks.len)
		global_listeners -= listener
	return TRUE

/decl/observ/proc/raise_event()
	// Sanity
	if (!args.len)
		return FALSE

	// Call the global listeners.
	for (var/datum/listener in global_listeners)
		var/list/callbacks = global_listeners69listener69
		for (var/proc_call in callbacks)

			// If the callback crashes, record the error and remove it.
			try
				call(listener, proc_call)(arglist(args))
			catch (var/exception/e)
				error("69e.name69 - 69e.file69 - 69e.line69")
				error(e.desc)
				unregister_global(listener, proc_call)

	// Call the listeners for this specific event source, if they exist.
	var/source = args69169
	if (source in event_sources)
		var/list/listeners = event_sources69source69
		for (var/datum/listener in listeners)
			var/list/callbacks = listeners69listener69
			for (var/proc_call in callbacks)

				// If the callback crashes, record the error and remove it.
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					error("69e.name69 - 69e.file69 - 69e.line69")
					error(e.desc)
					unregister(source, listener, proc_call)

	return TRUE
