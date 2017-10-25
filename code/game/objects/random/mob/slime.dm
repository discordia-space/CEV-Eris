/obj/random/cluster/slimes
	name = "cluster of slimes"
	icon_state = "hostilemob-cyan"
	min_amount = 1
	max_amount = 3
	spread_range = 0

/obj/random/cluster/slimes/item_to_spawn()
	return /mob/living/carbon/slime

/obj/random/cluster/slimes/low_chance
	name = "low chance cluster of slimes"
	icon_state = "hostilemob-cyan-low"
	spawn_nothing_percentage = 80
