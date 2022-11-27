/obj/item/organ/internal/bone
	name = "bone"
	icon_state = "bone_braces"
	desc = "You have got a bone to pick with this"
	organ_efficiency = list(OP_BONE = 100)
	price_tag = 100
	force = WEAPON_FORCE_NORMAL
	max_damage = 10

/obj/item/organ/internal/bone/Initialize()
    . = ..()
    src.transform *= 0.5 // this little trick makes bone size small while keeping detail level of 32x32 bones.

/obj/item/organ/internal/bone/get_possible_wounds(damage_type, is_robotic, is_organic)
	var/list/possible_wounds = list()

	switch(damage_type)
		if(BRUTE)
			if(!edge)
				if(sharp)
					if(is_organic)
						LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/bone_sharp))
					if(is_robotic)
						LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/sharp))
				else
					if(is_organic)
						LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/bone_blunt))
					if(is_robotic)
						LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/blunt))
			else
				if(is_organic)
					LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/bone_edge))
				if(is_robotic)
					LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/edge))
		if(BURN)
			if(is_organic)
				LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/burn))
			if(is_robotic)
				LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/emp_burn))

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
	force = WEAPON_FORCE_PAINFUL

/obj/item/organ/internal/bone/l_leg
	name = "left femur"
	icon_state = "left_leg"
	parent_organ_base = BP_L_LEG
	force = WEAPON_FORCE_PAINFUL

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
