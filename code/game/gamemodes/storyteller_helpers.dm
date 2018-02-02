/datum/storyteller/proc/update_crew_count()
	if(debug_mode)
		return

	crew = 0
	heads = 0
	sec = 0
	eng = 0
	med = 0
	sci = 0

	for(var/mob/M in player_list)
		if(M.client && (M.mind && !M.mind.antagonist.len) && M.stat != DEAD && (ishuman(M) || isrobot(M) || isAI(M)))
			var/datum/job/job = job_master.GetJob(M.mind.assigned_role)
			if(job)
				crew++
				if(job.head_position)
					heads++
				if(job.department == "Engineering")
					eng++
				if(job.department == "Security")
					sec++
				if(job.department == "Medical")
					med++
				if(job.department == "Science")
					sci++

/datum/storyteller/proc/update_event_weights()
	for(var/datum/storyevent/R in storyevents)
		get_event_weight(R)

/datum/storyteller/proc/calculate_event_weight(var/datum/storyevent/R)
	var/weight = 1

	weight *= weight_mult(crew,R.req_crew,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(heads,R.req_heads,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(sec,R.req_sec,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(eng,R.req_eng,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(med,R.req_med,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(sci,R.req_sci,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)

	weight *= weight_mult(event_spawn_stage,R.req_stage,R.max_stage_diff_lower,R.max_stage_diff_higher,TRUE)

	weight *= weight_mult(R.spawn_times,0,0,R.spawn_times_max)

	weight = R.get_special_weight(weight)

	return weight

/datum/storyteller/proc/weight_mult(var/val, var/req, var/min, var/max, var/atl = FALSE)
	if(req < 0)
		return 1
	if(val < min || (!atl && val > max))
		return 0
	if(atl && req < val)
		return 1
	var/mod = (min+max/2)**2
	return max(mod-(abs(val-req)**2),0)/mod

