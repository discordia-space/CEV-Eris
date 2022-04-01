/datum/antagonist/carrion
	id = ROLE_CARRION
	role_text = "Spiderman"
	role_text_plural = "Carrions"
	restricted_jobs = list("AI", "Robot")
	protected_jobs = list(JOBS_SECURITY, JOBS_COMMAND)
	bantype = ROLE_BANTYPE_CARRION
	welcome_text = "Spiderman, Spiderman, Does whatever a spider can Spins a web, any size, Catches thieves just like flies Look Out! Here comes the Spiderman."

	antaghud_indicator = "hudchangeling"


	survive_objective = null
	allow_neotheology = FALSE

	stat_modifiers = list(
		STAT_TGH = 5,
		STAT_VIG = 15,
		STAT_BIO = 20 //Good at surgery
	)

/datum/antagonist/carrion/special_init()
	owner.current.make_carrion()

/datum/antagonist/carrion/can_become_antag(datum/mind/player)
	if(..() && ishuman(player.current))
		var/mob/living/carbon/human/H = player.current
		if(H.isSynthetic())
			return FALSE
		if(H.species.flags & NO_SCAN)
			return FALSE
		return TRUE
	return FALSE

/datum/antagonist/carrion/equip()
	var/mob/living/L = owner.current

	for(var/name in stat_modifiers)
		L.stats.changeStat(name, stat_modifiers[name])
		
	spawn_uplink(L, 5)
