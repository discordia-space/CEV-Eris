// These are produced by organs. They should rarely appear elsewhere.
/datum/reagent/hormone
	name = "hormone"
	id = "hormone"
	reagent_state = LIQUID
	metabolism = REM
	scannable = FALSE					// Don't need these clogging up reagent lists on the health scanner
	constant_metabolism = TRUE			// We want these to get used up before the aberrant cooldown is over
	nerve_system_accumulations = 0		// These are hormones
	appear_in_default_catalog = FALSE
	reagent_type = "Hormone"
	var/hormone_type = 1	// Used for organ function info
	var/list/effects = list()	// "effect" = magnitude

/datum/reagent/hormone/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(!effects?.len)
		return

	for(var/effect in effects)
		M.add_chemical_effect(effect, effects[effect])

/datum/reagent/hormone/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	return

/datum/reagent/hormone/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	return

// Blood clotting
/datum/reagent/hormone/bloodclot
	name = "thrombopoietin"		// Increases platelet (clotting stuff) production
	id = "thrombopoietin"
	effects = list(CE_BLOODCLOT = 0.25)

/datum/reagent/hormone/bloodclot/alt
	name = "thromboxane"		// Produced by platelets to encourage stronger clots
	id = "thromboxane"
	hormone_type = 2

// Blood restoration
/datum/reagent/hormone/bloodrestore
	name = "aldosterone"		// Increases blood volume as a result of its IRL effects
	id = "aldosterone"
	effects = list(CE_BLOODRESTORE = 0.4)

/datum/reagent/hormone/bloodrestore/alt
	name = "erythropoietin"		// Stimulates red blood cell production
	id = "erythropoietin"
	hormone_type = 2

// Painkiller
/datum/reagent/hormone/painkiller
	name = "enkephalin"			// Regulates nociception (pain response)
	id = "enkephalin"
	effects = list(CE_PAINKILLER = 20)

/datum/reagent/hormone/painkiller/alt
	name = "endomorphin"		// Regulates nociception (pain response)
	id = "endomorphin"
	hormone_type = 2

// Speed boost
/datum/reagent/hormone/speedboost
	name = "osteocalcin"		// Increases energy availability in muscles among other things, probably close enough
	id = "osteocalcin"
	effects = list(CE_SPEEDBOOST = 0.25)

/datum/reagent/hormone/speedboost/alt
	name = "noradrenaline"		// Fight or flight hormone
	id = "noradrenaline"
	hormone_type = 2

// Anti-toxin
/datum/reagent/hormone/antitox
	name = "leukotriene"		// Produced by white blood cells, probably doesn't help against toxins IRL
	id = "leukotriene"
	effects = list(CE_ANTITOX = 0.5)	// Antitox doesn't do much on its own, but it's something

/datum/reagent/hormone/antitox/alt
	name = "histamine"			// Produced as part of the immune response, probably doesn't help against toxins IRL
	id = "histamine"
	hormone_type = 2

// Oxygenation
/datum/reagent/hormone/oxygenation
	name = "dexterone"			// Dexalin + progesterone, the only hormone I found that has something to do with cell oxygen levels; close enough
	id = "dexterone"
	effects = list(CE_OXYGENATED = 1)

/datum/reagent/hormone/oxygenation/alt
	name = "vasotriene"			// Vasokin from Star Trek
	id = "vasotriene"
	hormone_type = 2
