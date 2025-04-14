/*
	A vast number of space carp spawn around the ship. Will heavily stress the shields
	They eventually go away
*/
/datum/storyevent/carp_migration
	id = "carp_migration"
	name = "carp migration"

	event_type =/datum/event/carp_migration
	event_pools = list(EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR)
	tags = list(TAG_COMMUNAL, TAG_COMBAT, TAG_DESTRUCTIVE, TAG_SCARY, TAG_EXTERNAL)

//////////////////////////////////////////////////////////

/datum/event/carp_migration
	announceWhen	= 50
	endWhen 		= 900
	var/list/viable_turfs = list()
	var/list/spawned_carp = list()

/datum/event/carp_migration/setup()
	//We'll pick space tiles which have windows nearby
	//This means that carp will only be spawned in places where someone could see them
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

/datum/event/carp_migration/announce()
	var/announcement = ""
	if(severity == EVENT_LEVEL_MAJOR)
		announcement = "Massive migration of unknown biological entities has been detected near [station_name()], please stand-by."
	else
		announcement = "Unknown biological [spawned_carp.len == 1 ? "entity has" : "entities have"] been detected near [station_name()], please stand-by."
	command_announcement.Announce(announcement, "Lifesign Alert")

/datum/event/carp_migration/start()
	if(severity == EVENT_LEVEL_MAJOR)
		spawn_fish(260)
	else if(severity == EVENT_LEVEL_MODERATE)
		spawn_fish(50)

/datum/event/carp_migration/proc/spawn_fish(var/number)
	var/list/spawn_locations = pickweight_mult(viable_turfs, number)

	for(var/turf/T in spawn_locations)
		if(prob(97.5)) //2.5% chance of SHERK
			spawned_carp.Add(new /mob/living/simple_animal/hostile/carp(T))
		else
			spawned_carp.Add(new /mob/living/simple_animal/hostile/carp/pike(T))

/datum/event/carp_migration/end()
	for(var/mob/living/simple_animal/hostile/C in spawned_carp)
		if(!C.stat)
			var/turf/T = get_turf(C)
			if(istype(T, /turf/space))
				spawned_carp.Remove(C)
				qdel(C)
