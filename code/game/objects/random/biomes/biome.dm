GLOBAL_LIST_EMPTY(loot_biomes)

/obj/landmark/loot_biomes //TEST
	name = "debug biome"
	icon_state = "player-blue-cluster"
	var/prob_main_tag = 66
	var/list/main_tags = list(SPAWN_OS_TOOL)//test
	var/list/secondary_tags = list(SPAWN_KNIFE)//test
	var/list/tags_to_spawn = list()
	var/cap_price = 500000
	var/current_price = 0
	var/top_price = 10000 //top_price = cap_price / 10
	var/low_price = 0
	var/allow_blacklist = TRUE
	var/list/exclusion_paths = list()
	var/list/restricted_tags = list()
	var/range = 7
	var/alone = TRUE
	var/can_burrow = FALSE
	var/spread_range = 0
	var/min_amount = 1
	var/max_amount = 1
	var/spawner_count = 0
	var/use_loc = FALSE
	var/biome_type = /obj/landmark/loot_biomes
	var/obj/landmark/loot_biomes/obj/master


/obj/landmark/loot_biomes/Initialize(mapload)
	.=..()
	if(prob(prob_main_tag))
		tags_to_spawn = main_tags
	else
		tags_to_spawn = secondary_tags
	if(cap_price)
		top_price = cap_price / 10
	GLOB.loot_biomes += src

/obj/landmark/loot_biomes/proc/check_another_biome()
	var/distance = range
	var/new_distance
	for(var/obj/landmark/loot_biomes/biome in range(range, src))
		new_distance = get_dist(src, biome)
		if(biome.z != z)
			continue
		if(biome == src)
			continue
		if(new_distance > distance)
			continue
		if(istype(biome, /obj/landmark/loot_biomes/obj))
			if(!istype(src, /obj/landmark/loot_biomes/obj))
				master = biome
				distance = new_distance
			else
				crash_with("Two biome obj landmarks are too close, the minimun distance is [range], the coordenates are: [x], [y], [z]")
				continue

