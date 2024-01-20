#define ENVIRONMENT_SMASH_NONE			0
#define ENVIRONMENT_SMASH_STRUCTURES	(1<<0) 	//crates, lockers, ect
#define ENVIRONMENT_SMASH_WALLS			(1<<1)  //walls
#define ENVIRONMENT_SMASH_RWALLS		(1<<2)	//rwalls
var/list/mydirs = list(NORTH, SOUTH, EAST, WEST, SOUTHWEST, NORTHWEST, NORTHEAST, SOUTHEAST)

/mob/living/simple_animal/hostile
	faction = "hostile"
	bad_type = /mob/living/simple_animal/hostile
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/mob/living/target_mob
	var/attack_same = 0
	var/ranged = 0
	var/rapid = 0
	var/projectiletype
	var/projectilesound
	var/casingtype
	var/ranged_cooldown = 0 //What the current cooldown on ranged attacks is, generally world.time + ranged_cooldown_time
	var/list/friends = list()
	var/break_stuff_probability = 10
	var/ranged_ignores_vision
	stop_automated_movement_when_pulled = 0
	var/destroy_surroundings = 1
	var/fire_verb = "fires"
	a_intent = I_HURT
	can_burrow = TRUE
	hunger_enabled = 0//Until automated eating mechanics are enabled, disable hunger for hostile mobs
	var/minimum_distance = 1 //Minimum approach distance, so ranged mobs chase targets down, but still keep their distance set in tiles
	var/atom/targets_from = null //all range/attack/etc. calculations should be done from this atom, defaults to the mob itself, useful for Vehicles and such
	var/vision_range = 9 //How big of an area to search for targets in, a vision of 9 attempts to find targets as soon as they walk into screen view
	var/aggro_vision_range = 9 //If a mob is aggro, we search in this radius. Defaults to 9 to keep in line with original simple mob aggro radius
	var/approaching_target = FALSE //We should dodge now
	sanity_damage = 0.1

/mob/living/simple_animal/hostile/proc/FindTarget()
	var/atom/T = null
	stop_automated_movement = 0
	for(var/atom/A in ListTargets(vision_range))

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else if(!SA_attackable(L))
				stance = HOSTILE_STANCE_ATTACK
				T = L
				break

		if(istype(A, /obj/machinery/bot))
			var/obj/machinery/bot/B = A
			if (B.health > 0)
				stance = HOSTILE_STANCE_ATTACK
				T = B
				break
	return T


/mob/living/simple_animal/hostile/proc/Found(var/atom/A)
	return

/mob/living/simple_animal/hostile/proc/MoveToTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
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
			stance = HOSTILE_STANCE_ATTACKING
			set_glide_size(DELAY2GLIDESIZE(move_to_delay))
			walk_to(src, target_mob, 1, move_to_delay)
	return 0

/mob/living/simple_animal/hostile/proc/DestroyPathToTarget()
	if(environment_smash)
		EscapeConfinement()
		var/dir_to_target = get_dir(targets_from, target_mob)
		var/dir_list = list()
		if(dir_to_target in mydirs) //it's diagonal, so we need two directions to hit
			for(var/direction in mydirs)
				if(direction & dir_to_target)
					dir_list += direction
		else
			dir_list += dir_to_target
		for(var/direction in dir_list) //now we hit all of the directions we got in this fashion, since it's the only directions we should actually need
			DestroyObjectsInDirection(direction)

/mob/living/simple_animal/hostile/proc/EscapeConfinement()
	if(!isturf(targets_from.loc) && targets_from.loc != null)//Did someone put us in something?
		var/atom/A = targets_from.loc
		UnarmedAttack(A)//Bang on it till we get out

/mob/living/simple_animal/hostile/proc/DestroyObjectsInDirection(direction)
	var/turf/T = get_step(targets_from, direction)
	if(QDELETED(T))
		return
	if(T.Adjacent(targets_from))
		UnarmedAttack(T)
		return
	for(var/obj/O in T.contents)
		if(!O.Adjacent(targets_from))
			continue
		if((istype(O, /obj/machinery) || istype(O, /obj/structure) && O.density && environment_smash >= ENVIRONMENT_SMASH_STRUCTURES))
			UnarmedAttack(O)
			return

/mob/living/simple_animal/hostile/proc/AttackTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets(10)))
		LostTarget()
		return 0
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		return 1

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return L
	if(istype(target_mob,/mob/living/exosuit))
		var/mob/living/exosuit/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B

/mob/living/simple_animal/hostile/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)

/mob/living/simple_animal/hostile/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)


/mob/living/simple_animal/hostile/proc/ListTargets(var/dist = 7)
	var/list/L = hearers(src, dist)

	for (var/mob/living/exosuit/M in GLOB.mechas_list)
		if (M.z == z && get_dist(src, M) <= dist)
			L += M

	return L

/mob/living/simple_animal/hostile/Life()

	. = ..()
	if(!stasis && !AI_inactive)
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

/mob/living/simple_animal/hostile/proc/OpenFire(target_mob)
	var/target = target_mob
	visible_message("\red <b>[src]</b> [fire_verb] at [target]!", 1)

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

/mob/living/simple_animal/hostile/proc/Shoot(var/target, var/start, var/user, var/bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = new projectiletype(user:loc)
	playsound(user, projectilesound, 100, 1)
	if(!A)	return
	var/def_zone = get_exposed_defense_zone(target)
	A.PrepareForLaunch()
	A.launch(target, def_zone)

/mob/living/simple_animal/hostile/proc/DestroySurroundings()
	if(istype(src, /mob/living/simple_animal/hostile/megafauna))
		set_dir(get_dir(src,target_mob))
		for(var/turf/simulated/wall/obstacle in get_step(src, dir))
			if(prob(35))
				obstacle.dismantle_wall(1)
		for(var/obj/machinery/obstacle in get_step(src, dir))
			if(prob(65))
				obstacle.Destroy()
		for(var/obj/structure/obstacle in get_step(src, dir))
			if(prob(95))
				qdel(obstacle)

	if(prob(break_stuff_probability))
		for(var/dir in cardinal) // North, South, East, West
			for(var/obj/machinery/obstacle in get_step(src, dir))
				if((obstacle.dir == reverse_dir[dir])) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return
			for(var/turf/simulated/wall/obstacle in get_step(src, dir))
				if((obstacle.dir == reverse_dir[dir])) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return
			for(var/obj/structure/window/obstacle in get_step(src, dir))
				if((obstacle.dir == reverse_dir[dir]) || obstacle.is_fulltile()) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille) || istype(obstacle, /obj/structure/railing))
				obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
