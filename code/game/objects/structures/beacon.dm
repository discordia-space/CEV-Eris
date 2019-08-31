/////////////////BEACONS
////////////////////////////////
/obj/structure/strangebeacon
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "strange_beacon"
	var/death = 0

/obj/structure/strangebeacon/attack_hand(mob/living/user as mob)
	if(death == 0)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)	//Plays a beep
		death = 1

/obj/structure/strangebeacon/bots //who you gonna call
/obj/structure/strangebeacon/bots/attack_hand(mob/living/user as mob)
	if(death == 0)
		var/counter = 0
		var/counterfinish = rand(1,2)

		while(counter < counterfinish)
			counter++
			new /mob/living/bot/miningonestar/resources/agressive ( locate( get_step(src, pick(NORTH, WEST, EAST, SOUTH) ) ))
		death = 1

/obj/structure/strangebeacon/pods
/obj/structure/strangebeacon/pods/attack_hand(mob/living/user as mob)
	if(death == 0)
		var/drop_x = src.x-2
		var/drop_y = src.y-2
		var/drop_z = src.z
		var/drop_type = pick(supply_drop_random_loot_types())

		spawn(rand(100,300))
			new /datum/random_map/droppod/supply(null, drop_x, drop_y, drop_z, supplied_drop = drop_type) // Splat.
		death = 1

/obj/structure/strangebeacon/bombard
/obj/structure/strangebeacon/bombard/attack_hand(mob/living/user as mob)
	var/counter = 0
	var/counterfinish = rand(2,4)
	var/list/turf/bombarda = list()
	for(var/turf/T in src.loc.loc)
		bombarda.Add(T)

	while(counter < counterfinish)
		counter++
		sleep(rand(4,7))
		explosion(pick(bombarda), 1, 2, 3, 3)

/////////////////BEACONS
////////////////////////////////