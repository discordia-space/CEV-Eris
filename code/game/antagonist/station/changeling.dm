/datum/antagonist/changeling
	id = ROLE_CHANGELING
	role_text = "Changeling"
	role_text_plural = "Changelings"
	bantype = "changeling"
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Ironhammer Operative", "Ironhammer Gunnery Sergeant", "Ironhammer Inspector", "Ironhammer Commander", "Captain", "Ironhammer Medical Specialist")
	welcome_text = "Use say \"#g message\" to communicate with your fellow changelings. Remember: you get all of their absorbed DNA if you absorb them."

	faction = "changeling"

/datum/antagonist/changeling/get_special_objective_text()
	if(owner)
		return "<br><b>Changeling ID:</b> [owner.changeling.changelingID].<br><b>Genomes Absorbed:</b> [owner.changeling.absorbedcount]"

/datum/antagonist/changeling/create_antagonist(var/datum/mind/player, var/datum/faction/faction)
	..()
	player.current.make_changeling()

/datum/antagonist/changeling/create_objectives()
	if(!..())
		return

	//OBJECTIVES - Always absorb 5 genomes, plus random traitor objectives.
	//If they have two objectives as well as absorb, they must survive rather than escape
	//No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
	//If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone

	new /datum/objective/absorb (src, 2, 4)
	new /datum/objective/assassinate (src)
	new /datum/objective/steal (src)


	switch(rand(1,100))
		if(1 to 80)
			if (!(locate(/datum/objective/escape) in objectives))
				new /datum/objective/escape (src)
		else
			if (!(locate(/datum/objective/survive) in objectives))
				new /datum/objective/survive (src)
	return

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
