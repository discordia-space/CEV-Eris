/mob/living/superior_animal/giant_spider/proc/FindTarget()

	var/atom/T = null
	stop_automated_movement = 0
	for(var/atom/A in ListTargets(10))

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else
				if(!L.stat)
					stance = HOSTILE_STANCE_ATTACK
					T = L
					break

		else if(istype(A, /obj/mecha)) // Our line of sight stuff was already done in ListTargets().
			var/obj/mecha/M = A
			if (M.occupant)
				stance = HOSTILE_STANCE_ATTACK
				T = M
				break

		if(istype(A, /obj/machinery/bot))
			var/obj/machinery/bot/B = A
			if (B.health > 0)
				stance = HOSTILE_STANCE_ATTACK
				T = B
				break
	return T


/mob/living/superior_animal/giant_spider/proc/Found(var/atom/A)
	return


/mob/living/superior_animal/giant_spider/proc/MoveToTarget()
	stop_automated_movement = 1
	if(!target_mob || spider_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		stance = HOSTILE_STANCE_ATTACKING
		walk_to(src, target_mob, 1, move_to_delay)


/mob/living/superior_animal/giant_spider/proc/AttackTarget()
	stop_automated_movement = 1
	if(!target_mob || spider_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets(10)))
		LostTarget()
		return 0
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		return 1


/mob/living/superior_animal/giant_spider/proc/AttackingTarget()
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return L
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B


/mob/living/superior_animal/giant_spider/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)


/mob/living/superior_animal/giant_spider/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)


/mob/living/superior_animal/giant_spider/proc/ListTargets(var/dist = 7)
	var/list/L = hearers(src, dist)

	for (var/obj/mecha/M in mechas_list)
		if (M.z == src.z && get_dist(src, M) <= dist)
			L += M

	return L


/mob/living/superior_animal/giant_spider/death()
	..()
	walk(src, 0)


/mob/living/superior_animal/giant_spider/Life()

	. = ..()
	if(!.)
		walk(src, 0)
		return 0
	if(client)
		return 0

	if(!stat)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				target_mob = FindTarget()

			if(HOSTILE_STANCE_ATTACK)
				if(destroy_surroundings)
					DestroySurroundings()
				MoveToTarget()

			if(HOSTILE_STANCE_ATTACKING)
				if(destroy_surroundings)
					DestroySurroundings()
				AttackTarget()


/mob/living/superior_animal/giant_spider/proc/DestroySurroundings()
	if(prob(break_stuff_probability))
		for(var/dir in cardinal) // North, South, East, West
			for(var/obj/structure/window/obstacle in get_step(src, dir))
				if(obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
				obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)

/mob/living/superior_animal/giant_spider/proc/spider_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat && L.health >= (ishuman(L) ? HEALTH_THRESHOLD_CRIT : 0))
			return (0)
	if (istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		if (M.occupant)
			return (0)
	if (istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		if(B.health > 0)
			return (0)
	return 1