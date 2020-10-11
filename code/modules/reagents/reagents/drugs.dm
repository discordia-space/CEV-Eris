/* Drugs */
/datum/reagent/drug
	reagent_type = "Drug"
	sanity_gain = 0.5

/datum/reagent/drug/on_mob_add(mob/living/L)
	..()
	SEND_SIGNAL(L, COMSIG_CARBON_HAPPY, src, MOB_ADD_DRUG)

/datum/reagent/drug/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(sanity_gain)
		var/mob/living/carbon/human/H = M
		if(istype(H))
			H.sanity.onDrug(src, effect_multiplier)
		SEND_SIGNAL(M, COMSIG_CARBON_HAPPY, src, ON_MOB_DRUG)

/datum/reagent/drug/on_mob_delete(mob/living/L)
	..()
	SEND_SIGNAL(L, COMSIG_CARBON_HAPPY, src, MOB_DELETE_DRUG)

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
	sanity_gain = 1.5

/datum/reagent/drug/space_drugs/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.druggy = max(M.druggy, 15 * effect_multiplier)
	if(prob(10 * effect_multiplier) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))
	if(prob(7 * effect_multiplier))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
	M.add_chemical_effect(CE_PULSE, -1)
	..()


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
	sanity_gain = 1.5

/datum/reagent/drug/serotrotium/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(7 * effect_multiplier))
		M.emote(pick("twitch", "drool", "moan", "gasp"))
	..()


/datum/reagent/drug/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#000055"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	sanity_gain = 1

/datum/reagent/drug/cryptobiolin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.make_dizzy(4 * effect_multiplier)
	M.confused = max(M.confused, 20 * effect_multiplier)
	..()


/datum/reagent/drug/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	sanity_gain = 1

/datum/reagent/drug/impedrezene/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.jitteriness = max(M.jitteriness - (5 * effect_multiplier), 0)
	if(prob(80))
		M.adjustBrainLoss(0.1 * effect_multiplier)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3 * effect_multiplier)
	if(prob(10))
		M.emote("drool")
	..()


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

/datum/reagent/drug/mindwipe
	name = "Mindwipe"
	id = "mindwipe"
	description = "Shocks the user's brain hard enough to make him forget about his quirks. Is ill-advised because of side effects"
	taste_description = "bitter"
	reagent_state = LIQUID
	color = "#bfff00"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	nerve_system_accumulations = 90
	addiction_chance = 30
	sanity_gain = 2

/datum/reagent/drug/mindwipe/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.hallucination(50 * effect_multiplier, 50 * effect_multiplier)
	M.druggy = max(M.druggy, 5 * effect_multiplier)
	M.make_jittery(10 * effect_multiplier)
	M.make_dizzy(10 * effect_multiplier)
	M.confused = max(M.confused, 20 * effect_multiplier)
	if(prob(5 * effect_multiplier) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))
	if(ishuman(M))
		var/mob/living/carbon/human/affected = M
		if(prob(5 * effect_multiplier))
			for(var/datum/breakdown/B in affected.sanity.breakdowns)
				if(B)
					B.finished = TRUE
					to_chat(M, SPAN_NOTICE("You feel that something eases the strain on your sanity. But at which price?"))

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
	reagent_type = "Drug/Stimulator"
	sanity_gain = 1.5

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

	..()

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
	if(M.stats.getPerk(PERK_CHAINGUN_SMOKER))
		M.add_chemical_effect(CE_ANTITOX, 5 * effect_multiplier)
		M.heal_organ_damage(0.1 * effect_multiplier, 0.1 * effect_multiplier)

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
	metabolism = REM * 0.2
	overdose = REAGENTS_OVERDOSE * 0.66
	withdrawal_threshold = 10
	nerve_system_accumulations = 55
	reagent_type = "Drug/Stimulator"
	sanity_gain = 0


/datum/reagent/drug/hyperzine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 0.6)
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
