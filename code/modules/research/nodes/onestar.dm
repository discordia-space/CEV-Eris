/datum/technology/one_star_basic
	name = "Simple One Star Technology"
	desc = "Reverse engineered OneStar parts."
	tech_type = RESEARCH_ONESTAR

	x = 0.1
	y = 0.5
	icon = "one_star"

	cost = 10000

/datum/technology/one_star_engineering
	name = "One Star Engineering"
	desc = "Advanced engineering technology once thought lost to time."
	tech_type = RESEARCH_ONESTAR

	x = 0.3
	y = 0.2
	icon = "one_star"

	required_technologies = list(/datum/technology/super_adv_engineering)
	required_tech_levels = list(RESEARCH_ENGINEERING = 10)
	cost = 5000

	unlocks_designs = list(	/datum/design/research/item/part/os_capacitor,
							/datum/design/research/item/part/os_micro_laser,
							/datum/design/research/item/part/os_matter_bin
						)

/datum/technology/one_star_biotech
	name = "One Star Biotech"
	desc = "Advanced biotechnology once thought lost to time."
	tech_type = RESEARCH_ONESTAR

	x = 0.2
	y = 0.4
	icon = "medmulti"

	required_technologies = list(/datum/technology/top_biotech,
								 /datum/technology/one_star_basic
							)
	required_tech_levels = list(RESEARCH_BIOTECH = 10)
	cost = 5000

	unlocks_designs = list(	/datum/design/research/item/part/os_mani,
							/datum/design/research/item/part/os_sensor,
							/datum/design/research/
						)

/datum/technology/one_star_weapons
	name = "One Star Weapons"
	desc = "Advanced weapons technology once thought lost to time."
	tech_type = RESEARCH_ONESTAR

	x = 0.3
	y = 0.6
	icon = "one_star"

	required_technologies = list(/datum/technology/one_star_engineering)
	required_tech_levels = list(RESEARCH_COMBAT = 10)
	cost = 8000

	unlocks_designs = list(	/datum/design/research/item/,
							/datum/design/research/item/,
						)
