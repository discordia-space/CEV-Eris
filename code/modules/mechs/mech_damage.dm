/mob/living/exosuit/apply_effect(effect = 0, effecttype = STUN, armor_value = 0, check_protection = TRUE)
	if(!effect || (armor_value >= 100))
		return 0
	if(LAZYLEN(pilots) && !prob(body.pilot_coverage))
		if(effect > 0 && effecttype == IRRADIATE)
			effect = max((1 - (getarmor(null, ARMOR_RAD) / 100)) * effect / (armor_value + 1),0)
		var/mob/living/pilot = pick(pilots)
		return pilot.apply_effect(effect, effecttype, armor_value)
	if(!(effecttype in list(AGONY, STUTTER, EYE_BLUR, DROWSY, STUN, WEAKEN)))
		. = ..()

/mob/living/exosuit/resolve_item_attack(obj/item/I, mob/living/user, def_zone)
	if(!I.force)
		user.visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly with \the [I]."))
		return

	if(LAZYLEN(pilots) && !prob(body.pilot_coverage))
		var/mob/living/pilot = pick(pilots)
		return pilot.resolve_item_attack(I, user, def_zone)

	return def_zone //Careful with effects, mechs shouldn't be stunned

/mob/living/exosuit/getarmor(def_zone, type)
	. = ..()
	if(body?.armor_plate)
		var/body_armor = body.armor_plate?.armor.getRating(type)
		if(body_armor) . += body_armor

/mob/living/exosuit/updatehealth()
	if(body) maxHealth = body.mech_health
	health = maxHealth - (getFireLoss() + getBruteLoss())

/mob/living/exosuit/adjustFireLoss(amount, obj/item/mech_component/MC = pick(list(arms, legs, body, head)))
	if(MC)
		MC.take_burn_damage(amount)
		MC.update_health()

/mob/living/exosuit/adjustBruteLoss(amount, obj/item/mech_component/MC = pick(list(arms, legs, body, head)))
	if(MC)
		MC.take_brute_damage(amount)
		MC.update_health()

/mob/living/exosuit/proc/zoneToComponent(zone)
	switch(zone)
		if(BP_EYES, BP_HEAD) return head
		if(BP_L_ARM, BP_R_ARM) return arms
		if(BP_L_LEG, BP_R_LEG) return legs
		else return body


/mob/living/exosuit/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, sharp = FALSE, edge = FALSE, obj/used_weapon = null)
	. = ..()
	updatehealth()

/mob/living/exosuit/getFireLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		total += MC.burn_damage
	return total

/mob/living/exosuit/getBruteLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		total += MC.brute_damage
	return total

/mob/living/exosuit/emp_act(severity)
	var/ratio = getarmor(null, ARMOR_ENERGY)

	if(ratio >= 1)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("Your Faraday shielding absorbed the pulse!"))
		return
	else if(ratio > 0)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("Your Faraday shielding mitigated the pulse!"))

		emp_damage += round((12 - (severity*3))*( 1 - ratio))
		if(severity <= 3)
			for(var/obj/item/thing in list(arms,legs,head,body))
				thing.emp_act(severity)
			if(!hatch_closed || !prob(body.pilot_coverage))
				for(var/thing in pilots)
					var/mob/pilot = thing
					pilot.emp_act(severity)
