// Blunt
/datum/component/internal_wound/organic/bone_blunt
	name = "skeletal bruising"
	treatments_tool = list(QUALITY_SEALING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BONE_MEND = 1)
	severity = 1
	severity_max = 2
	hal_damage = 0.25

/datum/component/internal_wound/organic/bone_blunt/sprain
	name = "sprained ligament"

/datum/component/internal_wound/organic/bone_blunt/trauma
	name = "blunt trauma"

/datum/component/internal_wound/organic/bone_blunt/hemorrhage
	name = "internal hemorrhage"

/datum/component/internal_wound/organic/bone_blunt/dislocation
	name = "dislocation"

// Sharp
/datum/component/internal_wound/organic/bone_sharp
	name = "perforation"
	treatments_tool = list(QUALITY_SEALING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BONE_MEND = 1)
	severity = 1
	severity_max = 2
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = 0.25

/datum/component/internal_wound/organic/bone_sharp/cavity
	name = "cavitation"

/datum/component/internal_wound/organic/bone_sharp/puncture
	name = "puncture"

/datum/component/internal_wound/organic/bone_sharp/trauma
	name = "penetrating trauma"

/datum/component/internal_wound/organic/bone_sharp/depressed
	name = "depressed tissue"

// Edge
/datum/component/internal_wound/organic/bone_edge
	name = "laceration"
	treatments_tool = list(QUALITY_SEALING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BONE_MEND = 1)
	severity = 1
	severity_max = 2
	hal_damage = 0.25

/datum/component/internal_wound/organic/bone_edge/avulsion
	name = "avulsion"

/datum/component/internal_wound/organic/bone_edge/chip
	name = "chipped tissue"

/datum/component/internal_wound/organic/bone_edge/gore
	name = "gored tissue"

/datum/component/internal_wound/organic/bone_edge/cut
	name = "grazed tissue"

// Fracture
/datum/component/internal_wound/organic/bone_fracture
	name = "fracture"
	severity = 4
	severity_max = 4
	hal_damage = 0.5
	status_flag = ORGAN_BROKEN
