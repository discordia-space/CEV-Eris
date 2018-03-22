/datum/antagonist/revolutionary
	id = ROLE_REVOLUTIONARY
	role_text = "Infiltrator"
	role_text_plural = "Infiltrators"
	role_type = "Excelsior Infiltrator"
	welcome_text = "Viva la revolution!"
	protected_jobs = JOBS_COMMAND + JOBS_SECURITY

	survive_objective = null

/datum/antagonist/revolutionary/can_become_antag(var/datum/mind/M)
	if(!..() || !wearer.get_complant())
		return FALSE
	return TRUE


/datum/faction/excelsior
	id = FACTION_EXCELSIOR
	name = "Excelsior"
	antag = "infiltrator"
	antag_plural = "infiltrators"
	welcome_text = ""

	possible_antags = list(ROLE_REVOLUTIONARY)
