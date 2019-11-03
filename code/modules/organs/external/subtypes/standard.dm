/****************************************************
			   ORGAN DEFINES
****************************************************/

/obj/item/organ/external/chest
	name = "upper body"
	surgery_name = "torso"
	organ_tag = BP_CHEST
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEM_SIZE_HUGE
	body_part = UPPER_TORSO
	vital = TRUE
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	cannot_amputate = TRUE
	parent_organ = null
	encased = "ribcage"
	cavity_name = "thoracic cavity"
	cavity_max_w_class = ITEM_SIZE_NORMAL

/obj/item/organ/external/groin
	name = "lower body"
	surgery_name = "lower abdomen"
	organ_tag = BP_GROIN
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEM_SIZE_BULKY
	body_part = LOWER_TORSO
	vital = TRUE
	parent_organ = BP_CHEST
	amputation_point = "lumbar"
	joint = "hip"
	cavity_name = "abdominal cavity"
	cavity_max_w_class = ITEM_SIZE_SMALL
	dislocated = -1

/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	surgery_name = "head" // Prevents "Unknown's Unkonwn's head" from popping up if the head was amputated and then reattached
	max_damage = 75
	min_broken_damage = 35
	w_class = ITEM_SIZE_NORMAL
	body_part = HEAD
	vital = TRUE
	parent_organ = BP_CHEST
	joint = "jaw"
	amputation_point = "neck"
	encased = "skull"
	cavity_name = "cranial cavity"
	drop_on_remove = list(slot_head, slot_glasses, slot_l_ear, slot_r_ear, slot_wear_mask)
	functions = BODYPART_REAGENT_INTAKE

/obj/item/organ/external/head/removed()
	if(owner)
		name = "[owner.real_name]'s head"
		spawn(1)
			if(owner) // In case owner was destroyed already - gibbed, for example
				owner.update_hair()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())
	..(brute, burn, sharp, edge, used_weapon, forbidden_limbs)
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/get_conditions()
	var/list/conditions_list = ..()
	if(disfigured)
		var/list/condition = list(
			"name" = "Disfigured face",
			"fix_name" = "Restore",
			"step" = "[/datum/surgery_step/fix_face]"
		)
		conditions_list.Add(list(condition))

	return conditions_list