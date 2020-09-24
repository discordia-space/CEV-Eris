/datum/individual_objective/bad_technology//work
	name = "Heretical Technology"
	req_department = list(DEPARTMENT_CHURCH)
	limited_antag = TRUE
	req_cruciform = TRUE
	var/obj/item/target

/datum/individual_objective/bad_technology/assign()
	..()
	target = pick_faction_item(mind_holder)
	desc = " \The [target] is clearly against NT doctrine. It must be destroyed by Sword of Truth."//no sword of truth
	RegisterSignal(mind_holder, SWORD_OF_TRUTH_OF_DESTRUCTION, .proc/task_completed)

/datum/individual_objective/bad_technology/task_completed(obj/item/I)
	if(target.type == I.type)
		..(1)

/datum/individual_objective/bad_technology/completed()
	if(completed) return
	UnregisterSignal(mind_holder, SWORD_OF_TRUTH_OF_DESTRUCTION)
	..()

/datum/individual_objective/convert//test_requiered TEST!
	name = "Convert"
	limited_antag = TRUE
	//req_cruciform = TRUE uncoment
	var/mob/living/carbon/human/target

/datum/individual_objective/convert/assign()
	..()
	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)//todo: no owner
		if(H.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform))
			continue
		valid_targets += H
	target = pick(valid_targets)//todo: no mind.current
	desc = "[target] will make a nice addition to the church. Convert them, even if force is required."
	RegisterSignal(mind_holder, COMSIG_HUMAN_INSTALL_IMPLANT, .proc/task_completed)

/datum/individual_objective/convert/task_completed(mob/living/carbon/human/H, obj/item/weapon/implant)
	if(H == target && istype(target, /obj/item/weapon/implant/core_implant/cruciform))
		completed()

/datum/individual_objective/convert/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_INSTALL_IMPLANT)
	..()
