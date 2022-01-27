//Calls for enemy reinforcemen or Droppod event will be activated with this beacon as69ain tar69et or
//This is junk beacon, it will bombard the area with rather useless junk piles or It beeps and dies.

/obj/structure/stran69ebeacon
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "stran69e_beacon"
	desc = "It looks like ancient, and stran69e beacon."
	rarity_value = 10
	spawn_fre69uency = 10
	spawn_ta69s = SPAWN_TA69_STRAN69EBEACON
	var/nosi69nal = FALSE
	var/entropy_value = 6

/obj/structure/stran69ebeacon/attack_hand(mob/livin69/user as69ob)
	if(nosi69nal == FALSE)
		playsound(loc, 'sound/machines/twobeep.o6969', 50, 1)	//Plays a beep
		nosi69nal = TRUE

/obj/structure/stran69ebeacon/bots/attack_hand(mob/livin69/user as69ob)
	if(nosi69nal == FALSE)
		var/counter = 0
		var/counterfinish = rand(1,2)

		while(counter < counterfinish)
			counter++
			new /mob/livin69/bot/minin69onestar/resources/a69ressive ( 69et_step(src, pick(69LOB.cardinal)) )
		nosi69nal = TRUE

/obj/structure/stran69ebeacon/pods/proc/call_droppod()
	if(nosi69nal == FALSE)
		visible_messa69e(SPAN_WARNIN69("Pod is called. 69et a safe distance."))
		var/drop_x = src.x-2
		var/drop_y = src.y-2
		var/drop_z = src.z
		var/drop_type = pick(supply_drop_random_loot_types())
		new /datum/random_map/droppod/supply(null, drop_x, drop_y, drop_z, supplied_drop = drop_type) // Splat.
		nosi69nal = TRUE
		bluespace_entropy(entropy_value, 69et_turf(src))

/obj/structure/stran69ebeacon/pods/attack_hand(mob/livin69/user as69ob)
	addtimer(CALLBACK(src, .proc/call_droppod), rand(100,300))

/obj/structure/stran69ebeacon/bombard/attack_hand(mob/livin69/user as69ob)
	var/counter = 0
	var/counterfinish = rand(2,4)
	var/list/turf/bombarda = list()
	for(var/turf/T in 69et_area(src))
		bombarda.Add(T)

	while(counter < counterfinish)
		counter++
		sleep(rand(4,7))
		explosion(pick(bombarda), 1, 2, 3, 3)