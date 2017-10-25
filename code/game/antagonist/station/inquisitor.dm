// Inherits most of its vars from the base datum.
/datum/antagonist/inquisitor
	id = ROLE_INQUISITOR
	role_text = "Inquisitor"
	role_text_plural = "Inquisitors"
	bantype = "inquisitor"
	welcome_text = "Here should be the inquisitor welcome text."
	weight = 9
	protected_jobs = list("Cyberchristian Preacher")


/datum/antagonist/inquisitor/create_objectives()
	if(!..())
		return

	switch(rand(1,100))
		if(1 to 25)
			new /datum/objective/assassinate (src)
		if(26 to 40)
			new /datum/objective/brig (src)
		if(41 to 55)
			new /datum/objective/harm (src)
		if(56 to 80)
			new /datum/objective/baptize (src)
		else
			new /datum/objective/steal (src)

	if (!(locate(/datum/objective/escape) in objectives))
		new /datum/objective/escape (src)
	return

/datum/antagonist/inquisitor/can_become_antag(var/datum/mind/M)
	if(!..())
		return FALSE
	if(!M.current.get_cruciform())
		return FALSE
	return TRUE

/datum/antagonist/inquisitor/equip()
	if(!owner.current)
		return FALSE

	var/obj/item/weapon/implant/external/core_implant/cruciform/C = owner.current.get_cruciform()

	if(!C)
		return FALSE

	C.make_inquisitor()
	return TRUE

