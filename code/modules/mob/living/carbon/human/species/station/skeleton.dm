/datum/species/skeleton
	name = SPECIES_SKELETON
	name_plural = "skeletal remains"
	blurb = "A human of the skeletal variety."	// Could use a neat OS lore bit here

	icobase = 'icons/mob/human_races/r_skeleton.dmi'
	deform = 'icons/mob/human_races/r_skeleton.dmi'
	damage_overlays = null
	damage_mask = null
	blood_mask = null

	min_age = 499	// Oldest skeleton is of a person of 140 years. Implies OS managed to extend life expectancy via technology. Revise according to lore.
	max_age = 359	// OS disappeared in 2291, CEV Eris launched 2642. This means the skeleton of a child of 8 years would be 359 years old.

	eyes = null
	blood_color = null
	flesh_color = null
	blood_volume = 0

	default_language = null
	language = null

	language = null
	default_language = null
	greater_form = SPECIES_HUMAN
	show_ssd = null

	eyes = "blank_eyes"

	death_message = null

	meat_type = null

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

	has_process = list()

	spawn_flags = IS_RESTRICTED

/datum/species/skeleton/get_random_name()
	return "skeletal remains"
