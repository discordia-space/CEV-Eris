/mob/living/roach
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/mob/living/target_mob
	var/attack_same = 0
	var/move_to_delay = 4 //delay for the automated movement.
	var/list/friends = list()

	var/destroy_surroundings = 1
	var/break_stuff_probability = 10

	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1
	var/stop_automated_movement_when_pulled = 0

	a_intent = I_HURT

	faction = "roach"


/mob/living/roach/proc/FindTarget()
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
	if(T)
		visible_emote("charges at [T]!")
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)

	return T


/mob/living/roach/proc/Found(var/atom/A)
	return


/mob/living/roach/proc/MoveToTarget()
	stop_automated_movement = 1
	if(!target_mob || roach_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		stance = HOSTILE_STANCE_ATTACKING
		walk_to(src, target_mob, 1, move_to_delay)


/mob/living/roach/proc/AttackTarget()
	stop_automated_movement = 1
	if(!target_mob || roach_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets(10)))
		LostTarget()
		return 0
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		return 1


/mob/living/roach/proc/AttackingTarget()
	if(!Adjacent(target_mob))
		return

	var/mob/living/L
	if(isliving(target_mob))
		L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		L = M
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		L = B

	if(istype(L))
		if(prob(5))
			L.Weaken(3)
			L.visible_message(SPAN_DANGER("\the [src] knocks down \the [L]!"))

	return L


/mob/living/roach/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)


/mob/living/roach/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)


/mob/living/roach/proc/ListTargets(var/dist = 7)
	var/list/L = hearers(src, dist)

	for (var/obj/mecha/M in mechas_list)
		if (M.z == src.z && get_dist(src, M) <= dist)
			L += M

	return L


/mob/living/roach/proc/DestroySurroundings()
	if(prob(break_stuff_probability))
		for(var/dir in cardinal) // North, South, East, West
			for(var/obj/structure/window/obstacle in get_step(src, dir))
				if(obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
				obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)


/mob/living/roach/proc/roach_attackable(target_mob)
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

/mob/living/roach/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	if(melee_damage_upper == 0 && isliving(A))
		custom_emote(1, "[friendly] [A]!")
		return

	var/damage = rand(melee_damage_lower, melee_damage_upper)
	if(A.attack_generic(src, damage, attacktext, environment_smash) && loc && attack_sound)
		playsound(loc, attack_sound, 50, 1, 1)
