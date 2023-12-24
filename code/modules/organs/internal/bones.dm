/obj/item/organ/internal/bone
	name = "bone"
	icon_state = "bone_braces"
	desc = "You have got a bone to pick with this"
	organ_efficiency = list(OP_BONE = 100)
	price_tag = 100
	max_damage = IORGAN_SKELETAL_HEALTH
	min_bruised_damage = IORGAN_SKELETAL_BRUISE
	min_broken_damage = IORGAN_SKELETAL_BREAK

/obj/item/organ/internal/bone/Initialize()
    . = ..()
    src.transform *= 0.5 // this little trick makes bone size small while keeping detail level of 32x32 bones.

/// Bones can be repaired after being destroyed. It's not ideal to have this here instead of in the parent (checking for bone efficiencies), but there are fewer corner cases this way.
/obj/item/organ/internal/bone/die()
	return

/obj/item/organ/internal/bone/take_damage(amount, damage_type = BRUTE, wounding_multiplier = 1, sharp = FALSE, edge = FALSE, silent = FALSE)
	if(damage > (min_broken_damage * ORGAN_HEALTH_MULTIPLIER) && !(status & ORGAN_BROKEN))
		fracture()
	. = ..()

/obj/item/organ/internal/bone/get_possible_wounds(damage_type, sharp, edge)
	var/list/possible_wounds = list()

	// Determine possible wounds based on nature and damage type
	var/is_robotic = BP_IS_ROBOTIC(src)
	var/is_organic = BP_IS_ORGANIC(src) || BP_IS_ASSISTED(src)

	switch(damage_type)
		if(BRUTE)
			if(!edge)
				if(sharp)
					if(is_organic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/bone_sharp))
					if(is_robotic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/sharp))
				else
					if(is_organic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/bone_blunt))
					if(is_robotic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/blunt))
			else
				if(is_organic)
					LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/bone_edge))
				if(is_robotic)
					LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/edge))
		if(BURN)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/burn))
			if(is_robotic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/emp_burn))

	return possible_wounds

/obj/item/organ/internal/bone/chest
	name = "ribcage"
	icon_state = "ribcage"
	parent_organ_base = BP_CHEST

/obj/item/organ/internal/bone/groin
	name = "pelvis"
	icon_state = "pelvis"
	parent_organ_base = BP_GROIN

/obj/item/organ/internal/bone/head
	name = "skull"
	icon_state = "skull"
	parent_organ_base = BP_HEAD

/obj/item/organ/internal/bone/r_arm
	name = "right humerus"
	icon_state = "right_arm"
	parent_organ_base = BP_R_ARM

/obj/item/organ/internal/bone/l_arm
	name = "left humerus"
	icon_state = "left_arm"
	parent_organ_base = BP_L_ARM

/obj/item/organ/internal/bone/r_leg
	name = "right femur"
	icon_state = "right_leg"
	parent_organ_base = BP_R_LEG
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE, 19)))

/obj/item/organ/internal/bone/l_leg
	name = "left femur"
	icon_state = "left_leg"
	parent_organ_base = BP_L_LEG
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE, 19)))

//Robotic limb variants
/obj/item/organ/internal/bone/chest/robotic
	name = "chest frame"
	icon_state = "metal_ribcage"
	nature = MODIFICATION_SILICON
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)

/obj/item/organ/internal/bone/groin/robotic
	name = "groin frame"
	icon_state = "metal_pelvis"
	nature = MODIFICATION_SILICON
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)

/obj/item/organ/internal/bone/head/robotic
	name = "head frame"
	icon_state = "metal_skull"
	nature = MODIFICATION_SILICON
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)

/obj/item/organ/internal/bone/r_arm/robotic
	name = "right arm frame"
	icon_state = "metal_right_arm"
	nature = MODIFICATION_SILICON
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)

/obj/item/organ/internal/bone/l_arm/robotic
	name = "left arm frame"
	icon_state = "metal_left_arm"
	nature = MODIFICATION_SILICON
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)

/obj/item/organ/internal/bone/r_leg/robotic
	name = "right leg frame"
	icon_state = "metal_right_leg"
	nature = MODIFICATION_SILICON
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)

/obj/item/organ/internal/bone/l_leg/robotic
	name = "left leg frame"
	icon_state = "metal_left_leg"
	nature = MODIFICATION_SILICON
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)
