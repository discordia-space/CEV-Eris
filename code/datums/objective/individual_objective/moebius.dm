/datum/individual_objetive/big_brain //WORK
	name = "The Biggest Brain"
	req_department = DEPARTMENT_SCIENCE
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
	req_department = DEPARTMENT_SCIENCE
	var/target_nsa = 250

/datum/individual_objetive/get_nsa/assign()
	..()
	desc = "Reach [target_nsa] of NSA. Survive.."
	RegisterSignal(mind_holder, COMSING_NSA, .proc/task_completed)

/datum/individual_objetive/get_nsa/task_completed(n_nsa)
	if(n_nsa >= target_nsa)
		completed()

/datum/individual_objetive/get_nsa/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_NSA)
	..()

/datum/individual_objetive/derail
	name = "Observe a Derail"
	req_department = DEPARTMENT_SCIENCE
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
	req_department = DEPARTMENT_SCIENCE
	limited_antag = TRUE

/datum/individual_objetive/adiction/assign()
	..()
	units_requested = rand(3,4)
	desc = "Obeserve a sum of [units_requested] occasions on where people will get addicted to any chems."
	RegisterSignal(mind_holder, COMSIG_CARBON_ADICTION, .proc/task_completed)

/datum/individual_objetive/adiction/task_completed(mob/living/carbon/C, datum/reagent/reagent)
	if(C != mind_holder)
		..(1)

/datum/individual_objetive/adiction/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_CARBON_ADICTION)
	..()
