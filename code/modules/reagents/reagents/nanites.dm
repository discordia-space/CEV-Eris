// Nanobots blood drain per unit
#define NANOBOTS_BLOOD_DRAIN 0.003

/datum/reagent/nanites
	name = "Nanomachines" // son
	id = "dont use these"
	description = "Microscopic construction robots."
	taste_description = "slimey metal"
	reagent_state = LIQUID
	color = "#696969" // ( ͡° ͜ʖ ͡°)
	metabolism = REM/2
	heating_point = 363
	heating_products = list("toxin")

/datum/reagent/nanites/proc/eatBlood(var/mob/living/carbon/M) // Yam !
	var/datum/reagent/blood/B = M.get_blood()
	// blood regeneratin 0.1 u every tick so with NANOBOTS_BLOOD_DRAIN = 0.003 human can sustain 30u nanobots without losing blood
	if(B && B.volume)
		B.remove_self(volume * NANOBOTS_BLOOD_DRAIN)

/datum/reagent/nanites/proc/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	if(location == CHEM_BLOOD)
		return TRUE

/datum/reagent/nanites/consumed_amount(mob/living/carbon/M, var/alien, var/location)
	if(will_occur(M, alien, location))
		return ..()
	else
		return 0

/datum/reagent/nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	eatBlood()
	if(M.get_blood_volume() < BLOOD_VOLUME_OKAY)
		var/removed = consumed_amount() * (BLOOD_VOLUME_OKAY - M.get_blood_volume() / 100)
		removed = min(volume,removed)
		var/datum/reagents/metabolism/met = M.getMetabolismHandler(CHEM_BLOOD)
		met.remove_reagent(id, removed)
		met.add_reagent("nanodead", removed)
	if(will_occur(M, alien, CHEM_BLOOD))
		return TRUE

/datum/reagent/nanites/capped
	name = "Raw Industrial Nanobots"
	id = "nanites"
	description = "Microscopic construction robots."

/datum/reagent/nanites/capped/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	return FALSE

/datum/reagent/nanites/dead
	name = "Broken Nanobots"
	id = "nanodead"
	description = "Broken microscopic construction robots."
	taste_description = "slimey metal"
	color = "#535E66"
	metabolism = REM/4

/datum/reagent/nanites/dead/eatBlood(var/mob/living/carbon/M)
	return

/datum/reagent/nanites/dead/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	return TRUE

/datum/reagent/nanites/dead/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		M.adjustToxLoss(0.2 * effectMultiplier)

/datum/reagent/nanites/uncapped
	name = "Raw Uncapped Nanobots"
	id = "uncap nanites"
	description = "Microscopic construction robots."

/datum/reagent/nanites/uncapped/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	return FALSE

/datum/reagent/nanites/arad
	name = "A-rad (nanobots)"
	id = "arad nanites"
	description = "Microscopic construction robots."

/datum/reagent/nanites/arad/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	if(..() && M.radiation)
		return TRUE
		

/datum/reagent/nanites/arad/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		M.radiation = max(M.radiation - (5 + M.radiation * 0.10) * effectMultiplier, 0)
		

/datum/reagent/nanites/implantMedics
	name = "Implant Medics (nanobots)"
	id = "implant nanites"
	description = "Microscopic construction robots."


/datum/reagent/nanites/implantMedics/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	var/mob/living/carbon/human/H = M
	if(..() && istype(H))
		constantMetabolism = FALSE
		metabolism = initial(metabolism)
		for(var/obj/item/organ/organ in H.organs) //Grab the organ holding the implant.
			if((organ.damage > 0) && BP_IS_ROBOTIC(organ)) //only robotic organs
				return TRUE
			if(istype(organ, /obj/item/organ/external))
				var/obj/item/organ/external/E = organ
				for(var/obj/item/weapon/implant/I in E.implants)
					if(I.malfunction)
						metabolism = 1
						constantMetabolism = TRUE
						return TRUE
			

/datum/reagent/nanites/implantMedics/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		var/mob/living/carbon/human/H = M
		if(istype(H))
			for(var/obj/item/organ/organ in H.organs) //Grab the organ holding the implant.
				if(metabolism == 1 && istype(organ, /obj/item/organ/external)) // if metabolism == 1 then broken implant is found see implantMedics/will_occur()
					var/obj/item/organ/external/E = organ
					for(var/obj/item/weapon/implant/I in E.implants)
						if(I.malfunction)
							I.restore()
							return
				else if (istype(organ, /obj/item/organ/external) && organ.damage > 0 && BP_IS_ROBOTIC(organ))
					organ.heal_damage((2 + organ.damage * 0.05)* effectMultiplier, (2 + organ.damage * 0.05)* effectMultiplier, 1, 1)
					return
				else if (istype(organ, /obj/item/organ/internal) && organ.damage > 0 && BP_IS_ROBOTIC(organ))
					organ.heal_damage((2 + organ.damage * 0.05)* effectMultiplier)
					return
				

/datum/reagent/nanites/nantidotes
	name = "Nantidotes (nanobots)"
	id = "nantidotes"
	description = "Microscopic construction robots."

/datum/reagent/nanites/nantidotes/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	if(..() && M.bloodstr)
		for(var/current in M.bloodstr.reagent_list)
			if(!istype(current, /datum/reagent/nanites))
				return TRUE

/datum/reagent/nanites/nantidotes/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		if(M.bloodstr)
			for(var/current in M.bloodstr.reagent_list)
				var/datum/reagent/R = current
				if(!istype(current, /datum/reagent/nanites))
					R.remove_self(effectMultiplier * 1)

/datum/reagent/nanites/nanosymb
	name = "Nanosymbiotes (nanobots)"
	id = "nanosymb"
	description = "Microscopic construction robots."

