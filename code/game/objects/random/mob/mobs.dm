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

/obj/spawner/mob/burrow()
	if(check_biome_spawner() && biome.can_burrow)
		find_or_create_burrow(get_turf(biome))
		return TRUE
	return FALSE

/obj/spawner/mob/update_tags()
	..()
	tags_to_spawn = biome.mob_tags

/obj/spawner/mob/update_biome_vars()
	update_tags()
	biome.spawner_mob_count++
	var/count = biome.spawner_mob_count
	min_amount = max(1, biome.min_mobs_amount / count)
	max_amount = min(biome.max_mobs_amount, max(3, biome.max_mobs_amount / count))
	latejoin = TRUE
	if(use_biome_range)
		spread_range = biome.range
		forceMove(biome.loc)
