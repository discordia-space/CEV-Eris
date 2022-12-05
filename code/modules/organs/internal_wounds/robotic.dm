/datum/component/internal_wound/robotic
	diagnosis_stat = STAT_MEC
	diagnosis_difficulty = STAT_LEVEL_BASIC
	wound_nature = MODIFICATION_SILICON

// Blunt
/datum/component/internal_wound/robotic/blunt
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_HAMMERING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_MECH_REPAIR = 0.55)		// repair nanites + 3 metals OR repair nanite OD + a metal
	scar = /datum/component/internal_wound/robotic/deformation
	severity = 0
	severity_max = 5
	progression_threshold = IWOUND_4_MINUTES
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE

/datum/component/internal_wound/robotic/blunt/malfunction
	name = "mechanical malfunction"

/datum/component/internal_wound/robotic/blunt/deformation
	name = "bent structure"

/datum/component/internal_wound/robotic/blunt/crack
	name = "cracked frame"

// Sharp
/datum/component/internal_wound/robotic/sharp
	treatments_item = list(/obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_SEALING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_MECH_REPAIR = 0.85)		// repair nanites + 6 metals OR repair nanite OD + 7 metals
	severity = 0
	severity_max = 5
	progression_threshold = IWOUND_4_MINUTES
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE

/datum/component/internal_wound/robotic/sharp/perforation
	name = "perforation"

/datum/component/internal_wound/robotic/sharp/leak
	name = "weeping leak"

/datum/component/internal_wound/robotic/sharp/pressure
	name = "pressure failure"

// Edge
/datum/component/internal_wound/robotic/edge
	treatments_item = list(/obj/item/stack/cable_coil = 5, /obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_MECH_REPAIR = 0.85)
	severity = 0
	severity_max = 5
	progression_threshold = IWOUND_4_MINUTES
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE

/datum/component/internal_wound/robotic/edge/short
	name = "electrical short"

/datum/component/internal_wound/robotic/edge/cut
	name = "exposed wiring"

/datum/component/internal_wound/robotic/edge/arc
	name = "arcing"

// EMP/burn wounds
/datum/component/internal_wound/robotic/emp_burn
	treatments_item = list(/obj/item/stack/cable_coil = 5, /obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_PULSING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_MECH_REPAIR = 0.95)	// repair nanite OD + all metals
	severity = 0
	severity_max = 7
	progression_threshold = IWOUND_2_MINUTES
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE

/datum/component/internal_wound/robotic/emp_burn/elec_malfunction
	name = "electrical malfunction"

/datum/component/internal_wound/robotic/emp_burn/overheat
	name = "overheating component"
	treatments_item = list(/obj/item/stack/cable_coil = 5, /obj/item/stack/nanopaste = 1)
	treatments_tool = list(QUALITY_PULSING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_MECH_STABLE = 2.5)	// coolant + refrigerant

// Tox
/datum/component/internal_wound/robotic/build_up
	treatments_tool = list(QUALITY_PRYING = FAILCHANCE_NORMAL)	// Pop it out and replace the filter
	treatments_chem = list(CE_MECH_ACID = 1)		// sulphiric acid
	severity = 0
	severity_max = 3
	next_wound = /datum/component/internal_wound/robotic/corrosion
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE

/datum/component/internal_wound/robotic/build_up/filter
	name = "clogged filter"

/datum/component/internal_wound/robotic/build_up/fod
	name = "foreign object debris"

// Other wounds
/datum/component/internal_wound/robotic/corrosion
	treatments_chem = list(CE_MECH_ACID = 1.5)	// sulphiric + hydrochloric acid or poly acid
	scar = /datum/component/internal_wound/robotic/blunt	// Cleaning corrosion involves removing material
	severity = 0
	severity_max = 4
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE

/datum/component/internal_wound/robotic/corrosion/standard
	name = "corrosion"

/datum/component/internal_wound/robotic/corrosion/rust
	name = "rust"

/datum/component/internal_wound/robotic/deformation
	name = "plastic deformation"
	treatments_item = list(/obj/item/stack/nanopaste = 5)
	treatments_tool = list(QUALITY_WELDING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_MECH_REPAIR = 0.95)	// repair nanite OD + all metals
	severity = 4
	severity_max = 4
	hal_damage = IWOUND_INSIGNIFICANT_DAMAGE
	status_flag = ORGAN_BROKEN
