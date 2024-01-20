/mob/living/exosuit/apply_effect(effect = 0, effecttype = STUN, armor_value = 0, check_protection = TRUE)
	if(!effect || (armor_value >= 100))
		return 0
	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		if(effect > 0 && effecttype == IRRADIATE)
			effect = max((1 - (getarmor(null, ARMOR_RAD) / 100)) * effect / (armor_value + 1),0)
		var/mob/living/pilot = pick(pilots)
		return pilot.apply_effect(effect, effecttype, armor_value)
	if(!(effecttype in list(STUTTER, EYE_BLUR, DROWSY, STUN, WEAKEN)))
		. = ..()

/mob/living/exosuit/attack_generic(mob/user, var/damage, var/attack_message)

	if(!damage || !istype(user))
		return

	var/penetration = 0
	if(istype(user, /mob/living))
		var/mob/living/L = user
		penetration = L.armor_divisor
	var/list/damages = list(ARMOR_BLUNT = list(
		DELEM(BRUTE, damage)
	))
	if(user.dir & reverse_dir[dir])
		var/obj/item/mech_equipment/shield_generator/gen = getShield()
		if(gen)
			damages = gen.absorbDamages(damages)
	if(damages[ARMOR_BLUNT][1][2] == 0)
		return
	damage_through_armor(damages, pick(arms,legs,body,head), user, penetration, 1, FALSE)
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [name] ([ckey])</font>")
	attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [user.name] ([user.ckey])</font>")
	visible_message(SPAN_DANGER("[user] has [attack_message] [src]!"))
	user.do_attack_animation(src)
	updatehealth()
	return TRUE

/// Returns the best shield for damage reduction
/mob/living/exosuit/proc/getShield()
	var/obj/item/mech_equipment/shield_generator/chosen = null
	for(var/hardpoint in hardpoints)
		var/obj/item/mech_equipment/thing = hardpoints[hardpoint]
		if(istype(thing , /obj/item/mech_equipment/shield_generator))
			var/obj/item/mech_equipment/shield_generator/gen = thing
			if(!chosen || (chosen && (chosen.getEffectiveness() < gen.getEffectiveness())))
				chosen = gen
	return chosen

/mob/living/exosuit/resolve_item_attack(obj/item/I, mob/living/user, def_zone)
	if(dhTotalDamage(I.melleDamages) < 5)
		user.visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly with \the [I]."))
		return
	// must be in front if the hatch is opened , else we roll for any angle based on chassis coverage
	var/roll = !prob(body.pilot_coverage)
	var/list/damages = I.melleDamages.Copy()
	var/obj/item/mech_equipment/shield_generator/gen = getShield()
	if(gen)
		damages = gen.absorbDamages(damages)
// not enough made it in
	if(dhTotalDamage(damages) < round(dhTotalDamage(GLOB.melleDamagesCache[I.type]) / 2))
		visible_message("\The [src]'s shields block the blow!", 1, 2 ,5)
		return

	if(LAZYLEN(pilots) && ((!hatch_closed && (get_dir(user,src) & reverse_dir[dir])) || roll))
		var/mob/living/pilot = pick(pilots)
		var/turf/location = get_turf(src)
		location.visible_message(SPAN_DANGER("\The [user] attacks the pilot inside of \the [src]."),1,5)
		return pilot.resolve_item_attack(I, user, def_zone)
	else if(LAZYLEN(pilots) && !roll)
		var/turf/location = get_turf(src)
		location.visible_message(SPAN_DANGER("\The [user] tries to attack the pilot inside of \the [src], but the chassis blocks it!"), 1, 5)
		return def_zone

	return def_zone //Careful with effects, mechs shouldn't be stunned

/mob/living/exosuit/getarmor(def_zone, type)
	if(body?.armor_plate)
		var/body_armor = body.armor_plate?.armor.getRating(type)
		if(body_armor) return body_armor
	return 0

/mob/living/exosuit/updatehealth()
	if(body) maxHealth = body.mech_health
	health = maxHealth - (getFireLoss() + getBruteLoss())

/mob/living/exosuit/adjustFireLoss(amount, obj/item/mech_component/MC = null)
	if(!MC)
		var/list/picklist = list()
		if(arms) picklist.Add(arms)
		if(legs) picklist.Add(legs)
		if(head) picklist.Add(head)
		if(body) picklist.Add(body)
		MC = pick(picklist)
	if(amount < 1)
		return FALSE
	MC.take_burn_damage(amount)
	MC.update_health()

