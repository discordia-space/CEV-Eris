/obj/random
	name = "random object"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the map
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/min_amount = 1
	var/max_amount = 1
	var/spread_range = 0

// creates a new object and deletes itself
/obj/random/New()
	..()
	if(!prob(spawn_nothing_percentage))
		spawn_item()

/obj/random/Initialize()
	..()
	return INITIALIZE_HINT_QDEL

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return

// creates the random item
/obj/random/proc/spawn_item()
	var/list/points_for_spawn = list()
	for(var/turf/T in view(spread_range, src.loc))
		points_for_spawn += T
	var/build_path = item_to_spawn()
	for(var/i in 1 to rand(min_amount, max_amount))
		if(!points_for_spawn.len)
			log_debug("Spawner \"[type]\" ([x],[y],[z]) try spawn without free space around!")
			break
		var/turf/T = pick(points_for_spawn)
		new build_path(T)


/obj/random/single
	name = "randomly spawned object"
	var/spawn_object = null

/obj/random/single/item_to_spawn()
	return ispath(spawn_object) ? spawn_object : text2path(spawn_object)
