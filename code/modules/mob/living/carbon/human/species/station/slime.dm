/datum/species/slime
	name = SPECIES_SLIME
	name_plural = "slimes"
	mob_size = MOB_SMALL

	icobase = 'icons/mob/human_races/r_slime.dmi'
	deform = 'icons/mob/human_races/r_slime.dmi'

	language = null //todo?
	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	inherent_verbs = list(/mob/living/carbon/human/proc/regenerate_organs)
	flags = NO_SCAN | NO_SLIP | NO_BREATHE | NO_MINOR_CUT
	total_health = 200
	brute_mod = 1.2
	burn_mod = 0.7
	spawn_flags = IS_RESTRICTED
	siemens_coefficient = 3 //conductive
	darksight = 3

	injury_type =  INJURY_TYPE_HOMOGENOUS

	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "rapidly loses cohesion, splattering across the ground..."

	has_process = list(
		BP_BRAIN = /obj/item/organ/internal/brain/slime
		)

	breath_type = null
	poison_type = null

	bump_flag = SLIME
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	has_limbs = list(
		BP_CHEST =  new /datum/organ_description/chest/slime,
		BP_GROIN =  new /datum/organ_description/groin/slime,
		BP_HEAD =   new /datum/organ_description/head/slime,
		BP_L_ARM =  new /datum/organ_description/arm/left/slime,
		BP_R_ARM =  new /datum/organ_description/arm/right/slime,
		BP_L_LEG =  new /datum/organ_description/leg/left/slime,
		BP_R_LEG =  new /datum/organ_description/leg/right/slime
	)

/datum/species/slime/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()

/mob/living/carbon/human/proc/regenerate_organs()
	set name = "Regenerate missing limb"
	set desc = "Regenerate a missing limb at the cost of nutrition"
	set category = "Abilities"
	var/mob/living/carbon/human/user = usr
	var/missing_limb_tag
	if(!user || !species)
		return
	if(user.stat)
		return
	for(var/limb_tag in BP_ALL_LIMBS)
		var/obj/item/organ/external/organ_to_check = organs_by_name[limb_tag]
		if(!organ_to_check || istype(organ_to_check , /obj/item/organ/external/stump))
			missing_limb_tag = limb_tag
			break
	if(!missing_limb_tag)
		to_chat(user, "You don't have any limbs to replace!")
		return
	if(nutrition < 100)
		to_chat(user, "You do not have enough nutrition to regenerate a limb")
		return

	if(user.species.has_limbs.Find(missing_limb_tag))
		var/stump_to_delete = organs_by_name[missing_limb_tag]
		if(stump_to_delete)
			qdel(stump_to_delete)
		user.adjustNutrition(-100)
		var/datum/organ_description/OD = species.has_limbs[missing_limb_tag]
		OD.create_organ(src)
		to_chat(user, "You regenerate your [OD.name]")
