
/mob/living/carbon/proc/get_blood(datum/reagents/container)
	var/datum/reagent/blood/res = locate() in container.reagent_list //Grab some blood
	if(res) // Make sure there's some blood at all
		if(res.data["donor"] != src) //If it's not theirs, then we look for theirs
			for(var/datum/reagent/blood/D in container.reagent_list)
				if(D.data["donor"] == src)
					return D
	return res

//Get fluffy numbers
/mob/living/carbon/proc/get_blood_pressure()
	if(status_flags & FAKEDEATH)
		return "[Floor(120+rand(-5,5))*0.25]/[Floor(80+rand(-5,5)*0.25)]"
	var/blood_result = get_blood_circulation()
	return "[Floor((120+rand(-5,5))*(blood_result/100))]/[Floor((80+rand(-5,5))*(blood_result/100))]"

/mob/living/carbon/proc/get_blood_volume()
	return round((vessel.get_reagent_amount("blood"))*100)

//Percentage of maximum blood volume, affected by the condition of circulation organs
/mob/living/carbon/proc/get_blood_circulation()
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
	var/blood_volume = get_blood_volume()
	if(!heart)
		return 0.25 * blood_volume

	var/recent_pump = LAZYACCESS(heart.external_pump, 1) > world.time - (20 SECONDS)
	var/pulse_mod = 1
	if((status_flags & FAKEDEATH) || BP_IS_ROBOTIC(heart))
		pulse_mod = 1
	else
		switch(heart.pulse)
			if(PULSE_NONE)
				if(recent_pump)
					pulse_mod = LAZYACCESS(heart.external_pump, 2)
				else
					pulse_mod *= 0.25
			if(PULSE_SLOW)
				pulse_mod *= 0.9
			if(PULSE_FAST)
				pulse_mod *= 1.1
			if(PULSE_2FAST, PULSE_THREADY)
				pulse_mod *= 1.25
	blood_volume *= pulse_mod

	var/min_efficiency = recent_pump ? 0.5 : 0.3
	blood_volume *= max(min_efficiency, (1-(heart.damage / heart.max_damage)))

	if(chem_effects[CE_BLOCKAGE])
		blood_volume *= max(0, 1-chem_effects[CE_BLOCKAGE])

	return min(blood_volume, 100)

//Percentage of maximum blood volume, affected by the condition of circulation organs, affected by the oxygen loss. What ultimately matters for brain
/mob/living/carbon/proc/get_blood_oxygenation()
	var/blood_volume = get_blood_circulation()
	if(is_asystole()) // Heart is missing or isn't beating and we're not breathing (hardcrit)
		return min(blood_volume, BLOOD_VOLUME_SURVIVE)

	if(!need_breathe())
		return blood_volume
	else
		blood_volume = 100

	var/blood_volume_mod = max(0, 1 - getOxyLoss()/(species.total_health/2))
	var/oxygenated_mult = 0
	if(chem_effects[CE_OXYGENATED] == 1) // Dexalin.
		oxygenated_mult = 0.5
	else if(chem_effects[CE_OXYGENATED] >= 2) // Dexplus.
		oxygenated_mult = 0.8
	blood_volume_mod = blood_volume_mod + oxygenated_mult - (blood_volume_mod * oxygenated_mult)
	blood_volume = blood_volume * blood_volume_mod
	return min(blood_volume, 100)

//Whether the specimen needs blood to carry oxygen. Used in get_blood_oxygenation and may be expanded based on blood rather than species in the future.
/mob/living/carbon/proc/blood_carries_oxygen()
	return TRUE