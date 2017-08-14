/datum/antagonist/changeling
	id = ROLE_CHANGELING
	role_text = "Changeling"
	role_text_plural = "Changelings"
	bantype = "changeling"
	feedback_tag = "changeling_objective"
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Ironhammer Operative", "Ironhammer Gunnery Sergeant", "Ironhammer Inspector", "Ironhammer Commander", "Captain", "Ironhammer Medical Specialist")
	welcome_text = "Use say \"#g message\" to communicate with your fellow changelings. Remember: you get all of their absorbed DNA if you absorb them."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	antaghud_indicator = "hudchangeling"

	faction = "changeling"

/datum/antagonist/changeling/get_special_objective_text(var/datum/mind/player)
	return "<br><b>Changeling ID:</b> [player.changeling.changelingID].<br><b>Genomes Absorbed:</b> [player.changeling.absorbedcount]"

/datum/antagonist/changeling/update_antag_mob(var/datum/mind/player)
	..()
	player.current.make_changeling()

/datum/antagonist/changeling/create_objectives(var/datum/mind/changeling)
	if(!..())
		return

	//OBJECTIVES - Always absorb 5 genomes, plus random traitor objectives.
	//If they have two objectives as well as absorb, they must survive rather than escape
	//No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
	//If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone

	new /datum/objective/absorb (changeling, 2, 4)
	new /datum/objective/assassinate (changeling)
	new /datum/objective/steal (changeling)


	switch(rand(1,100))
		if(1 to 80)
			if (!(locate(/datum/objective/escape) in changeling.objectives))
				new /datum/objective/escape (changeling)
		else
			if (!(locate(/datum/objective/survive) in changeling.objectives))
				new /datum/objective/survive (changeling)
	return

/datum/antagonist/changeling/can_become_antag(var/datum/mind/player, var/ignore_role)
	if(..())
		if(player.current)
			if(ishuman(player.current))
				var/mob/living/carbon/human/H = player.current
				if(H.isSynthetic())
					return 0
				if(H.species.flags & NO_SCAN)
					return 0
				return 1
			else if(isnewplayer(player.current))
				if(player.current.client && player.current.client.prefs)
					var/datum/species/S = all_species[player.current.client.prefs.species]
					if(S && (S.flags & NO_SCAN))
						return 0
					if(player.current.client.prefs.organ_data["torso"] == "cyborg") // Full synthetic.
						return 0
					return 1
	return 0
