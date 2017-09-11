/datum/antagonist/revolutionary
	id = ROLE_REVOLUTIONARY
	role_text = "Head Revolutionary"
	role_text_plural = "Revolutionaries"
	bantype = "revolutionary"
	welcome_text = "Down with the capitalists! Down with the Bourgeoise!"

	//Inround revs.
	faction_role_text = "Revolutionary"
	faction_descriptor = "Revolution"
	faction_verb = /mob/living/proc/convert_to_rev
	faction_welcome = "Help the cause overturn the ruling class. Do not harm your fellow freedom fighters."
	faction_indicator = "rev"
	faction_invisible = 1
	faction = "revolutionary"

	restricted_jobs = list("AI", "Cyborg","Captain", "First Officer", "Ironhammer Commander", "Technomancer Exultant", "Moebius Expedition Overseer", "Moebius Biolab Officer")
	protected_jobs = list("Ironhammer Operative", "Ironhammer Gunnery Sergeant", "Ironhammer Inspector", "Ironhammer Medical Specialist")

/datum/faction/revolutionary
	id = FACTION_REVOLUTIONARY
	name = "Revolution"
	description = "Viva la revolution!"
	welcome_text = "Help the cause overturn the ruling class. Do not harm your fellow freedom fighters."
	faction_invisible = TRUE
	faction_indicator = "rev"

	antag = "Revolutionary"
	antag_plural = "Revolutionaries"

	leader_verbs = list(/mob/living/proc/convert_to_rev)

/mob/living/proc/convert_to_rev(mob/M as mob in oview(src))
	set name = "Convert Bourgeoise"
	set category = "Abilities"

/datum/faction/revolutionary/create_objectives()
	if(!..())
		return
	global_objectives = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(!player.mind || player.stat==2 || !(player.mind.assigned_role in command_positions))
			continue
		new /datum/objective/rev (player)
