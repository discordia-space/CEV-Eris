/obj/random
	name = "random object"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the map
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/min_amount = 1
	var/max_amount = 1
	var/spread_range = 0
	var/has_postspawn = FALSE
	invisibility = INVISIBILITY_MAXIMUM	// Hides these spawners from the dmm-tools minimap renderer of SpacemanDMM

// creates a new object and deletes itself
/obj/random/Initialize()
	..()
	if(!prob(spawn_nothing_percentage))
		var/list/spawns = spawn_item()
		if (has_postspawn && spawns.len)
			post_spawn(spawns)

	return INITIALIZE_HINT_QDEL

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return

// this function should return a specific item to spawn
/obj/random/proc/post_spawn(var/list/spawns)
	return


// creates the random item
/obj/random/proc/spawn_item()
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


/obj/random/single
	name = "randomly spawned object"
	var/spawn_object = null

/obj/random/single/item_to_spawn()
	return ispath(spawn_object) ? spawn_object : text2path(spawn_object)

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