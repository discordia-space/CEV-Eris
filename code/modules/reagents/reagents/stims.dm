/datum/reagent/stim
	scannable = 1
	metabolism = REM/4
	constant_metabolism = TRUE
	reagent_type = "Stimulator"

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

/datum/reagent/stim/stim/mbr/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_MEC, STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "mbr")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "mbr")

/datum/reagent/stim/stim/mbr/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "mbr_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "mbr_w")

/datum/reagent/stim/mbr/overdose(var/mob/living/carbon/M, var/alien)
	if(prob(5))
		M.vomit()
	M.add_chemical_effect(CE_TOXIN, 1)
	if(prob(80 - (30 * M.stats.getMult(STAT_TGH))))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[BP_LIVER]
		if (istype(L))
			L.take_damage(3, 0)

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

/datum/reagent/stim/cherrydrops/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_COG, STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "cherrydrops")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "cherrydrops")

/datum/reagent/stim/cherrydrops/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "cherrydrops_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "cherrydrops_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "cherrydrops_w")

/datum/reagent/stim/cherrydrops/overdose(var/mob/living/carbon/M, var/alien)
	M.apply_effect(3, STUTTER)

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

/datum/reagent/stim/pro_surgeon/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_BIO, STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "pro_surgeon")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "pro_surgeon")

/datum/reagent/stim/pro_surgeon/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "proSurgeon_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "proSurgeon_w")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "proSurgeon_w")

/datum/reagent/stim/pro_surgeon/overdose(var/mob/living/carbon/M, var/alien)
	if(prob(5 - (5 * M.stats.getMult(STAT_TGH))))
		M.custom_emote(1,"twitches and drops [M.gender == MALE ? "his" : "her"] [M.get_active_hand()].") // there is only two genders, male and others
		M.drop_item()
	M.add_chemical_effect(CE_TOXIN, 1)
	if(prob(80 - (20 * M.stats.getMult(STAT_TGH))))
		M.adjustToxLoss(5)

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

/datum/reagent/stim/violence/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_ROB, STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "violence")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "violence")
	M.add_chemical_effect(CE_PULSE, 1)
	M.add_chemical_effect(CE_SPEECH_VOLUME, rand(3,4))

/datum/reagent/stim/violence/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "violence_w")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "violence_w")

/datum/reagent/stim/violence/overdose(var/mob/living/carbon/M, var/alien)
	M.adjustCloneLoss(5)
	M.make_jittery(5)
	M.confused = max(M.confused, 20)

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

/datum/reagent/stim/bouncer/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "bouncer")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "bouncer")

/datum/reagent/stim/bouncer/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "bouncer_w")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "bouncer_w")

/datum/reagent/stim/bouncer/overdose(var/mob/living/carbon/M, var/alien)
	if(prob(5 - (3 * M.stats.getMult(STAT_TGH))))
		M.Stun(rand(1,5))
	M.bodytemperature += TEMPERATURE_DAMAGE_COEFFICIENT

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

/datum/reagent/stim/steady/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "steady")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "steady")

/datum/reagent/stim/steady/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "steady_w")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "steady_w")
	if(prob(25 - (10 * M.stats.getMult(STAT_TGH))))
		M.shake_animation(5)

/datum/reagent/stim/steady/overdose(var/mob/living/carbon/M, var/alien)
	if(prob(80 - (30 * M.stats.getMult(STAT_TGH))))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/L = H.internal_organs_by_name[BP_HEART]
		if (istype(L))
			L.take_damage(5, 0)
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

/datum/reagent/stim/machine_spirit/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_MEC, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "machine_spirit")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "machine_spirit")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "machine_spirit")

/datum/reagent/stim/machine_spirit/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "machineSpirit_w")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "machineSpirit_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "machineSpirit_w")

/datum/reagent/stim/machine_spirit/overdose(var/mob/living/carbon/M, var/alien)
	if(prob(5))
		M.vomit()
	M.add_chemical_effect(CE_TOXIN, 1)
	if(prob(80 - (30 * M.stats.getMult(STAT_TGH))))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[BP_LIVER]
		if (istype(L))
			L.take_damage(5, 0)

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

/datum/reagent/stim/grape_drops/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_COG, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "grape_drops")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "grape_drops")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "grape_drops")

/datum/reagent/stim/grape_drops/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "grapeDrops_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "grapeDrops_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "grapeDrops_w")
	M.add_side_effect("Headache", 11)

