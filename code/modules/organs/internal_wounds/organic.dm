/datum/component/internal_wound/organic
	dupe_mode = COMPONENT_DUPE_UNIQUE
	diagnosis_stat = STAT_BIO
	diagnosis_difficulty = STAT_LEVEL_ADEPT
	can_progress = TRUE
	wound_nature = MODIFICATION_ORGANIC

// Blunt
/datum/component/internal_wound/organic/blunt
	name = "rupture"
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BLOODCLOT = 0.55)	// Tricordrazine/polystem + bicaridine + meralyne OR quickclot OD + any brute heal
	severity = 0
	severity_max = 2
	hal_damage = 0.2

/datum/component/internal_wound/organic/blunt/bruising
	name = "severe bruising"

/datum/component/internal_wound/organic/blunt/trauma
	name = "blunt trauma"

/datum/component/internal_wound/organic/blunt/hemorrhage
	name = "internal hemorrhage"

/datum/component/internal_wound/organic/blunt/bruising
	name = "contusion"

// Sharp
/datum/component/internal_wound/organic/sharp
	name = "perforation"
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BLOODCLOT = 0.85)	// Brute heal chem mix + quickclot OD
	severity = 0
	severity_max = 2
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = 0.2

/datum/component/internal_wound/organic/sharp/cavity
	name = "cavitation"

/datum/component/internal_wound/organic/sharp/puncture
	name = "puncture"

/datum/component/internal_wound/organic/sharp/trauma
	name = "penetrating trauma"

/datum/component/internal_wound/organic/sharp/gore
	name = "gored tissue"

// Edge
/datum/component/internal_wound/organic/edge
	name = "laceration"
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BLOODCLOT = 0.85)	// Brute heal chem mix + quickclot OD
	severity = 0
	severity_max = 2
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = 0.2

/datum/component/internal_wound/organic/edge/gash
	name = "deep gash"

/datum/component/internal_wound/organic/edge/rip
	name = "ripped tissue"

/datum/component/internal_wound/organic/edge/tear
	name = "torn tissue"

/datum/component/internal_wound/organic/edge/cut
	name = "leaking cut"

// Burn
/datum/component/internal_wound/organic/burn
	name = "scorched tissue"
	treatments_item = list(/obj/item/stack/medical/advanced/ointment = 2)
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_STABLE = 1)	// Inaprov will only keep it from killing you
	scar = /datum/component/internal_wound/organic/damaged_tissue
	severity = 0
	severity_max = 3
	next_wound = /datum/component/internal_wound/organic/infection
	tox_damage = 0.1

/datum/component/internal_wound/organic/damaged_tissue
	name = "damaged tissue"
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	severity = 0
	severity_max = 1
	next_wound = /datum/component/internal_wound/organic/dying_tissue

/datum/component/internal_wound/organic/dying_tissue		// Copy of scorched tissue that doesn't use the burn type
	name = "dying tissue"
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_STABLE = 1)	// Inaprov will only keep it from killing you
	scar = /datum/component/internal_wound/organic/damaged_tissue
	severity = 0
	severity_max = 3
	next_wound = /datum/component/internal_wound/organic/infection
	tox_damage = 0.1

// Tox/chem OD/atmos
/datum/component/internal_wound/organic/poisoning
	name = "toxin accumulation"
	treatments_chem = list(CE_PURGER = 3)	// No anti-tox cure, poisoning can occur as a result of too much anti-tox
	severity = 0
	severity_max = 5
	hal_damage = 0.2
	tox_damage = 0.1

/datum/component/internal_wound/organic/poisoning/chem
	name = "chemical poisoning"

// Clone/radiation
/datum/component/internal_wound/organic/radiation
	name = "benign tumor"
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_ONCOCIDAL = 1)
	severity = 1
	severity_max = 1
	hal_damage = 0.1
	tox_damage = 0.1
	status_flag = ORGAN_MUTATED

/datum/component/internal_wound/organic/radiation/malignant
	name = "malignant tumor"
	treatments_tool = list()
	treatments_chem = list(CE_ONCOCIDAL = 2)
	severity = 0
	severity_max = 10
	can_spread = TRUE
	spread_threshold = 8

// Secondary wounds
/datum/component/internal_wound/organic/swelling
	name = "swelling"
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_ANTIBIOTIC = 3) // 5u Spaceacillin or spaceacillin + dylovene
	severity = 0
	severity_max = 2
	next_wound = /datum/component/internal_wound/organic/infection
	hal_damage = 0.2
	tox_damage = 0.1
	specific_organ_size_multiplier = 0.2

/datum/component/internal_wound/organic/swelling/abcess
	name = "abcess"

// Other wounds
/datum/component/internal_wound/organic/blood_loss
	name = "blood loss"
	treatments_chem = list(CE_OXYGENATED = 2, CE_BLOODRESTORE = 1)	// Dex+ treats, but it will come back if you don't get blood
	severity = 0
	severity_max = 10
	progression_threshold = 9	// Kills the organ in approx. 3 minutes

// Infection 2.0. This will spread to every organ in your body if untreated. Progresses until death.
/datum/component/internal_wound/organic/infection
	name = "infection"
	treatments_chem = list(CE_ANTIBIOTIC = 5)	// 10u Spaceacillin or 5u spaceacillin + dylovene
	severity = 0
	severity_max = 10
	progression_threshold = 150
	hal_damage = 0.2
	tox_damage = 0.2
	can_spread = TRUE
	spread_threshold = 4
