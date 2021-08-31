//Iam aware that reagents are suppose to go in the reagent module, but for now eayer acces is prefered. Todo move it to propper locations

/datum/reagent/medicine/atropine
    name = "atropine"
    id = "atropine"
    description = "A chemical found in a specific berry, helps with ACS and other heart problems."
    taste_description = "bitterness"
    color = "#000000"
    reagent_state = LIQUID
    metabolism = REM * 0.5
    scannable = 1
    overdose = REAGENTS_OVERDOSE
    metabolism = 0.1

/datum/reagent/medicine/atropine/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
    M.add_chemical_effect(CE_STABLE)
    M.add_chemical_effect(CE_PAINKILLER, 20 * effect_multiplier)
    M.add_chemical_effect(CE_PULSE, 1)
    M.adjustOxyLoss(-1 * effect_multiplier)
    M.add_chemical_effect(CE_OXYGENATED, 1)

/datum/reagent/medicine/atropine/overdose(var/mob/living/carbon/M, var/alien)
    ..()
    //just right that dexaline could counter act it
    M.adjustOxyLoss(1.4)

