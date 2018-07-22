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
	if(!calculate_weights)
		return

	for(var/datum/storyevent/R in storyevents)
		update_event_weight(R)

/datum/storyteller/proc/calculate_event_weight(var/datum/storyevent/R)
	var/weight = 1

	weight *= weight_mult(crew,R.req_crew)
	weight *= weight_mult(heads,R.req_heads)
	weight *= weight_mult(sec,R.req_sec)
	weight *= weight_mult(eng,R.req_eng)
	weight *= weight_mult(med,R.req_med)
	weight *= weight_mult(sci,R.req_sci)

	weight *= weight_mult(event_spawn_stage,R.req_stage)

	weight *= weight_mult(R.spawn_times,0)

	weight = R.get_special_weight(weight)

	return weight

/datum/storyteller/proc/weight_mult(var/val, var/req)
	if(req <= 0)
		return 1
	if(val <= 0)	//We need to spawn anything
		return 0.75/req
	return 1-((max(0,req-val)**3)/(req**3))

