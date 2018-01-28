/datum/antagonist/secdoc_hunter
	id = ROLE_SECDOC_HUNTER
	role_text = "Traitor"
	role_text_plural = "Traitor"
	bantype = "Syndicate"
	role_type = ROLE_TRAITOR
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Ironhammer Operative", "Ironhammer Gunnery Sergeant", "Ironhammer Inspector", "Ironhammer Commander", "Captain", "Ironhammer Medical Specialist")

	survive_objective = /datum/objective/escape

/datum/antagonist/secoc/hunter/equip()
	if(!owner.current)
		return FALSE

	if(!..())
		return FALSE

	spawn_uplink()

	return TRUE

/datum/antagonist/secdoc_scientist
	id = ROLE_SECDOC_DEFENDER
	role_text = "Scientist"
	role_text_plural = "Scientists"
	bantype = "Crew-sided"
	role_type = "crew-sided"
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Ironhammer Operative", "Ironhammer Gunnery Sergeant", "Ironhammer Inspector", "Ironhammer Commander", "Captain", "Ironhammer Medical Specialist")

	survive_objective = /datum/objective/escape

/datum/antagonist/secdoc_scientist/can_become_antag(var/datum/mind/M)
	if(..(M))
		var/datum/job/job = M.assigned_job
		if(job && job.department == "Science")
			return TRUE

	return FALSE
