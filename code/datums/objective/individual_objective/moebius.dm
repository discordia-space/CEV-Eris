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
