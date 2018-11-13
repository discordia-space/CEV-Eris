/mob/living/carbon/superior_animal/proc/getObjectsInView()
	objectsInView = objectsInView || view(src, viewRange)
	return objectsInView

/mob/living/carbon/superior_animal/proc/getPotentialTargets()
	return hearers(src, viewRange)

/mob/living/carbon/superior_animal/proc/findTarget()
	var/list/filteredTargets = new

	for(var/atom/O in getPotentialTargets())
		if (isValidAttackTarget(O))
			filteredTargets += O

	for (var/obj/mecha/M in mechas_list)
		if ((M.z == src.z) && (get_dist(src, M) <= viewRange) && isValidAttackTarget(M))
			filteredTargets += M

	return safepick(nearestObjectsInList(filteredTargets, src, acceptableTargetDistance))

/mob/living/carbon/superior_animal/proc/attemptAttackOnTarget()
	if (!Adjacent(target_mob))
		return

	return UnarmedAttack(target_mob,1)

/mob/living/carbon/superior_animal/proc/prepareAttackOnTarget()
	stop_automated_movement = 1

	if (!target_mob || !isValidAttackTarget(target_mob))
		loseTarget()
		return

	if (!(target_mob in getPotentialTargets()))
		loseTarget()
		return

	attemptAttackOnTarget()

/mob/living/carbon/superior_animal/proc/loseTarget()
	stop_automated_movement = 0
	walk(src, 0)
	target_mob = null
	stance = HOSTILE_STANCE_IDLE

/mob/living/carbon/superior_animal/proc/isValidAttackTarget(var/atom/O)
	if (isliving(O))
		var/mob/living/L = O
		if((L.stat != CONSCIOUS) || (L.health <= (ishuman(L) ? HEALTH_THRESHOLD_CRIT : 0)) || (!attack_same && (L.faction == src.faction)) || (L in friends))
			return
		return 1

	if (istype(O, /obj/mecha))
		var/obj/mecha/M = O
		return isValidAttackTarget(M.occupant)

/mob/living/carbon/superior_animal/proc/destroySurroundings()
	if (prob(break_stuff_probability))
		for (var/dir in cardinal) // North, South, East, West
			for (var/obj/structure/window/obstacle in get_step(src, dir))
				if (obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return

			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if (istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
				obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)

