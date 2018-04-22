var/global/list/storyevents = list()

/proc/fill_storyevents_list()
	for(var/type in typesof(/datum/storyevent)-/datum/storyevent-/datum/storyevent/roleset)
		storyevents.Add(new type)

/datum/storyevent
	var/id = "event"
	var/processing = FALSE

	var/multispawn = FALSE //Set to TRUE to let the storyteller spawn more than 1 event of this type per stage
	var/spawnable = TRUE

	var/cost = 0
	var/max_cost = 1
	var/min_cost = 100

	var/weight_cache = 0
	var/spawn_times = 0

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

	var/spawn_times_max = 1

	var/has_priest = -1

/datum/storyevent/proc/can_spawn()
	if(processing && is_processing())
		return FALSE
	return spawnable

/datum/storyevent/proc/get_special_weight(var/weight)
	return weight


/datum/storyevent/proc/create()
	if(spawn_event())
		spawn_times++
		last_spawn_time = world.time
		if(processing)
			start_processing(TRUE)
		return TRUE

	return FALSE

/datum/storyevent/proc/spawn_event()
	return FALSE


/datum/storyevent/Process()
	return

/datum/storyevent/proc/is_ended()
	return TRUE

/datum/storyevent/proc/start_processing(var/announce = FALSE)
	ticker.storyteller.add_processing(src)
	if(announce)
		announce()

/datum/storyevent/proc/stop_processing(var/announce = FALSE)
	ticker.storyteller.remove_processing(src)
	if(announce)
		announce_end()

/datum/storyevent/proc/is_processing()
	return (src in ticker.storyteller.processing_events)

/datum/storyevent/proc/weight_mult(var/val, var/req, var/min, var/max)
	if(req < 0)
		return 1
	if(val < min || val > max)
		return 0
	var/mod = (min+max/2)**2
	return max(mod-(abs(val-req)**2),0)/mod

/datum/storyevent/proc/announce()

/datum/storyevent/proc/announce_end()
