/obj/spawner
	name = "random object"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the map
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/min_amount = 1
	var/max_amount = 1
	var/spread_range = 0
	var/has_postspawn = FALSE
	var/top_price = 100
	var/low_price = 0
	var/allow_blacklist = FALSE
	var/direction = NORTH
	var/tag_to_spawn = SPAWN_ITEM

// creates a new object and deletes itself
/obj/spawner/Initialize()
	..()
	if(!prob(spawn_nothing_percentage))
		var/list/spawns = spawn_item()
		if (has_postspawn && spawns.len)
			post_spawn(spawns)

	return INITIALIZE_HINT_QDEL

// this function should return a specific item to spawn
/obj/spawner/proc/item_to_spawn()
	return

// this function should return a specific item to spawn
/obj/spawner/proc/post_spawn(var/list/spawns)
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
	return spawns

/obj/spawner/oddities
	name = "random oddities"
	icon_state = "techloot-grey"
	tag_to_spawn = SPAWN_ODDITY

/obj/spawner/oddities/item_to_spawn()
	var/datum/loot_spawner_data/LSD = GLOB.all_spawn_data["loot_s_data"]
	var/list/candidates = LSD.all_spawn_list_by_tag["[tag_to_spawn]"]
	return pick(candidates)
