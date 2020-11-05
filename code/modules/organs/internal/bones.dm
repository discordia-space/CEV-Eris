/obj/item/organ/internal/bone
	name = "bone"
	icon_state = "bone_braces"
	desc = "You have got a bone to pick with this"
	organ_tag = BP_B_CHEST
	price_tag = 100
	force = WEAPON_FORCE_NORMAL
	var/broken_description = ""
	var/reinforced = FALSE


/obj/item/organ/internal/bone/proc/fracture()
	if(owner)
		owner.visible_message(
			SPAN_DANGER("You hear a loud cracking sound coming from \the [owner]."),
			SPAN_DANGER("Something feels like it shattered in your [name]"),
			SPAN_DANGER("You hear a sickening crack.")
		)
		if(owner.species && !(owner.species.flags & NO_PAIN))
			owner.emote("scream")

	parent.status |= ORGAN_BROKEN	//Holding the status on the parent organ to make transition to erismed organ processes easier.
	broken_description = pick("broken","fracture","hairline fracture")
	parent.perma_injury = parent.brute_dam
	take_damage(10, 0)

	// Fractures have a chance of getting you out of restraints
	if(prob(25))
		parent.release_restraints()

/obj/item/organ/internal/bone/proc/mend()
	parent.status &= ~ORGAN_BROKEN
	parent.status &= ~ORGAN_SPLINTED
	parent.perma_injury = 0


/obj/item/organ/internal/bone/proc/reinforce()
	if(!reinforced) //Just in case
		organ_efficiency += 33
		reinforced = TRUE
		name = "reinforced [name]"
		icon_state = "reinforced_[icon_state]"

/obj/item/organ/internal/bone/chest
	name = "ribcage"
	icon_state = "ribcage"
	organ_tag = BP_B_CHEST
	parent_organ = BP_CHEST

/obj/item/organ/internal/bone/groin
	name = "pelvis"
	icon_state = "pelvis"
	organ_tag = BP_B_GROIN
	parent_organ = BP_GROIN

/obj/item/organ/internal/bone/head
	name = "skull"
	icon_state = "skull"
	organ_tag = BP_B_HEAD
	parent_organ = BP_HEAD

/obj/item/organ/internal/bone/r_arm
	name = "right humerus"
	icon_state = "right_arm"
	organ_tag = BP_B_R_ARM
	parent_organ = BP_R_ARM

/obj/item/organ/internal/bone/l_arm
	name = "left humerus"
	icon_state = "left_arm"
	organ_tag = BP_B_L_ARM
	parent_organ = BP_L_ARM

/obj/item/organ/internal/bone/r_leg
	name = "right femur"
	icon_state = "right_leg"
	organ_tag = BP_B_R_LEG
	parent_organ = BP_R_LEG
	force = WEAPON_FORCE_PAINFUL

/obj/item/organ/internal/bone/l_leg
	name = "left femur"
	icon_state = "left_leg"
	organ_tag = BP_B_L_LEG
	parent_organ = BP_L_LEG
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

//Bone braces
/obj/item/bone_brace
	name = "bone braces"
	desc = "Little metal bits that bones can be reinforced with"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone_braces"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTEEL = 3)
