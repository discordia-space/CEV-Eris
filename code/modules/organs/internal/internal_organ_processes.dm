#define BRUISED_2_EFFICIENCY 80
#define BROKEN_2_EFFICIENCY 50
#define DEAD_2_EFFICIENCY 0

//Has processes for all internal organs, called from /mob/living/carbon/human/Life()

/mob/living/carbon/human/proc/porcess_internal_ograns() //Calls all of the internal organ processes
	eye_process()
	kidney_process()
	liver_process()
	heart_process()
	lung_process()

/mob/living/carbon/human/proc/get_organ_efficiency(bodypart_define)
	var/obj/item/organ/internal/I = internal_organs_by_name[bodypart_define] //Change this to not a dumb list
	if(I)
		I.update_organ_efficiency()
		return I.organ_efficiency
	else
		return 0

/mob/living/carbon/human/proc/eye_process()
	var/eye_efficiency = get_organ_efficiency(BP_EYES)

	if(eye_efficiency < BRUISED_2_EFFICIENCY)
		eye_blurry = 1
	if(eye_efficiency < BROKEN_2_EFFICIENCY)
		eye_blind = 1
	update_client_colour()

/mob/living/carbon/human/proc/kidney_process()
	var/datum/reagents/metabolism/BLOOD_METABOLISM = get_metabolism_handler(CHEM_BLOOD)
	var/kidneys_efficiency = get_organ_efficiency(BP_KIDNEYS)
	//If your kidneys aren't working, your body's going to have a hard time cleaning your blood.
	if(chem_effects[CE_ANTITOX])
		if(kidneys_efficiency < BRUISED_2_EFFICIENCY)
			if(prob(5) && BLOOD_METABOLISM.get_reagent_amount("potassium") < 5)
				BLOOD_METABOLISM.add_reagent("potassium", REM*5)
		if(kidneys_efficiency < BROKEN_2_EFFICIENCY)
			if(BLOOD_METABOLISM.get_reagent_amount("potassium") < 15)
				BLOOD_METABOLISM.add_reagent("potassium", REM*2)
		if(kidneys_efficiency < DEAD_2_EFFICIENCY)
			adjustToxLoss(1)

/mob/living/carbon/human/proc/liver_process()

	var/liver_efficiency = get_organ_efficiency(BP_LIVER)
	var/obj/item/organ/internal/liver = internal_organs_by_name[BP_LIVER]

	if(chem_effects[CE_ANTITOX])
		liver_efficiency += chem_effects[CE_ANTITOX] * 33
	// If you're not filtering well, you're in trouble. Ammonia buildup to toxic levels and damage from alcohol
	if(liver_efficiency < 66)
		if(chem_effects[CE_ALCOHOL])
			adjustToxLoss(0.5 * max(2 - (liver_efficiency * 0.01), 0) * (chem_effects[CE_ALCOHOL_TOXIC] + 0.5 * chem_effects[CE_ALCOHOL]))
	else if(!chem_effects[CE_ALCOHOL] && !chem_effects[CE_TOXIN] && !radiation) // Heal a bit if needed and we're not busy. This allows recovery from low amounts of toxloss.
		// this will filter some toxins out of owners body
		adjustToxLoss(-(liver_efficiency * 0.001))


	if(chem_effects[CE_ALCOHOL_TOXIC])
		liver.take_internal_damage(chem_effects[CE_ALCOHOL_TOXIC], prob(90)) // Chance to warn them

	

	//Blood regeneration if there is some space
	regenerate_blood(0.1 + chem_effects[CE_BLOODRESTORE])

	// Blood loss or liver damage make you lose nutriments
	var/blood_volume = get_blood_volume()
	if(blood_volume < BLOOD_VOLUME_SAFE || (liver_efficiency < BRUISED_2_EFFICIENCY))
		if(nutrition >= 300)
			adjustNutrition(-10)
		else if(nutrition >= 200)
			adjustNutrition(-3)


