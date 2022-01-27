// only objs
/obj/landmark/loot_biomes/obj //debug

/obj/spawner/biome_spawner_obj
	name = "biome obj spawner"
	icon_state = "box-green-spawner"
	tags_to_spawn = list(SPAWN_ITEM)
	biome_spawner = TRUE

/obj/spawner/biome_spawner_obj/low_chance
	name = "biome obj spawner"
	icon_state = "box-green-spawner-low"
	biome_spawner = TRUE
	spawn_nothing_percentage = 60

// only69obs
/obj/landmark/loot_biomes/mob
	name = "mob biome"
	icon_state = "hostilemob-purple-biome"
	mob_tags = list(SPAWN_SPAWNER_MOB)
	min_mobs_amount = 3
	max_mobs_amount = 9
	min_loot_amount = 1
	max_loot_amount = 1
	can_burrow = TRUE

/obj/landmark/loot_biomes/mob/chek_tags()
	if(!mob_tags.len)
		crash_with("69src.name69 has no spawn tag: 69x69,69y69,69z69")

/obj/spawner/mob/biome_spawner_mob
	name = "biome69ob spawner"
	icon_state = "hostilemob-purple-spawner"
	biome_spawner = TRUE
	latejoin = TRUE

/obj/spawner/mob/biome_spawner_mob/low_chance
	name = "biome69ob spawner"
	icon_state = "hostilemob-purple-spawner-low"
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
	min_loot_amount = 1
	max_loot_amount = 1

/obj/landmark/loot_biomes/mob/roomba
	icon_state = "hostilemob-blue-biome"
	mob_tags = list(SPAWN_MOB_ROOMBA,SPAWN_MOB_OS_CUSTODIAN)

//only traps
/obj/landmark/loot_biomes/trap
	name = "trap biome"
	icon_state = "trap-purple-biome"
	trap_tags = list(SPAWN_TRAP_ARMED)
	cap_price = INFINITY
	min_traps_amount = 1
	max_traps_amount = 1

/obj/landmark/loot_biomes/trap/chek_tags()
	if(!trap_tags.len)
		crash_with("69src.name69 has no spawn tag: 69x69,69y69,69z69")

/obj/spawner/traps/biome_spawner_trap
	name = "biome trap spawner"
	icon_state = "trap-purple-spawner"
	biome_spawner = TRUE
	use_biome_range = TRUE
	latejoin = TRUE

/obj/spawner/traps/biome_spawner_trap/low_chance
	name = "biome trap spawner"
	icon_state = "trap-purple-spawner-low"
	spawn_nothing_percentage = 60

// Junk Tractor Beam (JTB)
/obj/landmark/loot_biomes/jtb
	range = 10 //69aximum could be 12 since we have 25x25 chunks and landmark is at the center
	min_loot_amount = 4
	max_loot_amount = 8
	min_traps_amount = 4
	max_traps_amount = 8
	min_mobs_amount = 0 //69obs are hardcoded in69ap file
	max_mobs_amount = 0

/obj/landmark/loot_biomes/jtb/neutral
	main_tags = list(SPAWN_ASTERS, SPAWN_IRONHAMMER, SPAWN_NEOTHEOLOGY, SPAWN_MOEBIUS, SPAWN_TECHNOMANCER)

/obj/landmark/loot_biomes/jtb/onestar
	main_tags = list(SPAWN_ONESTAR)

/obj/landmark/loot_biomes/jtb/ironhammer
	main_tags = list(SPAWN_IRONHAMMER)

/obj/landmark/loot_biomes/jtb/serbian
	main_tags = list(SPAWN_SERBIAN)
