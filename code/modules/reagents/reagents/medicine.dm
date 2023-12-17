/* General medicine */
/datum/reagent/medicine
	reagent_type = "Medicine"

/datum/reagent/medicine/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1

/datum/reagent/medicine/inaprovaline/holy
	id = "holyinaprovaline"
	scannable = 0

/datum/reagent/medicine/inaprovaline/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_STABLE)
	M.add_chemical_effect(CE_PAINKILLER, 15)
	M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/medicine/inaprovaline/sleeper
	name = "Synth-Inaprovaline"
	id = "inaprovaline2"

/datum/reagent/medicine/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/bicaridine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.heal_organ_damage(0.6 * effect_multiplier, 0, 5 * effect_multiplier)
	M.add_chemical_effect(CE_BLOODCLOT, 0.15)

/datum/reagent/medicine/bicaridine/overdose(mob/living/carbon/human/user, alien)
	var/obj/item/organ/internal/muscle/user_muscle = user.random_organ_by_process(OP_MUSCLE)
	var/obj/item/organ/internal/nerve/user_nerve = user.random_organ_by_process(OP_NERVE)
	if(!user_muscle)
		return FALSE
	user_muscle.take_damage(dose/3, FALSE, TOX)
	if(!user_nerve)
		return FALSE
	user_nerve.take_damage(dose/3, FALSE, TOX)
	if(prob(3))
		to_chat(user, span_danger("Your muscles ache with agonizing pain!"))
		user.Weaken(2)
	if(volume > 100 && prob(1))
		var/obj/item/organ/internal/vital/heart/user_heart = user.random_organ_by_process(OP_HEART)
		if(!user_heart || BP_IS_ROBOTIC(user_heart))
			return FALSE
		to_chat(user, span_danger("You feel like your heart just exploded!"))
		user_heart.take_damage(15, FALSE, TOX)

/datum/reagent/medicine/meralyne
	name = "Meralyne"
	id = "meralyne"
	description = "Meralyne is the next step in brute trauma medication. Works twice as good as bicaridine and enables the body to restore even the direst brute-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#E6666C"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
/datum/reagent/medicine/meralyne/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.heal_organ_damage(1.2 * effect_multiplier, 0, 5 * effect_multiplier)
	M.add_chemical_effect(CE_BLOODCLOT, 0.30)

/datum/reagent/medicine/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FFA800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/kelotane/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.heal_organ_damage(0, 0.6 * effect_multiplier, 0, 3 * effect_multiplier)

/datum/reagent/medicine/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#FF8000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/medicine/dermaline/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.heal_organ_damage(0, 1.2 * effect_multiplier, 0, 5 * effect_multiplier)

/datum/reagent/medicine/dylovene
	name = "Dylovene"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	taste_description = "a roll of gauze"
	reagent_state = LIQUID
	color = "#00A000"
	scannable = 1

/datum/reagent/medicine/dylovene/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.drowsyness = max(0, M.drowsyness - 0.6 * effect_multiplier)
	M.adjust_hallucination(-0.9 * effect_multiplier)
	M.add_chemical_effect(CE_ANTITOX, 2)
	holder.remove_reagent("pararein", 0.2)
	holder.remove_reagent("blattedin", 0.2)

/datum/reagent/medicine/dylovene/overdose(mob/living/carbon/human/user, alien)
	var/obj/item/organ/internal/blood_vessel/user_vessel = user.random_organ_by_process(OP_BLOOD_VESSEL)
	create_overdose_wound(user_vessel, user, /datum/component/internal_wound/organic/heavy_poisoning, "accumulation")

/datum/reagent/medicine/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/dexalin/holy
	id = "holydexalin"
	scannable = 0

/datum/reagent/medicine/dexalin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustOxyLoss(-1.5 * effect_multiplier)
	holder.remove_reagent("lexorin", 0.2 * effect_multiplier)
	var/ce_to_add = 1 - M.chem_effects[CE_OXYGENATED]
	if(ce_to_add > 0)
		M.add_chemical_effect(CE_OXYGENATED, ce_to_add)

