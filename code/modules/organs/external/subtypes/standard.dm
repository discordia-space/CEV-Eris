/****************************************************
			   ORGAN DEFINES
****************************************************/

/obj/item/organ/external/chest
	name = "upper body"
	organ_tag = BP_CHEST
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEM_SIZE_HUGE
	body_part = UPPER_TORSO
	vital = 1
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	cannot_amputate = 1
	parent_organ = null
	encased = "ribcage"
	limb_flags = ORGAN_FLAG_GENDERED_ICON | ORGAN_FLAG_HEALS_OVERKILL | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/groin
	name = "lower body"
	organ_tag = BP_GROIN
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEM_SIZE_LARGE
	body_part = LOWER_TORSO
	vital = 1
	parent_organ = BP_CHEST
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_GENDERED_ICON | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	max_damage = 75
	min_broken_damage = 35
	w_class = ITEM_SIZE_NORMAL
	body_part = HEAD
	vital = 1
	parent_organ = BP_CHEST
	joint = "jaw"
	amputation_point = "neck"
	encased = "skull"
	drop_on_remove = list(slot_head, slot_glasses, slot_l_ear, slot_r_ear, slot_wear_mask)
	var/can_intake_reagents = 1

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


/obj/item/organ/external/arm
	organ_tag = BP_L_ARM
	name = "left arm"
	icon_name = "l_arm"
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL
	body_part = ARM_LEFT
	parent_organ = BP_CHEST
	joint = "left elbow"
	amputation_point = "left shoulder"
	tendon_name = "palmaris longus tendon"
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_GRASP | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/arm/right
	organ_tag = BP_R_ARM
	name = "right arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"

/obj/item/organ/external/leg
	organ_tag = BP_L_LEG
	name = "left leg"
	icon_name = "l_leg"
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	joint = "left knee"
	amputation_point = "left hip"
	tendon_name = "cruciate ligament"
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/leg/right
	organ_tag = BP_R_LEG
	name = "right leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"
