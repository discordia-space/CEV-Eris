/datum/species/skeleton
	name = SPECIES_SKELETON
	name_plural = "skeletal remains"
	blurb = "They look like human remains. Some poor soul expired here, a million miles from home."

	icobase = 'icons/mob/human_races/r_skeleton.dmi'
	deform = 'icons/mob/human_races/r_skeleton.dmi'
	damage_overlays = null
	damage_mask = null
	blood_mask = null

	min_age = 18
	max_age = 110

	eyes = null
	blood_color = null//"#EDE7DF"	// Workaround for bleeding, pretend it's bone dust or something
	flesh_color = null
	blood_volume = -1	// 0 causes runtimes elsewhere

	language = null
	default_language = null
	show_ssd = null

	eyes = "blank_eyes"

	death_message = null

	meat_type = /obj/effect/decal/cleanable/ash
	gibber_type = /obj/effect/gibspawner/generic //TODO: Add sanity check to gibber so it can handle null values.
	single_gib_type = /obj/effect/decal/cleanable/ash
	remains_type = /obj/item/remains/human

	lower_sanity_process = FALSE

	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1
	heat_level_1 = INFINITY
	heat_level_2 = INFINITY
	heat_level_3 = INFINITY

	hazard_high_pressure = INFINITY
	warning_high_pressure = INFINITY
	warning_low_pressure = -1
	hazard_low_pressure = -1

	injury_type =  INJURY_TYPE_UNLIVING

	has_process = list()

	has_limbs = list(
		BP_CHEST =  new /datum/organ_description/chest/skeletal,
		BP_GROIN =  new /datum/organ_description/groin/skeletal,
		BP_HEAD =   new /datum/organ_description/head/skeletal,
		BP_L_ARM =  new /datum/organ_description/arm/left/skeletal,
		BP_R_ARM =  new /datum/organ_description/arm/right/skeletal,
		BP_L_LEG =  new /datum/organ_description/leg/left/skeletal,
		BP_R_LEG =  new /datum/organ_description/leg/right/skeletal
		)

	spawn_flags = IS_RESTRICTED

/datum/species/skeleton/get_random_name()
	return "skeletal remains"
