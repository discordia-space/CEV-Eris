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
	var/list/damages = list(BRUTE = damage)
	if(user.dir & reverse_dir[dir])
		var/obj/item/mech_equipment/shield_generator/gen = getShield()
		if(gen)
			damages = gen.absorbDamages(damages)
	if(damages[BRUTE] == 0)
		return
	damage_through_armor(damages[BRUTE], BRUTE, attack_flag=ARMOR_MELEE, armor_divisor=penetration, def_zone=pick(arms, legs, body, head))
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
	if(!I.force)
		user.visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly with \the [I]."))
		return
	// must be in front if the hatch is opened , else we roll for any angle based on chassis coverage
	var/roll = !prob(body.pilot_coverage)
	var/list/damages = list(BRUTE = I.force)
	var/obj/item/mech_equipment/shield_generator/gen = getShield()
	if(gen)
		damages = gen.absorbDamages(damages)
// not enough made it in
	if(damages[BRUTE] < round(I.force / 2))
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
	if(!def_zone)
		def_zone = ran_zone()
	var/obj/item/mech_component/hit_zone = zoneToComponent(def_zone)
	var/armor = hit_zone?.armor.getRating(type)
	if(armor)
		return armor
	return 0

/mob/living/exosuit/updatehealth()
	if(body) maxHealth = body.mech_health
	health = maxHealth - (getFireLoss() + getBruteLoss())

/mob/living/exosuit/damage_through_armor(damage, damagetype, def_zone, attack_flag, armor_divisor, used_weapon, sharp, edge, wounding_multiplier, list/dmg_types = list(), return_continuation)
	var/obj/item/mech_component/comp = zoneToComponent(def_zone)
	var/armor_def = comp.armor.getRating(damagetype)
	var/deflect_chance = (comp.cur_armor + armor_def)*0.5
	world.log << "deflect_chance was [deflect_chance]"
	if(prob(deflect_chance))
		visible_message(SPAN_DANGER("\The [used_weapon] glances off of \the [src]'s [comp]!"))
		return 0
	else
		var/dam_dif = armor_def - damage
		comp.cur_armor = max(0, comp.cur_armor-max(1, dam_dif))
	. = ..()

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


/mob/living/exosuit/bullet_act(obj/item/projectile/P, def_zone)
	var/hit_dir = get_dir(P.starting, src)
	var/dir_mult = get_dir_mult(hit_dir)
	var/obj/item/mech_component/comp = zoneToComponent(def_zone)
	/// aiming for soemthing the mech doesnt have
	if(!def_zone)
		return PROJECTILE_FORCE_MISS

	if (P.is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
		IgniteMob()
	var/obj/item/mech_equipment/shield_generator/gen = getShield()
	var/list/damages = P.damage_types.Copy()
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
	var/local_armor_divisor = P.armor_divisor - round(comp.cur_armor/100, 0.1)
	for(var/damage_type in damages)
		if(damage_type == HALLOSS)
			continue
		damages[damage_type] = round(damages[damage_type] * dir_mult)
		damage_through_armor(damages[damage_type], damage_type, def_zone, P.check_armour, armor_divisor = local_armor_divisor, used_weapon = P, sharp = is_sharp(P), edge = has_edge(P))

	P.on_hit(src, def_zone)
	return PROJECTILE_STOP

/mob/living/exosuit/proc/get_dir_mult(hit_dir) // This looks like a bit of a mess, but BYOND's switch cases are very fast.
	var/rear_dir
	var/list/side_dirs
	switch(dir)
		if(NORTH)
			rear_dir = SOUTH
			side_dirs = list(EAST, WEST)
		if(SOUTH)
			rear_dir = NORTH
			side_dirs = list(EAST, WEST)
		if(EAST)
			rear_dir = WEST
			side_dirs = list(NORTH, SOUTH)
		if(WEST)
			rear_dir = EAST
			side_dirs = list(NORTH, SOUTH)

	if(hit_dir == rear_dir)
		. = 1.25 // Hit from the back
	else if(hit_dir in side_dirs)
		. = 1 // Hit from the sides
	else
		. = 0.75 // Hit from the front
	world.log << "return value was [.]"
	return .

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
