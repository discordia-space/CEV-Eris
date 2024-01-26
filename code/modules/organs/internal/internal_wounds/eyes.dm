// Blunt
/datum/component/internal_wound/organic/eyes_blunt
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_HARD)
	treatments_chem = list(CE_EYEHEAL = 1)
	severity = 0
	severity_max = 3 // with 3 health it takes around 3 wounds to kill eyes
	hal_damage = IWOUND_MEDIUM_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/organic/eyes_blunt/dissection
	name = "retinal dissection"

/datum/component/internal_wound/organic/eyes_blunt/erosion //PAINFUL
	name = "corneal erosion"
	hal_damage = IWOUND_HEAVY_DAMAGE

/datum/component/internal_wound/organic/eyes_blunt/iris //iris hehehehe 
	name = "iris tears"

// Sharp

/datum/component/internal_wound/organic/eyes_sharp
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_LASER_CUTTING = FAILCHANCE_HARD)
	treatments_chem = list(CE_EYEHEAL = 1)
	severity = 0
	severity_max = 3
	hal_damage = IWOUND_MEDIUM_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/organic/eyes_sharp/cataract
	name = "traumatic cataract"

/datum/component/internal_wound/organic/eyes_sharp/perforation
	name = "superonasal perforation"

/datum/component/internal_wound/organic/eyes_sharp/matter
	name = "foreign matter"
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_HARD)

// Edge
/datum/component/internal_wound/organic/eyes_edge
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_EYEHEAL = 1)
	severity = 0
	severity_max = 3
	hal_damage = IWOUND_MEDIUM_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/organic/eyes_edge/laceration
	name = "globe laceration"

/datum/component/internal_wound/organic/eyes_edge/retina
	name = "cut retina"

/datum/component/internal_wound/organic/eyes_edge/slice
	name = "sliced vascular layer"

// Burn

/datum/component/internal_wound/organic/eyes_burn
	treatments_item = list(/obj/item/stack/medical/advanced/ointment = 2)
	treatments_tool = list(QUALITY_LASER_CUTTING = FAILCHANCE_HARD)
	treatments_chem = list(CE_EYEHEAL = 1)
	scar = /datum/component/internal_wound/organic/necrosis_start
	severity = 0
	severity_max = 3
	next_wound = /datum/component/internal_wound/organic/infection
	hal_damage = IWOUND_MEDIUM_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/organic/eyes_burn/burnt
	name = "burnt external fibrous layer"

/datum/component/internal_wound/organic/eyes_burn/char
	name = "charred sclera"

/datum/component/internal_wound/organic/eyes_burn/scorch
	name = "scorched deep tissue"
	treatments_tool = list(QUALITY_RETRACTING = FAILCHANCE_HARD)
	scar = /datum/component/internal_wound/organic/eyes_deep_burn

/datum/component/internal_wound/organic/eyes_deep_burn/stage2 //stage 2
	name = "scorched deep tissue"
	treatments_item = list(/obj/item/stack/medical/advanced/ointment = 2)
	treatments_chem = list(CE_EYEHEAL = 1)
	severity = 3 //starting at max damage because stage 2
	severity_max = 3
	hal_damage = IWOUND_HEAVY_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

// Tox (toxins)
/datum/component/internal_wound/organic/eyes_poisoning
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 1)
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_HARD)
	treatments_chem = list(CE_ANTITOX = 2)
	severity = 0
	severity_max = 3
	hal_damage = IWOUND_LIGHT_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/// Cheap hack, but prevents unbalanced toxins from killing someone immediately
/datum/component/internal_wound/organic/eyes_poisoning/InheritComponent()
	if(prob(5))
		progress()

/datum/component/internal_wound/organic/eyes_poisoning/pustule
	name = "vitreous pustule"
	specific_organ_size_multiplier = 0.20

/datum/component/internal_wound/organic/eyes_poisoning/intoxication
	name = "sclera intoxication"
	blood_req_multiplier = 0.25
	nutriment_req_multiplier = 0.25
	oxygen_req_multiplier = 0.25

/datum/component/internal_wound/organic/eyes_poisoning/accumulation
	name = "lens foreign accumulation"
	hal_damage = IWOUND_MEDIUM_DAMAGE

/// Robotic

