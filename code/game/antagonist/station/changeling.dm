/datum/antagonist/changeling
	id = ROLE_CHANGELING
	role_text = "Changeling"
	role_text_plural = "Changelings"
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list(JOBS_SECURITY, JOBS_COMMAND)
	welcome_text = "Use say \"#g message\" to communicate with your fellow changelings. Remember: you get all of their absorbed DNA if you absorb them."

	possible_objectives = list(
	/datum/objective/absorb,
	/datum/objective/assassinate = 100,
	/datum/objective/steal = 30,
	)

	survive_objective = /datum/objective/escape

/datum/antagonist/changeling/get_special_objective_text()
	if(owner && owner.changeling)
		return "<br><b>Changeling ID:</b> [owner.changeling.changelingID].<br><b>Genomes Absorbed:</b> [owner.changeling.absorbedcount]"

/datum/antagonist/changeling/special_init()
	owner.current.make_changeling()

/datum/antagonist/changeling/can_become_antag(var/datum/mind/player)
	if(..())
		if(player.current)
			if(ishuman(player.current))
				var/mob/living/carbon/human/H = player.current
				if(H.isSynthetic())
					return FALSE
				if(H.species.flags & NO_SCAN)
					return FALSE
				return TRUE
	return FALSE
