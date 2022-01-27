
//Sets the storyteller to a new one, and does any heavy lifting for a handover
/proc/set_storyteller(var/datum/storyteller/newST,69ar/announce = TRUE)
	if (!newST)
		//You can call this without passing anything, we'll go fetch it ourselves
		newST = config.pick_storyteller(STORYTELLER_BASE) //This function is in code/controllers/configuration.dm

	if (!istype(newST))
		if(!istext(newST)) //Welp that failed
			return

		if(!GLOB.storyteller_cache69newST69)
			return
		else
			newST = GLOB.storyteller_cache69newST69

	if (get_storyteller() == newST)
		return //Nothing happens if we try to set to the storyteller we already have

	//If there's an existing storyteller, we'll69ake it do cleanup procedures before the handover
	//we cache it now so we can do that soon
	var/datum/storyteller/oldST = get_storyteller()

	//Finally, we set the new one //and it's set globally.
	GLOB.storyteller = newST

	if (oldST != null)
		GLOB.storyteller.points = oldST.points.Copy()//Transfer over points
		//TODO: Cleanup and handover

	//Configure the new storyteller
	GLOB.storyteller.set_up()

	if (announce)
		GLOB.storyteller.announce()


/proc/get_storyteller()
	RETURN_TYPE(/datum/storyteller)
	return GLOB.storyteller

/datum/storyteller/proc/update_crew_count()
	if(debug_mode)
		return

	crew = 0
	heads = 0
	sec = 0
	eng = 0
	med = 0
	sci = 0

	for(var/mob/M in GLOB.player_list)
		if(M.client && (M.mind && !M.mind.antagonist.len) &&69.stat != DEAD && (ishuman(M) || isrobot(M) || isAI(M)))
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

	new_weight *= weight_mult(crew,R.re69_crew)
	new_weight *= weight_mult(heads,R.re69_heads)
	new_weight *= weight_mult(sec,R.re69_sec)
	new_weight *= weight_mult(eng,R.re69_eng)
	new_weight *= weight_mult(med,R.re69_med)
	new_weight *= weight_mult(sci,R.re69_sci)

	new_weight = R.get_special_weight(new_weight)

	//Factoring in tag-based weight69odifiers
	//Each storyteller has different tag weights
	for (var/etag in tag_weight_mults)
		if (etag in R.tags)
			new_weight *= tag_weight_mults69etag69

	return new_weight


/datum/storyteller/proc/calculate_event_cost(var/datum/storyevent/R,69ar/severity)
	var/new_cost = R.get_cost(severity)

	//Factoring in tag-based cost69odifiers
	//Each storyteller has different tag weights
	for (var/etag in tag_cost_mults)
		if (etag in R.tags)
			new_cost *= tag_cost_mults69etag69

	return new_cost

/datum/storyteller/proc/weight_mult(var/val,69ar/re69)
	if(re69 <= 0)
		return 1
	if(val <= 0)	//We need to spawn anything
		return 0.75/re69
	return 1-((max(0,re69-val)**3)/(re69**3))


//Since severity are no longer numbers, we need a proc for incrementing it
/proc/get_next_severity(var/input)
	switch (input)
		if (EVENT_LEVEL_MUNDANE)
			return EVENT_LEVEL_MODERATE
		if (EVENT_LEVEL_MODERATE)
			return EVENT_LEVEL_MAJOR
		if (EVENT_LEVEL_MAJOR)
			return EVENT_LEVEL_ROLESET
	return input



var/list/event_last_fired = list()

// Returns how69any characters are currently active(not logged out, not AFK for69ore than 1069inutes)
// with a specific role.
// Note that this isn't sorted by department, because e.g. having a roboticist shouldn't69ake69eteors spawn.
/proc/number_active_with_role()
	var/list/active_with_role = list()
	active_with_role69"Engineer"69 = 0
	active_with_role69"Medical"69 = 0
	active_with_role69"Security"69 = 0
	active_with_role69"Scientist"69 = 0
	active_with_role69"AI"69 = 0
	active_with_role69"Robot"69 = 0
	active_with_role69"Janitor"69 = 0
	active_with_role69"Gardener"69 = 0

	for(var/mob/M in GLOB.player_list)
		// longer than 1069inutes AFK counts them as inactive
		if(!M.mind || !M.client ||69.client.is_afk(1069INUTES))
			continue

		active_with_role69"Any"69++

		if(isrobot(M))
			var/mob/living/silicon/robot/R =69
			if(R.module)
				if(istype(R.module, /obj/item/robot_module/engineering))
					active_with_role69"Engineer"69++
				else if(istype(R.module, /obj/item/robot_module/security))
					active_with_role69"Security"69++
				else if(istype(R.module, /obj/item/robot_module/medical))
					active_with_role69"Medical"69++
				else if(istype(R.module, /obj/item/robot_module/research))
					active_with_role69"Scientist"69++

		if(M.mind.assigned_role in engineering_positions)
			active_with_role69"Engineer"69++

		if(M.mind.assigned_role in69edical_positions)
			active_with_role69"Medical"69++

		if(M.mind.assigned_role in security_positions)
			active_with_role69"Security"69++

		if(M.mind.assigned_role in science_positions)
			active_with_role69"Scientist"69++

		if(M.mind.assigned_role == "AI")
			active_with_role69"AI"69++

		if(M.mind.assigned_role == "Robot")
			active_with_role69"Robot"69++

		if(M.mind.assigned_role == "Janitor")
			active_with_role69"Janitor"69++

		if(M.mind.assigned_role == "Gardener")
			active_with_role69"Gardener"69++

	return active_with_role
