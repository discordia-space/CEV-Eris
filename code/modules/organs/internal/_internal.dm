/obj/item/organ/internal
	layer = ABOVE_LYING_MOB_LAYER
	origin_tech = list(TECH_BIO = 2)
	bad_type = /obj/item/organ/internal
	spawn_tags = SPAWN_TAG_ORGAN_INTERNAL
	max_damage = 100
	var/list/owner_verbs = list()
	var/list/organ_efficiency = list()	//Efficency of an organ, should become the most important variable
	var/scanner_hidden = FALSE	//Does this organ show up on the body scanner
	var/unique_tag	//If an organ is unique and doesn't scale off of organ processes
	var/specific_organ_size = 1  //Space organs take up in weight calculations, unaffected by w_class for balance reasons
	var/max_blood_storage = 0	//How much blood an organ stores. Base is 5 * blood_req, so the organ can survive without blood for 5 ticks beofre taking damage (+ blood supply of blood vessels)
	var/current_blood = 100	//How much blood is currently in the organ
	var/blood_req = 0	//How much blood an organ takes to funcion
	var/nutriment_req = 0	//Controls passive nutriment loss
	var/oxygen_req = 0	//If oxygen reqs are not satisfied, get debuff and brain starts taking damage

/obj/item/organ/internal/New(mob/living/carbon/human/holder, datum/organ_description/OD)
	..()
	update_icon()

/obj/item/organ/internal/Process()
	..()
	handle_blood()
	handle_regeneration()

/obj/item/organ/internal/removed_mob()
	for(var/process in organ_efficiency)
		owner.internal_organs_by_efficiency[process] -= src

	owner.internal_organs -= src

	var/skipverbs = FALSE
	for(var/organ in owner.internal_organs)
		var/obj/I = organ
		if(I.type == type)
			skipverbs = TRUE
	if(!skipverbs)
		for(var/verb_path in owner_verbs)
			verbs -= verb_path
	..()

/obj/item/organ/internal/replaced(obj/item/organ/external/affected)
	..()
	parent.internal_organs |= src

/obj/item/organ/internal/replaced_mob(mob/living/carbon/human/target)
	..()
	owner.internal_organs |= src
	for(var/process in organ_efficiency)
		if(!islist(owner.internal_organs_by_efficiency[process]))
			owner.internal_organs_by_efficiency[process] = list()
		owner.internal_organs_by_efficiency[process] += src

	for(var/proc_path in owner_verbs)
		verbs |= proc_path

/obj/item/organ/internal/proc/get_process_eficiency(process_define)
	return organ_efficiency[process_define] - (organ_efficiency[process_define] * (damage / max_damage))

/obj/item/organ/internal/take_damage(amount, silent)	//Deals damage to the organ itself
	damage = between(0, src.damage + (amount * (100 / parent.limb_efficiency)), max_damage)
	if(!(BP_IS_ROBOTIC(src)))
		//only show this if the organ is not robotic
		if(owner && parent && amount > 0 && !silent)
			owner.custom_pain("Something inside your [parent.name] hurts a lot.", 1)

/obj/item/organ/internal/proc/handle_blood()
	if(BP_IS_ROBOTIC(src) || !owner)
		return
	if(OP_BLOOD_VESSEL in organ_efficiency && !(owner.status_flags & BLEEDOUT))
		current_blood = min(current_blood + 5, max_blood_storage)	//Blood vessels get an extra flat 5 blood regen
	if(!blood_req)
		return

	if(owner.status_flags & BLEEDOUT)
		current_blood = max(current_blood - blood_req, 0)
		if(!current_blood)	//When all blood is lost, take blood from blood vessels
			var/obj/item/organ/internal/BV
			for(var/organ in shuffle(parent.internal_organs))
				var/obj/item/organ/internal/I = organ
				if(OP_BLOOD_VESSEL in I.organ_efficiency)
					BV = I
					break
			if(BV)
				BV.current_blood = max(BV.current_blood - blood_req, 0)
			if(BV?.current_blood == 0)	//When all blood from the organ and blood vessel is lost, 
				take_damage(rand(2,5), prob(95))	//95% chance to not warn them, damage will proc on every organ in the limb

		return

	current_blood = min(current_blood + blood_req, max_blood_storage)

/obj/item/organ/internal/proc/handle_regeneration()
	if(!damage || BP_IS_ROBOTIC(src) || !owner || owner.chem_effects[CE_TOXIN] || owner.is_asystole() || !current_blood)
		return
	if(damage < 0.1*max_damage)
		heal_damage(0.1)

/obj/item/organ/internal/examine(mob/user)
	. = ..()
	if(user.stats?.getStat(STAT_BIO) > STAT_LEVEL_BASIC)
		to_chat(user, SPAN_NOTICE("Organ size: [specific_organ_size]"))
	if(user.stats?.getStat(STAT_BIO) > STAT_LEVEL_EXPERT)
		to_chat(user, SPAN_NOTICE("Requirements: <span style='color:red'>[blood_req]</span>/<span style='color:blue'>[oxygen_req]</span>/<span style='color:orange'>[nutriment_req]</span>"))

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/heal_damage(amount, natural = TRUE)
	if (natural && !can_recover())
		return
	if(owner.chem_effects[CE_BLOODCLOT])
		amount *= 1 + owner.chem_effects[CE_BLOODCLOT]
	damage = between(0, damage - round(amount, 0.1), max_damage)

// Is body part open for most surgerical operations?
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
				"organ" = "\ref[src]"
			)
		else
			condition = list(
				"name" = "Damage",
				"fix_name" = "Heal",
				"step" = /datum/surgery_step/fix_organ,
				"organ" = "\ref[src]"
			)

		conditions_list.Add(list(condition))

	return conditions_list