/datum/reagent/stim/grape_drops/overdose(var/mob/living/carbon/M, var/alien)
	M.slurring = max(M.slurring, 30)
	M.adjustBrainLoss(1)

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

/datum/reagent/stim/ultra_surgeon/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_BIO, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "ultra_surgeon")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "ultra_surgeon")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "ultra_surgeon")

/datum/reagent/stim/ultra_surgeon/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "ultraSurgeon_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "ultraSurgeon_w")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "ultraSurgeon_w")
	if(prob(25 - (10 * M.stats.getMult(STAT_TGH))))
		M.shake_animation(8)

/datum/reagent/stim/ultra_surgeon/overdose(var/mob/living/carbon/M, var/alien)
	if(prob(80 - (20 * M.stats.getMult(STAT_TGH))))
		M.adjustToxLoss(10)
	if(prob(10 - (5 * M.stats.getMult(STAT_TGH))))
		M.custom_emote(1,"twitches and drops [M.gender == MALE ? "his" : "her"] [M.get_active_hand()].") // there is only two genders, male and others
		M.drop_item()

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

/datum/reagent/stim/violence_ultra/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_ROB, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "violence_ultra")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "violence_ultra")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "violence_ultra")

/datum/reagent/stim/violence_ultra/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "violenceUltra_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "violenceUltra_w")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "violenceUltra_w")
	if(prob(25 - (10 * M.stats.getMult(STAT_TGH))))
		M.shake_animation(8)
	M.adjustNutrition(-5)

/datum/reagent/stim/violence_ultra/overdose(var/mob/living/carbon/M, var/alien)
	M.adjustCloneLoss(5)
	M.make_jittery(5)
	M.confused = max(M.confused, 20)

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

/datum/reagent/stim/boxer/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "boxer")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "boxer")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "boxer")

/datum/reagent/stim/boxer/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "boxer_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "boxer_w")

/datum/reagent/stim/boxer/overdose(var/mob/living/carbon/M, var/alien)
	if(prob(8 - (3 * M.stats.getMult(STAT_TGH))))
		M.Stun(rand(2,5))
	M.bodytemperature += TEMPERATURE_DAMAGE_COEFFICIENT * 1.5

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

/datum/reagent/stim/turbo/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "turbo")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "turbo")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "turbo")

/datum/reagent/stim/turbo/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "turbo_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "turbo_w")
	if(prob(25 - (5 * M.stats.getMult(STAT_TGH))))
		M.shake_animation(8)

/datum/reagent/stim/turbo/overdose(var/mob/living/carbon/M, var/alien)
	if(prob(80 - (30 * M.stats.getMult(STAT_TGH))))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/L = H.internal_organs_by_name[BP_HEART]
		if (istype(L))
			L.take_damage(7, 0)
	M.add_chemical_effect(CE_SPEEDBOOST, -1)
	if(prob(5 - (2 * M.stats.getMult(STAT_TGH))))
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

/datum/reagent/stim/party_drops/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_MEC, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_BIO, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_COG, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "party_drops")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "party_drops")

/datum/reagent/stim/party_drops/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "partyDrops_w")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "partyDrops_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "partyDrops_w")
	if(prob(25 - (5 * M.stats.getMult(STAT_TGH))))
		M.shake_animation(8)

/datum/reagent/stim/party_drops/overdose(var/mob/living/carbon/M, var/alien)
	M.adjustBrainLoss(2)
	M.slurring = max(M.slurring, 30)
	if(prob(5))
		M.vomit()

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

/datum/reagent/stim/menace/affect_blood(var/mob/living/carbon/M, var/alien, var/effect_multiplier)
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_ROB, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "menace")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "menace")
	M.slurring = max(M.slurring, 30)
	M.add_chemical_effect(CE_SPEECH_VOLUME, 4)

/datum/reagent/stim/menace/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT, STIM_TIME, "menace_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT, STIM_TIME, "menace_w")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT, STIM_TIME, "menace_w")
	if(prob(25 - (5 * M.stats.getMult(STAT_TGH))))
		M.shake_animation(8)
	M.adjustNutrition(-7)

/datum/reagent/stim/menace/overdose(var/mob/living/carbon/M, var/alien)
	M.slurring = max(M.slurring, 50)
	M.apply_effect(3, STUTTER)
	if(prob(6))
		M.paralysis = max(M.paralysis, 20)
