/obj/item/organ/external/robotic
	name = "robotic"
	force_icon = 'icons/mob/human_races/cyberlimbs/generic.dmi'
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	nerve_struck = -1 // no nerves here
	nature = MODIFICATION_SILICON
	armor = list(melee = 2, bullet = 2, energy = 2, bomb = 10, bio = 100, rad = 100)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2) // Multiplied by w_class
	spawn_tags = SPAWN_TAG_PROSTHETIC
	bad_type = /obj/item/organ/external/robotic
	var/min_malfunction_damage = 20 // Any more damage than that and you start getting nasty random malfunctions
	var/list/constructs_body = list(
		BP_CHEST = null,
		BP_HEAD  = null,
		BP_GROIN = null,
		BP_L_ARM = null,
		BP_R_ARM = null,
		BP_L_LEG = null,
		BP_R_LEG = null,
	)

/obj/item/organ/external/robotic/New()
	..()
	if(organ_tag == BP_CHEST)
		constructs_body[BP_CHEST] = src

/obj/item/organ/external/robotic/get_cache_key()
	return "Robotic[model]"

/obj/item/organ/external/robotic/update_icon()
	var/gender = "m"
	if(owner)
		gender = owner.gender == FEMALE ? "f" : "m"
	icon_state = "[organ_tag]_[gender]"
	mob_icon = icon(force_icon, icon_state)
	icon = mob_icon

	overlays.Cut()
	for(var/tag in constructs_body)
		if(constructs_body[tag])
			overlays += constructs_body[tag]

	return mob_icon

/obj/item/organ/external/robotic/attackby(obj/item/I, mob/user)
	..()
	// Check if organ havent tag or not be chest
	if(!organ_tag || organ_tag != BP_CHEST)
		return

	// Check if organ not part
	if(!istype(I, bad_type))
		return to_chat(user, SPAN_NOTICE("Assemble parts of the same set."))

	// Check if parts already installed
	var/obj/item/organ/external/robotic/part = I
	if(!part.organ_tag || constructs_body[part.organ_tag])
		return to_chat(user, SPAN_NOTICE("You've already put that part in."))

	// Insert part into phantom holder
	constructs_body[part.organ_tag] = part
	user.drop_from_inventory(part)
	part.forceMove(src)
	update_icon()

	// Increase body size
	w_class += part.w_class

	// Check body pargs, if not fully done - return from proc
	for(var/tag in constructs_body)
		if(!constructs_body[tag])
			return

	// Prompt human name
	var/name = sanitizeSafe(input(user, "Set a name for the new prosthetic."), MAX_NAME_LEN)
	if(!name)
		name = "prosthetic ([random_id("prosthetic_id", 1, 999)])"

	// Prompt human sex
	var/sex = input(user, "Choose your character's sex:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in list(FEMALE, MALE, NEUTER)
	if(!sex)
		sex = NEUTER

	// Create human and rename
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(get_turf(loc))
	H.fully_replace_character_name(name, name)
	H.death(0)

	// Replace human organs
	for(var/tag in constructs_body)
		if(H.organs_by_name[tag])
			qdel(H.organs_by_name[tag])
		
		// Create new robo-organ
		var/obj/item/organ/external/organ = constructs_body[tag]
		new organ.type(H)

	// Create and prothesis organs, without brain and appendix
	for(var/tag in H.species.has_process - list(BP_BRAIN, OP_APPENDIX))
		var/organ_type = H.species.has_process[tag]

		// Create natural organ and change their nature type
		var/obj/item/organ/internal/O = new organ_type(H)
		O.nature = MODIFICATION_SILICON

	// Setup human sex and update body
	H.gender = sex
	H.update_body()
	H.regenerate_icons()

	// Delete chest with phantom holder
	qdel(src)

/obj/item/organ/external/robotic/is_malfunctioning()
	return prob(brute_dam + burn_dam - min_malfunction_damage)

/obj/item/organ/external/robotic/set_description(datum/organ_description/desc)
	..()
	src.name = "[initial(name)] [desc.name]"
	for(var/mat_name in matter)
		matter[mat_name] *= w_class

/obj/item/organ/external/robotic/Destroy()
	deactivate(emergency=TRUE)
	. = ..()

/obj/item/organ/external/robotic/removed()
	deactivate(emergency=TRUE)
	..()

/obj/item/organ/external/robotic/update_germs()
	germ_level = 0
	return

/obj/item/organ/external/robotic/setBleeding()
	return FALSE

/obj/item/organ/external/robotic/proc/can_activate()
	return TRUE

/obj/item/organ/external/robotic/proc/activate()
	return TRUE

/obj/item/organ/external/robotic/proc/deactivate(emergency = TRUE)
	return TRUE

/obj/item/organ/external/robotic/limb
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL
	bad_type = /obj/item/organ/external/robotic/limb

/obj/item/organ/external/robotic/tiny
	min_broken_damage = 15
	w_class = ITEM_SIZE_SMALL
	bad_type = /obj/item/organ/external/robotic/tiny


/obj/item/organ/external/robotic/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/groin
	default_description = /datum/organ_description/groin