/datum/reagent/medicine/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0040FF"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/medicine/dexalinp/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustOxyLoss(-30 * effect_multiplier)
	holder.remove_reagent("lexorin", 0.3 * effect_multiplier)
	var/ce_to_add = 2 - M.chem_effects[CE_OXYGENATED]
	if(ce_to_add > 0)
		M.add_chemical_effect(CE_OXYGENATED, ce_to_add)

/datum/reagent/medicine/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#8040FF"
	scannable = 1

/datum/reagent/medicine/tricordrazine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustOxyLoss(-0.6 * effect_multiplier)
	M.heal_organ_damage(0.3 * effect_multiplier, 0.3 * effect_multiplier)
	M.add_chemical_effect(CE_ANTITOX, 1)
	M.add_chemical_effect(CE_BLOODCLOT, 0.1)

/datum/reagent/medicine/tricordrazine/overdose(mob/living/carbon/human/user, alien)
	var/obj/item/organ/internal/liver/user_liver = user.random_organ_by_process(OP_LIVER)
	if(!user_liver)
		return FALSE
	user_liver.take_damage(dose/3, FALSE, TOX)
	// For those special people
	if(volume > 300 && prob(10))
		var/obj/item/organ/internal/blood_vessel/user_vessel = user.random_organ_by_process(OP_BLOOD_VESSEL)
		if(!user_vessel)
			return FALSE
		to_chat(user, "You feel intense swelling in your [user_vessel.loc?.name], and you notice it going numb and red!")
		user.AdjustParalysis(5)
		user_vessel.take_damage(15, FALSE, TOX)

/datum/reagent/medicine/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	scannable = 1

/datum/reagent/medicine/cryoxadone/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(M.bodytemperature < 170)
		M.add_chemical_effect(CE_ONCOCIDAL, 1)
		M.add_chemical_effect(CE_OXYGENATED, 1)
		M.add_chemical_effect(CE_BLOODCLOT, 0.50)
		M.add_chemical_effect(CE_ANTITOX, 2)
		M.add_chemical_effect(CE_ANTIBIOTIC, 5)
		M.add_chemical_effect(CE_PULSE, -2)
		M.adjustOxyLoss(-(1 + (M.getOxyLoss() * 0.05)) * effect_multiplier)
		M.heal_organ_damage(effect_multiplier, effect_multiplier, 5 * effect_multiplier, 5 * effect_multiplier)

/datum/reagent/medicine/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#80BFFF"
	metabolism = REM * 0.5
	scannable = 1

/datum/reagent/medicine/clonexadone/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(M.bodytemperature < 170)
		M.add_chemical_effect(CE_ONCOCIDAL, 1)
		M.add_chemical_effect(CE_OXYGENATED, 1)
		M.add_chemical_effect(CE_BLOODCLOT, 0.50)
		M.add_chemical_effect(CE_ANTITOX, 2)
		M.add_chemical_effect(CE_ANTIBIOTIC, 5)
		M.add_chemical_effect(CE_PULSE, -2)
		M.adjustOxyLoss(-(3 + (M.getOxyLoss() * 0.05)) * effect_multiplier)
		M.heal_organ_damage(3 * effect_multiplier, 3 * effect_multiplier, 5 * effect_multiplier, 5 * effect_multiplier)

/* Painkillers */

/datum/reagent/medicine/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "sickness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = 60
	scannable = 1
	metabolism = 0.02

/datum/reagent/medicine/paracetamol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_PAINKILLER, 25)

/datum/reagent/medicine/paracetamol/overdose(mob/living/carbon/M, alien)
	..()
	M.druggy = max(M.druggy, 2)

/datum/reagent/medicine/paracetamol/holy
	id = "angelsbalm"
	overdose = REAGENTS_OVERDOSE * 3
	scannable = 0
	nerve_system_accumulations = 0

/datum/reagent/medicine/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#CB68FC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	metabolism = 0.02
	nerve_system_accumulations = 40

/datum/reagent/medicine/tramadol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_PAINKILLER, 50)

/datum/reagent/medicine/tramadol/overdose(mob/living/carbon/M, alien)
	..()
	M.hallucination(120, 30)
	M.slurring = max(M.slurring, 30)
	M.add_chemical_effect(CE_SPEEDBOOST, -1)
	if(prob(3 - (2 * M.stats.getMult(STAT_TGH))))
		M.Stun(3)

