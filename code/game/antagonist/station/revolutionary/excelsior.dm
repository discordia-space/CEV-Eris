/datum/antagonist/revolutionary/excelsior
	id = ROLE_EXCELSIOR_REV
	role_text = "Infiltrator"
	role_text_plural = "Infiltrators"
	role_type = "Excelsior Infiltrator"
	welcome_text = "Viva la revolution!"

	faction_id = FACTION_EXCELSIOR

/datum/faction/revolutionary/excelsior
	id = FACTION_EXCELSIOR
	name = "Excelsior"
	antag = "infiltrator"
	antag_plural = "infiltrators"
	welcome_text = ""

	hud_indicator = "hudexcelsior"

	possible_antags = list(ROLE_EXCELSIOR_REV)
	verbs = list(/datum/faction/revolutioanry/excelsior/proc/communicate_verb)

/datum/faction/revolutioanry/excelsior/proc/communicate_verb()

	set name = "Excelsior comms"
	set category = "Cybernetics"

	if(!ishuman(usr))
		return

	var/datum/faction/F = get_faction_by_id(FACTION_EXCELSIOR)

	if(!F)
		return

	F.communicate(usr)
