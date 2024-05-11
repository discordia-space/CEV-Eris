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

/mob/living/exosuit/proc/getPilotCoverage(direction)
	if(!body)
		return 0
	if(!length(body.coverage_multipliers))
		return body.pilot_coverage
	else
		if(direction & dir)
			// behind
			return body.pilot_coverage * body.coverage_multipliers[3]
		else if(direction & reverse_dir[dir])
			// front
			return body.pilot_coverage * body.coverage_multipliers[1]
		else
			// sides
			return body.pilot_coverage * body.coverage_multipliers[2]


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
			damages[BRUTE] = gen.absorbDamages(damages[BRUTE])
	if(damages[BRUTE] == 0)
		return
	var/list/picks = list()
	if(arms) picks += arms
	if(legs) picks += legs
	if(body) picks += body
	if(head) picks += head
	if(!length(picks)) return error("ERROR: \the [src] at [loc] had an empty components list when [user] called attack_generic") // Shouldn't happen since the body being destroyed turns mechs into wrecks, but just in case...
	var/obj/item/mech_component/comp = pick(picks)
	var/hit_dir = get_dir(user, src)
	var/dir_mult = get_dir_mult(hit_dir, comp)
	damage_through_armor(damages[BRUTE], BRUTE, comp, ARMOR_MELEE, penetration, dmg_types = damages, dir_mult = dir_mult) // Removed the use of most named args here by rearranging the argument, except dmg_types, which skips used_weapon, sharp, edge and wounding_multiplier
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [name] ([ckey])</font>")
	attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [user.name] ([user.ckey])</font>")
	visible_message(SPAN_DANGER("[user] has [attack_message] [src]!"))
	user.do_attack_animation(src)
	updatehealth()
	return TRUE

/mob/living/exosuit/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/hit_dir = get_dir(user, src)
	var/obj/item/mech_component/comp = zoneToComponent(hit_zone)
	var/dir_mult = get_dir_mult(hit_dir, comp)
	if(!effective_force)
		return FALSE

	if (damage_through_armor(effective_force, I.damtype, hit_zone, ARMOR_MELEE, I.armor_divisor, used_weapon = I, sharp = is_sharp(I), edge = has_edge(I), dir_mult = dir_mult))
		return TRUE
	else
		return FALSE

/// Returns the best shield for damage reduction
/mob/living/exosuit/proc/getShield()
	var/obj/item/mech_equipment/shield_generator/chosen = null
	for(var/hardpoint in hardpoints)
		var/obj/item/mech_equipment/thing = hardpoints[hardpoint]
		if(istype(thing , /obj/item/mech_equipment/shield_generator))
			var/obj/item/mech_equipment/shield_generator/gen = thing
			if(!chosen || (chosen && (chosen.absorption_ratio < gen.absorption_ratio)))
				chosen = gen
	return chosen

/mob/living/exosuit/resolve_item_attack(obj/item/I, mob/living/user, def_zone)
	if(!I.force)
		user.visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly with \the [I]."))
		return
	// must be in front if the hatch is opened , else we roll for any angle based on chassis coverage
	var/roll = !prob(getPilotCoverage(get_dir(user,src)))
	var/list/damages = list(BRUTE = I.force)
	var/obj/item/mech_equipment/shield_generator/gen = getShield()
	if(gen)
		damages[BRUTE] = gen.absorbDamages(damages[BRUTE])
// not enough made it in
	if(damages[BRUTE] < round(I.force / 2))
		visible_message("\The [src]'s shields block the blow!", 1, 2 ,5)
		return

	if(LAZYLEN(pilots) && ((!hatch_closed * body.has_hatch) && (get_dir(user,src) & reverse_dir[dir])) || roll)
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

/*
/mob/living/exosuit/damage_through_armor(damage, damagetype, def_zone, attack_flag, armor_divisor, used_weapon, sharp, edge, wounding_multiplier, list/dmg_types, return_continuation, dir_mult)
	var/obj/item/mech_component/comp = zoneToComponent(def_zone)
	var/armor_def = comp.armor.getRating(attack_flag)
	var/deflect_chance = ((comp.shielding + armor_def)*0.5) - (armor_divisor*5)
	if(prob(deflect_chance)) // Energy weapons have no physical presence, I would suggest adding a damage type check here later, not touching it for now because it affects game balance too much
		visible_message(SPAN_DANGER("\The [used_weapon] glances off of \the [src]'s [comp]!"), 1, 2, 7)
		playsound(src, "ricochet", 50, 1, 7)
		return 0
	/*
	Uncomment this block if you want to use armor ablation for mechs. Otherwise, cur_armor will always be equal to max_armor, and you can just change max_armor to alter the target for deflection rolls.

	else
		var/dam_dif = armor_def - round(damage*(armor_divisor))
		var/orig_armor = comp.cur_armor
		var/armor_change = max(0, comp.cur_armor-max(0, dam_dif))
		comp.cur_armor = armor_change // The inner max function here causes attacks that do not deflect to always ablate at least 1 point of armor. The outer ensures that cur_armor never goes below 0
		if(orig_armor != comp.cur_armor)
			damage -= round(max(0, armor_change/armor_divisor))
	*/
	. = ..()
