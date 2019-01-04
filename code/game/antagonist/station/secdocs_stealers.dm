/datum/antagonist/secdoc_scientist
	id = ROLE_SECDOC_DEFENDER
	role_text = "Scientist"
	role_text_plural = "Scientists"
	bantype = ROLE_BANTYPE_CREW_SIDED
	restricted_jobs = list("AI", "Robot")
	protected_jobs = list(JOBS_COMMAND)

	survive_objective = /datum/objective/escape

/datum/antagonist/secdoc_scientist/can_become_antag(var/datum/mind/M)
	if(..(M))
		var/datum/job/job = M.assigned_job
		if(job && job.department == "Science")
			return TRUE

	return FALSE
