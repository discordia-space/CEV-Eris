/*
	This event spawns a ton of spaceborne fighter drones which crowd around the hull and fire lasers in
	through windows. They can be quite lethal if you stand around infront of them, but closing firelocks works
*/

/datum/storyevent/rogue_drone
	id = "rogue_drone"
	name = "rogue drone"

	event_type =/datum/event/rogue_drone
	event_pools = list(EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)
	tags = list(TAG_COMMUNAL, TAG_COMBAT, TAG_DESTRUCTIVE, TAG_SCARY, TAG_EXTERNAL)

//////////////////////////////////////////////////////////

/datum/event/rogue_drone
	endWhen = 1000
	var/list/drones_list = list()
	var/list/viable_turfs = list()
	var/drones_to_spawn = 40




/datum/event/rogue_drone/setup()
	//We'll pick space tiles which have windows nearby
	//This means that drones will only be spawned in places where someone could see them
		//And thusly, places where they might fire into the ship
	var/area/spess = locate(/area/space) in world
	for (var/turf/T in spess)
		if (!(T.z in GLOB.maps_data.station_levels))
			continue

		if (locate(/obj/effect/shield) in T)
			continue

		//The number of windows near each tile is recorded
		var/numwin
		for (var/obj/structure/window/W in view(4, T))
			numwin++

		//And the square of it is entered into the list as a weight
		if (numwin)
			viable_turfs[T] = numwin*numwin

	//We will then use pickweight and this will be more likely to choose tiles with many windows, for maximum exposure


	announceWhen = rand(40, 60)
	endWhen = rand(600,1200)

/datum/event/rogue_drone/announce()
	var/msg
	if(prob(33))
		msg = "A combat drone wing operating out of the IHS Atomos has failed to return from a sweep of this sector, if any are sighted approach with caution."
	else if(prob(50))
		msg = "Contact has been lost with a combat drone wing operating out of the IHS Atomos. If any are sighted in the area, approach with caution."
	else
		msg = "Unidentified hackers have targetted a combat drone wing deployed from the IHS Atomos. If any are sighted in the area, approach with caution."
	priority_announce(msg, "Rogue drone alert")

/datum/event/rogue_drone/start()
	//Pick a list of spawn locatioons
	var/list/spawn_locations = pickweight_mult(viable_turfs, drones_to_spawn)

	log_and_message_admins("Spawning [drones_to_spawn]")
	for(var/turf/T in spawn_locations)
		var/mob/living/simple_animal/hostile/retaliate/malf_drone/D = new /mob/living/simple_animal/hostile/retaliate/malf_drone(T)
		drones_list.Add(D)
		if (prob(25))
			D.disabled = rand(15, 60)
		if (prob(95))
			D.hostile_drone = TRUE //There's a small chance that each one wont attack
		if (prob(5))
			log_and_message_admins("Drone spawned at [jumplink(T)],")

/datum/event/rogue_drone/end()
	var/num_recovered = 0
	for(var/mob/living/simple_animal/hostile/retaliate/malf_drone/D in drones_list)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, D.loc)
		sparks.start()
		D.z = GLOB.maps_data.admin_levels[1]
		D.has_loot = 0

		qdel(D)
		num_recovered++

	if(num_recovered > drones_list.len * 0.75)
		priority_announce("IHS Atomos drone control reports the malfunctioning wing has been recovered safely.", "Rogue drone alert")
	else
		priority_announce("IHS Atomos drone control registers disappointment at the loss of the drones, but the survivors have been recovered.", "Rogue drone alert")
