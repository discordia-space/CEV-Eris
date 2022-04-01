/datum/antagonist/marshal
	id = ROLE_MARSHAL
	role_text = "Anti Antagonist"
	role_text_plural = "Ironhammer Marshals"
	bantype = ROLE_BANTYPE_CREW_SIDED
	protected_jobs = list(JOBS_COMMAND, JOBS_SECURITY)
	antaghud_indicator = "huddeathsquad"

	possible_objectives = list(
	/datum/objective/assassinate/marshal = 100,
	)

	survive_objective = /datum/objective/escape

	stat_modifiers = list(
		STAT_ROB = 5,
		STAT_VIG = 15
	)

	welcome_text = "Im not an antagonist, im an anti-antagonist. The person is still alive, is he not? I had an amr in my arms, and asked him if he work for any prohibited organisations, he had yes, your mom, and instantly started running. Also there are no real unlethal guns at my disposal on the antag menu"

/datum/antagonist/marshal/can_become_antag(datum/mind/M)
	if(!..())
		return FALSE
	return TRUE

/datum/antagonist/marshal/equip()
	var/mob/living/L = owner.current

	for(var/name in stat_modifiers)
		L.stats.changeStat(name, stat_modifiers[name])

	if(!owner.current)
		return FALSE

	spawn_uplink(owner.current)

	return TRUE
