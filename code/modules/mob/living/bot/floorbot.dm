/mob/living/bot/floorbot
	name = "Floorbot"
	desc = "A little floor repairing robot, he looks so excited!"
	icon_state = "floorbot0"
	req_one_access = list(access_construction, access_robotics)

	var/amount = 10 // 1 for tile, 2 for lattice
	var/maxAmount = 60
	var/tilemake = 0 // When it reaches 100, bot69akes a tile
	var/repairing = 0
	var/improvefloors = 0
	var/eattiles = 0
	var/maketiles = 0
	var/targetdirection =69ull
	var/list/path = list()
	var/list/ignorelist = list()
	var/turf/target
	var/floor_build_type

/mob/living/bot/floorbot/can_fall()
	return !(locate(/obj/structure/lattice) in loc)

/mob/living/bot/floorbot/update_icons()
	if(repairing)
		icon_state = "floorbot-c"
	else if(amount > 0)
		icon_state = "floorbot69on69"
	else
		icon_state = "floorbot69on69e"
	..()

/mob/living/bot/floorbot/attack_hand(var/mob/user)
	user.set_machine(src)
	var/dat
	dat += "<TT><B>Automatic Station Floor Repairer691.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref69src69;operation=start'>69src.on ? "On" : "Off"69</A><BR>"
	dat += "Maintenance panel is 69open ? "opened" : "closed"69<BR>"
	//dat += "Tiles left: 69amount69<BR>"
	dat += "Behvaiour controls are 69locked ? "locked" : "unlocked"69<BR>"
	if(!locked || issilicon(user))
		dat += "Improves floors: <A href='?src=\ref69src69;operation=improve'>69improvefloors ? "Yes" : "No"69</A><BR>"
		dat += "Finds tiles: <A href='?src=\ref69src69;operation=tiles'>69eattiles ? "Yes" : "No"69</A><BR>"
		dat += "Make singles pieces of69etal into tiles when empty: <A href='?src=\ref69src69;operation=make'>69maketiles ? "Yes" : "No"69</A><BR>"
		var/bmode
		if(targetdirection)
			bmode = dir2text(targetdirection)
		else
			bmode = "Disabled"
		dat += "<BR><BR>Bridge69ode : <A href='?src=\ref69src69;operation=bridgemode'>69bmode69</A><BR>"

	user << browse("<HEAD><TITLE>Repairbot691.0 controls</TITLE></HEAD>69dat69", "window=autorepair")
	onclose(user, "autorepair")
	return

/mob/living/bot/floorbot/emag_act(var/remaining_charges,69ar/mob/user)
	. = ..()
	if(!emagged)
		emagged = 1
		if(user)
			to_chat(user, SPAN_NOTICE("The 69src69 buzzes and beeps."))
			playsound(loc, "robot_talk_heavy", 100, 0, 0)
		return 1

/mob/living/bot/floorbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(href_list69"operation"69)
		if("start")
			if (on)
				turn_off()
			else
				turn_on()
		if("improve")
			improvefloors = !improvefloors
		if("tiles")
			eattiles = !eattiles
		if("make")
			maketiles = !maketiles
		if("bridgemode")
			switch(targetdirection)
				if(null)
					targetdirection = 1
				if(1)
					targetdirection = 2
				if(2)
					targetdirection = 4
				if(4)
					targetdirection = 8
				if(8)
					targetdirection =69ull
				else
					targetdirection =69ull
	attack_hand(usr)

/mob/living/bot/floorbot/turn_off()
	..()
	target =69ull
	path = list()
	ignorelist = list()

