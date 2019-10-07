/obj/rogue/telebeacon
	name = "ancient beacon"
	icon = 'icons/obj/bluespace_beacon.dmi'
	icon_state = "beacon_off"

/obj/rogue/teleporter //the teleporter itself
	name = "ancient teleporter"
	icon = 'icons/obj/bluespace_portal.dmi'
	icon_state = "bluespace_portal"
	var/charging = FALSE
	var/charge = 0
	var/charge_max = 50
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

/obj/rogue/teleporter/New()
	for(var/turf/T in orange(7, src))
		turfs_around += T

/obj/rogue/teleporter/attack_hand(var/mob/user as mob)
	if(!charge)
		to_chat(user, "You activate the teleporter. A strange rumbling fills the area around you.")
		start_teleporter_event()
	else if(charging)
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
	ticks_before_next_summon = rand(5, 15)
	var/mobs_to_spawn = rand(1, 3)
	while(mobs_to_spawn)
		var/mobchoice = pick(mobgenlist)
		var/mob/living/simple_animal/newmob = new mobchoice(pick(turfs_around))
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(newmob.loc))
		sparks.start()
		newmob.faction = "asteroid_belt" //so they won't just kill each other
		if(prob(10)) //elite mobs, rare, but more annoying
			newmob.maxHealth = newmob.maxHealth * 1.2
			newmob.health = newmob.maxHealth
			newmob.color = "green"
		else if(prob(10))
			newmob.harm_intent_damage = newmob.harm_intent_damage * 1.5
			newmob.melee_damage_lower = newmob.melee_damage_lower * 1.5
			newmob.melee_damage_upper = newmob.melee_damage_upper * 1.5
			newmob.color = "red"
		mobs_to_spawn--



/obj/rogue/teleporter/proc/end_teleporter_event()
	portal_burst()

	for(var/mob/living/carbon/human/H in range(8, src))//Only human mobs are allowed, otherwise you'd end up with a fuckton of carps in the dungeon
		victims_to_teleport += H

	for(var/mob/living/silicon/robot/R in range(8, src))//Borgs too
		victims_to_teleport += R

	new /obj/structure/scrap/science/large(src.loc)

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

	overlays.Add(image(icon, icon_state = "portal_failing"))
	visible_message("The portal starts flickering!")
	sleep(100)
	update_icon()

	overlays.Add(image(icon, icon_state = "portal_pop"))
	visible_message("The portal bursts!")

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)

	for (var/mob/living/O in viewers(src, null))
		if (get_dist(src, O) > 8)
			continue

		var/flash_time = 8
		if (ishuman(O))
			var/mob/living/carbon/human/H = O
			if(!H.eyecheck() <= 0)
				continue
			flash_time *= H.species.flash_mod
			var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
			if(!E)
				return
			if(E.is_bruised() && prob(E.damage + 50))
				if (O.HUDtech.Find("flash"))
					flick("e_flash", O.HUDtech["flash"])
				E.damage += rand(1, 5)
		else
			if(!O.blinded)
				if (istype(O,/mob/living/silicon/ai))
					return
				if (O.HUDtech.Find("flash"))
					flick("flash", O.HUDtech["flash"])
		O.Weaken(flash_time)

		sleep(10)