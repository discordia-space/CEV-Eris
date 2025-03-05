GLOBAL_LIST_EMPTY(loot_biomes)

/turf/proc/new_biome(obj/landmark/loot_biomes/new_biome)
	if(!new_biome)
		return
	if(new_biome.z != z)
		return
	var/new_distance = get_dist(src, new_biome)
	if(new_distance > new_biome.range)
		return
	if(get_area(src) != get_area(new_biome))
		return
	if(biome)
		if(new_distance >= get_dist(src, biome))
			return
		biome.turf_list -= src
		biome.spawn_turfs -=src
		biome.update_price()
	biome = new_biome
	biome.turf_list += src
	if(check_spawn_point(src))
		if(biome.check_room)
			if(check_room(src, biome))
				biome.spawn_turfs += src
		else
			biome.spawn_turfs += src

/turf/proc/update_biome(obj/landmark/loot_biomes/new_biome)
	if(new_biome)
		new_biome(new_biome)
		return
	for(var/obj/landmark/loot_biomes/biome_candidate in GLOB.loot_biomes)
		new_biome(biome_candidate)

/obj/landmark/loot_biomes
	name = "debug biome"
	icon_state = "player-blue-cluster"
	var/list/main_tags = list()
	var/list/secondary_tags = list()
	var/list/tags_to_spawn = list()
	var/list/should_be_include_tag = list()//TODO
	var/prob_secondary_tags = 33
	var/list/trap_tags = list(SPAWN_TRAP_ARMED)//all traps by default
	var/list/mob_tags = list()
	var/cap_price = 500000
	var/top_price = 10000 //top_price = cap_price / 10
	var/low_price = 0
	var/allow_blacklist = FALSE
	var/list/exclusion_paths = list()
	var/list/restricted_tags = list()
	var/danger_level = 0
	var/only_top = 1
	var/range = 7
	var/can_burrow = TRUE
	var/min_loot_amount = 1
	var/max_loot_amount = 1
	var/min_traps_amount = 8
	var/max_traps_amount = 12
	var/min_mobs_amount = 8
	var/max_mobs_amount = 12
	var/check_room = FALSE
	var/spawner_trap_count = 0
	var/spawner_mob_count = 0
	var/list/turf_list = list()
	var/list/spawn_turfs = list()

/obj/landmark/loot_biomes/Initialize(mapload)
	. = ..()
	if(cap_price)
		top_price = cap_price / 10
	update()
	GLOB.loot_biomes += src

/obj/landmark/loot_biomes/proc/update_turfs()
	turf_list = list()
	spawn_turfs = list()
	var/turf/source = get_turf(src)
	for(var/turf/T in RANGE_TURFS(range, source))
		T.update_biome(src)

/obj/landmark/loot_biomes/proc/update_price()
	price_tag = 0
	for(var/turf/T in turf_list)
		for(var/obj/item/I in T.contents)
			price_tag += I.get_item_cost()
	switch(price_tag)
		if(0 to LOOT_LEVEL_VERY_LOW)
			only_top = 1
		if(LOOT_LEVEL_VERY_LOW to LOOT_LEVEL_LOW)
			only_top = 0.35
		if(LOOT_LEVEL_LOW to LOOT_LEVEL_ADVERAGE)
			only_top = 0.30
		if(LOOT_LEVEL_ADVERAGE to LOOT_LEVEL_HIG)
			only_top = 0.25
		if(LOOT_LEVEL_HIG to LOOT_LEVEL_VERY_HIG)
			only_top = 0.20
		if(LOOT_LEVEL_VERY_HIG to INFINITY)
			only_top = 0.15

/obj/landmark/loot_biomes/proc/update()
	update_turfs()
	update_price()
	update_tags()

/obj/landmark/loot_biomes/proc/update_tags()
	tags_to_spawn = list(pickweight(main_tags))
	if(prob(prob_secondary_tags) && secondary_tags.len)
		tags_to_spawn = list(pickweight(secondary_tags))
	chek_tags()

/obj/landmark/loot_biomes/proc/chek_tags()
	if(!tags_to_spawn.len)
		CRASH("[src.name] has no spawn tag: [x],[y],[z]")
