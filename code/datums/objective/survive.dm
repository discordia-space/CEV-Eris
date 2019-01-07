/datum/objective/survive
	explanation_text = "Stay alive until the end."

/datum/objective/survive/check_completion()
	if (failed)
		return FALSE
	if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
		return FALSE
	if(issilicon(owner.current) && owner.current != owner.original)
		return FALSE
	return TRUE


