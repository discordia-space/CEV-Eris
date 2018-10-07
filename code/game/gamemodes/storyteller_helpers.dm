
//Sets the storyteller to a new one, and does any heavy lifting for a handover
/proc/set_storyteller(var/datum/storyteller/newST, var/announce = TRUE)
	if (!newST)
		//You can call this without passing anything, we'll go fetch it ourselves
		newST = config.pick_storyteller(master_storyteller) //This function is in code/controllers/configuration.dm

	if (!istype(newST))
		//Welp that failed
		return

	if (get_storyteller() == newST)
		return //Nothing happens if we try to set to the storyteller we already have

	//If there's an existing storyteller, we'll make it do cleanup procedures before the handover
	//we cache it now so we can do that soon
	var/datum/storyteller/oldST = get_storyteller()

	//Finally, we set the new one
	storyteller = newST

	if (oldST != null)
		storyteller.points.Cut()
		storyteller.points.Add(oldST.points.Copy())//Transfer over points
		//TODO: Cleanup and handover

	//Configure the new storyteller
	storyteller.set_up()

	if (announce)
		storyteller.announce()


/proc/get_storyteller()
	return storyteller

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


