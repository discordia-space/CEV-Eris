/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/landmarks.dmi'
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/min_ammount = 1
	var/max_ammount = 1
	var/spread_range = 0


// creates a new object and deletes itself
/obj/random/New()
	..()
	if (!prob(spawn_nothing_percentage))
		spawn_item()

/obj/random/initialize()
	..()
	qdel(src)

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0

// creates the random item
/obj/random/proc/spawn_item()
	var/list/points_for_spawn = list()
	for(var/turf/T in view(spread_range, src.loc))
		points_for_spawn += T
	var/build_path = item_to_spawn()
	for(var/i in 1 to rand(min_ammount, max_ammount))
		if(!points_for_spawn.len)
			log_debug("Spawner \"[type]\" ([x],[y],[z]) try spawn without free space around!")
			break
		var/turf/T = pick(points_for_spawn)
		new build_path (T)

/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start"
	var/spawn_object = null
	item_to_spawn()
		return ispath(spawn_object) ? spawn_object : text2path(spawn_object)
