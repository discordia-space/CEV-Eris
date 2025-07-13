
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, armor_divisor = 1, wounding_multiplier = 1, sharp = FALSE, edge = FALSE, used_weapon = null) // After melee rebalance set wounding_multiplier to 0 to activate melee wounding level determination
	activate_ai()
	switch(damagetype)
		if(BRUTE)
			wounding_multiplier = wound_check(injury_type, wounding_multiplier, edge, sharp)
			adjustBruteLoss(damage * wounding_multiplier)
		if(BURN)
//			if(COLD_RESISTANCE in mutations)
//				damage = 0
			wounding_multiplier = wound_check(injury_type, wounding_multiplier, edge, sharp) // Why not?
			adjustFireLoss(damage * wounding_multiplier)
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


/mob/living/proc/apply_damages(brute = 0, burn = 0, tox = 0, oxy = 0, clone = 0, halloss = 0, def_zone = null)
	activate_ai()
	if(brute)	apply_damage(brute, BRUTE, def_zone)
	if(burn)	apply_damage(burn, BURN, def_zone)
	if(tox)		apply_damage(tox, TOX, def_zone)
	if(oxy)		apply_damage(oxy, OXY, def_zone)
	if(clone)	apply_damage(clone, CLONE, def_zone)
	if(halloss) apply_damage(halloss, HALLOSS, def_zone)

	return TRUE



/mob/living/proc/apply_effect(effect = 0, effecttype = STUN, armor_value = 0, check_protection = 1)
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
			radiation += max((1 - rad_protection) * effect, 0)//Rads auto check armor
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry,(effect))
		if(DROWSY)
			drowsyness = max(drowsyness,(effect))

	updatehealth()

	return TRUE


/mob/living/proc/apply_effects(stun = 0, weaken = 0, paralyze = 0, irradiate = 0, stutter = 0, eyeblur = 0, drowsy = 0, agony = 0, armor_value = 0)
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
/mob/living/proc/heal_organ_damage(brute, burn, additionally_brute_percent = 0, additionaly_burn_percent = 0)
	adjustBruteLoss(-(brute + getBruteLoss()/100 * additionally_brute_percent))
	adjustFireLoss(-(burn + getFireLoss()/100 * additionaly_burn_percent))
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(brute, burn, emp=0)
	activate_ai()
	if(status_flags & GODMODE)
		return FALSE	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(brute, burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/take_overall_damage(brute, burn, used_weapon = null)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()


/mob/living/get_fall_damage(turf/from, turf/dest)
	activate_ai()
	var/damage = min(15, maxHealth*0.4)

	//If damage is multiplied by the number of floors you fall simultaneously
	if (from && dest)
		damage *= abs(from.z - dest.z)+1
	return damage

/mob/living/fall_impact(turf/from, turf/dest)
	activate_ai()
	var/damage = get_fall_damage(from, dest)
	if (damage > 0)
		take_overall_damage(damage)
		playsound(src, pick(punch_sound), 100, 1, 10)
		Weaken(4)
		updatehealth()
