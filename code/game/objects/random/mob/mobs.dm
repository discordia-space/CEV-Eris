/obj/spawner/mob
	name = "random mob"
	icon_state = "hostilemob-red"
	spawn_tags = SPAWN_TAG_SPAWNER_MOB
	tags_to_spawn = list(SPAWN_SPAWNER_MOB)
	exclusion_paths = list(/obj/spawner/mob)

/obj/spawner/mob/cluster
	name = "cluster of random mob"
	icon_state = "hostilemob-red-cluster"
	min_amount = 3
	max_amount = 6