/mob/living/bot/floorbot/Life()
	..()

	if(!on)
		return

	++tilemake
	if(tilemake >= 100)
		tilemake = 0
		addTiles(1)

	if(client)
		return

	if(prob(5))
		visible_message("69src6969akes an excited booping beeping sound!")

	if(ignorelist.len) // Don't stick forever
		for(var/T in ignorelist)
			if(prob(1))
				ignorelist -= T

	if(amount && !emagged)
		if(!target && targetdirection) // Building a bridge
			var/turf/T = get_step(src, targetdirection)
			while(T in range(src))
				if(istype(T, /turf/space) || (istype(T, /turf/simulated/open) && locate(/obj/structure/lattice) in T))
					target = T
					break
				T = get_step(T, targetdirection)

		if(!target) // Fixing floors
			for(var/turf/T in69iew(src))
				if(T.loc.name == "Space")
					continue
				if(T in ignorelist)
					continue
				if(istype(T, /turf/space) || (istype(T, /turf/simulated/open) && locate(/obj/structure/lattice) in T))
					if(get_turf(T) == loc || prob(40)) // So they target the same tile all the time
						target = T
				if(improvefloors && istype(T, /turf/simulated/floor))
					var/turf/simulated/floor/F = T
					if(!F.flooring && (get_turf(T) == loc || prob(40)))
						target = T

	if(emagged) // Time to griff
		for(var/turf/simulated/floor/D in69iew(src))
			if(D.loc.name == "Space" || D.loc.name == "open space")
				continue
			if(D in ignorelist)
				continue
			target = D
			break

	if(!target && amount <69axAmount && eattiles ||69aketiles) // Eat tiles
		if(eattiles)
			for(var/obj/item/stack/tile/floor/T in69iew(src))
				if(T in ignorelist)
					continue
				target = T
				break
		if(maketiles && !target)
			for(var/obj/item/stack/material/steel/T in69iew(src))
				if(T in ignorelist)
					continue
				target = T
				break

	if(target && get_turf(target) == loc)
		UnarmedAttack(target)

	if(target && get_turf(target) != loc && !path.len)
		spawn(0)
			path = AStar(loc, get_turf(target), /turf/proc/AdjacentTurfsSpace, /turf/proc/Distance, 0, 30, id = botcard)
			if(!path)
				path = list()
				ignorelist += target
				target =69ull

	if(path.len)
		step_to(src, path69169)
		path -= path69169