/datum/reagent/medicine/tramadol/holy
	id = "deusblessing"
	overdose = REAGENTS_OVERDOSE * 3
	scannable = 0
	nerve_system_accumulations = 0

/datum/reagent/medicine/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#800080"
	overdose = REAGENTS_OVERDOSE * 0.66
	metabolism = 0.02
	nerve_system_accumulations = 60

/datum/reagent/medicine/oxycodone/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_PAINKILLER, 75)
	M.druggy = max(M.druggy, 10)

/datum/reagent/medicine/oxycodone/overdose(mob/living/carbon/M, alien)
	..()
	M.hallucination(120, 30)
	M.druggy = max(M.druggy, 10)
	M.slurring = max(M.slurring, 30)
	M.add_chemical_effect(CE_SPEEDBOOST, -1)
	if(prob(5 - (2 * M.stats.getMult(STAT_TGH))))
		M.Stun(5)

/* Other medicine */

/datum/reagent/medicine/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.05
	overdose = 5
	scannable = 1
	nerve_system_accumulations = 50

/datum/reagent/medicine/synaptizine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent("mindbreaker", 5)
	M.adjust_hallucination(-10)
	M.add_chemical_effect(CE_MIND, 2)
	M.add_chemical_effect(CE_TOXIN, 2.5 * effect_multiplier) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.add_chemical_effect(CE_PAINKILLER, 20)

/datum/reagent/medicine/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FFFF66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/alkysine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/vital/brain/B = H.internal_organs_by_efficiency[BP_BRAIN]
		if(!BP_IS_ROBOTIC(B) && prob(75))
			M.add_chemical_effect(CE_PAINKILLER, 10)
			M.add_chemical_effect(CE_BRAINHEAL, 1)

