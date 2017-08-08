var/global/list/all_objectives = list()

/datum/objective
	var/datum/mind/owner = null			//Who owns the objective.
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = FALSE				//currently only used for custom objectives.

/datum/objective/New(var/new_owner)
	owner = new_owner
	find_target()
	all_objectives.Add(src)
	..()

/datum/objective/Destroy()
	all_objectives.Remove(src)
	..()

/datum/objective/proc/check_completion()
	return completed

/datum/objective/proc/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in ticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2))
			possible_targets.Add(possible_target)
	if(possible_targets.len > 0)
		target = pick(possible_targets)


















