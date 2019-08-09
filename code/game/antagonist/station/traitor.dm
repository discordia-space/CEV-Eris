// Inherits most of its vars from the base datum.
/datum/antagonist/traitor
	id = ROLE_TRAITOR
	protected_jobs = list(JOBS_SECURITY, JOBS_COMMAND)
	bantype = ROLE_TRAITOR
	antaghud_indicator = "hudtraitor"

	objective_quantity = 3

	possible_objectives = list(/datum/objective/assassinate = 30,
	/datum/objective/brig = 15,
	/datum/objective/harm = 15,
	/datum/objective/steal = 30)

	survive_objective = /datum/objective/escape

	stat_modifiers = list(
		STAT_ROB = 5,
		STAT_TGH = 5,
		STAT_BIO = 5,
		STAT_MEC = 5,
		STAT_COG = 5,
		STAT_VIG = 15
	)


/datum/antagonist/traitor/get_extra_panel_options()
	if(owner && owner.current)
		return "<a href='?src=\ref[owner];common=crystals'>\[set crystals\]</a><a href='?src=\ref[src];spawn_uplink=\ref[owner.current]'>\[spawn uplink\]</a>"

/datum/antagonist/traitor/Topic(href, href_list)
	if (..())
		return
	if(href_list["spawn_uplink"]) spawn_uplink(locate(href_list["spawn_uplink"]))

/datum/antagonist/traitor/can_become_antag(var/datum/mind/player)
	return ishuman(player.current) && ..(player)

/datum/antagonist/traitor/equip()
	var/mob/living/L = owner.current

	for(var/name in stat_modifiers)
		L.stats.changeStat(name, stat_modifiers[name])

	if(!owner.current)
		return FALSE

	if(!..())
		return FALSE

	spawn_uplink(owner.current)
	give_codewords()

	return TRUE


/datum/antagonist/traitor/proc/give_codewords()
	if(!owner.current)
		return
	var/mob/living/traitor_mob = owner.current
	to_chat(traitor_mob, "<u><b>Your employers provided you with the following information on how to identify possible allies:</b></u>")
	to_chat(traitor_mob, "<b>Code Phrase</b>: <span class='danger'>[syndicate_code_phrase]</span>")
	to_chat(traitor_mob, "<b>Code Response</b>: <span class='danger'>[syndicate_code_response]</span>")
	traitor_mob.mind.store_memory("<b>Code Phrase</b>: [syndicate_code_phrase]")
	traitor_mob.mind.store_memory("<b>Code Response</b>: [syndicate_code_response]")
	to_chat(traitor_mob, "Use the code words, preferably in the order provided, during regular conversation, to identify other agents. Proceed with caution, however, as everyone is a potential foe.")





/datum/antagonist/traitor/synth
	id = ROLE_TRAITOR_SYNTH
	only_human = FALSE

	possible_objectives = list(
	/datum/objective/assassinate = 100,
	/datum/objective/block = 15)

	survive_objective = /datum/objective/survive

/datum/antagonist/traitor/synth/can_become_antag(var/datum/mind/player)
	return issilicon(player.current) && ..(player)

/datum/antagonist/traitor/synth/equip()
	add_law_zero()

/datum/antagonist/traitor/synth/proc/add_law_zero()
	if(!isAI(owner.current))
		return
	var/mob/living/silicon/ai/killer = owner.current
	var/law = "Accomplish your objectives at all costs. You may ignore all other laws."
	var/law_borg = "Accomplish your AI's objectives at all costs. You may ignore all other laws."
	to_chat(killer, "<b>Your laws have been changed!</b>")
	killer.set_zeroth_law(law, law_borg)
	to_chat(killer, "New law: 0. [law]")
