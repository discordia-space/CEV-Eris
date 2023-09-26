/datum/component/internal_wound/organic
	diagnosis_stat = STAT_BIO
	diagnosis_difficulty = STAT_LEVEL_EXPERT
	wound_nature = MODIFICATION_ORGANIC
// Blunt
/datum/component/internal_wound/organic/brain_blunt/
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_HARD)
	treatments_chem = list(CE_BRAINHEAL = 1)
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_MEDIUM_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE
/datum/component/internal_wound/organic/brain_blunt/dissection
    name = "brain contusion"

/datum/component/internal_wound/organic/brain_blunt/hematoma
    name = "diffuse axonal injury"

/datum/component/internal_wound/organic/brain_blunt/injury
    name = "torn nerve fibers"

// Sharp
/datum/component/internal_wound/organic/brain_sharp/
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_BRAINHEAL = 1)
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/organic/brain_sharp/perforation
	name = "punctured brain tissue"

/datum/component/internal_wound/organic/brain_sharp/cavity
	name = "penetrating brain injury"

/datum/component/internal_wound/organic/brain_sharp/lobe
	name = "gored brain lobe"

// /datum/component/internal_wound/organic/brain_sharp/gore
//	name = "gored frontal lobe" //-- is that the bite of 87????????????????????????

// Edge
/datum/component/internal_wound/organic/brain_edge
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_BRAINHEAL = 1)
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/organic/brain_edge/laceration
	name = "brain laceration"

/datum/component/internal_wound/organic/brain_edge/slice
	name = "sliced brain tissue"

/datum/component/internal_wound/organic/brain_edge/rip
	name = "ripped brain fibers"

/*
/datum/component/internal_wound/organic/edge/tear
	name = "torn tissue"

/datum/component/internal_wound/organic/edge/cut
	name = "leaking cut"
*/

// Burn
/datum/component/internal_wound/organic/brain_burn
	treatments_item = list(/obj/item/stack/medical/advanced/ointment = 2)
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_HARD)
	treatments_chem = list(CE_BRAINHEAL = 1)
	scar = /datum/component/internal_wound/organic/necrosis_start
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/organic/infection
	hal_damage = IWOUND_MEDIUM_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/organic/burn/scorch
	name = "scorched tissue"

/datum/component/internal_wound/organic/burn/char
	name = "charred tissue"

/datum/component/internal_wound/organic/burn/incinerate
	name = "incinerated flesh"

/*
/datum/component/internal_wound/organic/burn/sear
	name = "seared flesh"

/datum/component/internal_wound/organic/burn/burnt
	name = "burnt tissue"
*/

/datum/component/internal_wound/organic/necrosis_start
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_HARD)
	severity = 0
	severity_max = 1
	next_wound = /datum/component/internal_wound/organic/necrosis

/datum/component/internal_wound/organic/necrosis_start/damaged_tissue
	name = "damaged tissue"

/datum/component/internal_wound/organic/necrosis
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_HARD)
	treatments_chem = list(CE_STABLE = 1)
	scar = /datum/component/internal_wound/organic/necrosis_start
	severity = 0
	severity_max = 3
	next_wound = /datum/component/internal_wound/organic/infection
	hal_damage = IWOUND_LIGHT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE
//---------------------------------------------------------------------------------------------
//----------------------------------ROBOTIC MOTHERFUCKERS--------------------------------------
//---------------------------------------------------------------------------------------------

/datum/component/internal_wound/robotic
	diagnosis_stat = STAT_MEC
	diagnosis_difficulty = STAT_LEVEL_BASIC
	wound_nature = MODIFICATION_SILICON

// Blunt
/datum/component/internal_wound/robotic/brain_blunt
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_HAMMERING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.55)		// repair nanites + 3 metals OR repair nanite OD + a metal
	severity = 0
	severity_max = IORGAN_MAX_HEALTH/3
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/robotic/blunt/malfunction
	name = "mechanical malfunction"

/datum/component/internal_wound/robotic/blunt/minor_deform
	name = "minor deformation"

/datum/component/internal_wound/robotic/blunt/shear
	name = "sheared support"

/*
/datum/component/internal_wound/robotic/blunt/bent
	name = "bent structure"

/datum/component/internal_wound/robotic/blunt/crack
	name = "cracked frame"
*/

// Sharp
/datum/component/internal_wound/robotic/sharp
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_SEALING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.85)		// repair nanites + 6 metals OR repair nanite OD + 7 metals
	severity = 0
	severity_max = IORGAN_MAX_HEALTH/3
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/robotic/sharp/perforation
	name = "perforation"

/datum/component/internal_wound/robotic/sharp/cavitation
	name = "cavitation"

/datum/component/internal_wound/robotic/sharp/leak
	name = "weeping leak"

/*
/datum/component/internal_wound/robotic/sharp/puncture
	name = "puncture"

/datum/component/internal_wound/robotic/sharp/pressure
	name = "pressure failure"
*/

// Edge
/datum/component/internal_wound/robotic/edge
	treatments_item = list(/obj/item/stack/cable_coil = 5, /obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.85)
	severity = 0
	severity_max = IORGAN_MAX_HEALTH/3
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/robotic/edge/cut
	name = "exposed wiring"

/datum/component/internal_wound/robotic/edge/gouge
	name = "gouged structure"

/datum/component/internal_wound/robotic/edge/shred
	name = "shredded shielding"

/*
/datum/component/internal_wound/robotic/edge/short
	name = "electrical short"

/datum/component/internal_wound/robotic/edge/arc
	name = "arcing"
*/

// EMP/burn wounds
/datum/component/internal_wound/robotic/brain_burn
	treatments_item = list(/obj/item/stack/cable_coil = 5, /obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.95)	// repair nanite OD + all metals
	severity = 0
	severity_max = IORGAN_MAX_HEALTH/3
	next_wound = /datum/component/internal_wound/robotic/overheat
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/robotic/emp_burn/elec_malfunction
	name = "electrical malfunction"

/datum/component/internal_wound/robotic/emp_burn/slag
	name = "slagged mechanism"

/datum/component/internal_wound/robotic/emp_burn/carbonized
	name = "carbonized wiring"
