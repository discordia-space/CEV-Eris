// Inherits most of its vars from the base datum.
/datum/antagonist/traitor
	id = ROLE_TRAITOR
	weight = 10
	protected_jobs = list("Ironhammer Operative", "Ironhammer Gunnery Sergeant", "Ironhammer Inspector", "Ironhammer Commander", "Captain", "Ironhammer Medical Specialist")

/datum/antagonist/traitor/get_extra_panel_options()
	if(owner.current)
		return "<a href='?src=\ref[owner];common=crystals'>\[set crystals\]</a><a href='?src=\ref[src];spawn_uplink=\ref[owner.current]'>\[spawn uplink\]</a>"

/datum/antagonist/traitor/Topic(href, href_list)
	if (..())
		return
	if(href_list["spawn_uplink"]) spawn_uplink(locate(href_list["spawn_uplink"]))

/datum/antagonist/traitor/create_objectives()
	if(!..())
		return

	if(issilicon(owner.current))
		new /datum/objective/assassinate (src)
		new /datum/objective/survive (src)

		if(prob(10))
			new /datum/objective/block (src)
	else
		switch(rand(1,100))
			if(1 to 33)
				new /datum/objective/assassinate (src)
			if(34 to 50)
				new /datum/objective/brig (src)
			if(51 to 66)
				new /datum/objective/harm (src)
			else
				new /datum/objective/steal (src)
		if (!(locate(/datum/objective/escape) in objectives))
			new /datum/objective/escape (src)
	return

/datum/antagonist/traitor/equip()
	if(!owner.current)
		return FALSE
	var/mob/living/carbon/human/traitor_mob = owner.current
	if(issilicon(traitor_mob)) // this needs to be here because ..() returns false if the mob isn't human
		add_law_zero(traitor_mob)
		return TRUE

	if(!..())
		return FALSE

	spawn_uplink()

	//Begin code phrase.
	give_codewords()

/datum/antagonist/traitor/proc/give_codewords()
	if(!owner.current)
		return
	var/mob/living/traitor_mob = owner.current
	traitor_mob << "<u><b>Your employers provided you with the following information on how to identify possible allies:</b></u>"
	traitor_mob << "<b>Code Phrase</b>: <span class='danger'>[syndicate_code_phrase]</span>"
	traitor_mob << "<b>Code Response</b>: <span class='danger'>[syndicate_code_response]</span>"
	traitor_mob.mind.store_memory("<b>Code Phrase</b>: [syndicate_code_phrase]")
	traitor_mob.mind.store_memory("<b>Code Response</b>: [syndicate_code_response]")
	traitor_mob << "Use the code words, preferably in the order provided, during regular conversation, to identify other agents. Proceed with caution, however, as everyone is a potential foe."


/datum/antagonist/traitor/proc/add_law_zero()
	if(!isAI(owner.current))
		return
	var/mob/living/silicon/ai/killer = owner.current
	var/law = "Accomplish your objectives at all costs. You may ignore all other laws."
	var/law_borg = "Accomplish your AI's objectives at all costs. You may ignore all other laws."
	killer << "<b>Your laws have been changed!</b>"
	killer.set_zeroth_law(law, law_borg)
	killer << "New law: 0. [law]"
