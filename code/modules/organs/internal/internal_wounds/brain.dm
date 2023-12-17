
// Blunt
/datum/component/internal_wound/organic/brain_blunt
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_HARD)
	treatments_chem = list(CE_BRAINHEAL = 1)
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_MEDIUM_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE
/datum/component/internal_wound/organic/brain_blunt/contusion
    name = "brain contusion"

/datum/component/internal_wound/organic/brain_blunt/diffuse
    name = "diffuse axonal injury"

/datum/component/internal_wound/organic/brain_blunt/torn
    name = "torn nerve fibers"

// Sharp
/datum/component/internal_wound/organic/brain_sharp
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_BRAINHEAL = 1)
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/organic/brain_sharp/punctured
	name = "punctured brain tissue"

/datum/component/internal_wound/organic/brain_sharp/lobe
	name = "gored brain lobe"
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_HARD)

/datum/component/internal_wound/organic/brain_sharp/penetrating
	name = "penetrating brain injury"
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 4)
	treatments_tool = list(QUALITY_LASER_CUTTING = FAILCHANCE_HARD)
	scar = list(/datum/component/internal_wound/organic/penetrating2) // stage 2

/datum/component/internal_wound/organic/penetrating2	 // stage 2
	name = "accessible penetrating brain injury"
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_BRAINHEAL = 1)
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE


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
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 4)
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_HARD)
	scar = list(/datum/component/internal_wound/organic/rip2)

/datum/component/internal_wound/organic/rip2
	name = "tighted ripped brain fibers"
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_BRAINHEAL = 1)
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

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

/datum/component/internal_wound/organic/brain_burn/brain_matter
	name = "burnt brain matter"
/datum/component/internal_wound/organic/brain_burn/cooked
	name = "well-cooked brain"
	treatments_item = list(/obj/item/stack/medical/advanced/ointment = 4)
/datum/component/internal_wound/organic/brain_burn/incinerate
	name = "incinerated brain fibers"

//---------------------------------------------------------------------------------------------
//----------------------------------------PROSTHETICS------------------------------------------
//---------------------------------------------------------------------------------------------

// Blunt
/datum/component/internal_wound/robotic/brain_blunt
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_HAMMERING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.55)		// repair nanites + 3 metals OR repair nanite OD + a metal 
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/robotic/brain_blunt/malfunction
	name = "damaged neural processor"
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
/datum/component/internal_wound/robotic/brain_blunt/voxel
	name = "voxel matrix deformation"
	treatments_tool = list(QUALITY_LASER_CUTTING = FAILCHANCE_HARD)
/datum/component/internal_wound/robotic/brain_blunt/loose
	name = "loose calculation coupling"
	treatments_tool = list(QUALITY_HAMMERING = FAILCHANCE_HARD)


/*
/datum/component/internal_wound/robotic/blunt/bent
	name = "bent structure"

/datum/component/internal_wound/robotic/blunt/crack
	name = "cracked frame"
*/

// Sharp
/datum/component/internal_wound/robotic/brain_sharp
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.85)
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/robotic/brain_sharp/puncture
	name = "punctured structure"

/datum/component/internal_wound/robotic/brain_sharp/shell
	name = "wrecked brain shell"
	treatments_tool = list(QUALITY_WELDING = FAILCHANCE_HARD)

/datum/component/internal_wound/robotic/brain_sharp/nand1
	name = "broken NAND circuit loop"
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	scar = /datum/component/internal_wound/robotic/nand2

/datum/component/internal_wound/robotic/nand2
	name = "broken NAND circuit loop"
	treatments_tool = list(QUALITY_PULSING = FAILCHANCE_HARD)

// Edge
/datum/component/internal_wound/robotic/brain_edge
	treatments_item = list(/obj/item/stack/cable_coil = 5, /obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.85)
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/robotic/brain_edge/trimmed
	name = "trimmed down VRAM"
	treatments_tool = list(QUALITY_WELDING = FAILCHANCE_HARD)

/datum/component/internal_wound/robotic/brain_edge/disheveled
	name = "cut fiber-optic cord"
	treatments_tool = list(QUALITY_BOLT_TURNING = FAILCHANCE_HARD)

/datum/component/internal_wound/robotic/brain_edge/shred1
	name = "scrapped bracing"
	treatments_tool = list(QUALITY_PRYING = FAILCHANCE_HARD)
	scar = /datum/component/internal_wound/robotic/shred2

/datum/component/internal_wound/robotic/shred2
	name = "scrapped bracing"
	treatments_tool = list(QUALITY_WELDING = FAILCHANCE_HARD)

/*
/datum/component/internal_wound/robotic/edge/short
	name = "electrical short"

/datum/component/internal_wound/robotic/edge/arc
	name = "arcing"
*/

// EMP/burn wounds
/datum/component/internal_wound/robotic/brain_emp_burn
	treatments_item = list(/obj/item/stack/cable_coil = 5, /obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.95)	// repair nanite OD + all metals
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/robotic/overheat
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	characteristic_flag = IWOUND_HALLUCINATE

/datum/component/internal_wound/robotic/brain_emp_burn/elec_malfunction
	name = "electrical malfunction"
	treatments_tool = list(QUALITY_PULSING = FAILCHANCE_HARD)

/datum/component/internal_wound/robotic/brain_emp_burn/cognitive_disorder
	name = "cognitive circuit disorder"
	treatments_tool = list(QUALITY_CAUTERIZE = FAILCHANCE_HARD)

/datum/component/internal_wound/robotic/brain_emp_burn/upturned
	name = "upturned memory stack" 
	treatments_tool = list(QUALITY_PRYING = FAILCHANCE_HARD) // gotta put it the way it was!
