/obj/spawner
	name = "debug random object"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the map
	invisibility = INVISIBILITY_MAXIMUM	// Hides these spawners from the dmm-tools minimap renderer of SpacemanDMM
	rarity_value = 10
	spawn_frequency = 10
	spawn_tags = SPAWN_SPAWNER
	bad_types = /obj/spawner
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/min_amount = 1
	var/max_amount = 1
	var/top_price = 0
	var/low_price = 0
	var/list/tags_to_spawn = list(SPAWN_ITEM, SPAWN_MOB, SPAWN_MACHINERY, SPAWN_STRUCTURE)
	var/list/should_be_include_tag = list()
	var/allow_blacklist = FALSE
	var/list/aditional_object = list()
	var/list/exclusion_paths = list()
	var/list/restricted_tags = list()
	var/list/include_paths = list()
	var/spread_range = 0
	var/has_postspawn = TRUE
	var/datum/loot_spawner_data/lsd
	var/list/points_for_spawn = list()
	//BIOME SPAWNERS
	var/obj/landmark/loot_biomes/biome
	var/biome_cap = FALSE
	var/biome_spawner = FALSE
	var/biome_type = /obj/landmark/loot_biomes/obj

/obj/spawner/biome_spawner/obj
	name = "biome obj spawner"
	tags_to_spawn = list(SPAWN_ITEM)
	biome_spawner = TRUE

// creates a new object and deletes itself
/obj/spawner/Initialize(mapload)
	.=..()
	lsd = GLOB.all_spawn_data["loot_s_data"]
	if(!biome_spawner && !prob(spawn_nothing_percentage))
		var/list/spawns = spawn_item()
		if(spawns.len)
			burrow()
			if(has_postspawn)
				post_spawn(spawns)
			if(biome)
				biome.current_price += price_tag
			post_spawn(spawns)

	return biome_spawner ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_QDEL 

/obj/spawner/proc/valid_candidates()
	var/list/candidates = lsd.spawn_by_tag(tags_to_spawn)
	candidates -= lsd.spawn_by_tag(restricted_tags)
	candidates -= exclusion_paths
	if(!allow_blacklist)
		candidates -= lsd.all_spawn_blacklist
	if(low_price)
		candidates -= lsd.spawns_lower_price(candidates, low_price)
	if(top_price)
		candidates -= lsd.spawns_upper_price(candidates, top_price)
	candidates += include_paths
	return candidates

/obj/spawner/proc/pick_spawn(list/candidates)
	var/selected = lsd.pick_spawn(candidates)
	aditional_object = lsd.all_spawn_accompanying_obj_by_path[selected]
	return selected

// this function should return a specific item to spawn
/obj/spawner/proc/item_to_spawn()
	if(biome_spawner)
		biome_candidates()
	if(biome_spawner && biome_cap)
		return
	var/list/candidates = valid_candidates()
	//if(!candidates.len)
	//	return
	return pick_spawn(candidates)

/obj/spawner/proc/post_spawn(list/spawns)
	return

// creates the random item
/obj/spawner/proc/spawn_item()
	var/list/points_for_spawn = list()
	var/list/spawns = list()
	var/atom/LocA = src.loc
	if(biome && biome.use_loc)
		LocA = biome.loc
	if(spread_range && istype(LocA, /turf))
		for(var/turf/T in trange(spread_range, LocA))
			if (!T.is_wall && !T.is_hole)
				points_for_spawn += T
	else
		points_for_spawn += LocA //We do not use get turf here, so that things can spawn inside containers
	for(var/i in 1 to rand(min_amount, max_amount))
		var/build_path = item_to_spawn()
		if (!build_path)
			return list()
		if(!points_for_spawn.len)
			log_debug("Spawner \"[type]\" ([x],[y],[z]) try spawn without free space around!")
			break
		var/atom/T = pick(points_for_spawn)
		var/atom/A = new build_path(T)
		if(ismachinery(A) || isstructure(A))
			A.set_dir(src.dir)
		spawns.Add(A)
		if(ismovable(A))
			var/atom/movable/AM = A
			price_tag += AM.get_item_cost()
		if(islist(aditional_object) && aditional_object.len)
			for(var/thing in aditional_object)
				var/atom/AO = new thing (T)
				spawns.Add(AO)
				if(ismovable(AO))
					var/atom/movable/AMAO = AO
					price_tag += AMAO.get_item_cost()
	rare_spawn = FALSE
	return spawns

/obj/spawner/proc/biome_candidates()
	var/distance = RANGE_BIOMES
	var/new_distance
	if(GLOB.loot_biomes.len)
		for(var/obj/landmark/loot_biomes/biome_candidate in GLOB.loot_biomes)
			new_distance = get_dist(src, biome_candidate)
			if(biome_candidate.z != z)
				continue
			if(new_distance > distance)
				continue
			if(!istype(biome_candidate, biome_type))
				continue
			admin_notice("esta es la distancia [get_dist(src, biome_candidate)]")
			to_world_log("esta es la distancia [get_dist(src, biome_candidate)]")
			distance = new_distance
			biome = biome_candidate
			biome.check_another_biome()
	if(biome)
		admin_notice("este es el bioma [biome]")
		to_world_log("este es el bioma [biome]")
		if(biome.current_price >= biome.cap_price)
			biome_cap = TRUE
			return biome
		biome.spawner_count++
		tags_to_spawn = biome.tags_to_spawn
		allow_blacklist = biome.allow_blacklist
		exclusion_paths = biome.exclusion_paths
		restricted_tags = biome.restricted_tags
		top_price = biome.top_price
		low_price = biome.low_price
		spread_range = min(1, biome.spread_range / biome.spawner_count)
		min_amount = min(1, biome.min_amount / biome.spawner_count)
		max_amount = min(1, biome.max_amount / biome.spawner_count)
		return biome
	return

/obj/randomcatcher
	name = "Random Catcher Object"
	desc = "You should not see this."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/randomcatcher/proc/get_item(type)
	new type(src)
	if (contents.len)
		. = pick(contents)
	else
		return null

/obj/randomcatcher/proc/get_items(type)
	new type(src)
	if (contents.len)
		return contents
	else
		return null

/obj/spawner/proc/burrow()
	return FALSE
