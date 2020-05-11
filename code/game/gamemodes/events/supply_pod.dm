/*
	A (sort of) positive major event. Rare thing!
	Supply pod event causes a drop pod to hit the ship, containing a variety of rare and useful loot.
	Assistants are sure to swarm it and ironhammer will need to fight them off. Or the assistants might die horribly

	The pod causes major devastation where it hits, Technomancers will need to rebuild the room
	It may contain monsters or traps.But it also contains a very large quantity of items,
	including quite a few rares

*/

/datum/storyevent/supply_pod
	id = "supply_pod"
	name = "supply pod"
	weight = 0.75
	event_type = /datum/event/supply_pod
	event_pools = list(EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR*1.2) //Slightly higher cost than other major events

	tags = list(TAG_DESTRUCTIVE, TAG_POSITIVE, TAG_COMBAT, TAG_EXTERNAL)


///////////////////////////////////////////////////////
/datum/event/supply_pod
	var/turf/epicentre = null
	var/list/pod_contents = list()
	startWhen = 1
	var/auto_open = FALSE

/datum/event/supply_pod/setup()
	find_dropsite()
	build_contents()
	add_guardians()

	//Sometimes the pod will open itself
	if (prob(50))
		auto_open = TRUE

/datum/event/supply_pod/proc/find_dropsite()
	var/attempts = 100
	//Lets find a place to drop our pod
	var/done = FALSE
	var/turf/T
	while(!done)
		attempts--
		if (attempts <= 0)
			done = TRUE

		var/area/A = random_ship_area(TRUE, TRUE, TRUE)
		if (!A)
			//Something is horribly wrong
			kill()
			break

		T = A.random_space()
		if (!T)
			continue

		var/nearspace = FALSE
		//We'll try not to cause breaches by dropping it somewhere sufficiently far from space
		for (var/u in trange(5, T))
			//We test each tile within a radius of 4
			var/turf/U = u
			if (turf_is_external(U))
				nearspace = TRUE
				break

		//If no external tiles were found within the radius, we are good to go!
		if (!nearspace)
			done = TRUE

	if (T)
		epicentre = T
	else
		//Something is horribly wrong
		kill()


//Next, what will be in it?
/datum/event/supply_pod/proc/build_contents()
	//First of all, we'll make it contain a couple of the possible supply pack contents
	for (var/i = 0; i < 2; i++)
		var/droptype = pick(subtypesof(/datum/supply_drop_loot))
		var/datum/supply_drop_loot/dropdatum = new droptype
		pod_contents.Add(dropdatum.contents)
		qdel(dropdatum)


	//Secondly, some rare items, to bring all the boys to the yard
	for (var/i = 0; i < 10; i++)
		pod_contents.Add(/obj/random/pack/rare)

	//Aaand thirdly a bunch of random stuff just to fill out space
	for (var/i = 0; i < 20; i++)
		pod_contents.Add(/obj/random/lowkeyrandom)


//Some mobs too!
/datum/event/supply_pod/proc/add_guardians()
	var/list/possible_mobs = list(/mob/living/simple_animal/hostile/hivebot,
	/mob/living/simple_animal/hostile/scarybat,
	/mob/living/simple_animal/mouse,
	/obj/random/slime/rainbow,
	/obj/random/mob/spiders,
	/obj/random/mob/roaches,
	/mob/living/simple_animal/hostile/samak,
	/mob/living/simple_animal/hostile/bear,
	/mob/living/simple_animal/hostile/carp,
	/mob/living/simple_animal/hostile/creature,
	/mob/living/simple_animal/hostile/carp/pike
	)

	//It may not contain mobs, or it may be a clown car full of horrors that spill forth like boiling oil
	while (prob(80))
		var/newtype = pick(possible_mobs)

		var/num = rand(2,6)
		for (var/i = 0; i < num;i++)
			pod_contents.Add(newtype)


/datum/event/supply_pod/start()
	log_and_message_admins("Drop pod impacted at [jumplink(epicentre)],")
	new /datum/random_map/droppod/supply(null, epicentre.x, epicentre.y, epicentre.z, supplied_drops = pod_contents, supplied_drop = null, automated = auto_open)