/* Drugs */
/datum/reagent/drug
	reagent_type = "Drug"
	sanity_gain = 0.5

/datum/reagent/drug/on_mob_add(mob/living/L)
	..()
	SEND_SIGNAL(L, COMSIG_CARBON_HAPPY, src, MOB_ADD_DRUG)

/datum/reagent/drug/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(sanity_gain && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.sanity.onDrug(src, effect_multiplier)
	SEND_SIGNAL(M, COMSIG_CARBON_HAPPY, src, ON_MOB_DRUG)

/datum/reagent/drug/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(sanity_gain && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.sanity.onDrug(src, effect_multiplier)
	SEND_SIGNAL(M, COMSIG_CARBON_HAPPY, src, ON_MOB_DRUG)

/datum/reagent/drug/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	if(sanity_gain && ishuman(M))
		var/mob/living/carbon/human/H = M
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
	sanity_gain = 3 // Very hard to make

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
	..()
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
	..()
	M.hallucination(50 * effect_multiplier, 50 * effect_multiplier)
	M.druggy = max(M.druggy, 5 * effect_multiplier)
	M.make_jittery(10 * effect_multiplier)
	M.make_dizzy(10 * effect_multiplier)
	M.confused = max(M.confused, 20 * effect_multiplier)
	if(prob(5 * effect_multiplier) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))
	if(ishuman(M) && (prob(5 * effect_multiplier)))
		var/mob/living/carbon/human/affected = M
		for(var/datum/breakdown/B in affected.sanity.breakdowns)
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
	withdrawal_threshold = 0.01
	overdose = REAGENTS_OVERDOSE/2
	addiction_chance = 20
	nerve_system_accumulations = 10
	max_dose = 10 // Nanako tier solution

/datum/reagent/drug/nicotine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.add_chemical_effect(CE_PULSE, 1)
	M.add_chemical_effect(CE_PAINKILLER, 5)
	if(M.stats.getPerk(PERK_CHAINGUN_SMOKER))
		M.add_chemical_effect(CE_ANTITOX, 5 * effect_multiplier)
		M.heal_organ_damage(0.1 * effect_multiplier, 0.1 * effect_multiplier)

/datum/reagent/drug/nicotine/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "nicotine_w")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "nicotine_w")

/datum/reagent/drug/nicotine/overdose(mob/living/carbon/M, alien)
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
	..()
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
	withdrawal_threshold = 30

/datum/reagent/drug/sanguinum/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.add_chemical_effect(CE_BLOODRESTORE, 1.6 * effect_multiplier)
	if(prob(2))
		spawn
			M.emote("me", 1, "coughs up blood!")
		M.drip_blood(10)

/datum/reagent/drug/sanguinum/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "sanguinum_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "sanguinum_w")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "sanguinum_w")

// It's time to cook
/datum/reagent/drug/crystal_dream
	name = "Crystal Dream"
	id = "crystal_dream"
	description = "Synthetic bliss."
	taste_description = "bitterant with a bite"
	color = "#8ecae6"
	metabolism = REM * 0.5
	constant_metabolism = TRUE	// So it doesn't get stuck in your system
	overdose = 14.9
	reagent_state = LIQUID
	sanity_gain = 3
	addiction_chance = 100
	withdrawal_threshold = 0.1
	nerve_system_accumulations = 80
	var/purity = 1

/datum/reagent/drug/crystal_dream/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	// Suffer every roach stim withdrawal at once
	M.stats.addTempStat(STAT_MEC, -15, STIM_TIME, id)
	M.stats.addTempStat(STAT_TGH, -70, STIM_TIME, id)
	M.stats.addTempStat(STAT_ROB, -55, STIM_TIME, id)
	M.stats.addTempStat(STAT_VIG, -15, STIM_TIME, id)

	// Extra effects
	M.add_chemical_effect(CE_PAINKILLER, 50 * effect_multiplier * purity)
	M.make_jittery(10 * effect_multiplier)
	M.hallucination(30 * effect_multiplier * purity, 30 * effect_multiplier * purity)
	if(prob(5))
		M.emote("me", 1, pick("twitches.", "sweats.", "shivers."))

	// The danger
	M.adjustToxLoss(1.5 * effect_multiplier * purity)
	damage_random_internal_organ(M, 1 * effect_multiplier * purity)

