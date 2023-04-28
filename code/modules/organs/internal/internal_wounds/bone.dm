// Blunt
/datum/component/internal_wound/organic/bone_blunt
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_SEALING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BONE_MEND = 1)
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_LIGHT_DAMAGE

/datum/component/internal_wound/organic/bone_blunt/bruise
	name = "skeletal bruising"

/datum/component/internal_wound/organic/bone_blunt/sprain
	name = "sprained ligament"

/datum/component/internal_wound/organic/bone_blunt/dislocation
	name = "dislocation"

/*
/datum/component/internal_wound/organic/bone_blunt/trauma
	name = "blunt trauma"

/datum/component/internal_wound/organic/bone_blunt/hemorrhage
	name = "internal hemorrhage"
*/

// Sharp
/datum/component/internal_wound/organic/bone_sharp
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_SEALING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BONE_MEND = 1)
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_LIGHT_DAMAGE

/datum/component/internal_wound/organic/bone_sharp/perforation
	name = "perforation"

/datum/component/internal_wound/organic/bone_sharp/cavity
	name = "cavitation"

/datum/component/internal_wound/organic/bone_sharp/puncture
	name = "puncture"

/*
/datum/component/internal_wound/organic/bone_sharp/trauma
	name = "penetrating trauma"

/datum/component/internal_wound/organic/bone_sharp/depressed
	name = "depressed tissue"
*/

// Edge
/datum/component/internal_wound/organic/bone_edge
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_SEALING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BONE_MEND = 1)
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_LIGHT_DAMAGE

/datum/component/internal_wound/organic/bone_edge/laceration
	name = "laceration"

/datum/component/internal_wound/organic/bone_edge/avulsion
	name = "avulsion"

/datum/component/internal_wound/organic/bone_edge/chip
	name = "chipped tissue"

/*
/datum/component/internal_wound/organic/bone_edge/gore
	name = "gored tissue"

/datum/component/internal_wound/organic/bone_edge/cut
	name = "grazed tissue"
*/

// Fracture
/datum/component/internal_wound/organic/bone_fracture
	name = "fracture"
	treatments_tool = list(QUALITY_BONE_SETTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BONE_MEND = 2)
	severity = 4
	severity_max = 4
	hal_damage = IWOUND_MEDIUM_DAMAGE
	status_flag = ORGAN_WOUNDED|ORGAN_BROKEN
