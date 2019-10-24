/* Drugs */
/datum/reagent/drug
	reagent_type = "Drug"


/datum/reagent/drug/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	taste_description = "bitterness"
	taste_mult = 0.4
	reagent_state = LIQUID
	color = "#60A584"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	addiction_chance = 100

/datum/reagent/drug/space_drugs/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.druggy = max(M.druggy, 15 * effect_multiplier)
	if(prob(10 * effect_multiplier) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))
	if(prob(7 * effect_multiplier))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
	M.add_chemical_effect(CE_PULSE, -1)


/datum/reagent/drug/serotrotium
	name = "Serotrotium"
	id = "serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#202040"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	addiction_threshold = 20
	addiction_chance = 10

/datum/reagent/drug/serotrotium/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(7 * effect_multiplier))
		M.emote(pick("twitch", "drool", "moan", "gasp"))


/datum/reagent/drug/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#000055"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/drug/cryptobiolin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.make_dizzy(4 * effect_multiplier)
	M.confused = max(M.confused, 20 * effect_multiplier)


/datum/reagent/drug/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/drug/impedrezene/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.jitteriness = max(M.jitteriness - (5 * effect_multiplier), 0)
	if(prob(80))
		M.adjustBrainLoss(0.1 * effect_multiplier)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3 * effect_multiplier)
	if(prob(10))
		M.emote("drool")


/datum/reagent/drug/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen, it can cause fatal effects in users."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#B31008"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE

/datum/reagent/drug/mindbreaker/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.hallucination(50 * effect_multiplier, 50 * effect_multiplier)


/datum/reagent/drug/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "A strong psycotropic derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#E700E7"
	overdose = REAGENTS_OVERDOSE * 0.66
	metabolism = REM * 0.5
	addiction_chance = 10
	nerve_system_accumulations = 40
	reagent_type = "Drugs/Stimulator"

/datum/reagent/drug/psilocybin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.druggy = max(M.druggy, 30 * effect_multiplier)
	
	var/effective_dose = dose
	if(issmall(M)) effective_dose *= 2
	if(effective_dose < 1)
		M.apply_effect(3, STUTTER)
		M.make_dizzy(5)
		M.stats.addTempStat(STAT_COG, STAT_LEVEL_BASIC, STIM_TIME, "psilocybin")
		M.hallucination(50, 50)
		if(prob(5))
			M.emote(pick("twitch", "giggle"))
	else if(effective_dose < 2)
		M.apply_effect(3, STUTTER)
		M.make_jittery(5)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		if(prob(10))
			M.emote(pick("twitch", "giggle"))
	else
		M.apply_effect(3, STUTTER)
		M.make_jittery(10)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		M.stats.addTempStat(STAT_COG, STAT_LEVEL_ADEPT, STIM_TIME, "psilocybin")
		M.hallucination(100, 50)
		if(prob(15))
			M.emote(pick("twitch", "giggle"))

/datum/reagent/drug/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A highly addictive stimulant extracted from the tobacco plant."
	taste_description = "pepper"
	reagent_state = LIQUID
	color = "#181818"
	overdose = REAGENTS_OVERDOSE/2
	addiction_chance = 20
	nerve_system_accumulations = 10

/datum/reagent/drug/nicotine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.add_chemical_effect(CE_PULSE, 1)
	M.add_chemical_effect(CE_PAINKILLER, 5 * effect_multiplier)

/datum/reagent/drug/nicotine/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "nicotine_w")

/datum/reagent/drug/nicotine/overdose(var/mob/living/carbon/M, var/alien)
	M.add_side_effect("Headache", 11)
	if(prob(5))
		M.vomit()
	M.adjustToxLoss(0.5)

/datum/reagent/drug/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.66
	withdrawal_threshold = 10
	nerve_system_accumulations = 70
	reagent_type = "Drug/Stimulator"

/datum/reagent/drug/hyperzine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/drug/hyperzine/withdrawal_act(mob/living/carbon/M)
	M.add_chemical_effect(CE_SPEEDBOOST, -1)
	M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/drug/sanguinum
	name = "Sanguinum"
	id = "sanguinum"
	description = "Forces bone marrow to produce more blood than usual. Have irritating side effects"
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#e06270"
	metabolism = REM
	overdose = REAGENTS_OVERDOSE/2
	nerve_system_accumulations = 80
	addiction_chance = 30

/datum/reagent/drug/sanguinum/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_BLOODRESTORE, 1.6 * effect_multiplier)
	if(prob(2))
		spawn 
			M.emote("me", 1, "coughs up blood!")
		M.drip_blood(10)

/datum/reagent/drug/sanguinum/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "sanguinum_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "sanguinum_w")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "sanguinum_w")

/datum/reagent/drug/sanguinum/overdose(var/mob/living/carbon/M, var/alien)
	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/list/obj/item/organ/external/bodyParts = locate(/obj/item/organ/external) in H.organs_by_name
		var/chanceToRupture = 30
		for(var/obj/item/organ/external/E in bodyParts)
			if(E.has_internal_bleeding())
				chanceToRupture -= 10
		chanceToRupture = max(0,chanceToRupture)
		if(prob(chanceToRupture))
			var/list/obj/item/organ/external/unluckyPart = pick(bodyParts)
			var/datum/wound/internal_bleeding/I = new (15)
			unluckyPart.wounds += I
