/obj/landmark/loot_biomes/obj
	name = "obj biome"
	biome_type = /obj/landmark/loot_biomes/obj

/obj/landmark/loot_biomes/mob
	name = "mob biome"
	main_tags = list(SPAWN_SPAWNER_MOB)//test
	can_burrow = TRUE
	spread_range = 7
	min_amount = 8
	max_amount = 12
	use_loc = TRUE
	biome_type = /obj/landmark/loot_biomes/mob

/obj/landmark/loot_biomes/mob/roach
	main_tags = list(SPAWN_SPAWNER_MOB)//test

/obj/landmark/loot_biomes/mob/spiders
	main_tags = list(SPAWN_SPAWNER_MOB)//test

/obj/landmark/loot_biomes/trap
	name = "trap biome"
	use_loc = TRUE
	biome_type = /obj/landmark/loot_biomes/trap

