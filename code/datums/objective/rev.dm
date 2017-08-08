/datum/objective/rev

/datum/objective/rev/find_target()
	..()
	if(target && target.current)
		explanation_text = "Assassinate, capture or convert [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/rev/check_completion()
	if(target && target.current)
		var/mob/living/carbon/human/H = target.current
		if(!istype(H))
			return TRUE
		if(H.stat == DEAD || H.restrained())
			return TRUE
		// Check if they're converted
		if(target in revs.current_antagonists)
			return TRUE
	return FALSE