/mob/living/exosuit/adjustBruteLoss(amount, obj/item/mech_component/MC = null)
	if(!MC)
		var/list/picklist = list()
		if(arms) picklist.Add(arms)
		if(legs) picklist.Add(legs)
		if(head) picklist.Add(head)
		if(body) picklist.Add(body)
		MC = pick(picklist)
	if(amount < 1)
		return FALSE
	MC.take_brute_damage(amount)
	MC.update_health()

/mob/living/exosuit/proc/zoneToComponent(zone)
	switch(zone)
		if(BP_EYES, BP_HEAD, BP_MOUTH) return head
		if(BP_L_ARM, BP_R_ARM) return arms
		if(BP_L_LEG, BP_R_LEG, BP_GROIN) return legs
		else return body

/mob/living/exosuit/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, armor_divisor = 1, wounding_multiplier = 1, sharp = FALSE, edge = FALSE, obj/used_weapon = null)
	if(istext(def_zone))
		def_zone = zoneToComponent(def_zone)

	switch(damagetype)
		if(BRUTE)
			wounding_multiplier = wound_check(injury_type, wounding_multiplier, edge, sharp)
			adjustBruteLoss(damage * wounding_multiplier, def_zone)
			return TRUE
		if(BURN)
			wounding_multiplier = wound_check(injury_type, wounding_multiplier, edge, sharp)
			adjustFireLoss(damage * wounding_multiplier, def_zone)
			return TRUE
	updatehealth()
	return FALSE


/mob/living/exosuit/bullet_act(obj/item/projectile/P, var/def_zone)
	var/hit_dir = get_dir(P.starting, src)
	def_zone = zoneToComponent(def_zone)
	/// aiming for soemthing the mech doesnt have
	if(!def_zone)
		return PROJECTILE_FORCE_MISS

	if (P.is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
		IgniteMob()
	var/obj/item/mech_equipment/shield_generator/gen = getShield()
	var/list/damages = P.damage
	if(hit_dir & reverse_dir[dir])
		if(gen)
			damages = gen.absorbDamages(damages)
		if(def_zone == body)
			if(!hatch_closed || !prob(body.pilot_coverage))
				var/mob/living/pilot = get_mob()
				if(pilot)
					var/result = pilot.bullet_act(P, ran_zone())
					var/turf/location = get_turf(src)
					location.visible_message("[get_mob()] gets hit by \the [P]!")
					if(result != PROJECTILE_CONTINUE)
						return
	if(P.taser_effect)
		qdel(P)
		return TRUE
	hit_impact(P.get_structure_damage(), hit_dir)
	damage_through_armor(damages, def_zone, P,P.armor_divisor, P.wounding_mult, FALSE)
	P.on_hit(src, def_zone)
	return PROJECTILE_STOP

/mob/living/exosuit/getDamageBlockers(list/armorToDam, armorDiv, woundMult, defZone)
	var/list/blockers = list(src)
	if(body && body.armor)
		blockers |= body.armor_plate
	return blockers

/mob/living/exosuit/getDamageBlockerRatings(list/relevantTypes)
	var/list/returnList = ..()
	if(!body)
		return returnList
	if(!body.armor)
		return returnList
	for(var/armorType in relevantTypes)
		returnList[armorType] += body.armor.getRating(armorType)
	return returnList

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
	var/emp_resist = 1 + getarmor(null, ARMOR_ENERGY)

	if(emp_resist >= 30)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("The electromagnetic pulse fails to penetrate your Faraday shielding!"))
		return
	else if(emp_resist < 30)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("The electromagnetic pulse penetrates your shielding, causing damage!"))

		emp_damage += round((12 - severity) / emp_resist * 20)
		if(severity <= 3)
			for(var/obj/item/thing in list(arms,legs,head,body))
				thing.emp_act(severity)
			if(!hatch_closed || !prob(body.pilot_coverage))
				for(var/thing in pilots)
					var/mob/pilot = thing
					pilot.emp_act(severity)

/mob/living/exosuit/explosion_act(target_power, explosion_handler/handler)
	var/damage = target_power - getarmor(body, ARMOR_BOMB)
	var/split = round(damage/4)
	var/blocked = 0
	if(head)
		adjustBruteLoss(split, head)
		blocked++
	if(body)
		if(get_mob() && !(hatch_closed || prob(body.pilot_coverage)))
			var/mob/living/pilot = get_mob()
			// split damage between pilot n mech
			pilot.explosion_act(round(split/2), handler)
			adjustBruteLoss(round(split/2), body)
		else
			adjustBruteLoss(split, body)
		blocked++
	if(legs)
		adjustBruteLoss(split, legs)
		blocked++
	if(arms)
		adjustBruteLoss(split, arms)
		blocked++
	if(damage > 400)
		occupant_message("You feel the shockwave of an external explosion pass through your body!")

	return round(split*blocked)

