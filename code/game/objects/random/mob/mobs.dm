/obj/spawner/mob
	name = "random mob"
	icon_state = "hostilemob-red"
	spawn_tags = SPAWN_TAG_SPAWNER_MOB
	tags_to_spawn = list(SPAWN_SPAWNER_MOB)
	exclusion_paths = list(/obj/spawner/mob)
	biome_type = /obj/landmark/loot_biomes/mob

/obj/spawner/mob/biome_spawner
	name = "biome mob spawner"
	biome_spawner = TRUE
	can_burrow = TRUE
	rare_if_alone = TRUE

/obj/spawner/mob/biome_spawner/LateInitialize()
	..()
	if(!prob(spawn_nothing_percentage))
		var/list/spawns = spawn_item()
		if(spawns.len)
			burrow()
			if(has_postspawn)
				post_spawn(spawns)
			if(biome)
				biome.current_price += price_tag
			post_spawn(spawns)
	qdel(src)

/obj/spawner/mob/burrow()
	if(biome && biome.can_burrow)
		find_or_create_burrow(get_turf(src))
		return TRUE
	return FALSE

/obj/spawner/mob/cluster
	name = "cluster of random mob"
	icon_state = "hostilemob-red-cluster"
	min_amount = 3
	max_amount = 6
