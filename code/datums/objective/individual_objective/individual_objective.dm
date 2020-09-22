/datum/mind/var/list/individual_objetives = list()

/mob/living/carbon/human/proc/pick_individual_objective()
	if(!mind || (mind && player_is_antag(mind)))
		return FALSE
	var/list/valid_objectives = list()
	for(var/datum/individual_objetive/IO in GLOB.individual_objetives)
		var/obj/item/weapon/implant/core_implant/cruciform/C = get_core_implant(/obj/item/weapon/implant/core_implant/cruciform)
		if(!C && IO.req_cruciform)
			continue
		if(C && !IO.allow_cruciform)
			continue
		if(IO.req_department.len && (!mind.assigned_job || !(mind.assigned_job.department in IO.req_department)))
			continue
		valid_objectives += GLOB.individual_objetives[IO]
	for(var/datum/individual_objetive/objective in mind.individual_objetives)
		valid_objectives -= objective.type
	if(!valid_objectives.len) return
	var/new_individual_objetive = pick(valid_objectives)
	var/datum/individual_objetive/IO = new new_individual_objetive()
	IO.assign(mind)

/proc/player_is_limited_antag(datum/mind/player)
	if(player_is_antag(player))
		return FALSE
	for(var/datum/individual_objetive/objetive in player.individual_objetives)
		if(objetive.limited_antag)
			return TRUE
	return FALSE

/datum/individual_objetive
	var/name = "individual"
	var/desc = "Placeholder Objective"
	var/datum/mind/owner
	var/mob/living/carbon/human/mind_holder
	var/completed = FALSE
	var/allow_cruciform = TRUE
	var/units_completed = 0
	var/units_requested = 1
	var/based_time = FALSE
	var/list/req_department = list()
	var/req_cruciform = FALSE
	var/insight_reward = 25
	var/completed_desc = "<span style='color:green'> Objective completed!</span>"
	var/limited_antag = FALSE
	var/show_la = "<span style='color:red'> (LA)</span>"
	var/la_explanation  = "<b><B>Note:</B><span style='font-size: 75%'> limited antag (LA) objectives provide an ability to harm only your target, \
						or to push for faction on faction conflict, but do not allow you to kill everyone in the department to get inside for their \
						needs.</span></b>"

/datum/individual_objetive/proc/assign(datum/mind/new_owner)
	SHOULD_CALL_PARENT(TRUE)
	owner = new_owner
	mind_holder = new_owner.current
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
	if(units_requested > 1)
		var/units_desc = units_completed
		if(based_time)
			units_desc = "[round(unit2time(units_desc))] minutes"
		n_desc += " (<span style='color:green'>[units_desc]</span>)"
	if(completed)
		n_desc += " [completed_desc]"
	return n_desc

/datum/individual_objetive/proc/unit2time(unit)
	var/time = unit/(1 MINUTES)
	return time


/datum/individual_objetive/proc/task_completed(count=1)
	units_completed += count
	if(check_for_completion())
		completed()

/datum/individual_objetive/proc/check_for_completion()
	if(units_completed >= units_requested)
		return TRUE
	return FALSE
