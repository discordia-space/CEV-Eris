/mob/living/simple_animal/hostile/megafauna/one_star
	name = "Type - 0315"
	desc = "Love and concrete."

	faction = "onestar"
	mob_size = MOB_GIGANTIC
	icon = 'icons/mob/64x64.dmi'
	icon_state = "onestar_boss_unpowered"
	icon_living = "onestar_boss_unpowered"
	icon_dead = "onestar_boss_wrecked"
	pixel_x = -16
	ranged = TRUE

	health = 1700
	maxHealth = 1700
	break_stuff_probability = 95
	stop_automated_movement = 1

	melee_damage_lower = 10
	melee_damage_upper = 20
	megafauna_min_cooldown = 30
	megafauna_max_cooldown = 60

	mob_classification = CLASSIFICATION_SYNTHETIC

	wander = FALSE //No more sleepwalking

	projectiletype = /obj/item/projectile/bullet/srifle/nomuzzle

/mob/living/simple_animal/hostile/megafauna/one_star/death()
	..()
	walk(src, 0)

/mob/living/simple_animal/hostile/megafauna/one_star/LoseTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/megafauna/one_star/LostTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/megafauna/one_star/FindTarget()
	if(istype(src.loc, /turf))
		var/turf/TURF = src.loc
		if(TURF.get_lumcount() < 1)
			vision_range = 4
		else
			vision_range = 10
	else
		vision_range = 0
	. = ..()
	if(.)
		icon_state = "onestar_boss"
	else
		icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/megafauna/one_star/AttackingTarget()
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return L
	if(istype(target_mob, /mob/living/exosuit))
		var/mob/living/exosuit/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B

/mob/living/simple_animal/hostile/megafauna/one_star/proc/shoot_rocket(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/item/projectile/P = new /obj/item/projectile/bullet/rocket(startloc)
	P.firer = src
	if(target)
		P.original = target
	P.PrepareForLaunch()
	P.launch( get_step(marker, pick(SOUTH, NORTH, WEST, EAST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)) )


/mob/living/simple_animal/hostile/megafauna/one_star/OpenFire()
	anger_modifier = CLAMP(((maxHealth - health)/50),0,20)
	ranged_cooldown = world.time + 120
	walk(src, 0)
	telegraph()
	icon_state = "onestar_boss"
	if(prob(35))
		shoot_rocket(target_mob.loc, rand(0,90))
		move_to_delay = initial(move_to_delay)
		MoveToTarget()
		return
	if(prob(45))
		select_spiral_attack()
		move_to_delay = initial(move_to_delay)
		MoveToTarget()
		return
	if(target_mob)
		if(prob(75))
			wave_shots()
			move_to_delay = initial(move_to_delay)
			MoveToTarget()
			return
		else
			shoot_projectile(target_mob.loc, rand(0,90))
			MoveToTarget()
	move_to_delay = initial(move_to_delay)
