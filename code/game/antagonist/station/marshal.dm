/datum/antagonist/marshal
	id = ROLE_MARSHAL
	role_text = "Ironhammer Marshal"
	role_text_plural = "Ironhammer Marshals"
	role_type = "Traitor"
	protected_jobs = list(JOBS_COMMAND, JOBS_SECURITY)

	possible_objectives = list(
	/datum/objective/assassinate/marshal = 100,
	/datum/objective/assassinate/marshal = 15,
	)

	survive_objective = /datum/objective/escape

/datum/antagonist/marshal/can_become_antag(var/datum/mind/M)
	if(!..())
		return FALSE
	return TRUE

/datum/antagonist/marshal/equip()
	if(!owner.current)
		return FALSE

	spawn_uplink()

	return TRUE
