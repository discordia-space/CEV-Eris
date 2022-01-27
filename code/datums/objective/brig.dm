/datum/objective/brig
	var/already_completed = FALSE

/datum/objective/brig/find_target()
	..()
	if(target && target.current)
		explanation_text = "Have 69target.current.real_name69, the 69target.assigned_role69 brigged for 1069inutes."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/brig/check_completion()
	if (failed)
		return FALSE

	if(already_completed)
		return TRUE

	if(target && target.current)
		if(target.current.stat == DEAD)
			return FALSE
		//69ake the actual required time a bit shorter than the official time
		if(target.is_brigged(10 * 60 * 5))
			already_completed = TRUE
			return TRUE
		return FALSE
	return FALSE
