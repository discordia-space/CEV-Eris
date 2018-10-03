//Storyevent is the new event_meta, a holder for events, which holds meta information about their weighting, requirements, etc

/datum/storyevent
	var/id = "event"
	var/processing = FALSE

	//Which event pools this story event can appear in.
	//Multiple options allowed, can be any combination of
	//EVENT_LEVEL_MUNDANE
	//EVENT_LEVEL_MODERATE
	//EVENT_LEVEL_MAJOR
	//EVENT_LEVEL_ROLESET
	//EVENT_LEVEL_ECONOMY  (not implemented)
	var/list/pool_types = list()


	var/enabled = TRUE //Compile time switch to enable/disable the event completely

	var/parallel = TRUE //Set true for storyevents that don't need to do any processing and will finish firing in a single stack
	//When false, multiple copies of this event cannot be queued up at the same time.
	//The storyteller will be forced to wait for the previously scheduled copy to resolve completely

	var/cost = 20
	var/max_cost = 1
	var/min_cost = 100

	var/weight = 1
	var/weight_cache = 0

	var/last_spawn_time = 0

	//Weight calculation settings. Set to negative to disable check
	var/req_crew = -1
	var/req_heads = -1
	var/req_sec = -1
	var/req_eng = -1
	var/req_med = -1
	var/req_sci = -1

	var/req_stage = -1

	var/max_crew_diff_lower = 10	//Maximum difference between above values and real crew distribution. If difference is greater, weight will be 0
	var/max_crew_diff_higher = 10

	var/max_stage_diff_lower = 0
	var/max_stage_diff_higher = 10

	var/ocurrences = 0 //How many times this round, this storyevent has happened
	var/ocurrences_max = -1
	var/last_trigger_time = 0

	var/has_priest = -1

/datum/storyevent/proc/can_trigger()
	if(processing && is_processing())
		return FALSE
	return TRUE

/datum/storyevent/proc/get_special_weight(var/weight)
	return weight


/datum/storyevent/proc/create()
	if(trigger_event())
		ocurrences++
		last_trigger_time = world.time
		if(processing)
			start_processing(TRUE)
		return TRUE

	return FALSE

/datum/storyevent/proc/cancel(var/type, var/completion = 0.0)
	//This proc refunds the cost of this event
	if (storyteller)
		storyteller.modify_points(get_cost(type), type)

/datum/storyevent/proc/trigger_event()
	return FALSE


/datum/storyevent/Process()
	return

/datum/storyevent/proc/is_ended()
	return TRUE

/datum/storyevent/proc/start_processing(var/announce = FALSE)
	SSticker.storyteller.add_processing(src)
	if(announce)
		announce()

/datum/storyevent/proc/stop_processing(var/announce = FALSE)
	SSticker.storyteller.remove_processing(src)
	if(announce)
		announce_end()

/datum/storyevent/proc/is_processing()
	return (src in SSticker.storyteller.processing_events)

/datum/storyevent/proc/announce()

/datum/storyevent/proc/announce_end()

/datum/storyevent/proc/weight_mult(var/val, var/req, var/min, var/max)
	if(req < 0)
		return 1
	if(val < min || val > max)
		return 0
	var/mod = (min+max/2)**2
	return max(mod-(abs(val-req)**2),0)/mod