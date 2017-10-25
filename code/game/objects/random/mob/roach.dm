/obj/random/mob/roaches
	name = "random roach"
	icon_state = "hostilemob-brown"

/obj/random/mob/roaches/item_to_spawn()
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
	min_amount = 5
	max_amount = 15
	spread_range = 0

/obj/random/cluster/roaches/item_to_spawn()
	return /obj/random/mob/roaches

/obj/random/cluster/roaches/low_chance
	name = "low chance cluster of roaches"
	icon_state = "hostilemob-brown-low"
	spawn_nothing_percentage = 82
