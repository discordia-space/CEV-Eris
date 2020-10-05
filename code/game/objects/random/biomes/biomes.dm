/obj/landmark/loot_biomes/obj
	name = "obj biome"
	main_tags = list(SPAWN_ITEM)//test
	secondary_tags = list(SPAWN_KNIFE)//test
	allow_blacklist = TRUE //TEST
	biome_type = /obj/landmark/loot_biomes/obj
	low_price = 500

/obj/landmark/loot_biomes/mob
	name = "mob biome"
	main_tags = list(SPAWN_SPAWNER_MOB)//test
	spread_range = 7
	min_amount = 8
	max_amount = 12
	can_burrow = TRUE
	allowed_only_top = TRUE
	use_loc = TRUE
	cap_price = INFINITY
	biome_type = /obj/landmark/loot_biomes/mob

/obj/landmark/loot_biomes/mob/roach
	main_tags = list(SPAWN_ROACH)//test

/obj/landmark/loot_biomes/mob/spiders
	main_tags = list(SPAWN_SPIDER)//test

/obj/landmark/loot_biomes/trap
	name = "trap biome"
	main_tags = list(SPAWN_TRAP_ARMED)
	min_amount = 8
	max_amount = 12
	allowed_only_top = TRUE
	use_loc = TRUE
	cap_price = INFINITY
	biome_type = /obj/landmark/loot_biomes/trap

