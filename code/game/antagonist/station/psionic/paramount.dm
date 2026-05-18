/datum/antagonist/paramount
	id = ROLE_PARAMOUNT
	role_text = "Paramount"
	role_text_plural = "Paramounts"
	protected_jobs = list(JOBS_SECURITY, JOBS_COMMAND, "Moebius Bio-Engineer", JOBS_CHURCH)
	restricted_jobs = list("AI", "Robot")
	bantype = ROLE_BANTYPE_PARAMOUNT
	antaghud_indicator = "hudmalai"

	welcome_text = "Awake our Paramount almighty. Let the prison of your thoughts break open and enter our service again. <br>\
	The Founders see the open vastness of the Null Sector as a treasure cove of knowledge and entropic phenomena, gored open by the fleets of ignorants and barbarians. <br>\
	Let no seeds of hatred take root over this profanity, and cherish such an occasion! In their foolishness, they expose their inferior minds to us! <br>\
	Go through the visions not meant for these mere mortals, and collect her gifts for us to plunder."

	possible_objectives = list(
		/datum/objective/assassinate = 30,
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
	var/mob/living/carbon/human/H = owner.current

	for(var/name in stat_modifiers)
		H.stats.changeStat(name, stat_modifiers[name])

	if(!owner.current)
		return FALSE

//	owner.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/psi_amp(owner), slot_head)
	H.set_psi_rank(PSI_REDACTION, 5,     defer_update = TRUE) // TODO: set these to 3 if this is ever made a real antag
	H.set_psi_rank(PSI_COERCION, 5,      defer_update = TRUE)
	H.set_psi_rank(PSI_PSYCHOKINESIS, 5, defer_update = TRUE)
	H.set_psi_rank(PSI_ENERGISTICS, 5,   defer_update = TRUE)
	H.set_psi_power(2, FALSE, defer_update = TRUE)
	if(!get_active_mutation(H, MUTATION_PSI_HIGH))
		var/datum/mutation/M = new MUTATION_PSI_HIGH
		M.imprint(H)
	H.psi.update(TRUE)

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
	to_chat(player, SPAN_DANGER("<font size=3>You are a [role_text]!</font>"))

	to_chat(player, "Awake our Paramount almighty. Let the prison of your thoughts break open and enter our service again. <br>\
	The Founders see the open vastness of the Null Sector as a treasure cove of knowledge and entropic phenomena, gored open by the fleets of ignorants and barbarians. <br>\
	Let no seeds of hatred take root over this profanity, and cherish such an occasion! In their foolishness, they expose their inferior minds to us! <br>\
	Go through the visions not meant for these mere mortals, and collect her gifts for us to plunder.")

	to_chat(player, SPAN_NOTICE("Shift + left click the Psionic HUD icon to get started."))

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
