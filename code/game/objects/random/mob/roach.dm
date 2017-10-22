/obj/random/mob/roaches
	name = "random roach"
	icon_state = "hostilemob-brown"
	item_to_spawn()
		return pick(prob(12);/mob/living/simple_animal/hostile/roach,\
					prob(3);/mob/living/simple_animal/hostile/roach/tank,\
					prob(3);/mob/living/simple_animal/hostile/roach/hunter,\
					prob(3);/mob/living/simple_animal/hostile/roach/support,\
					prob(1);/mob/living/simple_animal/hostile/roach/fuhrer)

/obj/random/mob/roaches/low_chance
	name = "low chance random roach"
	icon_state = "hostilemob-brown-low"
	spawn_nothing_percentage = 82


/obj/random/cluster/roaches
	name = "cluster of roaches"
	icon_state = "hostilemob-brown"
	min_ammount = 5
	max_ammount = 15
	spread_range = 0
	item_to_spawn()
		return /obj/random/mob/roaches

/obj/random/cluster/roaches/low_chance
	name = "low chance cluster of roaches"
	icon_state = "hostilemob-brown-low"
	spawn_nothing_percentage = 82
