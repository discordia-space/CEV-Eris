//Iam aware that reagents are suppose to go in the reagent69odule, but for69ow eayer acces is prefered. Todo69ove it to propper locations

/datum/reagent/medicine/atropine
   69ame = "atropine"
    id = "atropine"
    description = "A chemical found in a specific berry, helps with ACS and other heart problems."
    taste_description = "bitterness"
    color = "#000000"
    reagent_state = LIQUID
   69etabolism = REM * 0.5
    scannable = 1
    overdose = REAGENTS_OVERDOSE
   69etabolism = 0.1

/datum/reagent/medicine/atropine/affect_blood(var/mob/living/carbon/M,69ar/alien,69ar/effect_multiplier)
   69.add_chemical_effect(CE_STABLE)
   69.add_chemical_effect(CE_PAINKILLER, 20 * effect_multiplier)
   69.add_chemical_effect(CE_PULSE, 1)
   69.adjustOxyLoss(-1 * effect_multiplier)
   69.add_chemical_effect(CE_OXYGENATED, 1)

/datum/reagent/medicine/atropine/overdose(var/mob/living/carbon/M,69ar/alien)
    ..()
    //just right that dexaline could counter act it
   69.adjustOxyLoss(1.4)

