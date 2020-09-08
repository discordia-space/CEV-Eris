/obj/item/organ/internal/bone
	name = "bone"
	icon_state = "appendix"
	desc = "You have got a bone to pick with this"
	organ_tag = BP_B_CHEST
	price_tag = 100
	var/broken_description = ""


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


/obj/item/organ/internal/bone/chest
	name = "spine"
	organ_tag = BP_B_CHEST
	parent_organ = BP_CHEST

/obj/item/organ/internal/bone/groin
	name = "pelvis"
	organ_tag = BP_B_GROIN
	parent_organ = BP_GROIN

/obj/item/organ/internal/bone/head
	name = "skull"
	organ_tag = BP_B_HEAD
	parent_organ = BP_HEAD

/obj/item/organ/internal/bone/r_arm
	name = "right arm bone"
	organ_tag = BP_B_R_ARM
	parent_organ = BP_R_ARM

/obj/item/organ/internal/bone/l_arm
	name = "left arm bone"
	organ_tag = BP_B_L_ARM
	parent_organ = BP_L_ARM

/obj/item/organ/internal/bone/r_leg
	name = "right leg bone"
	organ_tag = BP_B_R_LEG
	parent_organ = BP_R_LEG

/obj/item/organ/internal/bone/l_leg
	name = "left leg bone"
	organ_tag = BP_B_L_LEG
	parent_organ = BP_L_LEG

//Robotic limb variants
/obj/item/organ/internal/bone/chest/robotic
	name = "robotic spine"
	nature = MODIFICATION_SILICON

/obj/item/organ/internal/bone/groin/robotic
	name = "robotic pelvis"
	nature = MODIFICATION_SILICON

/obj/item/organ/internal/bone/head/robotic
	name = "robotic skull"
	nature = MODIFICATION_SILICON

/obj/item/organ/internal/bone/r_arm/robotic
	name = "right arm frame"
	nature = MODIFICATION_SILICON

/obj/item/organ/internal/bone/l_arm/robotic
	name = "left arm frame"
	nature = MODIFICATION_SILICON

/obj/item/organ/internal/bone/r_leg/robotic
	name = "right leg frame"
	nature = MODIFICATION_SILICON

/obj/item/organ/internal/bone/l_leg/robotic
	name = "left leg frame"
	nature = MODIFICATION_SILICON
