// only objs
/obj/landmark/loot_biomes
	name = "obj biome"
	icon_state = "box-green-biome"
	cap_price = 200000
	main_tags = list(SPAWN_ITEM)

/obj/spawner/biome_spawner_obj
	name = "biome obj spawner"
	icon_state = "box-green-spawner"
	tags_to_spawn = list(SPAWN_ITEM)
	biome_spawner = TRUE


// only mobs
/obj/landmark/loot_biomes/mob
	name = "mob biome"
	icon_state = "hostilemob-purple-biome"
	mob_tags = list(SPAWN_SPAWNER_MOB)
	min_mobs_amount = 3
	max_mobs_amount = 9
	can_burrow = TRUE
	allowed_only_top = TRUE
	cap_price = INFINITY

/obj/spawner/mob/biome_spawner_mob
	name = "biome mob spawner"
	icon_state = "hostilemob-purple-spawner"
	biome_spawner = TRUE

/obj/spawner/mob/biome_spawner_mob/low_chance
	name = "biome mob spawner"
	icon_state = "hostilemob-purple-spawner-low"
	biome_spawner = TRUE
	spawn_nothing_percentage = 60

/obj/landmark/loot_biomes/mob/roach
	icon_state = "hostilemob-brown-biome"
	mob_tags = list(SPAWN_ROACH)

/obj/landmark/loot_biomes/mob/roach/room
	icon_state = "hostilemob-brown-biome"
	check_room = TRUE

/obj/landmark/loot_biomes/mob/spiders
	icon_state = "hostilemob-black-biome"
	mob_tags = list(SPAWN_SPIDER)
	min_mobs_amount = 1
	max_mobs_amount = 5

/obj/landmark/loot_biomes/mob/roomba
	icon_state = "hostilemob-blue-biome"
	mob_tags = list(SPAWN_MOB_ROOMBA,SPAWN_MOB_OS_CUSTODIAN)

//only traps
/obj/landmark/loot_biomes/trap
	name = "trap biome"
	icon_state = "trap-purple-biome"
	trap_tags = list(SPAWN_TRAP_ARMED)
	allowed_only_top = TRUE
	cap_price = INFINITY
	min_traps_amount = 1
	max_traps_amount = 1

/obj/spawner/traps/biome_spawner_trap
	name = "biome trap spawner"
	icon_state = "trap-purple-spawner"
	biome_spawner = TRUE
	use_biome_range = TRUE

/obj/spawner/traps/biome_spawner_trap/low_chance
	name = "biome trap spawner"
	icon_state = "trap-purple-spawner-low"