*/

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

/mob/living/exosuit/fall_impact(turf/from, turf/dest)
	if(legs && legs.can_fall_safe)
		playsound(src, 'sound/weapons/thudswoosh.ogg', 100, 1, 10, 10)
		return
	//Wreck the contents of the tile
	for (var/atom/movable/AM in dest)
		if (AM != src)
			AM.explosion_act(200, null)

	//Damage surrounding tiles
	for (var/turf/T in range(1, src))
		T.explosion_act(150, null)

	apply_damage(abs(from.z - dest.z)*30, BRUTE, BP_LEGS, 10)

	//And do some screenshake for everyone in the vicinity
	for (var/mob/M in range(20, src))
		var/dist = get_dist(M, src)
		dist *= 0.5
		if (dist <= 1)
			dist = 1 //Prevent runtime errors

		shake_camera(M, 10/dist, 2.5/dist, 0.12)

	playsound(src, 'sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	spawn(1)
		playsound(src, 'sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	spawn(2)
		playsound(src, 'sound/weapons/heavysmash.ogg', 100, 1, 20,20)

/mob/living/exosuit/bullet_act(obj/item/projectile/P, def_zone)
	var/hit_dir = get_dir(P.starting, src)
	var/obj/item/mech_component/comp
	if(istext(def_zone))
		comp = zoneToComponent(def_zone)
	else
		comp = def_zone

	var/dir_mult = get_dir_mult(hit_dir, comp)
	/// aiming for soemthing the mech doesnt have
	if(!def_zone)
		return PROJECTILE_FORCE_MISS
	var/armor_def = comp.armor.getRating(P.check_armour) * dir_mult
	var/deflect_chance = ((comp.shielding + armor_def)*0.5) - (armor_divisor*5)
	if(prob(deflect_chance)) // Energy weapons have no physical presence, I would suggest adding a damage type check here later, not touching it for now because it affects game balance too much
		visible_message(SPAN_DANGER("\The [P] glances off of \the [src]'s [comp]!"), 1, 2, 7)
		playsound(src, "ricochet", 50, 1, 7)
		if(P.starting)
			var/turf/sourceloc = get_turf_away_from_target_simple(src, P.starting, 6)
			var/new_x = sourceloc.x + ( rand(2, 5) * (prob(50) ? -1 : 1 ))
			var/new_y = sourceloc.y + ( rand(2, 5) * (prob(50) ? -1 : 1 ))
			sourceloc = locate(new_x , new_y, sourceloc.z)
			sourceloc.color = "#a92312"
			P.redirect(new_x, new_y, get_turf(src), src)
		return PROJECTILE_CONTINUE

	if (P.is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
		IgniteMob()
	var/obj/item/mech_equipment/shield_generator/gen = getShield()
	var/list/damages = P.damage_types
	if(gen && hit_dir & reverse_dir[dir])
		for(var/damage in damages)	//Loop once just to get the key from the list
			damages[damage] = gen.absorbDamages(damages[damage])
	var/coverage = getPilotCoverage(hit_dir)
	if(def_zone == body)
		// enforce frontal attacks for first case. Second case just enforce a prob check on coverage.
		if((body.has_hatch && !hatch_closed && hit_dir & reverse_dir[dir]) || (!body.has_hatch && !prob(coverage)))
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
	for(var/damage_type in damages)
		if(damage_type == HALLOSS)
			continue
		damage_through_armor(damages[damage_type], damage_type, def_zone, P.check_armour, armor_divisor = P.armor_divisor, used_weapon = P, sharp = is_sharp(P), edge = has_edge(P), dir_mult = dir_mult)

	P.on_hit(src, def_zone)
	return PROJECTILE_STOP

/mob/living/exosuit/proc/get_dir_mult(hit_dir, obj/item/mech_component/comp)
    var/facing_vector = get_vector(dir)
    var/incoming_hit_vector = get_vector(hit_dir)
    var/angle = get_vector_angle(facing_vector, incoming_hit_vector)

    // Front quadrant (135 - 225 degrees)
    if(angle > 135 && angle < 225)
        . = comp.front_mult // Hit from the front
    // Rear quadrant (315 - 45 degrees, with wrap-around at 360/0 degrees)
    else if(angle < 45 || angle > 315)
        . = comp.rear_mult // Hit from the back
    // Side quadrants (45 - 135 degrees and 225 - 315 degrees)

    else if (!facing_vector||!angle||!incoming_hit_vector)
        . = comp.side_mult
    else
        . = comp.side_mult // Hit from the sides

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
/*
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
*/
/mob/living/exosuit/explosion_act(target_power, explosion_handler/handler)
	var/damage = target_power - (getarmor(body, ARMOR_BOMB) + getarmor(arms, ARMOR_BOMB) + getarmor(legs, ARMOR_BOMB) + getarmor(head, ARMOR_BOMB))/4 // Now uses the average armor of all components
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

/mob/living/exosuit/hit_impact(damage, dir)
	if(prob(50))
		do_sparks(rand(3, 6), FALSE, src)
		if(prob(5))
			new /obj/effect/decal/cleanable/blood/oil(src.loc)