/datum/reagent/drug/crystal_dream/overdose(mob/living/carbon/M, alien)
	if(!M.stats.getPerk(PERK_DREAMER) && purity > 0.991)
		M.stats.addPerk(PERK_DREAMER)
		to_chat(M, SPAN_NOTICE("<i>Your imagination becomes tangible.</i>"))

/datum/reagent/drug/crystal_dream/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -15, STIM_TIME, id)
	M.stats.addTempStat(STAT_TGH, -70, STIM_TIME, id)
	M.stats.addTempStat(STAT_ROB, -55, STIM_TIME, id)
	M.stats.addTempStat(STAT_VIG, -15, STIM_TIME, id)

	M.make_jittery(10)
	M.add_chemical_effect(CE_PULSE, 3)

	M.adjustToxLoss(3 * purity)
	damage_random_internal_organ(M, 2 * purity)
	if(prob(5))
		M.emote("me", 1, pick("twitches spastically.", "sweats profusely.", "shivers violently."))

/datum/reagent/drug/crystal_dream/proc/damage_random_internal_organ(mob/living/carbon/M, damage_amount)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/organ_process = pick(OP_HEART, OP_LIVER, OP_LUNGS, OP_KIDNEYS, OP_BLOOD_VESSEL)
		var/obj/item/organ/internal/I = H.random_organ_by_process(organ_process)
		if(istype(I))
			I.take_damage(damage_amount, TRUE)

/datum/reagent/drug/crystal_dream/white
	name = "White Crystal Dream"
	id = "white_crystal_dream"
	description = "Liquid glass. Pure scante."
	color = "#d3d3d3"
	sanity_gain = 2
	purity = 0.8

/datum/reagent/drug/crystal_dream/yellow
	name = "Yellow Crystal Dream"
	id = "yellow_crystal_dream"
	description = "Low-quality product. Also known as Dreamer's Piss."
	color = "#e6d68e"
	sanity_gain = 1
	purity = 0.4

// Spider heroin
/datum/reagent/drug/paroin
	name = "Paroin"
	id = "paroin"
	description = "A fertile concoction of spider ichor."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#421d04"
	metabolism = REM * 0.5
	constant_metabolism = TRUE	// So it doesn't get stuck in your system
	overdose = 14.9
	sanity_gain = 2
	addiction_chance = 100
	withdrawal_threshold = 0.1
	nerve_system_accumulations = 80

/datum/reagent/drug/paroin/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	// Suffer every negative spider venom stat effect at once
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, id)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, id)

	// Extra effects
	M.hallucination(45 * effect_multiplier, 45 * effect_multiplier)
	M.add_chemical_effect(CE_PULSE, -1)
	M.add_chemical_effect(CE_SPEEDBOOST, -2)
	M.confused = max(M.confused, 20 * effect_multiplier)
	if(prob(5))
		M.emote("me", 1, pick("chitters.", "chatters.", "shivers."))

	// The danger
	M.adjustToxLoss(0.5 * effect_multiplier)
	grow_egg(M, 1)

/datum/reagent/drug/paroin/overdose(mob/living/carbon/M, alien)
	// The reward
	if(!M.stats.getPerk(PERK_EIGHTH_EYE))
		M.stats.addPerk(PERK_EIGHTH_EYE)
		to_chat(M, SPAN_NOTICE("<i>Your eighth eye opens.</i>"))
	
	grow_egg(M, 100)

/datum/reagent/drug/paroin/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, id)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, id)

	M.hallucination(60, 60)
	M.add_chemical_effect(CE_PULSE, -2)
	M.add_chemical_effect(CE_SPEEDBOOST, -4)
	M.drowsyness = max(M.drowsyness, 5)
	M.confused = max(M.confused, 20)

	M.adjustToxLoss(2)
	grow_egg(M, 1)

/datum/reagent/drug/paroin/proc/grow_egg(mob/living/carbon/M, chance)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(chance))
			var/obj/item/organ/external/O = safepick(H.organs)
			if(O && !BP_IS_ROBOTIC(O))
				to_chat(H, SPAN_WARNING("You feel something twitching inside of your [O.name]!"))
				var/obj/effect/spider/eggcluster/minor/S = new()
				S.loc = O
				O.implants += S
				O.take_damage(10, 0, TRUE)
