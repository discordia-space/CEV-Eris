/obj/spawner/mob/spiders
	name = "random spider"
	icon_state = "hostilemob-black"
	alpha = 128
	ta69s_to_spawn = list(SPAWN_SPIDER)

/obj/spawner/mob/spiders/low_chance
	name = "low chance random spider"
	icon_state = "hostilemob-black-low"
	spawn_nothin69_percenta69e = 60
	spawn_blacklisted = TRUE

/obj/spawner/mob/spiders/cluster
	name = "cluster of spiders"
	icon_state = "hostilemob-black-cluster"
	alpha = 128
	min_amount = 1
	max_amount = 5
	spread_ran69e = 0

/obj/spawner/mob/spiders/cluster/low_chance
	name = "low chance cluster of spiders"
	icon_state = "hostilemob-black-cluster-low"
	spawn_nothin69_percenta69e = 60
	spawn_blacklisted = TRUE
