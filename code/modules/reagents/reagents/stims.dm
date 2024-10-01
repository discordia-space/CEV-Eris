/datum/reagent/stim
	scannable = 1
	metabolism = REM/4
	constant_metabolism = TRUE
	reagent_type = "Stimulator"
	withdrawal_threshold = 20
	withdrawal_rate = REM * 1.5

/datum/reagent/stim/mbr
	name = "Machine binding ritual"
	id = "machine binding ritual"
	description = "A ethanol based stimulator. Used as ritual drink during technomancers initiation into tribe."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#5f95e2"
	overdose = REAGENTS_OVERDOSE
	addiction_chance = 20
	nerve_system_accumulations = 15

/datum/reagent/stim/mbr/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_MEC, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "mbr")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "mbr")
	sanity_gain = 1

/datum/reagent/stim/mbr/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "mbr_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "mbr_w")
	sanity_gain = -1.5

/datum/reagent/stim/mbr/overdose(mob/living/carbon/M, alien)
	if(prob(5))
		M.vomit()
	if(ishuman(M) && prob(80 - (60 * (1 - M.stats.getMult(STAT_TGH)))))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/L = H.random_organ_by_process(OP_LIVER)
		create_overdose_wound(L, M, /datum/component/internal_wound/organic/heavy_poisoning)

/datum/reagent/stim/cherrydrops
	name = "Cherry Drops"
	id = "cherry drops"
	description = "Stimulator designed to enchant cognitive capabilities. Quite common in scientific circles."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#9bd70f"
	overdose = REAGENTS_OVERDOSE + 5
	nerve_system_accumulations = 20
	addiction_chance = 30

/datum/reagent/stim/cherrydrops/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_COG, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "cherrydrops")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "cherrydrops")
	sanity_gain = 1

/datum/reagent/stim/cherrydrops/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "cherrydrops_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "cherrydrops_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "cherrydrops_w")
	sanity_gain = -1.5

/datum/reagent/stim/cherrydrops/overdose(mob/living/carbon/M, alien)
	M.apply_effect(3, STUTTER)
	if(ishuman(M) && prob(80 - (60 * (1 - M.stats.getMult(STAT_TGH)))))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/B = H.random_organ_by_process(OP_BLOOD_VESSEL)
		create_overdose_wound(B, M, /datum/component/internal_wound/organic/heavy_poisoning)

/datum/reagent/stim/pro_surgeon
	name = "ProSurgeon"
	id = "prosurgeon"
	description = "A stimulating drug, used to reduce tremor to minimum. Common in medical facilities."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#2d867a"
	overdose = REAGENTS_OVERDOSE
	nerve_system_accumulations = 20
	addiction_chance = 20

/datum/reagent/stim/pro_surgeon/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_BIO, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "pro_surgeon")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "pro_surgeon")
	sanity_gain = 1

/datum/reagent/stim/pro_surgeon/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "proSurgeon_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "proSurgeon_w")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "proSurgeon_w")
	sanity_gain = -1.5

/datum/reagent/stim/pro_surgeon/overdose(mob/living/carbon/M, alien)
	var/inverse_tough_mult = 1 - M.stats.getMult(STAT_TGH)
	if(prob(5 - (5 * inverse_tough_mult)))
		M.custom_emote(1,"twitches and drops [M.gender == MALE ? "his" : "her"] [M.get_active_hand()].") // there is only two genders, male and others
		M.drop_item()
	if(prob(80 - (20 * inverse_tough_mult)))
		M.add_chemical_effect(CE_TOXIN, 5)
	if(ishuman(M)&& prob(80 - (60 * inverse_tough_mult)))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/N = H.random_organ_by_process(OP_NERVE)
		create_overdose_wound(N, M, /datum/component/internal_wound/organic/heavy_poisoning)

/datum/reagent/stim/violence
	name = "Violence"
	id = "violence"
	description = "Stimulator famous for it's ability to increase peak muscle strength. Popular among criminal elements."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#75aea5"
	overdose = REAGENTS_OVERDOSE - 10
	nerve_system_accumulations = 30
	addiction_chance = 30

/datum/reagent/stim/violence/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_ROB, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "violence")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "violence")
	M.add_chemical_effect(CE_PULSE, 1)
	M.add_chemical_effect(CE_SPEECH_VOLUME, rand(3,4))
	sanity_gain = 1

/datum/reagent/stim/violence/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "violence_w")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "violence_w")
	sanity_gain = -1