/datum/reagent/medicine/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Helps naturally regenerate and restore eye cells."
	taste_description = "dull toxin"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/imidazoline/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.eye_blurry = max(M.eye_blurry - (5 * effect_multiplier), 0)
	M.eye_blind = max(M.eye_blind - (5 * effect_multiplier), 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/E = H.random_organ_by_process(OP_EYES)
		if(E && istype(E))
			var/list/current_wounds = E.GetComponents(/datum/component/internal_wound)
			if(LAZYLEN(current_wounds) && prob(75))
				M.add_chemical_effect(CE_EYEHEAL, 1)

/datum/reagent/medicine/imidazoline/overdose(mob/living/carbon/M, alien)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/list/eye_organs = H.internal_organs_by_efficiency[OP_EYES]
		if(LAZYLEN(eye_organs))
			create_overdose_wound(pick(eye_organs), H, /datum/component/internal_wound/organic/heavy_poisoning)

/datum/reagent/medicine/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#561EC3"
	overdose = 10
	scannable = 1

/datum/reagent/medicine/peridaxon/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/list/organs_sans_brain_and_bones = H.internal_organs - H.internal_organs_by_efficiency[BP_BRAIN] - H.internal_organs_by_efficiency[OP_BONE] // Peridaxon shouldn't heal brain or bones
		for(var/obj/item/organ/I in organs_sans_brain_and_bones)
			var/list/current_wounds = I.GetComponents(/datum/component/internal_wound)
			if(LAZYLEN(current_wounds) && !BP_IS_ROBOTIC(I) && prob(75)) //Peridaxon heals only non-robotic organs
				M.add_chemical_effect(CE_ONCOCIDAL, 1)
				M.add_chemical_effect(CE_BLOODCLOT, 1)
				M.add_chemical_effect(CE_ANTITOX, 2)

/datum/reagent/medicine/peridaxon/overdose(mob/living/carbon/M, alien)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/list/organs_sans_brain_and_bones = H.internal_organs - H.internal_organs_by_efficiency[BP_BRAIN] - H.internal_organs_by_efficiency[OP_BONE] // Since it doesn't heal brain/bones it shouldn't damage them too
		if(LAZYLEN(organs_sans_brain_and_bones))
			create_overdose_wound(pick(organs_sans_brain_and_bones), H, /datum/component/internal_wound/organic/heavy_poisoning)

/datum/reagent/medicine/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#004000"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/medicine/ryetalyn/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_ONCOCIDAL, 2)
/*
	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()
*/
/datum/reagent/medicine/kognim
	name = "Kognim"
	id = "kognim"
	description = "Puts the user in pain. Necessary for use of portable genome splicer."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#224422"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/medicine/kognim/affect_blood(mob/living/carbon/human/H, alien, effect_multiplier)
	if(istype(H))
		var/obj/item/organ/external/E = pick(H.organs)
		H.apply_damage(2, HALLOSS)
		H.pain(E.name, 15, TRUE)

/datum/reagent/medicine/negative_ling
	name = "Negative Paragenetic Marker"
	id = "negativeling"
	description = "A marker compound that turns positive when put in contact with morphogenic mutant blood."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#022000"


/datum/reagent/medicine/positive_ling
	name = "Positive Paragenetic Marker"
	id = "positiveling"
	description = "This marker compound has come in contact with morphogenic mutant blood."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#910000"


/datum/reagent/medicine/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/medicine/ethylredoxrazine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	if(M.bloodstr)
		for(var/datum/reagent/R in M.bloodstr.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				R.dose = max(R.dose + effect_multiplier * 4, 0) // Increases the metabolism rate of ethanol by 0.2 for each unit of ethylredoxrazine metabolised

/datum/reagent/medicine/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/hyronalin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.radiation = max(M.radiation - (3 * effect_multiplier), 0)
	M.add_chemical_effect(CE_ONCOCIDAL, 1)

/datum/reagent/medicine/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/arithrazine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.radiation = max(M.radiation - (7 + (M.radiation * 0.10)) * effect_multiplier, 0)
	M.add_chemical_effect(CE_TOXIN, -(1 + (M.chem_effects[CE_TOXIN] * 0.05)) * effect_multiplier)
	if(prob(60))
		M.take_organ_damage(0.4 * effect_multiplier, 0)
	M.add_chemical_effect(CE_ONCOCIDAL, 1)

/datum/reagent/medicine/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C1C1C1"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/spaceacillin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_ANTIBIOTIC, 5)

/datum/reagent/medicine/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	touch_met = 5

/datum/reagent/medicine/sterilizine/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null

/datum/reagent/medicine/sterilizine/touch_obj(var/obj/O)
	O.was_bloodied = null

/datum/reagent/medicine/sterilizine/touch_turf(var/turf/T)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/blood/B in T)
		qdel(B)
	return TRUE

/datum/reagent/medicine/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/leporazine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT) * effect_multiplier)
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT) * effect_multiplier)

/* Antidepressants */

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/medicine/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#BF80BF"
	metabolism = 0.01
	data = 0

/datum/reagent/medicine/methylphenidate/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, SPAN_WARNING("You lose focus..."))
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, SPAN_NOTICE("Your mind feels focused and undivided."))

/datum/reagent/medicine/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FF80FF"
	metabolism = 0.01
	data = 0

/datum/reagent/medicine/citalopram/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, SPAN_WARNING("Your mind feels a little less stable..."))
	else
		M.add_chemical_effect(CE_MIND, 1)
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, SPAN_NOTICE("Your mind feels stable... a little stable."))

/datum/reagent/medicine/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = LIQUID
	color = "#FF80BF"
	metabolism = 0.01
	data = 0

/datum/reagent/medicine/paroxetine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, SPAN_WARNING("Your mind feels much less stable..."))
	else
		M.add_chemical_effect(CE_MIND, 2)
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, SPAN_NOTICE("Your mind feels much more stable."))
			else
				to_chat(M, SPAN_WARNING("Your mind breaks apart..."))
				M.hallucination(200, 100)

/datum/reagent/medicine/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	taste_description = "sickness"
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/rezadone/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustOxyLoss(-0.2 * effect_multiplier)
	M.heal_organ_damage(2 * effect_multiplier, 2 * effect_multiplier, 5 * effect_multiplier, 5 * effect_multiplier)
	M.add_chemical_effect(CE_TOXIN, -(2 + (M.chem_effects[CE_TOXIN] * 0.05)) * effect_multiplier)
	M.add_chemical_effect(CE_ONCOCIDAL, 2)
	if(dose > 3)
		M.status_flags &= ~DISFIGURED
	if(dose > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/datum/reagent/medicine/quickclot
	name = "Quickclot"
	id = "quickclot"
	description = "Temporarily stops\\oppresses any internal and external bleeding."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#a6b85b"
	overdose = REAGENTS_OVERDOSE / 6
	metabolism = REM / 2

/datum/reagent/medicine/quickclot/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_BLOODCLOT, 0.25)

