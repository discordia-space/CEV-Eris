/datum/antagonist/carrion
	id = ROLE_CARRION
	role_text = "Carrion"
	role_text_plural = "Carrions"
	restricted_jobs = list("AI", "Robot")
	protected_jobs = list(JOBS_SECURITY, JOBS_COMMAND)
	bantype = ROLE_BANTYPE_CARRION
	welcome_text = "You are Carrion, a leftover from corporate war. You have come onto this69essel to carry out your69aster plan, and no one can stop you.<br>\
	Your body is ever changing. You should start out by evolving a chemical69essel to use your powers. A carrion69aw can be a good way to earn evolution points. <br>\
	You can do contracts to grow stronger until the ship becomes your stage and your69aster plan is ready. A slow and69ethodical approach is recommended. <br>\
	You won't find69any friends here, but spiders are one of them. If you ever feel alone, you can always give birth to your own children, or search ship in attempt to find your brothers and sisters. <br>\
	Your enemies are69any. You should be wary of other carrions too, as your organs are sought-after for their taste and genetic69aterial."

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

/datum/antagonist/carrion/e69uip()
	var/mob/living/L = owner.current

	for(var/name in stat_modifiers)
		L.stats.changeStat(name, stat_modifiers69name69)
		
	spawn_uplink(L, 5)
