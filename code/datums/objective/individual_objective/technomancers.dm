/datum/individual_objetive/disturbance
	name = "Disturbance"
	req_department = ENGINEERING
	var/target_time = 1 MINUTES
	var/area/target_area

/datum/individual_objetive/disturbance/assign()
	..()
	var/list/candidates = ship_areas.Copy()
	for(var/area/A in candidates)
		if(A.is_maintenance)
			candidates -= A
			continue
		if(!A.apc)
			candidates -= A
			continue
	target_area = pick(candidates)
	desc = "Something in bluespace tries mess with ship systems. You need to go to [target_area] and power it down by APC \
	for [target_time/(1 MINUTES)] minutes"
	RegisterSignal(target_area, COMSIG_AREA_APC_UNOPERATING, .proc/task_completed)

/datum/individual_objetive/disturbance/task_completed(time)
	if(time >= target_time)
		completed()

/datum/individual_objetive/disturbance/completed()
	if(completed) return
	UnregisterSignal(target_area, COMSIG_AREA_APC_UNOPERATING)
	..()
