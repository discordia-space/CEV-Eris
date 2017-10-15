/obj/random/mob/roaches
	name = "cluster of roaches"
	icon_state = "hostilemob-brown"
	min_ammount = 5
	max_ammount = 15
	spread_range = 0
	item_to_spawn()
		return /mob/living/simple_animal/hostile/roach

/obj/random/mob/roaches/low_chance
	name = "low chance cluster of roaches"
	icon_state = "hostilemob-brown-low"
	spawn_nothing_percentage = 80