/datum/reagent/medicine/quickclot/overdose(mob/living/carbon/M, alien)
	M.add_chemical_effect(CE_BLOODCLOT, 0.75)

/datum/reagent/medicine/ossisine
	name = "Ossisine"
	id = "ossisine"
	description = "Puts the user in a great amount of pain and repairs broken bones. Medicate in critical conditions only."
	taste_description = "calcium"
	reagent_state = LIQUID
	color = "#660679"
	metabolism = REM * 5
	overdose = 12	// 15u will treat 4 fractures

/datum/reagent/medicine/ossisine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.apply_damage(20, HALLOSS)
	M.add_chemical_effect(CE_BLOODCLOT, 0.1)
	M.add_chemical_effect(CE_BONE_MEND, 1)

/datum/reagent/medicine/ossisine/overdose(mob/living/carbon/M, alien)
	M.adjustCloneLoss(5)
	M.add_chemical_effect(CE_BONE_MEND, 1)

/datum/reagent/medicine/noexcutite
	name = "Noexcutite"
	id = "noexcutite"
	description = "A thick, syrupy liquid that has a lethargic effect. Used to cure cases of jitteriness."
	taste_description = "numbing coldness"
	reagent_state = LIQUID
	color = "#bc018a"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/medicine/noexcutite/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.make_jittery(-50)


/datum/reagent/medicine/kyphotorin
	name = "Kyphotorin"
	id = "kyphotorin"
	description = "Allows patient to grow back limbs. Extremely painful to user and needs constant medical attention when applied."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#7d88e6"
	overdose = REAGENTS_OVERDOSE * 0.66

/datum/reagent/medicine/kyphotorin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(5 * effect_multiplier + dose) || dose == overdose)
			var/list/missingLimbs = list()
			for(var/name in BP_ALL_LIMBS)
				if(!H.has_appendage(name))
					missingLimbs += name
			if(missingLimbs.len)
				var/luckyLimbName = pick(missingLimbs)
				H.restore_organ(luckyLimbName)
				M.pain(luckyLimbName, 100, TRUE)
				dose = 0
	if(prob(10))
		M.take_organ_damage(pick(0,5))

/datum/reagent/medicine/kyphotorin/overdose(mob/living/carbon/M, alien)
	M.adjustCloneLoss(4)

/datum/reagent/medicine/polystem
	name = "Polystem"
	id = "polystem"
	description = "Polystem boosts natural body regeneration."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#ded890"
	scannable = 1
	metabolism = REM/2
	overdose = REAGENTS_OVERDOSE - 10

/datum/reagent/medicine/polystem/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.heal_organ_damage(0.2 * effect_multiplier, 0, 3 * effect_multiplier)
	M.add_chemical_effect(CE_BLOODCLOT, min(1,0.1 * effect_multiplier))

/datum/reagent/medicine/polystem/overdose(mob/living/carbon/M, alien)
	M.add_chemical_effect(CE_BLOODCLOT, 0.1)

/datum/reagent/medicine/detox
	name = "Detox"
	id = "detox"
	description = "Boosts neural regeneration, allowing neural system to tolerate more chemicals without permament damage."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#229e08"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	metabolism = REM/2

/datum/reagent/medicine/detox/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(M.metabolism_effects.nsa_threshold_base == initial(M.metabolism_effects.nsa_threshold_base))
		M.metabolism_effects.nsa_threshold_base += rand(20, 60)

/datum/reagent/medicine/detox/on_mob_delete(mob/living/L)
	..()
	var/mob/living/carbon/C = L
	if(istype(C))
		C.metabolism_effects.nsa_threshold_base = initial(C.metabolism_effects.nsa_threshold_base)

