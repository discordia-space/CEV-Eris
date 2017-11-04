/datum/antagonist/marshal
	id = ROLE_MARSHAL
	role_text = "Ironhammer Marshal"
	role_text_plural = "Ironhammer Marshals"
	bantype = "marshal"
	welcome_text = "Here should be the marshal welcome text."
	weight = 9
	protected_jobs = list(JOBS_COMMAND,JOBS_SECURITY)


/datum/antagonist/marshal/create_objectives()
	if(!..())
		return

	new /datum/objective/assassinate/marshal (src)

	if(prob(15))
		new /datum/objective/assassinate/marshal (src)

	new /datum/objective/escape (src)

/datum/antagonist/marshal/can_become_antag(var/datum/mind/M)
	if(!..())
		return FALSE
	return TRUE

/datum/antagonist/marshal/equip()
	if(!owner.current)
		return FALSE

	spawn_uplink()

	return TRUE
