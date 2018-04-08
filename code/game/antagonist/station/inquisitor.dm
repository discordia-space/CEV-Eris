/datum/antagonist/inquisitor
	id = ROLE_INQUISITOR
	role_text = "NeoTheology Inquisitor"
	role_text_plural = "NeoTheology Inquisitors"
	bantype = "Inquisitor"
	welcome_text = "Here should be the inquisitor welcome text."
	restricted_jobs = list("Cyberchristian Preacher")

	possible_objectives = list(
	list(
	/datum/objective/assasinate = 30,
	/datum/objective/brig = 15,
	/datum/objective/harm = 15,
	/datum/objective/steal = 30,
	/datum/objective/baptize = 30,
	))

	survive_objective = /datum/objective/escape

/datum/antagonist/inquisitor/can_become_antag(var/datum/mind/M)
	if(!..())
		return FALSE
	if(!M.current.get_cruciform())
		return FALSE
	return TRUE

/datum/antagonist/inquisitor/equip()
	if(!owner.current)
		return FALSE

	var/obj/item/weapon/implant/core_implant/cruciform/C = owner.current.get_cruciform()

	if(!C)
		return FALSE

	C.make_inquisitor()
	return TRUE