/mob/living/carbon/human/proc/heart_process()
	handle_pulse()
	handle_heart_blood()

	if(get_blood_oxygenation() < BLOOD_VOLUME_SURVIVE)
		if(chem_effects[CE_STABLE] || prob(60))
			adjustBrainLoss(0.5)

/mob/living/carbon/human/proc/handle_pulse()
	var/obj/item/organ/internal/heart = internal_organs_by_name[BP_HEART]
	if(stat == DEAD || (heart.nature == MODIFICATION_SILICON || heart.nature == MODIFICATION_LIFELIKE))
		pulse = PULSE_NONE	//that's it, you're dead (or your metal heart is), nothing can influence your pulse
		return
	if(life_tick % 5 == 0)//update pulse every 5 life ticks (~1 tick/sec, depending on server load)
		pulse = PULSE_NORM

		if(round(vessel.get_reagent_amount("blood")) <= BLOOD_VOLUME_BAD)	//how much blood do we have
			pulse  = PULSE_THREADY	//not enough :(

		if(status_flags & FAKEDEATH || chem_effects[CE_NOPULSE])
			pulse = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds

		pulse = CLAMP(pulse + chem_effects[CE_PULSE], PULSE_SLOW, PULSE_2FAST)

/mob/living/carbon/human/proc/handle_heart_blood()
	var/heart_efficiency = get_organ_efficiency(BP_HEART)
	if(stat == DEAD && bodytemperature >= 170)	//Dead or cryosleep people do not pump the blood.
		return

	var/blood_volume_raw = vessel.get_reagent_amount("blood")
	var/blood_volume = round((blood_volume_raw/species.blood_volume)*100) // Percentage.


	// Damaged heart virtually reduces the blood volume, as the blood isn't
	// being pumped properly anymore.
	if(heart_efficiency < BROKEN_2_EFFICIENCY)
		blood_volume *= 0.3
	else if(heart_efficiency < BRUISED_2_EFFICIENCY)
		blood_volume *= 0.6
	else if(heart_efficiency < 100)
		blood_volume *= 0.8

	//Effects of bloodloss
	switch(blood_volume)

		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			if(prob(1))
				to_chat(src, SPAN_WARNING("You feel [pick("dizzy","woosey","faint")]"))
			if(getOxyLoss() < 20)
				adjustOxyLoss(3)
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			eye_blurry = max(eye_blurry,6)
			if(getOxyLoss() < 50)
				adjustOxyLoss(10)
			adjustOxyLoss(1)
			if(prob(15))
				Paralyse(rand(1,3))
				to_chat(src, SPAN_WARNING("You feel extremely [pick("dizzy","woosey","faint")]"))
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			adjustOxyLoss(5)
			adjustToxLoss(3)
			if(prob(15))
				to_chat(src, SPAN_WARNING("You feel extremely [pick("dizzy","woosey","faint")]"))
		else if(blood_volume < BLOOD_VOLUME_SURVIVE)
			death()

	//Blood regeneration if there is some space
	if(blood_volume_raw < species.blood_volume)
		var/datum/reagent/organic/blood/B = get_blood(vessel)
		B.volume += 0.1 // regenerate blood VERY slowly
		if(CE_BLOODRESTORE in chem_effects)
			B.volume += chem_effects[CE_BLOODRESTORE]

	// Blood loss or liver damage make you lose nutriments
	if(blood_volume < BLOOD_VOLUME_SAFE || heart_efficiency < BRUISED_2_EFFICIENCY)
		if(nutrition >= 300)
			nutrition -= 10
		else if(nutrition >= 200)
			nutrition -= 3


/mob/living/carbon/human/proc/lung_process()
	var/lung_efficiency = get_organ_efficiency(BP_LUNGS)
	if(lung_efficiency < BRUISED_2_EFFICIENCY)
		if(prob(2))
			spawn emote("me", 1, "coughs up blood!")
			drip_blood(10)
		if(prob(4))
			spawn emote("me", 1, "gasps for air!")
			losebreath += 15


#undef BRUISED_2_EFFICIENCY
#undef BROKEN_2_EFFICIENCY
#undef DEAD_2_EFFICIENCY
