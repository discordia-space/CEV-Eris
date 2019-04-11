/datum/antagonist/inquisitor
	id = ROLE_INQUISITOR
	role_text = "NeoTheology Inquisitor"
	role_text_plural = "NeoTheology Inquisitors"
	bantype = ROLE_BANTYPE_INQUISITOR
	welcome_text = ""
	antaghud_indicator = "hudcyberchristian"
	possible_objectives = list(
		/datum/objective/assassinate = 30,
		/datum/objective/brig = 15,
		/datum/objective/harm = 15,
		/datum/objective/steal = 30,
		/datum/objective/baptize = 30,
	)

	survive_objective = /datum/objective/escape
	var/was_priest = FALSE

/datum/antagonist/inquisitor/can_become_antag(var/datum/mind/M, var/mob/report)
	if(!..())
		if (report) report << SPAN_NOTICE("Failure: Parent can_become_antag returned false")
		return FALSE
	if(!M.current.get_cruciform())
		if (report) report << SPAN_NOTICE("Failure: [M] does not have a cruciform and this antag requires it")
		return FALSE
	return TRUE

/datum/antagonist/inquisitor/equip()
	if(!owner.current)
		return FALSE

	var/obj/item/weapon/implant/core_implant/cruciform/C = owner.current.get_cruciform()

	if(!C)
		return FALSE

	if (ispriest(owner.current))
		was_priest = TRUE

	C.make_inquisitor()
	return TRUE


/datum/antagonist/inquisitor/greet()
	if(!owner || !owner.current)
		return

	var/mob/player = owner.current

	if (was_priest)
		player << "<span class='notice'>You've been promoted...</span>"
		sleep(30)
	// Basic intro text.
	player << "<span class='danger'><font size=3>You are a [role_text]!</font></span>"

	player << "Inquisitor is a higher ranking officer in the Church of Neotheology.<br>\
	You are here to promote the Church's interests and protect disciples, but more importantly, you are also here to \
	track down criminals, spies and saboteurs within the church's ranks. Interrogate NT followers, and deal with those \
	who would tarnish the public image of the Church or betray its principles.<br>\
	<br>\
	Any local Church staff are your subordinates and should obey your commands. With other disciples, things are less clear, \
	people may put their shipboard duties above loyalty to the church. You should be discreet in your interactions with the ship command staff \
	Revealing your role may tarnish the Church's image, it's often best to deal with internal problems quietly"

	if (was_priest)
		player << "If you were the ship's preacher before, you have the authority to promote someone to be your replacement."
	else
		player << "You have been working undercover here, until a signal from NT command calls you to action. You may wish to make your presence known to the local preacher, if there is one."

	player << "You will need a ritual book to utilise your abilities. They can be found or purchased in the chapel. The Bounty ritual can be used to request items from central command. You may request a Priest upgrade to promote a new preacher."


	show_objectives()
	printTip()

	return TRUE


//Returns true if the mob in question is an NT preacher
/proc/ispriest(var/mob/living/carbon/human/H)
	if (!istype(H))
		return FALSE

	//We will get their cruciform implant, assuming they have one
	var/obj/item/weapon/implant/core_implant/cruciform/C = get_coreimplant(/obj/item/weapon/implant/core_implant/cruciform, H)
	if (!C)
		return FALSE

	//Check them for a priest module
	if(C.get_module(CRUCIFORM_PRIEST))
		return TRUE

	return FALSE