// These are produced by organs. They should rarely appear elsewhere.
/datum/reagent/hormone
	name = "hormone"
	id = "hormone"
	reagent_state = LIQUID
	metabolism = REM
	scannable = TRUE
	constant_metabolism = TRUE			// We want these to get used up before the aberrant cooldown is over
	nerve_system_accumulations = 0		// These are hormones
	appear_in_default_catalog = TRUE
	reagent_type = "Hormone"
	var/hormone_type = 1		// Used for organ function info
	var/list/effects = list()	// "effect" = magnitude

/datum/reagent/hormone/on_mob_add(mob/living/L)
	. = ..()
	if(!LAZYLEN(effects))
		remove_self(volume)

/datum/reagent/hormone/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	for(var/effect in effects)
		M.add_chemical_effect(effect, effects[effect])

/datum/reagent/hormone/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	return

/datum/reagent/hormone/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	return

// =================================================
// ===============     STANDARD     ================
// =================================================

// Blood clotting
/datum/reagent/hormone/bloodclot
	name = "blood clotting hormone"
	id = "bloodclot_t1"
	effects = list(CE_BLOODCLOT = 0.15)

/datum/reagent/hormone/bloodclot/type_2
	id = "bloodclot_t2"
	hormone_type = 2

/datum/reagent/hormone/bloodclot/type_3
	id = "bloodclot_t3"
	hormone_type = 3
	effects = list(CE_BLOODCLOT = 0.20)

// Blood restoration
/datum/reagent/hormone/bloodrestore
	name = "blood regeneration hormone"
	id = "bloodrestore_t1"
	effects = list(CE_BLOODRESTORE = 0.3)

/datum/reagent/hormone/bloodrestore/type_2
	id = "bloodrestore_t2"
	hormone_type = 2

/datum/reagent/hormone/bloodrestore/type_3
	id = "bloodrestore_t3"
	hormone_type = 3
	effects = list(CE_BLOODRESTORE = 0.4)

// Painkiller
/datum/reagent/hormone/painkiller
	name = "painkiller hormone"
	id = "painkiller_t1"
	effects = list(CE_PAINKILLER = 10)

/datum/reagent/hormone/painkiller/type_2
	id = "painkiller_t2"
	hormone_type = 2

/datum/reagent/hormone/painkiller/type_3
	id = "painkiller_t3"
	hormone_type = 3
	effects = list(CE_PAINKILLER = 20)

// Speed boost
/datum/reagent/hormone/speedboost
	name = "agility augment hormone"
	id = "speedboost_t1"
	effects = list(CE_SPEEDBOOST = 0.15)

/datum/reagent/hormone/speedboost/type_2
	id = "speedboost_t2"
	hormone_type = 2

/datum/reagent/hormone/speedboost/type_3
	id = "speedboost_t3"
	hormone_type = 3
	effects = list(CE_SPEEDBOOST = 0.20)

// Anti-toxin
/datum/reagent/hormone/antitox
	name = "antitoxin hormone"
	id = "antitoxin_t1"
	effects = list(CE_ANTITOX = 0.25)

/datum/reagent/hormone/antitox/type_2
	id = "antitoxin_t2"
	hormone_type = 2

/datum/reagent/hormone/antitox/type_3
	id = "antitoxin_t3"
	hormone_type = 3
	effects = list(CE_ANTITOX = 0.50)

// Oxygenation
/datum/reagent/hormone/oxygenation
	name = "oxygenation hormone"
	id = "oxygenation_t1"
	effects = list(CE_OXYGENATED = 0.25)

/datum/reagent/hormone/oxygenation/type_2
	id = "oxygenation_t2"
	hormone_type = 2

/datum/reagent/hormone/oxygenation/type_3
	id = "oxygenation_t3"
	hormone_type = 3
	effects = list(CE_OXYGENATED = 0.50)
