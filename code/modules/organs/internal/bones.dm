/obj/item/organ/internal/bone
	name = "bone"
	icon_state = "bone_braces"
	desc = "You have got a bone to pick with this"
	organ_efficiency = list(OP_BONE = 100)
	price_tag = 100
	force = WEAPON_FORCE_NORMAL
	max_damage = 100
	var/broken_description = ""
	var/reinforced = FALSE

/obj/item/organ/internal/bone/Initialize()
    . = ..()
    src.transform *= 0.5 // this little trick makes bone size small while keeping detail level of 32x32 bones.

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

/obj/item/organ/internal/bone/get_actions()
	var/list/actions_list = list()
	if(BP_IS_ROBOTIC(src))
		if(parent.status & ORGAN_BROKEN)
			actions_list.Add(list(list(
				"name" = "Mend break",
				"organ" = "\ref[src]",
				"step" = /datum/surgery_step/robotic/fix_bone
			)))
	else
		if(item_upgrades.len < max_upgrades)
			actions_list.Add(list(list(
				"name" = "Attach Mod",
				"organ" = "\ref[src]",
				"step" = /datum/surgery_step/attach_mod
			)))
		if(item_upgrades.len)
			actions_list.Add(list(list(
				"name" = "Remove Mod",
				"organ" = "\ref[src]",
				"step" = /datum/surgery_step/remove_mod
			)))
		actions_list.Add(list(list(
			"name" = (parent.status & ORGAN_BROKEN) ? "Mend" : "Break",
			"organ" = "\ref[src]",
			"step" = (parent.status & ORGAN_BROKEN) ? /datum/surgery_step/mend_bone : /datum/surgery_step/break_bone
		)))
		if(parent.status & ORGAN_BROKEN)
			actions_list.Add(list(list(
					"name" = "Reinforce",
					"organ" = "\ref[src]",
					"step" = /datum/surgery_step/reinforce_bone
				)))
		actions_list.Add(list(list(
				"name" = "Replace",
				"organ" = "\ref[src]",
				"step" = /datum/surgery_step/replace_bone
			)))

	return actions_list

/obj/item/organ/internal/bone/proc/mend()
	parent.status &= ~ORGAN_BROKEN
	parent.status &= ~ORGAN_SPLINTED
	parent.perma_injury = 0


/obj/item/organ/internal/bone/proc/reinforce()
	if(!reinforced) //Just in case
		organ_efficiency[OP_BONE] += 33
		reinforced = TRUE
		name = "reinforced [name]"
		icon_state = "reinforced_[icon_state]"

/obj/item/organ/internal/bone/refresh_upgrades()
	name = initial(name)
	color = initial(color)
	max_upgrades = initial(max_upgrades)
	prefixes = list()
	min_bruised_damage = initial(min_bruised_damage)
	min_broken_damage = initial(min_broken_damage)
	max_damage = initial(max_damage)
	owner_verbs = initial(owner_verbs)
	organ_efficiency = initial_organ_efficiency.Copy()
	scanner_hidden = initial(scanner_hidden)
	unique_tag = initial(unique_tag)
	specific_organ_size = initial(specific_organ_size)
	max_blood_storage = initial(max_blood_storage)
	current_blood = initial(current_blood)
	blood_req = initial(blood_req)
	nutriment_req = initial(nutriment_req)
	oxygen_req = initial(oxygen_req)

	if(reinforced)
		reinforced = FALSE
		reinforce()

	SEND_SIGNAL(src, COMSIG_APPVAL, src)

	for(var/prefix in prefixes)
		name = "[prefix] [name]"

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

//Bone braces
/obj/item/bone_brace
	name = "bone braces"
	desc = "Little metal bits that bones can be reinforced with"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone_braces"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTEEL = 3)
