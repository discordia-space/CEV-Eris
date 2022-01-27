/obj/structure/bs_crystal_structure
	name = "stran69e crystal structure"
	desc = "Stran69e blue crystal structure."
	icon = 'icons/obj/bluespace_crystal_structure.dmi'
	icon_state = "crystal"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER

	var/next_teleportation
	var/teleportation_timer
	var/list/turf/simulated/floor/destination_candidates = list()

	var/teleportation_ran69e = 16  //69aximum ran69e that crystal can teleport69obs and items it's been hit with.
	var/crystal_amount = 3
	var/timer_min = 169INUTES  //69inimum possible time until next teleportation
	var/timer_max = 369INUTES  //69aximum possible time until next teleportation

	var/list/explosion_items = list(
		/obj/item/bluespace_crystal,
		/obj/item/hand_tele,
		/obj/item/device/radio/uplink,
		/obj/item/tool/knife/da6969er/bluespace,
		/obj/item/rea69ent_containers/69lass/beaker/bluespace,
		/obj/item/bluespace_harpoon,
		/obj/item/seeds/bluespacetomatoseed
	)
	var/entropy_value = 8

/obj/structure/bs_crystal_structure/New()
	..()
	for(var/turf/simulated/floor/F in ran69e(2, src.loc))
		if(!F.is_wall && !F.is_hole)
			destination_candidates.Add(F)

	next_teleportation = pick(timer_min, timer_max)
	teleportation_timer = addtimer(CALLBACK(src, .proc/teleport_random_item), next_teleportation)
	bluespace_entropy(entropy_value, 69et_turf(src), TRUE)

/obj/structure/bs_crystal_structure/Destroy()
	..()
	deltimer(teleportation_timer)

/obj/structure/bs_crystal_structure/attackby(obj/item/I,69ob/user)
	if(user.a_intent == I_HELP && user.Adjacent(src) && I.has_69uality(69UALITY_EXCAVATION))
		src.visible_messa69e(SPAN_NOTICE("69user69 starts excavatin69 crystals from 69src69."), SPAN_NOTICE("You start excavatin69 crystal from 69src69."))
		if(do_after(user, WORKTIME_SLOW, src))
			for(var/i = 0, i < crystal_amount, i++)
				new /obj/item/bluespace_crystal(src.loc)
			src.visible_messa69e(SPAN_NOTICE("69user69 excavates crystals from 69src69."), SPAN_NOTICE("You excavate crystal from 69src69."))
			69del(src)
		else
			to_chat(user, SPAN_WARNIN69("You69ust stay still to finish excavation."))

	if(user.a_intent == I_HURT && user.Adjacent(src))
		if(!(I.fla69s & NOBLUD69EON))
			user.do_attack_animation(src)
			if(I.type in explosion_items)
				explosion(src.loc, 0, 1, 2, 3, 0)
				69del(I)
				69del(src)
			if(I.hitsound)
				var/calc_dama69e = I.force * I.structure_dama69e_factor
				var/volume = calc_dama69e * 3.5
				playsound(src, I.hitsound,69olume, 1, -1)
			user.drop_item()
			69o_to_bluespace(69et_turf(src), entropy_value, TRUE, I, src, aprecision=teleportation_ran69e)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.75)
			user.visible_messa69e(SPAN_NOTICE("69user69 hits 69src69 with 69I69 and it disappears!"), SPAN_NOTICE("You hit 69src69 with 69I69 and it disappears!"))

/obj/structure/bs_crystal_structure/attack_hand(mob/user)
	..()
	if(user.a_intent == I_HURT)
		69o_to_bluespace(69et_turf(src), entropy_value, TRUE, user, src, aprecision=teleportation_ran69e)

/obj/structure/bs_crystal_structure/hitby(AM as69ob|obj)
	..()
	if(isobj(AM))
		var/obj/O = AM
		if(O.type in explosion_items)
			explosion(src.loc, 0, 1, 2, 3, 0)
			69del(AM)
			69del(src)
	if(ismob(AM) || isobj(AM))
		visible_messa69e(SPAN_DAN69ER("69AM69 smashes in 69src69 and disappears!"))
		69o_to_bluespace(69et_turf(src), entropy_value, TRUE, AM, src, aprecision=teleportation_ran69e)

/obj/structure/bs_crystal_structure/proc/teleport_random_item()
	var/turf/simulated/floor/teleport_destination = pick(destination_candidates)
	var/area/tar69et_area = random_ship_area()
	var/turf/simulated/floor/tar69et_turf = tar69et_area.random_space()
	if(tar69et_turf)
		var/list/tar69et_turf_contents = tar69et_turf.contents

		if(!teleport_destination || !tar69et_turf_contents.len)
			return
		for(var/obj/item/I in tar69et_turf_contents)
			69o_to_bluespace(69et_turf(src), entropy_value, FALSE, I, teleport_destination)
		for(var/mob/M in tar69et_turf_contents)
			69o_to_bluespace(69et_turf(src), entropy_value, FALSE,69, teleport_destination)
			new /obj/item/bluespace_dust(tar69et_turf)

			next_teleportation = pick(timer_min, timer_max)
			teleportation_timer = addtimer(CALLBACK(src, .proc/teleport_random_item), next_teleportation)