// Blunt
/datum/component/internal_wound/robotic/eyes_blunt
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_SCREW_DRIVING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.55)		// repair nanites + 3 metals OR repair nanite OD + a metal
	severity = 0
	severity_max = 3
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/robotic/eyes_blunt/lense
	name = "misplaced lense"
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_HARD)

/datum/component/internal_wound/robotic/eyes_blunt/jam
    name = "jammed mechanics"

/datum/component/internal_wound/robotic/eyes_blunt/matrix
	name = "disconnected matrix"
	organ_efficiency_multiplier = -1 // can't see anything because of loose wire

// Sharp

/datum/component/internal_wound/robotic/eyes_sharp
	treatments_item = list(/obj/item/stack/nanopaste = 2)
	treatments_tool = list()
	treatments_chem = list(CE_MECH_REPAIR = 0.85)		// repair nanites + 6 metals OR repair nanite OD + 7 metals
	severity = 0
	severity_max = 3
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/robotic/eyes_sharp/prism
	name = "fractured prism"
	treatments_tool = list(QUALITY_ADHESIVE = FAILCHANCE_HARD)

/datum/component/internal_wound/robotic/eyes_sharp/shatter
	name = "shattered thin-film transistor"
	treatments_chem = list(CE_MECH_REPAIR = 0.20)

/datum/component/internal_wound/robotic/eyes_sharp/failure
	name = "mechanical matrix failure"
	treatments_item = list(/obj/item/stock_parts/scanning_module = 1, /obj/item/stack/nanopaste = 2)

// Edge
/datum/component/internal_wound/robotic/eyes_edge
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.85)
	severity = 0
	severity_max = 3
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/robotic/eyes_edge/ocular
	name = "scratched ocular"

/datum/component/internal_wound/robotic/eyes_edge/focuser
	name = "torn focuser"

/datum/component/internal_wound/robotic/eyes_edge/slice
	name = "sliced open optical cord"
	treatments_item = list(/obj/item/stack/cable_coil = 5)

// EMP/burn wounds

/datum/component/internal_wound/robotic/eyes_emp_burn
	treatments_item = list(/obj/item/stack/cable_coil = 5)
	treatments_tool = list(QUALITY_WIRE_CUTTING = FAILCHANCE_HARD)
	treatments_chem = list(CE_MECH_REPAIR = 0.95)	// repair nanite OD + all metals
	severity = 0
	severity_max = 3
	next_wound = /datum/component/internal_wound/robotic/eyes_overheat
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/robotic/eyes_emp_burn/pixels
	name = "burnt matrix pixels"
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_PULSING = FAILCHANCE_HARD)

/datum/component/internal_wound/robotic/eyes_emp_burn/inverse
	name = "inversed movement axis"
	treatments_tool = list(QUALITY_SCREW_DRIVING = FAILCHANCE_HARD)
/datum/component/internal_wound/robotic/eyes_emp_burn/carbonized
	name = "mangled wiring"

/datum/component/internal_wound/robotic/eyes_overheat
	treatments_item = list(/obj/item/stack/cable_coil = 10, /obj/item/stack/nanopaste = 2)
	treatments_chem = list(CE_MECH_STABLE = 0.5)	// coolant or refrigerant
	severity = 0
	severity_max = IORGAN_MAX_HEALTH
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/robotic/eyes_overheat/standard
	name = "overheating link"

/datum/component/internal_wound/robotic/eyes_overheat/alt
	name = "thermal blackout"
	organ_efficiency_multiplier = -1

// Tox - UNUSED
/datum/component/internal_wound/robotic/eyes_build_up
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_HARD)	// Clear any clog wtih a thin tool
	treatments_chem = list(CE_MECH_ACID = 1)		// sulphiric acid
	severity = 0
	severity_max = 3
	next_wound = /datum/component/internal_wound/robotic/corrosion
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	diagnosis_difficulty = STAT_LEVEL_EXPERT

/datum/component/internal_wound/robotic/eyes_build_up/breach
	name = "breached bioisolation"
	treatments_tool = list(QUALITY_ADHESIVE = FAILCHANCE_HARD)
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_chem = list(CE_MECH_REPAIR = 0.30)

/datum/component/internal_wound/robotic/eyes_build_up/clog
	name = "clogged circuitry"
	severity_max = 5
	hal_damage = IWOUND_MEDIUM_DAMAGE
