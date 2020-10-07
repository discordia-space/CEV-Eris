/obj/spawner
	name = "debug random object"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the map
	invisibility = INVISIBILITY_MAXIMUM	// Hides these spawners from the dmm-tools minimap renderer of SpacemanDMM
	rarity_value = 10
	spawn_frequency = 10
	price_tag = 1
	spawn_tags = SPAWN_SPAWNER
	bad_type = /obj/spawner
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/min_amount = 1
	var/max_amount = 1
	var/top_price = 0
	var/low_price = 0
	var/list/tags_to_spawn = list(SPAWN_ITEM, SPAWN_MOB, SPAWN_MACHINERY, SPAWN_STRUCTURE)
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
	var/biome_spawner = FALSE
	var/biome_type = /obj/landmark/loot_biomes/obj
	var/spawn_count = 0
	var/latejoin = FALSE
	var/check_density = TRUE //for find smart spawn

// creates a new object and deletes itself
/obj/spawner/Initialize(mapload)
	.=..()
	lsd = GLOB.all_spawn_data["loot_s_data"]
	if(!latejoin && !prob(spawn_nothing_percentage))
		var/list/spawns = spawn_item()
		if(spawns.len)
			burrow()
			if(has_postspawn)
				post_spawn(spawns)
			if(biome)
				biome.price_tag += price_tag
			post_spawn(spawns)

	return latejoin ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_QDEL 

/obj/spawner/LateInitialize()
	..()
	if(!prob(spawn_nothing_percentage) && latejoin)
		var/list/spawns = spawn_item()
		if(spawns.len)
			burrow()
			if(has_postspawn)
				post_spawn(spawns)
			if(biome)
				biome.price_tag += price_tag
			post_spawn(spawns)
	qdel(src)

// creates the random item
/obj/spawner/proc/spawn_item()
	var/list/points_for_spawn = list()
	var/list/spawns = list()
	var/atom/LocA = src.loc
	if(!biome)
		fid_biome()
	if(biome_spawner && biome && biome.use_loc)
		LocA = get_turf(biome)
	if(spread_range && istype(LocA, /turf))
		for(var/turf/T in trange(spread_range, LocA))
			if(!T.is_wall && !T.is_hole)
				points_for_spawn += T
	else
		points_for_spawn += LocA //We do not use get turf here, so that things can spawn inside containers
	for(var/i in 1 to rand(min_amount, max_amount))
		spawn_count++
		var/build_path = item_to_spawn()
		if(!build_path)
			return list()
		if(find_smart_point(build_path))
			points_for_spawn = find_smart_point(build_path)
		if(!points_for_spawn.len)
			to_world_log("Spawner \"[type]\" ([x],[y],[z]) try spawn without free space around!")
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
	return spawns

/obj/spawner/proc/fid_biome()
	var/distance = RANGE_BIOMES
	var/new_distance
	if(GLOB.loot_biomes.len)
		for(var/obj/landmark/loot_biomes/biome_candidate in GLOB.loot_biomes)
			new_distance = get_dist(src, biome_candidate)
			if(biome_candidate.z != z)
				continue
			if(new_distance > distance)
				continue
			if(biome && istype(biome, biome_type) && !istype(biome_candidate, biome_type))
				continue
			distance = new_distance
			biome = biome_candidate
	if(biome_spawner && biome)
		biome.spawner_count++
		tags_to_spawn = biome.tags_to_spawn
		allow_blacklist = biome.allow_blacklist
		exclusion_paths = biome.exclusion_paths
		restricted_tags = biome.restricted_tags
		top_price = biome.top_price
		low_price = biome.low_price
		spread_range = biome.spread_range
		min_amount = max(1, biome.min_amount / biome.spawner_count)
		max_amount = max(1, biome.max_amount / biome.spawner_count)


// this function should return a specific item to spawn
/obj/spawner/proc/item_to_spawn()
	if(biome)
		biome.update()
	if(biome_spawner && biome && biome.price_tag >= biome.cap_price)
		return
	var/list/candidates = valid_candidates()
	//if(!candidates.len)
	//	return
	return pick_spawn(candidates)

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

	if(biome_spawner && biome && biome.allowed_only_top && biome.spawner_count < 2)
		var/top = round(candidates.len*spawn_count*biome.only_top)
		if(top <= candidates.len)
			var/top_spawn = CLAMP(top, 1, min(candidates.len,10))
			candidates = lsd.only_top_candidates(candidates, top_spawn)
	return candidates

/obj/spawner/proc/pick_spawn(list/candidates)
	var/selected = lsd.pick_spawn(candidates)
	aditional_object = lsd.all_accompanying_obj_by_path[selected]
	return selected

/obj/spawner/proc/post_spawn(list/spawns)
	return

/obj/spawner/proc/find_smart_point(path)
	if(biome_spawner || !biome || !biome.use_loc)
		return FALSE
	return can_spawn_in_biome(get_turf(biome), biome.range, check_density)

/proc/can_spawn_in_biome(turf/T, nrange, check_density=FALSE)
	var/list/spawn_points = list()
	for(var/turf/target in trange(nrange, T))
		if(target in spawn_points)
			continue
		var/ndist = get_dist(T, target)
		var/turf/current = T
		var/clear_way = TRUE
		for(var/i in 1 to ndist)
			current = get_step(current, get_dir(current, target))
			if(current.density  || current.is_wall || (current.is_hole && !current.is_solid_structure()))
				clear_way = FALSE
				break
			if(check_density && !turf_clear(current))
				continue
			if(!(current in spawn_points))
				spawn_points += current
		if(clear_way && !(target in spawn_points) && (!check_density || check_density && turf_clear(current)))
			spawn_points += target
	return spawn_points

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