/datum/reagent/stim/violence/overdose(mob/living/carbon/M, alien)
	var/inverse_tough_mult = 1 - M.stats.getMult(STAT_TGH)
	M.make_jittery(5)
	M.confused = max(M.confused, 20)
	if(prob(80 - (20 * inverse_tough_mult)))
		M.adjustCloneLoss(5)
	if(ishuman(M) && prob(80 - (60 * inverse_tough_mult)))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/I = H.random_organ_by_process(OP_MUSCLE)
		create_overdose_wound(I, M, /datum/component/internal_wound/organic/heavy_poisoning)

/datum/reagent/stim/bouncer
	name = "Bouncer"
	id = "bouncer"
	description = "Stimulator that boost regenerative capabilities. Quite often issued to crew operating in hazard enviroments."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#682f93"
	overdose = REAGENTS_OVERDOSE
	nerve_system_accumulations = 10
	addiction_chance = 20

/datum/reagent/stim/bouncer/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "bouncer")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "bouncer")
	sanity_gain = 1

/datum/reagent/stim/bouncer/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "bouncer_w")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "bouncer_w")
	sanity_gain = -1.5

/datum/reagent/stim/bouncer/overdose(mob/living/carbon/M, alien)
	var/inverse_tough_mult = 1 - M.stats.getMult(STAT_TGH)
	if(prob(5 - (3 * inverse_tough_mult)))
		M.Stun(rand(1,5))
	M.bodytemperature += TEMPERATURE_DAMAGE_COEFFICIENT
	if(ishuman(M) && prob(80 - (60 * inverse_tough_mult)))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/L = H.random_organ_by_process(OP_LUNGS)
		create_overdose_wound(L, M, /datum/component/internal_wound/organic/heavy_poisoning)

/datum/reagent/stim/steady
	name = "Steady"
	id = "steady"
	description = "Stimulator with ability to enchant reaction time. Usual find in mercenary groups."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#334183"
	overdose = REAGENTS_OVERDOSE - 10
	nerve_system_accumulations = 20
	addiction_chance = 20

/datum/reagent/stim/steady/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "steady")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "steady")
	sanity_gain = 1

/datum/reagent/stim/steady/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "steady_w")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "steady_w")
	if(prob(25 - (10 * (1 - M.stats.getMult(STAT_TGH)))))
		M.shake_animation(5)
	sanity_gain = -1.5

/datum/reagent/stim/steady/overdose(mob/living/carbon/M, alien)
	if(ishuman(M) && prob(80 - (60 * (1 - M.stats.getMult(STAT_TGH)))))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/I = H.random_organ_by_process(OP_HEART)
		create_overdose_wound(I, M, /datum/component/internal_wound/organic/heavy_poisoning)
	M.add_chemical_effect(CE_SPEEDBOOST, -1)

/datum/reagent/stim/machine_spirit
	name = "Machine Spirit"
	id = "machine spirit"
	description = "Potent ethanol based stimulator. Used to initiate technomancer into inner cirle."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#9eb236"
	overdose = REAGENTS_OVERDOSE - 12
	nerve_system_accumulations = 30
	addiction_chance = 30

/datum/reagent/stim/machine_spirit/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_MEC, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "machine_spirit")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "machine_spirit")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "machine_spirit")
	sanity_gain = 1.25

/datum/reagent/stim/machine_spirit/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "machineSpirit_w")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "machineSpirit_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "machineSpirit_w")
	sanity_gain = -1.75

/datum/reagent/stim/machine_spirit/overdose(mob/living/carbon/M, alien)
	if(prob(5))
		M.vomit()
	if(ishuman(M) && prob(80 - (60 * (1 - M.stats.getMult(STAT_TGH)))))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/L = H.random_organ_by_process(OP_LIVER)
		create_overdose_wound(L, M, /datum/component/internal_wound/organic/necrosis_start, "rot")

/datum/reagent/stim/grape_drops
	name = "Grape Drops"
	id = "grape drops"
	description = "Powerful stimulator which boosts creativity. Often used by scientists."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#eb5783"
	overdose = REAGENTS_OVERDOSE - 5
	nerve_system_accumulations = 30
	addiction_chance = 40

/datum/reagent/stim/grape_drops/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_COG, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "grape_drops")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "grape_drops")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "grape_drops")
	sanity_gain = 1.25

/datum/reagent/stim/grape_drops/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "grapeDrops_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "grapeDrops_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "grapeDrops_w")
	M.add_side_effect("Headache", 11)
	sanity_gain = -1.75

/datum/reagent/stim/grape_drops/overdose(mob/living/carbon/M, alien)
	M.slurring = max(M.slurring, 30)
	M.adjustBrainLoss(1)
	if(ishuman(M) && prob(80 - (60 * (1 - M.stats.getMult(STAT_TGH)))))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/B = H.random_organ_by_process(OP_BLOOD_VESSEL)
		create_overdose_wound(B, M, /datum/component/internal_wound/organic/necrosis_start, "rot")

