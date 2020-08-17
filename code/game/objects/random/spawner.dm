/obj/spawner
	name = "random object"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the map
	invisibility = INVISIBILITY_MAXIMUM	// Hides these spawners from the dmm-tools minimap renderer of SpacemanDMM
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/min_amount = 1
	var/max_amount = 1
	var/spread_range = 0
	var/has_postspawn = FALSE
	var/top_price = 0
	var/low_price = 0
	var/allow_blacklist = FALSE
	var/direction
	var/list/tags_to_spawn = list(SPAWN_ITEM, SPAWN_MOB, SPAWN_MACHINERY)
	var/datum/loot_spawner_data/lsd
	var/list/aditional_object = list()


// creates a new object and deletes itself
/obj/spawner/Initialize()
	..()
	lsd = GLOB.all_spawn_data["loot_s_data"]
	if(!prob(spawn_nothing_percentage))
		var/list/spawns = spawn_item()
		if (has_postspawn && spawns.len)
			post_spawn(spawns)

	return INITIALIZE_HINT_QDEL

// this function should return a specific item to spawn
/obj/spawner/proc/item_to_spawn()
	accompanying_object = initial(accompanying_object)
	var/list/candidates = lsd.spawn_by_tag(tags_to_spawn)
	var/list/spawns_without_frequency = lsd.all_spawn_by_frequency["0"]

	if(!candidates.len)
		return
	candidates -= spawns_without_frequency
	if(!allow_blacklist)
		candidates -= lsd.all_spawn_blacklist
	if(low_price)
		candidates -= lsd.spawns_lower_price(candidates, low_price)
	if(top_price)
		candidates -= lsd.spawns_upper_price(candidates, top_price)
	candidates = lsd.pick_frequency_spawn(candidates)
	candidates = lsd.pick_rarity_spawn(candidates)
	var/selected = pick(candidates)
	aditional_object = lsd.all_spawn_accompanying_obj_by_path[selected]
	return selected


// this function should return a specific item to spawn
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
		spawns.Add(A)
		if(islist(aditional_object) && aditional_object.len)
			for(var/thing in aditional_object)
				var/atom/AAO = new thing (T)
				spawns.Add(AAO)
	return spawns

/obj/spawner/oddities
	name = "random oddities"
	icon_state = "techloot-grey"
	tags_to_spawn = list(SPAWN_ODDITY)

