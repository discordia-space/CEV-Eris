/obj/rogue/teleporter //the teleporter itself
	name = "ancient teleporter"
	icon = 'icons/obj/bluespace_portal.dmi'
	desc = "A rugged and battered piece of technology from before, seems barely operational."
	icon_state = "bluespace_portal"
	w_class = ITEM_SIZE_GARGANTUAN
	pixel_x = -16
	var/charging = FALSE
	var/charge = 0
	var/charge_max = 50
	var/flick_lighting = 0
	var/ticks_before_next_summon = 2
	var/mobgenlist = list(
		/mob/living/simple_animal/hostile/bear,
		/mob/living/simple_animal/hostile/carp,
		/mob/living/simple_animal/hostile/carp,
		/mob/living/simple_animal/hostile/carp/pike,
		/mob/living/simple_animal/hostile/hivebot,
		/mob/living/simple_animal/hostile/viscerator,
		/mob/living/simple_animal/hostile/viscerator)//duplicates to rig chances towards spawning more weaker enemies, but in favour of generally spawning more enemies
	var/turfs_around = list()
	var/victims_to_teleport = list()
	var/obj/crawler/spawnpoint/target
	anchored = TRUE
	unacidable = 1
	density = TRUE

/obj/rogue/teleporter/New()
	for(var/turf/T in orange(7, src))
		turfs_around += T

/obj/rogue/teleporter/attack_hand(mob/user)
	if(!charge)
		target = locate(/obj/crawler/spawnpoint)
		if(target)
			to_chat(user, "You activate the teleporter. A strange rumbling fills the area around you.")
			start_teleporter_event()
		else
			to_chat(user, "Nothing seems to happen.")
	else if(charging)
		if(flick_lighting)
			to_chat(user, "The portal looks too unstable to pass through!")
		else
			to_chat(user, "The teleporter needs time to charge.")

/obj/rogue/teleporter/proc/start_teleporter_event()
	charging = TRUE
	handle_teleporter_event()

/obj/rogue/teleporter/proc/handle_teleporter_event()
	while(charge < charge_max)
		update_icon()
		sleep(15)
		charge++
		if(ticks_before_next_summon)
			ticks_before_next_summon--
		else
			summon_mobs()
		sleep(5)

	end_teleporter_event()

/obj/rogue/teleporter/proc/summon_mobs()
	var/max_mobs = 3
	var/min_mobs = 1
	var/monsoon_coefficient = 1

	switch(GLOB.storyteller.config_tag)
		if("warrior")
			max_mobs = 5
			min_mobs = 2
			monsoon_coefficient = 2
		if("healer")
			max_mobs = 2
			monsoon_coefficient = 0.5
		if("jester")//because it's funnier this way
			max_mobs = rand(0, 7)
			min_mobs = rand(0, 3)
			monsoon_coefficient = (rand(5, 30)/10)

	ticks_before_next_summon = rand(10, 20)
	var/mobs_to_spawn = rand(min_mobs, max_mobs)
	while(mobs_to_spawn)
		var/mobchoice = pick(mobgenlist)
		var/mob/living/simple_animal/newmob = new mobchoice(pick(turfs_around))
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(newmob.loc))
		sparks.start()
		newmob.faction = "asteroid_belt" //so they won't just kill each other
		if(prob(10 * monsoon_coefficient)) //elite mobs, rare, but more annoying
			newmob.maxHealth = newmob.maxHealth * 1.2
			newmob.health = newmob.maxHealth
			newmob.color = "green"
		else if(prob(10 * monsoon_coefficient))
			newmob.harm_intent_damage = newmob.harm_intent_damage * 1.5
			newmob.melee_damage_lower = newmob.melee_damage_lower * 1.5
			newmob.melee_damage_upper = newmob.melee_damage_upper * 1.5
			newmob.color = "red"
		mobs_to_spawn--



/obj/rogue/teleporter/proc/end_teleporter_event()
	portal_burst()

	for(var/mob/living/simple_animal/SA in range(8, src))//So wounded people won't fucking die when returning
		SA.adjustBruteLoss(50)

	for(var/mob/living/carbon/human/H in range(8, src))//Only human mobs are allowed, otherwise you'd end up with a fuckton of carps in the dungeon
		victims_to_teleport += H

	for(var/mob/living/silicon/robot/R in range(8, src))//Borgs too
		victims_to_teleport += R

	for(var/mob/living/exosuit/E in range(8, src))//And exosuits too
		victims_to_teleport += E

	for(var/mob/living/M in victims_to_teleport)
		go_to_bluespace(get_turf(src), 3, FALSE, M, get_turf(target))

	new /obj/structure/scrap_spawner/science/large(src.loc)

	sleep(2)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, get_turf(loc))
	sparks.start()

	qdel(src)


