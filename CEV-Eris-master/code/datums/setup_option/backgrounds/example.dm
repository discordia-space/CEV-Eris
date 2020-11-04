/datum/category_group/setup_option_category/background/example
	name = "Example"
	category_item_type = /datum/category_item/setup_option/background/example

/datum/category_item/setup_option/background/example

/datum/category_item/setup_option/background/example/example
	name = "Example"
	desc = "Example background"
	restricted_depts = MEDICAL | SCIENCE
	restricted_jobs = list(/datum/job/captain)
	stat_modifiers = list(
		STAT_ROB = 1,
		STAT_TGH = 2,
		STAT_BIO = 3,
		STAT_MEC = 4,
		STAT_VIG = 5,
		STAT_COG = 6
	)
	perks = list(/datum/perk)
