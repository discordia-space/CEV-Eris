/datum/individual_objetive/big_brain
	name = "The Biggest Brain"
	req_department = list(DEPARTMENT_SCIENCE, DEPARTMENT_MEDICAL)
	var/target_stat = STAT_COG
	var/target_val //initial_val+delta
	var/delta = 10

/datum/individual_objetive/big_brain/assign()
	..()
	target_val = mind_holder.stats.getStat(STAT_COG) + delta
	desc = "Ensure that your COG stat will be increased to [target_val]."
	RegisterSignal(mind_holder, COMSIG_STAT, .proc/task_completed)

/datum/individual_objetive/big_brain/task_completed(stat_name, stat_value, stat_value_pure)
	if(target_stat == stat_name && (stat_value >= target_val))
		completed()

/datum/individual_objetive/big_brain/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_STAT)
	..()

/datum/individual_objetive/get_nsa
	name = "Blow the Lid"
	req_department = list(DEPARTMENT_SCIENCE, DEPARTMENT_MEDICAL)
	units_requested = 250

/datum/individual_objetive/get_nsa/assign()
	..()
	desc = "Reach [units_requested] of NSA. Survive.."
	RegisterSignal(mind_holder, COMSING_NSA, .proc/task_completed)

/datum/individual_objetive/get_nsa/task_completed(n_nsa)
	units_completed = n_nsa
	if(check_for_completion())
		completed()

/datum/individual_objetive/get_nsa/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_NSA)
	..()

/datum/individual_objetive/derail
	name = "Observe a Derail"
	req_department = list(DEPARTMENT_SCIENCE, DEPARTMENT_MEDICAL)
	limited_antag = TRUE

/datum/individual_objetive/derail/assign()
	..()
	units_requested = rand(3,4)
	desc = "Obeserve a sum of [units_requested] mental breakdowns of you, orother non people."
	RegisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN, .proc/task_completed)

/datum/individual_objetive/derail/task_completed(mob/living/L, datum/breakdown/breakdown)
	..(1)

/datum/individual_objetive/derail/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN)
	..()

/datum/individual_objetive/adiction
	name = "On The Hook"
	req_department = list(DEPARTMENT_SCIENCE, DEPARTMENT_MEDICAL)
	limited_antag = TRUE

/datum/individual_objetive/adiction/assign()
	..()
	units_requested = rand(3,4)
	desc = "Obeserve a sum of [units_requested] occasions on where people will get addicted to any chems."
	RegisterSignal(mind_holder, COMSIG_CARBON_ADICTION, .proc/task_completed)

/datum/individual_objetive/adiction/task_completed(mob/living/carbon/C, datum/reagent/reagent)
	//if(C != mind_holder)//uncoment it
	..(1)//tab

/datum/individual_objetive/adiction/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_CARBON_ADICTION)
	..()

/datum/individual_objetive/autopsy
	name = "Death is the Answer"
	req_department = list(DEPARTMENT_SCIENCE, DEPARTMENT_MEDICAL)
	var/list/cadavers = list()

/datum/individual_objetive/autopsy/assign()
	..()
	units_requested = rand(2,3)
	desc = "Perform [units_requested] autopsies."
	RegisterSignal(mind_holder, COMSING_AUTOPSY, .proc/task_completed)

/datum/individual_objetive/autopsy/task_completed(mob/living/carbon/human/H) 
	//if(H in cadavers) uncoment
	//	return
	cadavers += H
	..(1)

/datum/individual_objetive/autopsy/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_AUTOPSY)
	..()


/datum/individual_objetive/more_research
	name = "Mandate of Science"
	req_department = list(DEPARTMENT_SCIENCE, DEPARTMENT_MEDICAL)
	limited_antag = TRUE
	var/obj/item/target

/datum/individual_objetive/more_research/assign()
	..()
	var/list/valid_targets = list()
	for(var/obj/item/faction_item in GLOB.all_faction_items)
		if(faction_item in valid_targets)
			continue
		if(owner.assigned_job in GLOB.all_faction_items[faction_item])
			continue
		valid_targets += faction_item
	target = pick_faction_item(mind_holder)
	desc = "[target] is wasted in their hands. Put it into a destructive analyzer."
	RegisterSignal(mind_holder, COMSING_DESTRUCTIVE_ANALIZER, .proc/task_completed)

/datum/individual_objetive/more_research/task_completed(var/obj/item/I) 
	if(target.type == I.type)
		..(1)

/datum/individual_objetive/more_research/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_DESTRUCTIVE_ANALIZER)
	..()
