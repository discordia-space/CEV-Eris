/datum/objective/borer_survive
	explanation_text = "Survive in a host until the end of the round."
	unique = TRUE

/datum/objective/borer_survive/check_completion()
	if(owner && owner.current)
		var/mob/living/simple_animal/borer/B = owner.current
		if(istype(B) && B.stat < DEAD && B.host && B.host.stat < DEAD)
			return TRUE
	return FALSE


/datum/objective/borer_reproduce
	explanation_text = "Reproduce at least once."

/datum/objective/borer_reproduce/check_completion()
	if (failed)
		return FALSE

	if(owner && owner.current)
		var/mob/living/simple_animal/borer/B = owner.current
		if(istype(B) && B.has_reproduced)
			return TRUE
	return FALSE