/obj/rogue/teleporter/update_icon()
	overlays.Cut()

	if(charging && charge < 10)
		overlays.Add(image(icon, icon_state = "charging_1"))
		return

	if(charging & charge < 25)
		overlays.Add(image(icon, icon_state = "charging_2"))
		return

	if(charging & charge < charge_max)
		overlays.Add(image(icon, icon_state = "charging_3"))
		return

	if(charge >= charge_max)
		overlays.Add(image(icon, icon_state = "charged_portal"))
		overlays.Add(image(icon, icon_state = "beam"))
		return

/obj/rogue/teleporter/proc/portal_burst()
	overlays.Add(image(icon, icon_state = "portal_on"))
	visible_message("A shimmering portal appears!")
	sleep(100)
	update_icon()

	for(var/mob/living/simple_animal/A in target.loc.loc)
		spawn(1)
			if(A)
				A.stasis = FALSE
				A.activate_ai()

	overlays.Add(image(icon, icon_state = "portal_failing"))
	visible_message("The portal starts flickering!")
	flick_lighting = 1
	sleep(100)
	update_icon()

	overlays.Add(image(icon, icon_state = "portal_pop"))
	visible_message("The portal bursts!")

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)

	for (var/mob/living/O in viewers(src, null))
		if (get_dist(src, O) > 8)
			continue

		if (ishuman(O))
			var/mob/living/carbon/human/H = O
			H.flash(8, FALSE , FALSE , FALSE, 8)

		else
			if(!O.blinded)
				if (istype(O,/mob/living/silicon/ai))
					return
				O.flash(8, FALSE, FALSE ,FALSE)

		sleep(1)


/obj/rogue/telebeacon
	name = "ancient beacon"
	desc = "A metallic pylon, covered in rust. It seems still operational."
	icon = 'icons/obj/bluespace_beacon.dmi'
	icon_state = "beacon_off"
	var/victims_to_teleport = list()
	var/turf/target = null
	var/active = FALSE
	w_class = ITEM_SIZE_GARGANTUAN
	anchored = TRUE
	unacidable = 1
	density = TRUE
	var/t_x
	var/t_y
	var/t_z




/obj/rogue/telebeacon/attack_hand(mob/user)
	if(!target)
		target = locate(/obj/crawler/teleport_marker)
	if(!active)
		if(target)
			to_chat(user, "You activate the beacon. It starts glowing softly.")
			active = 1
			icon_state = "beacon_on"
		else
			to_chat(user, "The beacon has no destination, Ahelp this.")
	else if(active)
		to_chat(user, "You reach out and touch the beacon. A strange feeling envelops you.")

		for(var/mob/living/carbon/human/H in range(8, src))//Only human mobs are allowed, otherwise you'd end up with a fuckton of cockroaches in space
			victims_to_teleport += H

		for(var/mob/living/silicon/robot/R in range(8, src))//Borgs too
			victims_to_teleport += R

		for(var/obj/structure/closet/C in range(8, src))//Clostes as well, for transport and storage
			victims_to_teleport += C
		for(var/atom/movable/M in victims_to_teleport)
			go_to_bluespace(get_turf(src), 3, FALSE, M, get_turf(target))
			sleep(1)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, get_turf(loc))
			sparks.start()


/obj/rogue/telebeacon/return_beacon
	name = "ancient return beacon"
	desc = "A metallic pylon, covered in rust. It seems still operational. Barely."


/obj/rogue/telebeacon/return_beacon/attack_hand(mob/user)
	if(!target)
		target = locate(/obj/crawler/teleport_marker)
	if(!active)
		if(target)
			to_chat(user, "You activate the beacon. It starts glowing softly.")
			active = 1
			icon_state = "beacon_on"
		else
			to_chat(user, "The beacon has no destination, Ahelp this.")
	else if(active)
		to_chat(user, "You reach out and touch the beacon. A strange feeling envelops you.")
		go_to_bluespace(get_turf(src), 3, FALSE, user, get_turf(target))
		sleep(1)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(user))
		sparks.start()
