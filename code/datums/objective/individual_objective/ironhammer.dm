/datum/individual_objetive/familiar_face //TEST REQUIERED
	name = "A Familiar Face"
	req_department = DEPARTMENT_SECURITY
	var/mob/living/carbon/human/target

/datum/individual_objetive/familiar_face/assign()
	..()
	target = pick(GLOB.player_list)
	desc = "You swear you saw to [target] somewhere before, and in your line of job it cannot mean good. Search them, \
	remove their backpack or empty their pockets"
	RegisterSignal(owner, COMSIG_EMPTY_POCKETS, .proc/task_completed)

/datum/individual_objetive/familiar_face/task_completed(n_target)
	if(n_target == target)
		completed()

/datum/individual_objetive/familiar_face/completed()
	if(completed) return
	UnregisterSignal(owner, COMSIG_EMPTY_POCKETS)
	..()

/datum/individual_objetive/time_to_action //WORK
	name = "Time for Action"
	req_department = DEPARTMENT_SECURITY
	units_requested = 20

/datum/individual_objetive/time_to_action/assign()
	..()
	desc = "Murder or observer murdering of 20 mobs."
	RegisterSignal(owner, COMSIG_MOB_DEATH, .proc/task_completed)

/datum/individual_objetive/time_to_action/task_completed(mob/mob_death)
	..(1)

/datum/individual_objetive/time_to_action/completed()
	if(completed) return
	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	.=..()