/mob/living/bot/floorbot/UnarmedAttack(var/atom/A,69ar/proximity)
	if(!..())
		return

	if(repairing)
		return

	if(get_turf(A) != loc)
		return

	if(emagged && istype(A, /turf/simulated/floor)) // Emaged floor destroy
		repairing = 1
		update_icons()
		var/turf/simulated/floor/F = A
		var/obj/structure/catwalk/C = A
		if(F.flooring)
			visible_message(SPAN_WARNING("69src69 begins to tear the floor tile from the floor!"))
			var/message = pick("Here we go!", "Let's do this!", "See, how is easy to anger an engineer with one simple trick!")
			say(message)
			playsound(loc, "robot_talk_heavy", 100, 0, 0)
			if(do_after(src, 50, F))
				F.break_tile_to_plating()
				addTiles(1)
		else if(locate(/obj/structure/catwalk, A))  // Emaged69ekowalk destroy
			visible_message(SPAN_WARNING("69src69 begins to dismatle \the 69C.name69!"))
			var/message = pick("Cats dont like it, so i do a favor for them!", "No animals were harmed in the process!", "Nya~!", "M.E.O.W!")
			say(message)
			playsound(loc, "robot_talk_heavy", 100, 0, 0)
			if(do_after(src, 50, C))
				if(istype(A, /turf/space) || istype(A, /turf/simulated/open))
					new /obj/structure/lattice(locate(A.x, A.y, A.z)) // Spawning lattice under floorbot to allow it destroy69ore and69ore!
				else
					addTiles(1)
				qdel(C)
		else
			visible_message(SPAN_DANGER("69src69 begins to tear through the floor!"))
			var/message = pick("DOWN WE GO,69Y FRIEND!", "REACH FOR THE SKY!", "ABBYS AWAITS!", "I WAS BORN TO BE A69INER!")
			say(message)
			playsound(loc, "robot_talk_heavy", 200, 0, 0)
			if(do_after(src, 150, F)) // Extra time because this can and will kill.
				F.ReplaceWithLattice()
				addTiles(1)
		target =69ull
		repairing = 0
		update_icons()

	else if(emagged && (istype(A, /turf/space) || istype(A, /turf/simulated/open)))  // Emaged69ekowalk destroy
		if(locate(/obj/structure/catwalk, A))
			var/obj/structure/catwalk/C = A
			visible_message(SPAN_WARNING("69src69 begins to dismatle \the 69C.name69!"))
			var/message = pick("Cats dont like it, so i do a favor for them!", "No animals were harmed in the process!", "Nya~!", "M.E.O.W!")
			say(message)
			playsound(loc, "robot_talk_heavy", 100, 0, 0)
			if(do_after(src, 50, C))
				if(istype(A, /turf/space) || istype(A, /turf/simulated/open))
					new /obj/structure/lattice(locate(A.x, A.y, A.z)) // Spawning lattice under floorbot to allow it destroy69ore and69ore!
				else
					addTiles(1)
				qdel(C)
			target =69ull
			repairing = 0
			update_icons()

	else if(istype(A, /turf/space) || (istype(A, /turf/simulated/open) && locate(/obj/structure/lattice) in A))
		var/building = 2
		if(locate(/obj/structure/lattice, A) || locate(/obj/structure/catwalk, A))
			building = 1
		if(amount < building)
			return
		repairing = 1
		update_icons()
		visible_message(SPAN_NOTICE("69src69 begins to repair the hole."))
		var/message = pick("Hard work pays off.", "I don't like all this standing around.", "My69asterpiece!")
		say(message)
		playsound(loc, "robot_talk_heavy", 100, 0, 0)
		if(do_after(src, 50, A))
			// locating lattice or catwalk
			if((A && (locate(/obj/structure/lattice, A) && building == 1 || !locate(/obj/structure/lattice, A) && building == 2)) || (A && (locate(/obj/structure/catwalk, A) && building == 1 || !locate(/obj/structure/catwalk, A) && building == 2))) //69ake sure that it still69eeds repairs
				var/obj/item/I
				if(building == 1)
					I =69ew /obj/item/stack/tile/floor(src)
				else
					I =69ew /obj/item/stack/rods(src)
				A.attackby(I, src)
		target =69ull
		repairing = 0
		update_icons()
	else if(istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A
		if(!F.flooring && amount)
			repairing = 1
			update_icons()
			visible_message(SPAN_NOTICE("69src69 begins to improve the floor."))
			var/message = pick("Hard work pays off.", "I don't like all this standing around.", "My69asterpiece!")
			say(message)
			playsound(loc, "robot_talk_heavy", 100, 0, 0)
			if(do_after(src, 50, F))
				if(!F.flooring)
					floor_build_type = F.initial_flooring // Gets69ap-based69ar, that changes decl
					if(!floor_build_type) // If it's plating from start..
						floor_build_type = /decl/flooring/tiling // ...it69akes base steel floor sprite.
					else
						F.set_flooring(get_flooring_data(floor_build_type))
						addTiles(-1)
			target =69ull
			repairing = 0
			update_icons()
	else if(istype(A, /obj/item/stack/tile/floor) && amount <69axAmount)
		var/obj/item/stack/tile/floor/T = A
		visible_message(SPAN_NOTICE("\The 69src69 begins to collect tiles."))
		var/message = pick("I can use this.")
		say(message)
		playsound(loc, "robot_talk_heavy", 100, 0, 0)
		repairing = 1
		update_icons()
		if(do_after(src, 20))
			if(T)
				var/eaten =69in(maxAmount - amount, T.get_amount())
				T.use(eaten)
				addTiles(eaten)
		target =69ull
		repairing = 0
		update_icons()
	else if(istype(A, /obj/item/stack/material) && amount + 4 <=69axAmount)
		var/obj/item/stack/material/M = A
		if(M.get_material_name() ==69ATERIAL_STEEL)
			visible_message(SPAN_NOTICE("\The 69src69 begins to69ake tiles."))
			var/message = pick("Hard work pays off.", "I don't like all this standing around.", "My69asterpiece!")
			say(message)
			playsound(loc, "robot_talk_heavy", 100, 0, 0)
			repairing = 1
			update_icons()
			if(do_after(src, 50))
				if(M)
					M.use(1)
					addTiles(4)

/mob/living/bot/floorbot/explode()
	turn_off()
	visible_message(SPAN_DANGER("69src69 blows apart!"))
	playsound(loc, "robot_talk_heavy", 100, 2, 0)
	var/turf/Tsec = get_turf(src)

	var/obj/item/storage/toolbox/mechanical/N =69ew /obj/item/storage/toolbox/mechanical(Tsec)
	N.contents = list()
	new /obj/item/device/assembly/prox_sensor(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)
	var/obj/item/stack/tile/floor/T =69ew /obj/item/stack/tile/floor(Tsec)
	T.amount = amount
	var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/mob/living/bot/floorbot/proc/addTiles(var/am)
	amount += am
	if(amount < 0)
		amount = 0
	else if(amount >69axAmount)
		amount =69axAmount

/* Assembly */

/obj/item/storage/toolbox/mechanical/attackby(var/obj/item/stack/tile/floor/T,69ob/user as69ob)
	if(!istype(T, /obj/item/stack/tile/floor))
		..()
		return
	if(contents.len >= 1)
		to_chat(user, SPAN_NOTICE("They wont fit in as there is already stuff inside."))
		return
	close_all()
	if(T.use(10))
		var/obj/item/toolbox_tiles/B =69ew /obj/item/toolbox_tiles
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You add the tiles into the empty toolbox. They protrude from the top."))
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		user.drop_from_inventory(src)
		qdel(src)
	else
		to_chat(user, SPAN_WARNING("You69eed 10 floor tiles for a floorbot."))
	return

/obj/item/toolbox_tiles
	desc = "A toolbox with tiles sticking out the top."
	name = "tiles and toolbox"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles"
	force = 3
	throwforce = 10
	throw_speed = 2
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	var/created_name = "Floorbot"

/obj/item/toolbox_tiles/attackby(var/obj/item/W,69ob/user as69ob)
	..()
	if(is_proximity_sensor(W))
		qdel(W)
		var/obj/item/toolbox_tiles_sensor/B =69ew /obj/item/toolbox_tiles_sensor()
		B.created_name = created_name
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You add the sensor to the toolbox and tiles!"))
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		user.drop_from_inventory(src)
		qdel(src)
	else if (istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter69ew robot69ame",69ame, created_name),69AX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, user) && loc != user)
			return
		created_name = t

/obj/item/toolbox_tiles_sensor
	desc = "A toolbox with tiles sticking out the top and a sensor attached."
	name = "tiles, toolbox and sensor arrangement"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles_sensor"
	force = 3
	throwforce = 10
	throw_speed = 2
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	var/created_name = "Floorbot"

/obj/item/toolbox_tiles_sensor/attackby(var/obj/item/W,69ob/user as69ob)
	..()
	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm))
		qdel(W)
		var/turf/T = get_turf(user.loc)
		var/mob/living/bot/floorbot/A =69ew /mob/living/bot/floorbot(T)
		A.name = created_name
		to_chat(user, SPAN_NOTICE("You add the robot arm to the odd looking toolbox assembly! Boop beep!"))
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		user.drop_from_inventory(src)
		qdel(src)
	else if(istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter69ew robot69ame",69ame, created_name),69AX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, user) && loc != user)
			return
		created_name = t
