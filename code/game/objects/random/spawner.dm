/obj/spawner
	name = "random object"
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
	var/allow_blacklist = FALSE
	var/list/aditional_object = list()
	var/allow_aditional_object = TRUE
	var/list/exclusion_paths = list()
	var/list/restricted_tags = list()
	var/list/include_paths = list()
	var/spread_range = 0
	var/has_postspawn = TRUE
	var/datum/loot_spawner_data/lsd


// creates a new object and deletes itself
/obj/spawner/Initialize(mapload, with_aditional_object=TRUE)
	..()
	lsd = GLOB.all_spawn_data["loot_s_data"]
	allow_aditional_object = with_aditional_object
	if(!prob(spawn_nothing_percentage))
		var/list/spawns = spawn_item()
		if (has_postspawn && spawns.len)
			post_spawn(spawns)

	return INITIALIZE_HINT_QDEL

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
	candidates = lsd.pick_frequencies_spawn(candidates)
	candidates = lsd.pick_rarities_spawn(candidates)
	var/selected = lsd.pick_spawn(candidates)
	aditional_object = lsd.all_spawn_accompanying_obj_by_path[selected]
	return selected

// this function should return a specific item to spawn
/obj/spawner/proc/item_to_spawn()
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
	if (spread_range && istype(loc, /turf))
		for(var/turf/T in trange(spread_range, src.loc))
			if (!T.is_wall && !T.is_hole)
				points_for_spawn += T
	else
		points_for_spawn += loc //We do not use get turf here, so that things can spawn inside containers
	for(var/i in 1 to rand(min_amount, max_amount))
		var/build_path = item_to_spawn()
		if (!build_path)
			return list()
		if(!points_for_spawn.len)
			log_debug("Spawner \"[type]\" ([x],[y],[z]) try spawn without free space around!")
			break
		var/atom/T = pick(points_for_spawn)
		var/atom/A = new build_path(T)
		if(istype(A,/obj/machinery) || istype(A, /obj/structure))
			A.set_dir(src.dir)
		spawns.Add(A)
		if(ismovable(A))
			var/atom/movable/AM = A
			price_tag += AM.price_tag
		if(allow_aditional_object && islist(aditional_object) && aditional_object.len)
			for(var/thing in aditional_object)
				var/atom/AO = new thing (T)
				spawns.Add(AO)
				if(ismovable(AO))
					var/atom/movable/AMAO = AO
					price_tag += AMAO.price_tag
	return spawns

/obj/randomcatcher
	name = "Random Catcher Object"
	desc = "You should not see this."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/randomcatcher/proc/get_item(type, with_aditional_object=FALSE)
	new type(src, with_aditional_object)
	if (contents.len)
		. = pick(contents)
	else
		return null

/obj/randomcatcher/proc/get_items(type, with_aditional_object=FALSE)
	new type(src, with_aditional_object)
	if (contents.len)
		return contents
	else
		return null
