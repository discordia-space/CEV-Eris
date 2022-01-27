/obj/item/organ/internal
	layer = ABOVE_LYING_MOB_LAYER
	origin_tech = list(TECH_BIO = 2)
	bad_type = /obj/item/organ/internal
	spawn_tags = SPAWN_TAG_ORGAN_INTERNAL
	max_damage = 100
	desc = "A69ital organ."
	var/list/owner_verbs = list()
	var/list/organ_efficiency = list()	//Efficency of an organ, should become the69ost important69ariable
	var/scanner_hidden = FALSE	//Does this organ show up on the body scanner
	var/unique_tag	//If an organ is unique and doesn't scale off of organ processes
	var/specific_organ_size = 1  //Space organs take up in weight calculations, unaffected by w_class for balance reasons
	var/max_blood_storage = 0	//How69uch blood an organ stores. Base is 5 * blood_req, so the organ can survive without blood for 5 ticks beofre taking damage (+ blood supply of blood69essels)
	var/current_blood = 100	//How69uch blood is currently in the organ
	var/blood_req = 0	//How69uch blood an organ takes to funcion
	var/nutriment_req = 0	//Controls passive69utriment loss
	var/oxygen_req = 0	//If oxygen reqs are69ot satisfied, get debuff and brain starts taking damage

/obj/item/organ/internal/New(mob/living/carbon/human/holder, datum/organ_description/OD)
	..()
	update_icon()

/obj/item/organ/internal/Process()
	..()
	handle_blood()
	handle_regeneration()

/obj/item/organ/internal/removed_mob()
	for(var/process in organ_efficiency)
		owner.internal_organs_by_efficiency69process69 -= src

	owner.internal_organs -= src

	var/skipverbs = FALSE
	for(var/organ in owner.internal_organs)
		var/obj/I = organ
		if(I.type == type)
			skipverbs = TRUE
	if(!skipverbs)
		for(var/verb_path in owner_verbs)
			verbs -=69erb_path
	..()

/obj/item/organ/internal/replaced(obj/item/organ/external/affected)
	..()
	parent.internal_organs |= src

/obj/item/organ/internal/replaced_mob(mob/living/carbon/human/target)
	..()
	owner.internal_organs |= src
	for(var/process in organ_efficiency)
		if(!islist(owner.internal_organs_by_efficiency69process69))
			owner.internal_organs_by_efficiency69process69 = list()
		owner.internal_organs_by_efficiency69process69 += src

	for(var/proc_path in owner_verbs)
		verbs |= proc_path

/obj/item/organ/internal/proc/get_process_efficiency(process_define)
	return organ_efficiency69process_define69 - (organ_efficiency69process_define69 * (damage /69ax_damage))

/obj/item/organ/internal/take_damage(amount, silent)	//Deals damage to the organ itself
	damage = between(0, src.damage + (amount * (100 / parent.limb_efficiency)),69ax_damage)
	if(!(BP_IS_ROBOTIC(src)))
		//only show this if the organ is69ot robotic
		if(owner && parent && amount > 0 && !silent)
			owner.custom_pain("Something inside your 69parent.name69 hurts a lot.", 1)

/obj/item/organ/internal/proc/handle_blood()
	if(BP_IS_ROBOTIC(src) || !owner)
		return
	if(OP_BLOOD_VESSEL in organ_efficiency && !(owner.status_flags & BLEEDOUT))
		current_blood =69in(current_blood + 5,69ax_blood_storage)	//Blood69essels get an extra flat 5 blood regen
	if(!blood_req)
		return

	if(owner.status_flags & BLEEDOUT)
		current_blood =69ax(current_blood - blood_req, 0)
		if(!current_blood)	//When all blood is lost, take blood from blood69essels
			var/obj/item/organ/internal/BV
			for(var/organ in shuffle(parent.internal_organs))
				var/obj/item/organ/internal/I = organ
				if(OP_BLOOD_VESSEL in I.organ_efficiency)
					BV = I
					break
			if(BV)
				BV.current_blood =69ax(BV.current_blood - blood_req, 0)
			if(BV?.current_blood == 0)	//When all blood from the organ and blood69essel is lost, 
				take_damage(rand(2,5), prob(95))	//95% chance to69ot warn them, damage will proc on every organ in the limb

		return

	current_blood =69in(current_blood + blood_req,69ax_blood_storage)

/obj/item/organ/internal/proc/handle_regeneration()
	if(!damage || BP_IS_ROBOTIC(src) || !owner || owner.chem_effects69CE_TOXIN69 || owner.is_asystole() || !current_blood)
		return
	if(damage < 0.1*max_damage)
		heal_damage(0.1)

/obj/item/organ/internal/examine(mob/user)
	. = ..()
	if(user.stats?.getStat(STAT_BIO) > STAT_LEVEL_BASIC)
		to_chat(user, SPAN_NOTICE("Organ size: 69specific_organ_size69"))
	if(user.stats?.getStat(STAT_BIO) > STAT_LEVEL_EXPERT)
		to_chat(user, SPAN_NOTICE("Requirements: <span style='color:red'>69blood_req69</span>/<span style='color:blue'>69oxygen_req69</span>/<span style='color:orange'>69nutriment_req69</span>"))

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/heal_damage(amount,69atural = TRUE)
	if (natural && !can_recover())
		return
	if(owner.chem_effects69CE_BLOODCLOT69)
		amount *= 1 + owner.chem_effects69CE_BLOODCLOT69
	damage = between(0, damage - round(amount, 0.1),69ax_damage)

// Is body part open for69ost surgerical operations?
/obj/item/organ/internal/is_open()
	var/obj/item/organ/external/limb = get_limb()

	if(limb)
		return limb.is_open()
	else
		return TRUE


// Gets a list of surgically treatable conditions
/obj/item/organ/internal/get_conditions()
	var/list/conditions_list = ..()
	var/list/condition

	if(damage > 0)
		if(BP_IS_ROBOTIC(src))
			condition = list(
				"name" = "Damage",
				"fix_name" = "Repair",
				"step" = /datum/surgery_step/robotic/fix_organ,
				"organ" = "\ref69src69"
			)
		else
			condition = list(
				"name" = "Damage",
				"fix_name" = "Heal",
				"step" = /datum/surgery_step/fix_organ,
				"organ" = "\ref69src69"
			)

		conditions_list.Add(list(condition))

	return conditions_list
