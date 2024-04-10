// Organs
/datum/design/organ/scaffold
	category = "Aberrant"
	build_path = /obj/item/organ/internal/scaffold
	starts_unlocked = TRUE

/datum/design/organ/scaffold/large
	build_path = /obj/item/organ/internal/scaffold/large
	starts_unlocked = FALSE

/datum/design/organ/aberrant_organ
	category = "Aberrant"
	starts_unlocked = FALSE

/datum/design/organ/aberrant_organ/scrub_toxin_blood
	build_path = /obj/item/organ/internal/scaffold/aberrant/scrub_toxin/blood
	
/datum/design/organ/aberrant_organ/scrub_toxin_ingest
	build_path = /obj/item/organ/internal/scaffold/aberrant/scrub_toxin/ingest
	
/datum/design/organ/aberrant_organ/scrub_toxin_touch
	build_path = /obj/item/organ/internal/scaffold/aberrant/scrub_toxin/touch
	
/datum/design/organ/aberrant_organ/gastric
	build_path = /obj/item/organ/internal/scaffold/aberrant/gastric
	
/datum/design/organ/aberrant_organ/damage_response
	build_path = /obj/item/organ/internal/scaffold/aberrant/damage_response


// Mods
/datum/design/organ/organ_mod
	category = "Modifications"
	starts_unlocked = TRUE

/datum/design/organ/organ_mod/capillaries
	build_path = /obj/item/modification/organ/internal/stromal/requirements

/datum/design/organ/organ_mod/durable_membrane
	build_path = /obj/item/modification/organ/internal/stromal/durability

/datum/design/organ/organ_mod/stem_cells
	build_path = /obj/item/modification/organ/internal/stromal/efficiency

/datum/design/organ/organ_mod/expander
	build_path = /obj/item/modification/organ/internal/stromal/expander

/datum/design/organ/organ_mod/overclock
	build_path = /obj/item/modification/organ/internal/stromal/overclock

/datum/design/organ/organ_mod/underclock
	build_path = /obj/item/modification/organ/internal/stromal/underclock

/datum/design/organ/organ_mod/silencer
	build_path = /obj/item/modification/organ/internal/stromal/silencer

/datum/design/organ/organ_mod/parenchymal
	build_path = /obj/item/modification/organ/internal/parenchymal

/datum/design/organ/organ_mod/parenchymal_large
	build_path = /obj/item/modification/organ/internal/parenchymal/large
	starts_unlocked = FALSE


// Teratomas
/datum/design/organ/teratoma
	category = "Teratoma"
	starts_unlocked = FALSE


/datum/design/organ/teratoma/input
	category = "Inputs"
	starts_unlocked = TRUE

/datum/design/organ/teratoma/input/reagents_roach
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/roach
	starts_unlocked = FALSE

/datum/design/organ/teratoma/input/reagents_spider
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/spider

/datum/design/organ/teratoma/input/reagents_toxin
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/toxin

/datum/design/organ/teratoma/input/reagents_edible
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/edible

/datum/design/organ/teratoma/input/reagents_alcohol
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/alcohol

/datum/design/organ/teratoma/input/reagents_drugs
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/drugs

/datum/design/organ/teratoma/input/reagents_dispenser
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/dispenser

/datum/design/organ/teratoma/input/consume
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/consume

/datum/design/organ/teratoma/input/damage_basic
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/damage/basic
	starts_unlocked = FALSE

/datum/design/organ/teratoma/input/damage_all
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/damage/all
	starts_unlocked = FALSE

/datum/design/organ/teratoma/input/power_source
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/input/power_source
	starts_unlocked = FALSE


/datum/design/organ/teratoma/process
	category = "Processes"
	starts_unlocked = TRUE

/datum/design/organ/teratoma/process/map
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/process/map

/datum/design/organ/teratoma/process/multiplier
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier
	starts_unlocked = FALSE

/datum/design/organ/teratoma/process/multiplier/negative_low
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier/negative_low
	starts_unlocked = FALSE

/datum/design/organ/teratoma/process/multiplier/negative
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier/negative
	starts_unlocked = FALSE

/datum/design/organ/teratoma/process/multiplier/low
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier/low
	starts_unlocked = FALSE

/datum/design/organ/teratoma/process/multiplier/high
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier/high
	starts_unlocked = FALSE

/datum/design/organ/teratoma/process/cooldown
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/process/cooldown
	starts_unlocked = FALSE

/datum/design/organ/teratoma/process/cooldown/long
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/process/cooldown/long
	starts_unlocked = FALSE

/datum/design/organ/teratoma/process/cooldown/negative
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/process/cooldown/negative
	starts_unlocked = FALSE


/datum/design/organ/teratoma/output
	category = "Outputs"
	starts_unlocked = TRUE

/datum/design/organ/teratoma/output/reagents_blood_drugs
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/drugs

/datum/design/organ/teratoma/output/reagents_blood_industrial
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/industrial

/datum/design/organ/teratoma/output/reagents_blood_roach
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/roach
	starts_unlocked = FALSE

/datum/design/organ/teratoma/output/reagents_blood_spider
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/spider
	starts_unlocked = FALSE

/datum/design/organ/teratoma/output/reagents_blood_dispenser_base
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/dispenser_base
	starts_unlocked = FALSE

/datum/design/organ/teratoma/output/reagents_blood_dispenser_one
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/dispenser_one
	starts_unlocked = FALSE

/datum/design/organ/teratoma/output/reagents_blood_dispenser_two
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/dispenser_two
	starts_unlocked = FALSE

/datum/design/organ/teratoma/output/reagents_blood_fungal
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/fungal
	starts_unlocked = FALSE

/datum/design/organ/teratoma/output/reagents_ingest_edible
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/edible

/datum/design/organ/teratoma/output/reagents_ingest_alcohol
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/alcohol

/datum/design/organ/teratoma/output/chemical_effects_type_1
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/type_1

/datum/design/organ/teratoma/output/chemical_effects_type_2
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/type_2
	starts_unlocked = FALSE

/datum/design/organ/teratoma/output/stat_boost
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/stat_boost

/datum/design/organ/teratoma/output/produce
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/produce
	starts_unlocked = FALSE

/datum/design/organ/teratoma/output/produce_light_antag
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/produce/light_antag
	starts_unlocked = FALSE

/datum/design/organ/teratoma/output/chem_smoke
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/output/chem_smoke
	starts_unlocked = FALSE


/datum/design/organ/teratoma/special
	category = "Secondary"
	starts_unlocked = FALSE

/datum/design/organ/teratoma/special/chemical_effects
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/special/chemical_effect

/datum/design/organ/teratoma/special/stat_boost
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/special/stat_boost

/datum/design/organ/teratoma/special/symbiotic_parasite
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/special/parasitic

/datum/design/organ/teratoma/special/symbiotic_commensal
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/special/commensal

/datum/design/organ/teratoma/special/symbiotic_mutual
	build_path = /obj/item/organ/internal/scaffold/aberrant/teratoma/special/mutual

// Machinery
/datum/design/viscera
	starts_unlocked = FALSE		// Not meant to be researched

/datum/design/viscera/organ_fabricator
	build_path = /obj/item/electronics/circuitboard/organ_fabricator

/datum/design/viscera/disgorger
	build_path = /obj/item/electronics/circuitboard/disgorger