/datum/reagent/nanites/nanosymb/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	if(..() && (M.getBruteLoss() || M.getFireLoss() || M.getToxLoss() || M.getCloneLoss() || M.getBrainLoss()))
		return TRUE

/datum/reagent/nanites/nanosymb/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		M.heal_organ_damage(1 * effectMultiplier, 1 * effectMultiplier, 3 * effectMultiplier, 3 * effectMultiplier)
		M.adjustToxLoss(-((1 + (M.getToxLoss() * 0.03)) * effectMultiplier))
		M.adjustCloneLoss(-(1 + (M.getCloneLoss() * 0.03)) * effectMultiplier)
		M.adjustBrainLoss(-(1 + (M.getBrainLoss() * 0.03)) * effectMultiplier)

/datum/reagent/nanites/oxyrush
	name = "Oxyrush (nanobots)"
	id = "oxyrush"
	description = "Microscopic construction robots."

/datum/reagent/nanites/oxyrush/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	if(..() && M.getOxyLoss())
		return TRUE

/datum/reagent/nanites/oxyrush/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		M.adjustOxyLoss(-30 * effectMultiplier)
		M.add_chemical_effect(CE_OXYGENATED, 2)

/datum/reagent/nanites/tcs
	name = "Trauma Control System (nanobots)"
	id = "tcs"
	description = "Microscopic construction robots."

/datum/reagent/nanites/tcs/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	if(..())
		var/mob/living/carbon/human/H = M
		if(istype(H))
			for(var/obj/item/organ/organ in H.organs) //Grab the organ holding the implant.
				if(organ.damage > 0 && !BP_IS_ROBOTIC(organ))
					return TRUE

/datum/reagent/nanites/tcs/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		var/mob/living/carbon/human/H = M
		if(istype(H))
			for(var/obj/item/organ/organ in H.organs) //Grab the organ holding the implant.
				if (istype(organ, /obj/item/organ/external) && organ.damage > 0 && !BP_IS_ROBOTIC(organ))
					organ.heal_damage((2 + organ.damage * 0.03)* effectMultiplier, (2 + organ.damage * 0.03)* effectMultiplier)
				else if (istype(organ, /obj/item/organ/internal) && organ.damage > 0 && !BP_IS_ROBOTIC(organ))
					organ.heal_damage((2 + organ.damage * 0.03)* effectMultiplier)

/datum/reagent/nanites/purgers
	name = "Purgers (nanobots)"
	id = "nanopurgers"
	description = "Microscopic construction robots."

/datum/reagent/nanites/purgers/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	if(..() && M.bloodstr)
		for(var/current in M.bloodstr.reagent_list)
			if(istype(current, /datum/reagent/nanites) && !istype(current, /datum/reagent/nanites/purgers))
				return TRUE

/datum/reagent/nanites/purgers/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		if(M.bloodstr)
			for(var/current in M.bloodstr.reagent_list)
				var/datum/reagent/R = current
				if(istype(current, /datum/reagent/nanites) && !istype(current, /datum/reagent/nanites/purgers))
					R.remove_self(effectMultiplier * 1)

/datum/reagent/nanites/uncapped/will_occur(var/mob/living/carbon/M, var/alien, var/location)
	if(..())
		return TRUE


/datum/reagent/nanites/uncapped/controlBoosterUtility
	name = "Control Booster Utility (uncapped nanobots)"
	id = "cbu"
	description = "Microscopic construction robots."

/datum/reagent/nanites/uncapped/controlBoosterUtility/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		M.stats.addTempStat(STAT_MEC, STAT_LEVEL_ADEPT, STIM_TIME, "CBU")
		M.stats.addTempStat(STAT_BIO, STAT_LEVEL_ADEPT, STIM_TIME, "CBU")
		M.stats.addTempStat(STAT_COG, STAT_LEVEL_ADEPT, STIM_TIME, "CBU")

/datum/reagent/nanites/uncapped/controlBoosterCombat
	name = "Control Booster Combat (uncapped nanobots)"
	id = "cbc"
	description = "Microscopic construction robots."

/datum/reagent/nanites/uncapped/controlBoosterCombat/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		M.stats.addTempStat(STAT_VIG, STAT_LEVEL_ADEPT, STIM_TIME, "CBC")
		M.stats.addTempStat(STAT_TGH, STAT_LEVEL_ADEPT, STIM_TIME, "CBC")
		M.stats.addTempStat(STAT_ROB, STAT_LEVEL_ADEPT, STIM_TIME, "CBC")

/datum/reagent/nanites/uncapped/voiceMimic
	name = "Voice mimics (uncapped nanobots)"
	id = "nanovoice"
	description = "Changes users voice. You should hit them first, just in case..."
	var/voiceName = "Unknown"

/datum/reagent/nanites/uncapped/voiceMimic/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		M.add_chemical_effect(CE_VOICEMIMIC, voiceName)

/datum/reagent/nanites/uncapped/dynamicHandprints
	name = "Nanomachines (uncapped nanobots)"
	id = "nanohands"
	description = "Microscopic construction robots."
	var/uni_identity

/datum/reagent/nanites/uncapped/dynamicHandprints/on_mob_add(mob/living/L)
	var/mob/living/carbon/human/host = L
	if(istype(host))
		for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
			if(host != H && H.dna)
				uni_identity = H.dna.uni_identity
				return

/datum/reagent/nanites/uncapped/dynamicHandprints/affect_blood(var/mob/living/carbon/M, var/alien, var/effectMultiplier)
	if(..())
		M.add_chemical_effect(CE_DYNAMICFINGERS, uni_identity)