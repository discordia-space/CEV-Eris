GLOBAL_LIST_EMPTY(loot_biomes)

#define LEVEL_VERY_LOW_LOOT 1500

#define LEVEL_LOW_LOOT 5000

#define LEVEL_ADVERAGE_LOOT 10000

#define LEVEL_HIG_LOOT 20000

#define LEVEL_VERY_HIG_LOOT 25000


/obj/landmark/loot_biomes //TEST
	name = "debug biome"
	icon_state = "player-blue-cluster"
	var/prob_secondary_tags = 33
	var/list/main_tags = list()
	var/list/secondary_tags = list()
	var/list/tags_to_spawn = list()
	var/cap_price = 500000
	var/top_price = 10000 //top_price = cap_price / 10
	var/low_price = 0
	var/allow_blacklist = FALSE
	var/list/exclusion_paths = list()
	var/list/restricted_tags = list()
	var/danger_level = 0
	var/only_top = 1		//for mob biomes
	var/allowed_only_top = FALSE
	var/range = 7
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
	price_tag = 0
	for(var/obj/item/I in view())
		price_tag += I.get_item_cost()
	update()
	if(cap_price)
		top_price = cap_price / 10
	GLOB.loot_biomes += src

/obj/landmark/loot_biomes/proc/check_master()
	if(master) return master
	var/distance = range
	var/new_distance
	for(var/obj/landmark/loot_biomes/biome in GLOB.loot_biomes)
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
	return master

/obj/landmark/loot_biomes/proc/update()
	tags_to_spawn = main_tags
	if(prob(prob_secondary_tags) && secondary_tags.len)
		tags_to_spawn = secondary_tags
	check_master()
	if(master)
		price_tag = master.price_tag
	if(allowed_only_top)
		switch(price_tag)
			if(0 to LEVEL_VERY_LOW_LOOT)
				only_top = 1 // 1*1 = 1
			if(LEVEL_VERY_LOW_LOOT to LEVEL_LOW_LOOT)
				only_top = 0.30 //4*0.3 > 1
			if(LEVEL_LOW_LOOT to LEVEL_HIG_LOOT)
				only_top = 0.25 // 4*0.25 = 1
			if(LEVEL_HIG_LOOT to LEVEL_VERY_HIG_LOOT)
				only_top = 0.20 // 5*0.20 = 1
			if(LEVEL_VERY_HIG_LOOT to INFINITY)
				only_top = 0.15 //6*0.15 > 1
