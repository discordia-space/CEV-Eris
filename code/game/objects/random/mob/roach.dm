/obj/spawner/roaches
	name = "random roach"
	icon_state = "hostilemob-brown"
	tags_to_spawn = list(SPAWN_ROACH)

/obj/spawner/roaches/low_chance
	name = "low chance random roach"
	icon_state = "hostilemob-brown-low"
	spawn_nothing_percentage = 60

/obj/spawner/roaches/cluster
	name = "cluster of roaches"
	icon_state = "hostilemob-brown-cluster"
	alpha = 128
	min_amount = 3
	max_amount = 9
	spread_range = 0

/obj/spawner/roaches/cluster/low_chance
	name = "low chance cluster of roaches"
	icon_state = "hostilemob-brown-cluster-low"
	spawn_nothing_percentage = 60

// For Scrap Beacon
/obj/spawner/roaches/cluster/beacon
	tags_to_spawn = list(SPAWN_NANITE_ROACH)