/datum/reagent/medicine/detox/overdose(mob/living/carbon/M, alien)
	var/mob/living/carbon/C = M
	if(istype(C))
		C.metabolism_effects.nsa_threshold_base = initial(C.metabolism_effects.nsa_threshold_base) - rand(20, 40)

/datum/reagent/medicine/purger
	name = "Purger"
	id = "purger"
	description = "Temporary purges all addictions and treats chemical poisoning in large doses."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#d4cf3b"
	scannable = 1
	metabolism = REM / 2
	overdose = REAGENTS_OVERDOSE / 3

/datum/reagent/medicine/purger/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_PURGER, 1)

/datum/reagent/medicine/purger/overdose(mob/living/carbon/M, alien)
	. = ..()
	M.add_chemical_effect(CE_PURGER, 2)

/datum/reagent/medicine/addictol
	name = "Addictol"
	id = "addictol"
	description = "Purges all addictions and greatly aids in treating chemical poisoning."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0179e7"
	scannable = 1
	metabolism = REM/2

/datum/reagent/medicine/addictol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	var/mob/living/carbon/C = M
	if(istype(C) && C.metabolism_effects.addiction_list.len)
		if(prob(5 * effect_multiplier + dose))
			var/datum/reagent/R = pick(C.metabolism_effects.addiction_list)
			to_chat(C, SPAN_NOTICE("You dont crave [R.name] anymore."))
			C.metabolism_effects.addiction_list.Remove(R)
			qdel(R)
	M.add_chemical_effect(CE_PURGER, 2)

/datum/reagent/medicine/addictol/on_mob_delete(mob/living/L)
	..()
	var/mob/living/carbon/C = L
	if(dose >= 10)
		if(istype(C))
			C.remove_all_addictions()

/datum/reagent/medicine/aminazine
	name = "Aminazine"
	id = "aminazine"
	description = "Medication designed to suppress withdrawal effects for some time."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#88336f"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	metabolism = REM/2

/datum/reagent/medicine/aminazine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_NOWITHDRAW, 1)

/datum/reagent/medicine/haloperidol
	name = "Haloperidol"
	id = "haloperidol"
	description = "Purges chems from bloodstream, lowers NSA and sedates patient. An overdose of haloperidol can be fatal."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ba1f04"
	overdose = REAGENTS_OVERDOSE/2
	scannable = 1
	metabolism = REM/2

/datum/reagent/medicine/haloperidol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(M.bloodstr)
		for(var/current in M.bloodstr.reagent_list)
			var/datum/reagent/toxin/pararein/R = current
			if(!istype(R, src))
				R.remove_self(effect_multiplier * pick(list(1,2,3)))
	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(effective_dose < 1)
		if(effective_dose == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(effective_dose < 1.5)
		M.eye_blurry = max(M.eye_blurry, 10)
	else if(effective_dose < 3)
		if(prob(50))
			M.Weaken(2)
		M.drowsyness = max(M.drowsyness, 20)
	else
		M.sleeping = max(M.sleeping, 20)
		M.drowsyness = max(M.drowsyness, 60)
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/medicine/haloperidol/overdose(mob/living/carbon/M, alien)
	M.add_chemical_effect(CE_TOXIN, 6)

/datum/reagent/medicine/vomitol
	name = "Vomitol"
	id = "vomitol"
	description = "Forces patient to vomit - results in total cleaning of his stomach. Has extremely unpleasant taste and seems to collect on food in mushroom rich enviroments."
	taste_description = "worst thing in the world"
	reagent_state = LIQUID
	color = "#a6b85b"
	overdose = REAGENTS_OVERDOSE
	heating_point = 683.15
	heating_products = list("carbon", "hclacid", "acetone")

/datum/reagent/medicine/vomitol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(10 * effect_multiplier))
		M.vomit()

/datum/reagent/medicine/suppressital
	name = "Suppressital"
	id = "suppressital"
	description = "Medication designed to make breakdowns impossible to happen."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#001aff"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM/2

/datum/reagent/medicine/suppressital/affect_blood/(mob/living/carbon/M)
	if(!M.stats.getPerk(PERK_NJOY))
		M.stats.addPerk(PERK_NJOY)

/datum/reagent/medicine/suppressital/on_mob_delete(mob/living/M)
	..()
	M.stats.removePerk(PERK_NJOY)

