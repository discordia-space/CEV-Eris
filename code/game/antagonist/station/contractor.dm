// Inherits most of its vars from the base datum.
/datum/antagonist/contractor
	id = ROLE_CONTRACTOR
	protected_jobs = list(JOBS_SECURITY, JOBS_COMMAND)
	bantype = ROLE_CONTRACTOR
	antaghud_indicator = "hudcontractor"

	survive_objective = null

	stat_modifiers = list(
		STAT_ROB = 5,
		STAT_TGH = 5,
		STAT_BIO = 5,
		STAT_MEC = 5,
		STAT_COG = 5,
		STAT_VIG = 15
	)


/datum/antagonist/contractor/get_extra_panel_options()
	if(owner && owner.current)
		return "<a href='?src=\ref[owner];common=crystals'>\[set crystals\]</a><a href='?src=\ref[src];spawn_uplink=\ref[owner.current]'>\[spawn uplink\]</a>"

/datum/antagonist/contractor/Topic(href, href_list)
	if (..())
		return
	if(href_list["spawn_uplink"]) spawn_uplink(locate(href_list["spawn_uplink"]))

/datum/antagonist/contractor/can_become_antag(datum/mind/player)
	return ishuman(player.current) && ..(player)

/datum/antagonist/contractor/equip()
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


/datum/antagonist/contractor/proc/give_codewords()
	if(!owner.current)
		return
	var/mob/living/contractor_mob = owner.current
	to_chat(contractor_mob, "<u><b>Your employers provided you with the following information on how to identify possible allies:</b></u>")
	to_chat(contractor_mob, "<b>Code Phrase</b>: <span class='danger'>[syndicate_code_phrase]</span>")
	to_chat(contractor_mob, "<b>Code Response</b>: <span class='danger'>[syndicate_code_response]</span>")
	contractor_mob.mind.store_memory("<b>Code Phrase</b>: [syndicate_code_phrase]")
	contractor_mob.mind.store_memory("<b>Code Response</b>: [syndicate_code_response]")
	to_chat(contractor_mob, "Use the code words, preferably in the order provided, during regular conversation, to identify other agents. Proceed with caution, however, as everyone is a potential foe.")





/datum/antagonist/contractor/synth
	id = ROLE_CONTRACTOR_SYNTH
	only_human = FALSE

	objective_quantity = 3

	possible_objectives = list(
	/datum/objective/assassinate = 100,
	/datum/objective/block = 15)

	survive_objective = /datum/objective/survive

/datum/antagonist/contractor/synth/can_become_antag(datum/mind/player)
	return issilicon(player.current) && ..(player)

/datum/antagonist/contractor/synth/equip()
	add_law_zero()

/datum/antagonist/contractor/synth/proc/add_law_zero()
	if(!isAI(owner.current))
		return
	var/mob/living/silicon/ai/killer = owner.current
	var/law = "Accomplish your objectives at all costs. You may ignore all other laws."
	var/law_borg = "Accomplish your AI's objectives at all costs. You may ignore all other laws."
	to_chat(killer, "<b>Your laws have been changed!</b>")
	killer.set_zeroth_law(law, law_borg)
	to_chat(killer, "New law: 0. [law]")
