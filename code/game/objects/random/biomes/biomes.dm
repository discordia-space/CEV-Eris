/obj/landmark/loot_biomes/obj
	name = "obj biome"
	icon_state = "box-green-biome"
	cap_price = 200000
	main_tags = list(SPAWN_ITEM)
	biome_type = /obj/landmark/loot_biomes/obj

/obj/spawner/biome_spawner_obj
	name = "biome obj spawner"
	icon_state = "box-green-spawner"
	tags_to_spawn = list(SPAWN_ITEM)
	biome_type = /obj/landmark/loot_biomes/obj
	biome_spawner = TRUE

/obj/landmark/loot_biomes/mob
	name = "mob biome"
	icon_state = "hostilemob-purple-biome"
	main_tags = list(SPAWN_SPAWNER_MOB)
	min_amount = 3
	max_amount = 9
	can_burrow = TRUE
	allowed_only_top = TRUE
	cap_price = INFINITY
	biome_type = /obj/landmark/loot_biomes/mob

/obj/spawner/mob/biome_spawner_mob
	name = "biome mob spawner"
	icon_state = "hostilemob-purple-spawner"
	biome_spawner = TRUE
	latejoin = TRUE

/obj/spawner/mob/biome_spawner_mob/low_chance
	name = "biome mob spawner"
	icon_state = "hostilemob-purple-spawner-low"
	biome_spawner = TRUE
	latejoin = TRUE
	spawn_nothing_percentage = 60

/obj/landmark/loot_biomes/mob/roach
	icon_state = "hostilemob-brown-biome"
	main_tags = list(SPAWN_ROACH)

/obj/landmark/loot_biomes/mob/roach/room
	icon_state = "hostilemob-brown-biome"
	check_room = TRUE

/obj/landmark/loot_biomes/mob/spiders
	icon_state = "hostilemob-black-biome"
	main_tags = list(SPAWN_SPIDER)
	min_amount = 1
	max_amount = 5

/obj/landmark/loot_biomes/mob/roomba
	icon_state = "hostilemob-blue-biome"
	main_tags = list(SPAWN_MOB_ROOMBA,SPAWN_MOB_OS_CUSTODIAN)

/obj/landmark/loot_biomes/trap
	name = "trap biome"
	icon_state = "trap-purple-biome"
	main_tags = list(SPAWN_TRAP_ARMED)
	allowed_only_top = TRUE
	cap_price = INFINITY
	biome_type = /obj/landmark/loot_biomes/trap

/obj/spawner/traps/biome_spawner_trap
	name = "biome trap spawner"
	icon_state = "trap-purple-spawner"
	biome_spawner = TRUE
	latejoin = TRUE
	use_biome_range = TRUE

/obj/spawner/traps/biome_spawner_trap/low_chance
	name = "biome trap spawner"
	icon_state = "trap-purple-spawner-low"
