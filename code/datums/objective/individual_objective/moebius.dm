/datum/individual_objetive/big_brain
	name = "The Biggest Brain"
	req_department = DEPARTMENT_SCIENCE
	var/target_stat = STAT_COG
	var/target_val //initial_val+delta
	var/delta = 10

/datum/individual_objetive/big_brain/assign()
	..()
	target_val = owner.current.stats.getStat(STAT_COG) + delta
	desc = "Ensure that your COG stat will be increased to [target_val]."
	RegisterSignal(owner, COMSIG_STAT, .proc/task_completed)

/datum/individual_objetive/big_brain/task_completed(stat_name, stat_value)
	if(target_stat == stat_name && (stat_value >= target_val))
		completed()

/datum/individual_objetive/big_brain/completed()
	if(completed) return
	UnregisterSignal(owner, COMSIG_STAT)
	..()
