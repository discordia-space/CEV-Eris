//Calls for enemy reinforcemen or Droppod event will be activated with this beacon as main target or
//This is junk beacon, it will bombard the area with rather useless junk piles or It beeps and dies.

/obj/structure/strangebeacon
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "strange_beacon"
	desc = "It looks like ancient, and strange beacon."
	rarity_value = 10
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_STRANGEBEACON
	var/nosignal = FALSE
	var/entropy_value = 6

/obj/structure/strangebeacon/attack_hand(mob/living/user as mob)
	if(nosignal == FALSE)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)	//Plays a beep
		nosignal = TRUE

/obj/structure/strangebeacon/bots/attack_hand(mob/living/user as mob)
	if(nosignal == FALSE)
		var/counter = 0
		var/counterfinish = rand(1,2)

		while(counter < counterfinish)
			counter++
			new /mob/living/bot/miningonestar/resources/agressive ( get_step(src, pick(GLOB.cardinal)) )
		nosignal = TRUE

/obj/structure/strangebeacon/pods/proc/call_droppod()
	if(nosignal == FALSE)
		visible_message(SPAN_WARNING("Pod is called. Get a safe distance."))
		var/drop_x = src.x-2
		var/drop_y = src.y-2
		var/drop_z = src.z
		var/drop_type = pick(supply_drop_random_loot_types())
		new /datum/random_map/droppod/supply(null, drop_x, drop_y, drop_z, supplied_drop = drop_type) // Splat.
		nosignal = TRUE
		bluespace_entropy(entropy_value, get_turf(src))

/obj/structure/strangebeacon/pods/attack_hand(mob/living/user as mob)
	addtimer(CALLBACK(src, PROC_REF(call_droppod)), rand(100,300))

/obj/structure/strangebeacon/bombard/attack_hand(mob/living/user as mob)
	var/counter = 0
	var/counterfinish = rand(2,4)
	var/list/turf/bombarda = list()
	for(var/turf/T in get_area(src))
		bombarda.Add(T)

	while(counter < counterfinish)
		counter++
		sleep(rand(4,7))
		explosion(get_turf(src), 500, 100)
