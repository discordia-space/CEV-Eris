/datum/mind/var/list/individual_objetives = list()

/mob/living/carbon/human/proc/pick_individual_objective()
	if(!mind || (mind && player_is_antag(mind))) 
		return FALSE
	var/list/valid_objectives = list()
	for(var/datum/individual_objetive/IO in GLOB.individual_objetives)
		var/repeat = FALSE
		for(var/datum/individual_objetive/OLD in mind.individual_objetives)
			if(OLD.name == IO.name)
				repeat = TRUE
		if(repeat)
			continue
		if(IO.req_department && (!mind.assigned_job || IO.req_department != mind.assigned_job.department))
			continue
		valid_objectives += GLOB.individual_objetives[IO]
	if(!valid_objectives.len) return
	var/new_individual_objetive = pick(valid_objectives)
	var/datum/individual_objetive/IO = new new_individual_objetive()
	IO.assign(mind)

/datum/individual_objetive
	var/name = "individual"
	var/desc = "Placeholder Objective"
	var/datum/mind/owner
	var/completed = FALSE
	var/units_completed = 0
	var/units_requested = 1
	var/req_department
	var/req_cruciform
	var/insight_reward = 20
	var/completed_desc = " <span style='color:green'> Objective completed!</span>"

/datum/individual_objetive/proc/assign(datum/mind/new_owner)
	SHOULD_CALL_PARENT(TRUE)
	owner = new_owner
	owner.individual_objetives += src
	to_chat(owner,  SPAN_NOTICE("You now have the personal objective: [name]"))

/datum/individual_objetive/proc/completed(fail=FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!owner.current || !ishuman(owner.current) || completed)
		return
	completed = TRUE
	var/mob/living/carbon/human/H = owner.current
	H.sanity.insight += insight_reward
	to_chat(owner,  SPAN_NOTICE("You has completed the personal objective: [name]"))

/datum/individual_objetive/proc/get_description()
	var/n_desc = desc
	if(completed)
		n_desc += completed_desc
	return n_desc

/datum/individual_objetive/proc/task_completed(count=1)
	units_completed += count
	if(check_for_completion())
		completed()

/datum/individual_objetive/proc/check_for_completion()
	if(units_completed >= units_requested)
		return TRUE
	return FALSE
