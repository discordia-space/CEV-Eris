/datum/mind/var/list/individual_objectives = list()

/mob/living/carbon/human/proc/pick_individual_objective()
	var/list/valid_objectives = list()
	for(var/npath in GLOB.individual_objectives)
		var/datum/individual_objective/IO = GLOB.individual_objectives[npath]
		if(!IO.can_assign(src))
			continue
		valid_objectives[npath] = IO.rarity
	for(var/datum/individual_objective/objective in mind.individual_objectives)
		valid_objectives -= objective.type
	if(!valid_objectives.len) return
	var/new_individual_objective = pickweight(valid_objectives)
	var/datum/individual_objective/IO = new new_individual_objective()
	IO.assign(mind)

/proc/player_is_limited_antag(datum/mind/player)
	if(player_is_antag(player))
		return FALSE
	for(var/datum/individual_objective/objective in player.individual_objectives)
		if(objective.limited_antag)
			return TRUE
	return FALSE

/datum/individual_objective
	var/name = "Individual"
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
	var/limited_antag = FALSE
	var/rarity = 1
	var/completed_desc = "<span style='color:green'>Objective completed!</span>"
	var/show_la = "<span style='color:red'>(LA)</span>"
	var/la_explanation  = "<b><B>Note:</B><span style='font-size: 75%'> limited antag (LA) objectives provide an ability to harm only your target, \
						or to push for faction on faction conflict, but do not allow you to kill everyone in the department to get inside for their \
						needs.</span></b>"

/datum/individual_objective/proc/assign(datum/mind/new_owner)
	SHOULD_CALL_PARENT(TRUE)
	owner = new_owner
	mind_holder = new_owner.current
	owner.individual_objectives += src
	to_chat(owner,  SPAN_NOTICE("You have obtained a new personal objective: [name]"))

/datum/individual_objective/proc/completed(fail=FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!owner.current || !ishuman(owner.current) || completed)
		return
	completed = TRUE
	var/mob/living/carbon/human/H = owner.current
	H.sanity.insight += insight_reward
	to_chat(owner,  SPAN_NOTICE("You has completed the personal objective: [name]"))

/datum/individual_objective/proc/get_description()
	var/n_desc = desc
	if(units_requested > 1 && !completed)
		var/units_desc = units_completed
		if(based_time)
			units_desc = "[round(unit2time(units_desc))] minutes"
		n_desc += " (<span style='color:green'>[units_desc]</span>)"
	if(completed)
		n_desc += " [completed_desc]"
	return n_desc

/datum/individual_objective/proc/unit2time(unit)
	var/time = unit/(1 MINUTES)
	return time


/datum/individual_objective/proc/task_completed(count=1)
	units_completed += count
	if(check_for_completion())
		completed()

/datum/individual_objective/proc/check_for_completion()
	if(units_completed >= units_requested)
		return TRUE
	return FALSE

/datum/individual_objective/proc/pick_faction_item(var/mob/living/carbon/human/H, ignore_departmen=FALSE)
	var/list/valid_targets = list()
	for(var/obj/item/faction_item in GLOB.all_faction_items)
		if(faction_item in valid_targets)
			continue
		if(!ignore_departmen && H.mind.assigned_job && (H.mind.assigned_job.department in GLOB.all_faction_items[faction_item]))
			continue
		if(!ignore_departmen && H && GLOB.all_faction_items[faction_item] == church_positions && H.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform))
			continue
		if(!locate(faction_item.type))
			continue
		valid_targets += faction_item
	if(valid_targets.len)
		return pick(valid_targets)
	return FALSE

/datum/individual_objective/proc/can_assign(mob/living/L)
	if(!isliving(L))
		return FALSE
	if(!L || !L.mind || (L.mind && player_is_antag(L.mind)))
		return FALSE
	var/obj/item/weapon/implant/core_implant/cruciform/C = L.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform)
	if(!C && req_cruciform)
		return FALSE
	if(C && !allow_cruciform)
		return FALSE
	if(req_department.len && (!L.mind.assigned_job || !(L.mind.assigned_job.department in req_department)))
		return FALSE
	return TRUE
