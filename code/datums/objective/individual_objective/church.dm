/datum/individual_objective/bad_technology//work
	name = "Heretical Technology"
	req_department = list(DEPARTMENT_CHURCH)
	limited_antag = TRUE
	req_cruciform = TRUE
	rarity = 4
	var/obj/item/target

/datum/individual_objective/bad_technology/assign()
	..()
	target = pick_faction_item(mind_holder)
	desc = "\The [target] is clearly against NT doctrine. It must be destroyed by Sword of Truth."//no sword of truth
	RegisterSignal(mind_holder, SWORD_OF_TRUTH_OF_DESTRUCTION, .proc/task_completed)

/datum/individual_objective/bad_technology/task_completed(obj/item/I)
	if(target.type == I.type)
		..(1)

/datum/individual_objective/bad_technology/completed()
	if(completed) return
	UnregisterSignal(mind_holder, SWORD_OF_TRUTH_OF_DESTRUCTION)
	..()

/datum/individual_objective/convert//owrk
	name = "Convert"
	limited_antag = TRUE
	req_cruciform = TRUE
	rarity = 4
	var/mob/living/carbon/human/target

/datum/individual_objective/convert/can_assign(mob/living/L)
	if(!..())
		return FALSE
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - L
	for(var/mob/living/carbon/human/H in candidates)
		if(!H.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform))
			return TRUE
	return FALSE

/datum/individual_objective/convert/assign()
	..()
	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/H in ((GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - mind_holder))
		if(H.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform))
			continue
		valid_targets += H
	target = pick(valid_targets)
	desc = "[target] will make a nice addition to the church. Convert them, even if force is required."
	RegisterSignal(target, COMSIG_HUMAN_INSTALL_IMPLANT, .proc/task_completed)

/datum/individual_objective/convert/task_completed(mob/living/carbon/human/H, obj/item/weapon/implant)
	if(H == target && istype(implant, /obj/item/weapon/implant/core_implant/cruciform))
		completed()

/datum/individual_objective/convert/completed()
	if(completed) return
	UnregisterSignal(target, COMSIG_HUMAN_INSTALL_IMPLANT)
	..()

/datum/individual_objective/spread
	name = "Spread the Word"
	req_cruciform = TRUE
	var/datum/ritual/ritual
	var/ritual_name = "Revelation"
	var/mob/living/carbon/human/target

/datum/individual_objective/spread/can_assign(mob/living/L)
	if(!..())
		return FALSE
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - L
	for(var/mob/living/carbon/human/H in candidates)
		if(!H.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform))
			return TRUE
	return FALSE

/datum/individual_objective/spread/assign()
	..()
	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/H in ((GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - mind_holder))
		if(H.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform))
			continue
		valid_targets += H
	target = pick(valid_targets)//todo: no mind.current
	desc = "Perform  \the [ritual_name] ritual on [target]."
	ritual = GLOB.all_rituals[ritual_name]
	RegisterSignal(mind_holder, COMSIG_RITUAL, .proc/task_completed)

/datum/individual_objective/spread/task_completed(datum/ritual/cruciform/R, mob/M)
	if(R.type == ritual.type && M == target)
		completed()

/datum/individual_objective/spread/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_RITUAL)
	..()

/datum/individual_objective/sanctify
	name = "Sanctify"
	req_cruciform = TRUE
	var/area/target_area

/datum/individual_objective/sanctify/assign()
	..()
	target_area = random_ship_area()
	desc = "Sanctify the [target_area]"
	RegisterSignal(target_area, COMSIG_AREA_SANCTIFY, .proc/task_completed)

/datum/individual_objective/sanctify/task_completed()
	completed()

/datum/individual_objective/sanctify/completed()
	if(completed) return
	UnregisterSignal(target_area, COMSIG_AREA_SANCTIFY)
	..()
