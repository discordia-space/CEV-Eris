/obj/spawner/mob/roaches
	name = "random roach"
	icon_state = "hostilemob-brown"
	tags_to_spawn = list(SPAWN_ROACH)

/obj/spawner/mob/roaches/low_chance
	name = "low chance random roach"
	icon_state = "hostilemob-brown-low"
	spawn_nothing_percentage = 60
	spawn_blacklisted = TRUE

/obj/spawner/mob/roaches/cluster
	name = "cluster of roaches"
	icon_state = "hostilemob-brown-cluster"
	alpha = 128
	min_amount = 3
	max_amount = 9
	spread_range = 0

/obj/spawner/mob/roaches/cluster/low_chance
	name = "low chance cluster of roaches"
	icon_state = "hostilemob-brown-cluster-low"
	spawn_nothing_percentage = 60
	spawn_blacklisted = TRUE

// For Scrap Beacon
/obj/spawner/mob/roaches/cluster/beacon
	tags_to_spawn = list(SPAWN_ROACH_NANITE)
