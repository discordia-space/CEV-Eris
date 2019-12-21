/datum/antagonist/changeling
	id = ROLE_CHANGELING
	role_text = "Changeling"
	role_text_plural = "Changelings"
	restricted_jobs = list("AI", "Robot")
	protected_jobs = list(JOBS_SECURITY, JOBS_COMMAND)
	bantype = ROLE_BANTYPE_CHANGELING
	welcome_text = "Use say \"#g message\" to communicate with your fellow changelings. Remember: you get all of their absorbed DNA if you absorb them."
	antaghud_indicator = "hudchangeling"

	possible_objectives = list(
	/datum/objective/absorb = 60,
	/datum/objective/assassinate = 60,
	/datum/objective/steal = 30,
	)

	survive_objective = /datum/objective/escape
	allow_neotheology = FALSE

	stat_modifiers = list(
		STAT_TGH = 5,
		STAT_VIG = 15
	)

/datum/antagonist/changeling/get_special_objective_text()
	if(owner && owner.changeling)
		return "<br><b>Changeling ID:</b> [owner.changeling.changelingID].<br><b>Genomes Absorbed:</b> [owner.changeling.absorbedcount]"

/datum/antagonist/changeling/special_init()
	owner.current.make_changeling()

/datum/antagonist/changeling/can_become_antag(datum/mind/player)
	if(..() && ishuman(player.current))
		var/mob/living/carbon/human/H = player.current
		if(H.isSynthetic())
			return FALSE
		if(H.species.flags & NO_SCAN)
			return FALSE
		return TRUE
	return FALSE

/datum/antagonist/changeling/equip()
	var/mob/living/L = owner.current

	for(var/name in stat_modifiers)
		L.stats.changeStat(name, stat_modifiers[name])
		
	setup_uplink_source(L, 5)