/datum/reagent/stim/ultra_surgeon
	name = "UltraSurgeon"
	id = "ultrasurgeon"
	description = "Strong stimulating drug, which stabilizes muscle motility. Used as last resort during complex surgeries."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0c07c4"
	overdose = REAGENTS_OVERDOSE - 13
	nerve_system_accumulations = 30
	addiction_chance = 30

/datum/reagent/stim/ultra_surgeon/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_BIO, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "ultra_surgeon")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "ultra_surgeon")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "ultra_surgeon")
	sanity_gain = 1.25

/datum/reagent/stim/ultra_surgeon/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "ultraSurgeon_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "ultraSurgeon_w")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "ultraSurgeon_w")
	if(prob(25 - (10 * (1 - M.stats.getMult(STAT_TGH)))))
		M.shake_animation(8)
	sanity_gain = -1.75

/datum/reagent/stim/ultra_surgeon/overdose(mob/living/carbon/M, alien)
	var/inverse_tough_mult = 1 - M.stats.getMult(STAT_TGH)
	if(prob(80 - (20 * inverse_tough_mult)))
		M.add_chemical_effect(CE_TOXIN, 10)
	if(prob(10 - (5 * inverse_tough_mult)))
		M.custom_emote(1,"twitches and drops [M.gender == MALE ? "his" : "her"] [M.get_active_hand()].") // there is only two genders, male and others
		M.drop_item()
	if(ishuman(M) && prob(80 - (60 * inverse_tough_mult)))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/N = H.random_organ_by_process(OP_NERVE)
		create_overdose_wound(N, M, /datum/component/internal_wound/organic/necrosis_start, "rot")

/datum/reagent/stim/violence_ultra
	name = "Violence Ultra"
	id = "violence ultra"
	description = "Effective electrolyte based muscle stimulant. Often used by most violent gangs"
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#3d3362"
	overdose = REAGENTS_OVERDOSE - 19
	nerve_system_accumulations = 60
	addiction_chance = 40

/datum/reagent/stim/violence_ultra/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_ROB, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "violence_ultra")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "violence_ultra")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "violence_ultra")
	sanity_gain = 1.25

/datum/reagent/stim/violence_ultra/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "violenceUltra_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "violenceUltra_w")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "violenceUltra_w")
	if(prob(25 - (10 * (1 - M.stats.getMult(STAT_TGH)))))
		M.shake_animation(8)
	M.adjustNutrition(-5)
	sanity_gain = -1.75

/datum/reagent/stim/violence_ultra/overdose(mob/living/carbon/M, alien)
	var/inverse_tough_mult = 1 - M.stats.getMult(STAT_TGH)
	M.make_jittery(5)
	M.confused = max(M.confused, 20)
	if(prob(80 - (20 * inverse_tough_mult)))
		M.adjustCloneLoss(5)
	if(ishuman(M) && prob(80 - (60 * inverse_tough_mult)))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/I = H.random_organ_by_process(OP_MUSCLE)
		create_overdose_wound(I, M, /datum/component/internal_wound/organic/necrosis_start, "rot")

/datum/reagent/stim/boxer
	name = "Boxer"
	id = "boxer"
	description = "Stimulator which boosts robustness of human body. Known for its use by boxers"
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0ed750"
	overdose = REAGENTS_OVERDOSE/2
	nerve_system_accumulations = 50
	addiction_chance = 30

/datum/reagent/stim/boxer/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "boxer")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "boxer")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "boxer")
	sanity_gain = 1.25

/datum/reagent/stim/boxer/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "boxer_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "boxer_w")
	sanity_gain = -1.75

/datum/reagent/stim/boxer/overdose(mob/living/carbon/M, alien)
	var/inverse_tough_mult = 1 - M.stats.getMult(STAT_TGH)
	M.bodytemperature += TEMPERATURE_DAMAGE_COEFFICIENT * 1.5
	if(prob(8 - (3 * inverse_tough_mult)))
		M.Stun(rand(2,5))
	if(ishuman(M) && prob(80 - (60 * inverse_tough_mult)))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/L = H.random_organ_by_process(OP_LUNGS)
		create_overdose_wound(L, M, /datum/component/internal_wound/organic/necrosis_start, "rot")

/datum/reagent/stim/turbo
	name = "TURBO"
	id = "turbo"
	description = "Potent mix of cardiovascular and neuro stimulators. Used by sharpshooters to increase accuracy."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#f22168"
	overdose = REAGENTS_OVERDOSE-18
	nerve_system_accumulations = 60
	addiction_chance = 40

