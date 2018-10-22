/superior_animal/Life()
	. = ..()

	objectsInView = null

	if(!.) //dead
		walk(src, 0)
		return

	if(client)
		return

	if(stat == CONSCIOUS)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				stop_automated_movement = 0
				target_mob = findTarget()
				if (target_mob)
					stance = HOSTILE_STANCE_ATTACK

			if(HOSTILE_STANCE_ATTACK)
				if(destroy_surroundings)
					destroySurroundings()

				stop_automated_movement = 1
				stance = HOSTILE_STANCE_ATTACKING
				walk_to(src, target_mob, 1, move_to_delay)

			if(HOSTILE_STANCE_ATTACKING)
				if(destroy_surroundings)
					destroySurroundings()

				prepareAttackOnTarget()
	else
		walk(src, 0)

/superior_animal/proc/getObjectsInView()
	objectsInView = objectsInView || view(src, viewRange)
	return objectsInView

/superior_animal/proc/getPotentialTargets()
	return hearers(src, viewRange)

/superior_animal/proc/findTarget()
	var/list/filteredTargets = new

	for(var/atom/O in getPotentialTargets())
		if (isValidAttackTarget(O))
			filteredTargets += O

	for (var/obj/mecha/M in mechas_list)
		if ((M.z == src.z) && (get_dist(src, M) <= viewRange) && isValidAttackTarget(M))
			filteredTargets += M

	return safepick(nearestObjectsToSource(filteredTargets,src,1))

/superior_animal/proc/attemptAttackOnTarget()
	if(!Adjacent(target_mob))
		return

	if(isliving(target_mob))
		var/mob/living/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M

	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M

/superior_animal/proc/prepareAttackOnTarget()
	stop_automated_movement = 1

	if(!target_mob || !isValidAttackTarget(target_mob))
		loseTarget()
		return

	if(!(target_mob in getPotentialTargets()))
		lostTarget()
		return

	attemptAttackOnTarget()

/superior_animal/proc/lostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)

/superior_animal/proc/loseTarget()
	target_mob = null
	lostTarget()

/superior_animal/death()
	. = ..()
	walk(src, 0)

/superior_animal/proc/isValidAttackTarget(var/atom/O)
	if (isliving(O))
		var/mob/living/L = O
		if((L.stat != CONSCIOUS) || (L.health <= (ishuman(L) ? HEALTH_THRESHOLD_CRIT : 0)) || (!attack_same && (L.faction == src.faction)) || (L in friends))
			return
		return 1

	if (istype(O, /obj/mecha))
		var/obj/mecha/M = O
		return isValidAttackTarget(M.occupant)

/superior_animal/proc/destroySurroundings()
	if(prob(break_stuff_probability))
		for(var/dir in cardinal) // North, South, East, West
			for(var/obj/structure/window/obstacle in get_step(src, dir))
				if(obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return

			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
				obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)