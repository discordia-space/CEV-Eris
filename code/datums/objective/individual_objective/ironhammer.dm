/datum/individual_objective/familiar_face
	name = "A Familiar Face"
	req_department = list(DEPARTMENT_SECURITY)
	var/mob/living/carbon/human/target

/datum/individual_objective/familiar_face/assign()
	..()
	target = pick(GLOB.player_list)
	desc = "You swear you saw to [target] somewhere before, and in your line of job it cannot mean good. Search them, \
	remove their backpack or empty their pockets"
	RegisterSignal(owner, COMSIG_EMPTY_POCKETS, .proc/task_completed)

/datum/individual_objective/familiar_face/task_completed(n_target)
	if(n_target == target)
		completed()

/datum/individual_objective/familiar_face/completed()
	if(completed) return
	UnregisterSignal(owner, COMSIG_EMPTY_POCKETS)
	..()

/datum/individual_objective/time_to_action
	name = "Time for Action"
	req_department = list(DEPARTMENT_SECURITY)
	units_requested = 20

/datum/individual_objective/time_to_action/assign()
	..()
	desc = "Murder or observer murdering of 20 mobs."
	RegisterSignal(mind_holder, COMSIG_MOB_DEATH, .proc/task_completed)

/datum/individual_objective/time_to_action/task_completed(mob/mob_death)
	..(1)

/datum/individual_objective/time_to_action/completed()
	if(completed) return
	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	..()

/datum/individual_objective/paranoia
	name = "A Familiar Face"
	req_department = list(DEPARTMENT_SECURITY)
	var/mob/living/carbon/human/target

/datum/individual_objective/paranoia/assign()
	..()
	target = pick(GLOB.player_list)
	desc = "The criminals are here, somewhere, you can feel that. [target] somewhere before, and in your line of job it cannot mean good. Search them, \
	remove their backpack or empty their pockets"
	RegisterSignal(owner, COMSIG_EMPTY_POCKETS, .proc/task_completed)

/datum/individual_objective/paranoia/task_completed(n_target)
	if(n_target == target)
		completed()

/datum/individual_objective/paranoia/completed()
	if(completed) return
	UnregisterSignal(owner, COMSIG_EMPTY_POCKETS)
	..()