/datum/reagent/stim/turbo/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "turbo")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "turbo")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "turbo")
	sanity_gain = 1.25

/datum/reagent/stim/turbo/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "turbo_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "turbo_w")
	if(prob(25 - (5 * (1 - M.stats.getMult(STAT_TGH)))))
		M.shake_animation(8)
	sanity_gain = -1.75

/datum/reagent/stim/turbo/overdose(mob/living/carbon/M, alien)
	var/inverse_tough_mult = 1 - M.stats.getMult(STAT_TGH)
	if(ishuman(M) && prob(80 - (60 * inverse_tough_mult)))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/vital/heart/L = H.random_organ_by_process(OP_HEART)
		create_overdose_wound(L, M, /datum/component/internal_wound/organic/necrosis_start, "rot")
	M.add_chemical_effect(CE_SPEEDBOOST, -1)
	if(prob(5 - (2 * inverse_tough_mult)))
		M.paralysis = max(M.paralysis, 20)

/datum/reagent/stim/party_drops
	name = "Party Drops"
	id = "party drops"
	description = "Stimulating substance which pumps intelectual capabilities to theoretical maximum. Used as delicacy by some high ranking scientists."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffb3b7"
	overdose = REAGENTS_OVERDOSE - 18
	nerve_system_accumulations = 70
	addiction_chance = 50

/datum/reagent/stim/party_drops/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_MEC, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_BIO, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_COG, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "party_drops")
	sanity_gain = 1

/datum/reagent/stim/party_drops/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "partyDrops_w")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "partyDrops_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "partyDrops_w")
	if(prob(25 - (5 * (1 - M.stats.getMult(STAT_TGH)))))
		M.shake_animation(8)
	sanity_gain = -2

/datum/reagent/stim/party_drops/overdose(mob/living/carbon/M, alien)
	var/wound_chance = 80 - (79 * (1 - M.stats.getMult(STAT_TGH)))
	M.adjustBrainLoss(2)
	M.slurring = max(M.slurring, 30)
	if(prob(5))
		M.vomit()
	if(ishuman(M))
		if(prob(wound_chance))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/B = H.random_organ_by_process(OP_BLOOD_VESSEL)
			create_overdose_wound(B, M, /datum/component/internal_wound/organic/permanent, "scar")
		if(prob(wound_chance))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/liver/L = H.random_organ_by_process(OP_LIVER)
			create_overdose_wound(L, M, /datum/component/internal_wound/organic/permanent, "scar")
		if(prob(wound_chance))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/N = H.random_organ_by_process(OP_NERVE)
			create_overdose_wound(N, M, /datum/component/internal_wound/organic/permanent, "scar")


/datum/reagent/stim/menace
	name = "MENACE"
	id = "menace"
	description = "Awfully potent stimulant. Notorious for its usage by suicide troops."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffb3b7"
	overdose = REAGENTS_OVERDOSE - 21
	nerve_system_accumulations = 90
	addiction_chance = 70

/datum/reagent/stim/menace/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_ROB, STAT_LEVEL_EXPERT * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "menace")
	M.slurring = max(M.slurring, 30)
	M.add_chemical_effect(CE_SPEECH_VOLUME, 4)
	sanity_gain = 1

/datum/reagent/stim/menace/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT, STIM_TIME, "menace_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT, STIM_TIME, "menace_w")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT, STIM_TIME, "menace_w")
	if(prob(25 - (5 * (1 - M.stats.getMult(STAT_TGH)))))
		M.shake_animation(8)
	M.adjustNutrition(-7)
	sanity_gain = -2

/datum/reagent/stim/menace/overdose(mob/living/carbon/M, alien)
	var/wound_chance = 80 - (79 * (1 - M.stats.getMult(STAT_TGH)))
	M.slurring = max(M.slurring, 50)
	M.apply_effect(3, STUTTER)
	if(prob(6))
		M.paralysis = max(M.paralysis, 20)
	if(ishuman(M))
		if(prob(wound_chance))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/I = H.random_organ_by_process(OP_MUSCLE)
			create_overdose_wound(I, M, /datum/component/internal_wound/organic/permanent, "scar")
		if(prob(wound_chance))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/liver/L = H.random_organ_by_process(OP_LUNGS)
			create_overdose_wound(L, M, /datum/component/internal_wound/organic/permanent, "scar")
		if(prob(wound_chance))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/O = H.random_organ_by_process(OP_HEART)
			create_overdose_wound(O, M, /datum/component/internal_wound/organic/permanent, "scar")
