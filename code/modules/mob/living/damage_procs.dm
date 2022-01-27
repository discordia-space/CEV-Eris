
/*
	apply_damage(a,b,c)
	args
	a:damage - How69uch damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE,69ar/def_zone =69ull,69ar/sharp = FALSE,69ar/edge = FALSE,69ar/used_weapon =69ull)
	activate_ai()
	switch(damagetype)

		if(BRUTE)
			adjustBruteLoss(damage)

		if(BURN)
			if(COLD_RESISTANCE in69utations)
				damage = 0
			adjustFireLoss(damage)

		if(TOX)
			adjustToxLoss(damage)

		if(OXY)
			adjustOxyLoss(damage)

		if(CLONE)
			adjustCloneLoss(damage)

		if(HALLOSS)
			adjustHalLoss(damage)

	flash_weak_pain()
	updatehealth()

	return TRUE


/mob/living/proc/apply_damages(var/brute = 0,69ar/burn = 0,69ar/tox = 0,69ar/oxy = 0,69ar/clone = 0,69ar/halloss = 0,69ar/def_zone =69ull)
	activate_ai()
	if(brute)	apply_damage(brute, BRUTE, def_zone)
	if(burn)	apply_damage(burn, BURN, def_zone)
	if(tox)		apply_damage(tox, TOX, def_zone)
	if(oxy)		apply_damage(oxy, OXY, def_zone)
	if(clone)	apply_damage(clone, CLONE, def_zone)
	if(halloss) apply_damage(halloss, HALLOSS, def_zone)

	return TRUE



/mob/living/proc/apply_effect(var/effect = 0,69ar/effecttype = STUN,69ar/armor_value = 0,69ar/check_protection = 1)
	activate_ai()

	if(!effect)
		return FALSE

	if(armor_value)
		effect = effect * ( ( 100 - armor_value ) / 100 )

	switch(effecttype)

		if(STUN)
			Stun(effect)
		if(WEAKEN)
			Weaken(effect)
		if(PARALYZE)
			Paralyse(effect)
		if(IRRADIATE)
			var/rad_protection = check_protection ? getarmor(null, ARMOR_RAD) / 100 : 0
			radiation +=69ax((1 - rad_protection) * effect, 0)//Rads auto check armor
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering =69ax(stuttering,(effect))
		if(EYE_BLUR)
			eye_blurry =69ax(eye_blurry,(effect))
		if(DROWSY)
			drowsyness =69ax(drowsyness,(effect))

	updatehealth()

	return TRUE


/mob/living/proc/apply_effects(var/stun = 0,69ar/weaken = 0,69ar/paralyze = 0,69ar/irradiate = 0,69ar/stutter = 0,69ar/eyeblur = 0,69ar/drowsy = 0,69ar/agony = 0,69ar/armor_value = 0)
	activate_ai()
	if(stun)		apply_effect(stun, STUN, armor_value)
	if(weaken)		apply_effect(weaken, WEAKEN, armor_value)
	if(paralyze)	apply_effect(paralyze, PARALYZE, armor_value)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, armor_value)
	if(stutter)		apply_effect(stutter, STUTTER, armor_value)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR, armor_value)
	if(drowsy)		apply_effect(drowsy, DROWSY, armor_value)
	return 1


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute,69ar/burn,69ar/additionally_brute_percent = 0,69ar/additionaly_burn_percent = 0)
	adjustBruteLoss(-(brute + getBruteLoss()/100 * additionally_brute_percent))
	adjustFireLoss(-(burn + getFireLoss()/100 * additionaly_burn_percent))
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute,69ar/burn,69ar/emp=0)
	activate_ai()
	if(status_flags & GODMODE)
		return FALSE	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal69ANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute,69ar/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage69ANY external organs, in random order
/mob/living/take_overall_damage(var/brute,69ar/burn,69ar/used_weapon =69ull)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()


/mob/living/get_fall_damage(var/turf/from,69ar/turf/dest)
	activate_ai()
	var/damage =69in(15,69axHealth*0.4)

	//If damage is69ultiplied by the69umber of floors you fall simultaneously
	if (from && dest)
		damage *= abs(from.z - dest.z)+1
	return damage

/mob/living/fall_impact(var/turf/from,69ar/turf/dest)
	activate_ai()
	var/damage = get_fall_damage(from, dest)
	if (damage > 0)
		take_overall_damage(damage)
		playsound(src, pick(punch_sound), 100, 1, 10)
		Weaken(4)
		updatehealth()
