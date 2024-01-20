/mob/living/carbon/superior_animal/attack_ui(slot_id)
	return

/mob/living/carbon/superior_animal/UnarmedAttack(atom/A, var/proximity)
	if(!..())
		return

	var/damage = rand(melee_damage_lower, melee_damage_upper)

	. = A.attack_generic(src, damage, pick(attacktext), environment_smash, melee_sharp, melee_edge, wound_mult)
	if(.)
		if (attack_sound && loc && prob(attack_sound_chance))
			playsound(loc, attack_sound, attack_sound_volume, 1)

/mob/living/carbon/superior_animal/RangedAttack()
	if(ranged)
		if(get_dist(src, target_mob) <= 6 && !istype(src, /mob/living/simple_animal/hostile/megafauna))
			OpenFire(target_mob)
		else
			set_glide_size(DELAY2GLIDESIZE(move_to_delay))
			walk_to(src, target_mob, 1, move_to_delay)
		if(ranged && istype(src, /mob/living/simple_animal/hostile/megafauna))
			var/mob/living/simple_animal/hostile/megafauna/megafauna = src
			sleep(rand(megafauna.megafauna_min_cooldown,megafauna.megafauna_max_cooldown))
			if(istype(src, /mob/living/simple_animal/hostile/megafauna/one_star))
				if(prob(rand(15,25)))
					stance = HOSTILE_STANCE_ATTACKING
					set_glide_size(DELAY2GLIDESIZE(move_to_delay))
					walk_to(src, target_mob, 1, move_to_delay)
				else
					OpenFire(target_mob)
			else
				if(prob(45))
					stance = HOSTILE_STANCE_ATTACKING
					set_glide_size(DELAY2GLIDESIZE(move_to_delay))
					walk_to(src, target_mob, 1, move_to_delay)
				else
					OpenFire(target_mob)
		else
			return

/mob/living/carbon/superior_animal/proc/OpenFire(target_mob)
	var/target = target_mob
	visible_message(SPAN_DANGER("<b>[src]</b> [fire_verb] at [target]!"), 1)

	if(rapid)
		spawn(1)
			Shoot(target, loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(4)
			Shoot(target, loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(6)
			Shoot(target, loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
	else
		Shoot(target, loc, src)
		if(casingtype)
			new casingtype

	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	return

/mob/living/carbon/superior_animal/proc/Shoot(var/target, var/start, var/user, var/bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = new projectiletype(user:loc)
	playsound(user, projectilesound, 100, 1)
	if(!A)	return
	var/def_zone = get_exposed_defense_zone(target)
	A.PrepareForLaunch()
	A.launch(target, def_zone)
