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
			var/datum/job/job = SSjob.GetJob(M.mind.assigned_role)
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



/datum/storyteller/proc/calculate_event_weight(var/datum/storyevent/R)
	var/new_weight = R.weight

	new_weight *= weight_mult(crew,R.req_crew)
	new_weight *= weight_mult(heads,R.req_heads)
	new_weight *= weight_mult(sec,R.req_sec)
	new_weight *= weight_mult(eng,R.req_eng)
	new_weight *= weight_mult(med,R.req_med)
	new_weight *= weight_mult(sci,R.req_sci)

	new_weight = R.get_special_weight(new_weight)

	return new_weight

/datum/storyteller/proc/weight_mult(var/val, var/req)
	if(req <= 0)
		return 1
	if(val <= 0)	//We need to spawn anything
		return 0.75/req
	return 1-((max(0,req-val)**3)/(req**3))

