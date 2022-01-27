//Storyevent is the new event_meta, a holder for events, which holds69eta information about their weighting, re69uirements, etc

/datum/storyevent
	var/id = "event" //An id for internal use. No spaces or punctuation, 12 letter69ax length
		//Only admins/devs will see it

	var/name = "event" //More publicly69isible name. Use proper spacing, capitalize proper nouns
		//Players69ay see the name
	var/processing = FALSE




	var/enabled = TRUE //Compile time switch to enable/disable the event completely

	var/parallel = TRUE //Set true for storyevents that don't need to do any processing and will finish firing in a single stack
	//When false,69ultiple copies of this event cannot be 69ueued up at the same time.
	//The storyteller will be forced to wait for the previously scheduled copy to resolve completely


	var/weight_cache = 0

	var/last_spawn_time = 0

	//Weight calculation settings. Set to negative to disable check
	var/re69_crew = -1
	var/re69_heads = -1
	var/re69_sec = -1
	var/re69_eng = -1
	var/re69_med = -1
	var/re69_sci = -1

	var/re69_stage = -1

	var/max_crew_diff_lower = 10	//Maximum difference between above69alues and real crew distribution. If difference is greater, weight will be 0
	var/max_crew_diff_higher = 10

	var/max_stage_diff_lower = 0
	var/max_stage_diff_higher = 10

	var/ocurrences = 0 //How69any times this round, this storyevent has happened
	var/ocurrences_max = -1
	var/last_trigger_time = 0

	var/has_priest = -1

	//Things to configure
	var/event_type
	var/weight = 1 //Our base weight coefficient, which affects how likely we are to be picked from a list of other story events

	//Which event pools this story event can appear in.
	//Multiple options allowed, can be any combination of
	//EVENT_LEVEL_MUNDANE
	//EVENT_LEVEL_MODERATE
	//EVENT_LEVEL_MAJOR
	//EVENT_LEVEL_ROLESET
	//EVENT_LEVEL_ECONOMY  (not implemented)

	//It should be an associative list with the data being the cost of the event at that level
	var/list/event_pools = list()

	//Tags that describe what the event does. See __defines/storyteller.dm for a list
	var/list/tags = list()



//Check if we can trigger
/datum/storyevent/proc/can_trigger(var/severity,69ar/mob/report)
	.=TRUE
	if (!enabled)
		if (report) to_chat(report, SPAN_NOTICE("Failure: The event is disabled"))
		return FALSE

	if (ocurrences_max > 0 && ocurrences >= ocurrences_max)
		if (report) to_chat(report, SPAN_NOTICE("Failure: The event has already triggered the69aximum number of times for a single round"))
		return FALSE

	if(processing && is_processing())
		if (report) to_chat(report, SPAN_NOTICE("Failure: This event is already processing"))
		return FALSE

	//IF this is a wrapper for a random event, we'll check if that event can trigger
	if (event_type)
		//We have to create a new one, but New doesn't really do anything for events
		var/datum/event/E = new event_type(src, severity)
		if (!E.can_trigger())
			if (report) to_chat(report, SPAN_NOTICE("Failure: Event can't trigger for specific unknown reasons"))
			.=FALSE
		//Clean it up after we're done
		69del(E)
	return

/datum/storyevent/proc/get_special_weight(var/weight)
	return weight


/datum/storyevent/proc/create(var/severity)
	if(trigger_event(severity))
		ocurrences++
		last_trigger_time = world.time
		if(processing)
			start_processing(TRUE)
		return TRUE

	return FALSE

/datum/storyevent/proc/cancel(var/type,69ar/completion = 0)
	//This proc refunds the cost of this event
	if (GLOB.storyteller)
		GLOB.storyteller.modify_points(get_cost(type)*(1 - completion), type)

/datum/storyevent/proc/trigger_event(var/severity = EVENT_LEVEL_MUNDANE)
	if (event_type)
		var/datum/event/E = new event_type(src, severity)
		if (!E.can_trigger())
			return FALSE
		//If we get here, the event is fine to fire!

		//And away it goes.
		E.Initialize()
		return TRUE
		//From here everything is automated, the event69anager subsystem will handle ticking

	return FALSE


/datum/storyevent/Process()
	return

/datum/storyevent/proc/is_ended()
	return TRUE

/datum/storyevent/proc/start_processing(var/announce = FALSE)
	GLOB.storyteller.add_processing(src)
	if(announce)
		announce()

/datum/storyevent/proc/stop_processing(var/announce = FALSE)
	GLOB.storyteller.remove_processing(src)
	if(announce)
		announce_end()

/datum/storyevent/proc/is_processing()
	return (src in GLOB.storyteller.processing_events)

/datum/storyevent/proc/announce()

/datum/storyevent/proc/announce_end()

/datum/storyevent/proc/weight_mult(var/val,69ar/re69,69ar/min,69ar/max)
	if(re69 < 0)
		return 1
	if(val <69in ||69al >69ax)
		return 1
	var/mod = (min+max/2)**2
	return69ax(mod-(abs(val-re69)**2),0)/mod

/datum/storyevent/proc/get_cost(var/event_type)
	return event_pools69event_type69
