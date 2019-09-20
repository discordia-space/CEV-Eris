/mob/living/simple_animal/hostile/megafauna/hivemind_tyrant
	name = "Hivemind Tyrant"
	desc = "Hivemind's will, manifested in flesh and metal."

	faction = "hive"

	icon = 'icons/mob/64x64.dmi'
	icon_state = "hivemind_tyrant"
	icon_living = "hivemind_tyrant"
	icon_dead = "hivemind_tyrant"
	pixel_x = -16
	ranged = TRUE

	health = 2500
	maxHealth = 2500
	break_stuff_probability = 95

	melee_damage_lower = 10
	melee_damage_upper = 20
	megafauna_min_cooldown = 50
	megafauna_max_cooldown = 80


	var/health_marker_1 = 0//1700
	var/health_marker_2 = 0//900
	var/health_marker_3 = 0//100

	projectiletype = /obj/item/projectile/goo

/mob/living/simple_animal/hostile/megafauna/hivemind_tyrant/death()
	..()
	delhivetech()
	walk(src, 0)

/mob/living/simple_animal/hostile/megafauna/hivemind_tyrant/proc/telenode()
	var/list/atom/NODES = list()
	for(var/obj/machinery/hivemind_machine/node/NODE in world)
		NODES.Add(NODE.loc)
	if(length(NODES) > 0)
		forceMove(pick(NODES))

/mob/living/simple_animal/hostile/megafauna/hivemind_tyrant/proc/delhivetech()
	var/othertyrant = 0
	for(var/mob/living/simple_animal/hostile/megafauna/hivemind_tyrant/HT in world)
		if(HT != src)
			othertyrant = 1
	if(othertyrant == 0)
		for(var/obj/machinery/hivemind_machine/NODE in world)
			qdel(NODE)

/mob/living/simple_animal/hostile/megafauna/hivemind_tyrant/Life()

	. = ..()
	if(!.)
		walk(src, 0)
		return 0
	if(client)
		return 0

	if(!health_marker_1 && health < 1700)
		health_marker_1 = !health_marker_1
		telenode()

	if(!health_marker_2 && health < 900)
		health_marker_2 = !health_marker_2
		telenode()

	if(!health_marker_3 && health < 100)
		health_marker_3 = !health_marker_3
		telenode()

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

/mob/living/simple_animal/hostile/megafauna/hivemind_tyrant/OpenFire()
	anger_modifier = CLAMP(((maxHealth - health)/50),0,20)
	ranged_cooldown = world.time + 120
	walk(src, 0)
	telegraph()
	if(prob(50))
		random_shots()
		move_to_delay = initial(move_to_delay)
		MoveToTarget()
		return
	else
		select_spiral_attack()
		move_to_delay = initial(move_to_delay)
		MoveToTarget()
		return