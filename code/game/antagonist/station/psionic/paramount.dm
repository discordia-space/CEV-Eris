/datum/antagonist/paramount
	id = ROLE_PARAMOUNT
	role_text = "Paramount"
	role_text_plural = "Paramounts"
	bantype = ROLE_BANTYPE_PARAMOUNT
	welcome_text = ""
	antaghud_indicator = "hudmalai"
	id_type = /obj/item/card/id/syndicate

	possible_objectives = list(
		/datum/objective/assassinate = 30,
		/datum/objective/brig = 15,
		/datum/objective/harm = 15,
		/datum/objective/steal = 30
	)

	survive_objective = /datum/objective/escape

	stat_modifiers = list(
		STAT_COG = 30
	)

/datum/antagonist/paramount/can_become_antag(datum/mind/M, mob/report)
	if(!..())
		if (report)
			to_chat(report, SPAN_NOTICE("Failure: Parent can_become_antag returned false"))
		return FALSE
	if(M.current.get_core_implant(/obj/item/implant/core_implant/cruciform))
		if (report)
			to_chat(report, SPAN_NOTICE("Failure: [M] has a cruciform and this antag prohibits it"))
		return FALSE
	return TRUE

/datum/antagonist/paramount/equip()
	var/mob/living/L = owner.current

	for(var/name in stat_modifiers)
		L.stats.changeStat(name, stat_modifiers[name])

	if(!owner.current)
		return FALSE

//	owner.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/psi_amp(owner), slot_head)
	L.set_psi_rank(PSI_REDACTION, 3,     defer_update = TRUE)
	L.set_psi_rank(PSI_COERCION, 3,      defer_update = TRUE)
	L.set_psi_rank(PSI_PSYCHOKINESIS, 3, defer_update = TRUE)
	L.set_psi_rank(PSI_ENERGISTICS, 3,   defer_update = TRUE)
	L.psi.update(TRUE)

/*
	owner.equip_to_slot_or_del(new /obj/item/clothing/under/psysuit(owner), slot_w_uniform)
	owner.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/psypurple(owner), slot_wear_suit)
	owner.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(owner), slot_shoes)
	owner.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(owner), slot_back)
	var/obj/item/clothing/gloves/color/gloves = new()
	gloves.color = COLOR_GRAY80
	owner.equip_to_slot_or_del(gloves, slot_gloves)
*/
	return TRUE

/datum/antagonist/paramount/greet()
	if(!owner || !owner.current)
		return

	var/mob/player = owner.current

	// Basic intro text.
	to_chat(player, "<span class='danger'><font size=3>You are a [role_text]!</font></span>")

	to_chat(player, "Inquisitor is a higher ranking officer in the Church of NeoTheology.<br>\
	You are here to promote the Church's interests and protect disciples, but more importantly, you are also here to \
	track down criminals, spies and saboteurs within the church's ranks. Interrogate NT followers, and deal with those \
	who would tarnish the public image of the Church or betray its principles.<br>\
	<br>\
	Any local Church staff are your subordinates and should obey your commands. With other disciples, things are less clear, \
	people may put their shipboard duties above loyalty to the church. You should be discreet in your interactions with the ship command staff \
	Revealing your role may tarnish the Church's image, it's often best to deal with internal problems quietly")

	to_chat(player, "You have been working undercover here, until a signal from NT command calls you to action. You may wish to make your presence known to the local preacher, if there is one.")

	show_objectives()
	printTip()

	return TRUE


/datum/antagonist/paramount/create_objectives()

	if(!..())
		return
	// Copied from ninja for now.
	var/objective_list = list(1,2,3)
	for(var/i=rand(2,3),i>0,i--)
		switch(pick(objective_list))
			if(1)//Kill
				var/datum/objective/assassinate/objective = new
				objective.owner = owner
				objective.target = objective.find_target()
				if(objective.target != "Free Objective")
					owner.individual_objectives += objective
				else
					i++
				objective_list -= 1 // No more than one kill objective
			if(2)//Protect
				var/datum/objective/protect/objective = new
				objective.owner = owner
				objective.target = objective.find_target()
				if(objective.target != "Free Objective")
					owner.individual_objectives += objective
				else
					i++
					objective_list -= 3
			if(3)//Harm
				var/datum/objective/harm/objective = new
				objective.owner = owner
				objective.target = objective.find_target()
				if(objective.target != "Free Objective")
					owner.individual_objectives += objective
				else
					i++
					objective_list -= 4

	var/datum/objective/survive/objective = new
	objective.owner = owner
	owner.individual_objectives += objective
