#define FARMBOT_COLLECT 1
#define FARMBOT_WATER 2
#define FARMBOT_UPROOT 3
#define FARMBOT_NUTRIMENT 4

/mob/living/bot/farmbot
	name = "Farmbot"
	desc = "The botanist's best friend."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "farmbot0"
	health = 50
	maxHealth = 50
	req_one_access = list(access_hydroponics, access_robotics)

	var/action = "" // Used to update icon
	var/waters_trays = 1
	var/refills_water = 1
	var/uproots_weeds = 1
	var/replaces_nutriment = 0
	var/collects_produce = 0
	var/removes_dead = 0

	var/obj/structure/reagent_dispensers/watertank/tank

	var/attacking = 0
	var/list/path = list()
	var/atom/target
	var/frustration = 0

/mob/living/bot/farmbot/Initialize()
	. = ..()
	tank = locate() in contents
	if(!tank)
		tank =69ew /obj/structure/reagent_dispensers/watertank(src)

/mob/living/bot/farmbot/attack_hand(var/mob/user as69ob)
	. = ..()
	if(.)
		return
	var/dat = ""
	dat += "<TT><B>Automatic Hyrdoponic Assisting Unit691.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref69src69;power=1'>69on ? "On" : "Off"69</A><BR>"
	dat += "Water Tank: "
	if (tank)
		dat += "69tank.reagents.total_volume69/69tank.reagents.maximum_volume69"
	else
		dat += "Error: Watertank69ot found"
	dat += "<br>Behaviour controls are 69locked ? "locked" : "unlocked"69<hr>"
	if(!locked)
		dat += "<TT>Watering controls:<br>"
		dat += "Water plants : <A href='?src=\ref69src69;water=1'>69waters_trays ? "Yes" : "No"69</A><BR>"
		dat += "Refill watertank : <A href='?src=\ref69src69;refill=1'>69refills_water ? "Yes" : "No"69</A><BR>"
		dat += "<br>Weeding controls:<br>"
		dat += "Weed plants: <A href='?src=\ref69src69;weed=1'>69uproots_weeds ? "Yes" : "No"69</A><BR>"
		dat += "<br>Nutriment controls:<br>"
		dat += "Replace fertilizer: <A href='?src=\ref69src69;replacenutri=1'>69replaces_nutriment ? "Yes" : "No"69</A><BR>"
		dat += "<br>Plant controls:<br>"
		dat += "Collect produce: <A href='?src=\ref69src69;collect=1'>69collects_produce ? "Yes" : "No"69</A><BR>"
		dat += "Remove dead plants: <A href='?src=\ref69src69;removedead=1'>69removes_dead ? "Yes" : "No"69</A><BR>"
		dat += "</TT>"

	user << browse("<HEAD><TITLE>Farmbot691.0 controls</TITLE></HEAD>69dat69", "window=autofarm")
	onclose(user, "autofarm")
	return

/mob/living/bot/farmbot/emag_act(var/remaining_charges,69ar/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, SPAN_NOTICE("You short out 69src69's plant identifier circuits."))
		spawn(rand(30, 50))
			visible_message(SPAN_WARNING("69src69 buzzes oddly."))
			playsound(loc, "robot_talk_heavy", 100, 0, 0)
			emagged = 1
		return 1

/mob/living/bot/farmbot/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	add_fingerprint(usr)
	if((href_list69"power"69) && (access_scanner.allowed(usr)))
		if(on)
			turn_off()
		else
			turn_on()

	if(locked)
		return

	if(href_list69"water"69)
		waters_trays = !waters_trays
	else if(href_list69"refill"69)
		refills_water = !refills_water
	else if(href_list69"weed"69)
		uproots_weeds = !uproots_weeds
	else if(href_list69"replacenutri"69)
		replaces_nutriment = !replaces_nutriment
	else if(href_list69"collect"69)
		collects_produce = !collects_produce
	else if(href_list69"removedead"69)
		removes_dead = !removes_dead

	attack_hand(usr)
	return

/mob/living/bot/farmbot/update_icons()
	if(on && action)
		icon_state = "farmbot_69action69"
	else
		icon_state = "farmbot69on69"
	..()

/mob/living/bot/farmbot/Life()
	..()
	if(!on)
		return
	if(emagged && prob(1))
		flick("farmbot_broke", src)
	if(client)
		return

	if(target)
		if(Adjacent(target))
			UnarmedAttack(target)
			path = list()
			target =69ull
		else
			if(path.len && frustration < 5)
				if(path69169 == loc)
					path -= path69169
				var/t = step_towards(src, path69169)
				if(t)
					path -= path69169
				else
					++frustration
			else
				path = list()
				target =69ull
	else
		if(emagged)
			for(var/mob/living/carbon/human/H in69iew(7, src))
				target = H
				break
		else
			for(var/obj/machinery/portable_atmospherics/hydroponics/tray in69iew(7, src))
				if(process_tray(tray))
					target = tray
					frustration = 0
					break
			if(!target && refills_water && tank && tank.reagents.total_volume < tank.reagents.maximum_volume)
				for(var/obj/structure/sink/source in69iew(7, src))
					target = source
					frustration = 0
					break
		if(target)
			var/t = get_dir(target, src) // Turf with the tray is impassable, so a* can't69avigate directly to it
			path = AStar(loc, get_step(target, t), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id = botcard)
			if(!path)
				path = list()

/mob/living/bot/farmbot/UnarmedAttack(var/atom/A,69ar/proximity)
	if(!..())
		return
	if(attacking)
		return

	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = A
		var/t = process_tray(T)
		switch(t)
			if(0)
				return
			if(FARMBOT_COLLECT)
				action = "collect"
				update_icons()
				visible_message("<span class='notice'>69src69 starts 69T.dead? "removing the plant from" : "harvesting"69 \the 69A69.</span>")
				playsound(loc, "robot_talk_heavy", 100, 0, 0)
				var/message = pick("I WILL GATHER.", "TIME FOR THE HARVEST.", "YOURE TIME HAS COME.", "WHAT YOU SOW IS WHAT YOU REAP.", "PLOW IT UP.", "IT'S THE HARVEST69OON.", "THE HEART OF PERFECT FARMING", "THE CREAM OF THE CROP.")
				say(message)
				attacking = 1
				if(do_after(src, 30, A))
					visible_message("<span class='notice'>69src69 69T.dead? "removes the plant from" : "harvests"69 \the 69A69.</span>")
					T.attack_hand(src)
			if(FARMBOT_WATER)
				action = "water"
				update_icons()
				visible_message(SPAN_NOTICE("69src69 starts watering \the 69A69."))
				playsound(loc, "robot_talk_heavy", 100, 0, 0)
				var/message = pick("WATER IS LIFE.", "YOU69EED WATER. I GIVE WATER.", "THOUSANDS LIVE WITHOUT LOVE,69OBODY WITHOUT WATER.", "NO WATER,69O LIFE.69O BLUE,69O GREEN.", "WATER IS THE DRIVING FORCE OF ALL69ATURE.", "WATER CAN FLOW, OR IT CAN CRASH. BE WATER,69Y FRIEND.", "KEEP CALM AND LOVE WATER", "WATER: THE ORIGINAL69O CALORIE DRINK.", "LIFE STARTS WITH WATER.")
				say(message)
				attacking = 1
				if(do_after(src, 30, A))
					playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
					visible_message(SPAN_NOTICE("69src69 waters \the 69A69."))
					playsound(loc, "robot_talk_heavy", 100, 0, 0)
					tank.reagents.trans_to(T, 100 - T.waterlevel)
			if(FARMBOT_UPROOT)
				action = "hoe"
				update_icons()
				visible_message(SPAN_NOTICE("69src69 starts uprooting the weeds in \the 69A69."))
				playsound(loc, "robot_talk_heavy", 100, 0, 0)
				var/message = pick("I WILL PURGE THIS.", "YOU HAVE69O PLACE HERE.", "WEEDS ARE STUBBORN. WEEDS ARE INDEPENDENT. WEEDS ARE69OT TOLERATED.", "ONCE WEEDS GROW ROOTS, THEY ARE HARDER TO DIG UP.", "NO PLACE FOR PESTS.")
				say(message)
				attacking = 1
				if(do_after(src, 30, A))
					visible_message(SPAN_NOTICE("69src69 uproots the weeds in \the 69A69."))
					playsound(loc, "robot_talk_heavy", 100, 0, 0)
					T.weedlevel = 0
			if(FARMBOT_NUTRIMENT)
				action = "fertile"
				update_icons()
				visible_message(SPAN_NOTICE("69src69 starts fertilizing \the 69A69."))
				playsound(loc, "robot_talk_heavy", 100, 0, 0)
				var/message = pick("MUST FEED YOU.", "YOU HAVE TO GROW BIG.", "DEATH IS GOOD. IT'S FERTILIZING.", "PLANTS WOULD RATHER BE DEFECATED ON THAN BE LOVED.", "ONLY69ATURAL INGREDIENTS.")
				say(message)
				attacking = 1
				if(do_after(src, 30, A))
					visible_message(SPAN_NOTICE("69src69 waters \the 69A69."))
					playsound(loc, "robot_talk_heavy", 100, 0, 0)
					T.reagents.add_reagent("ammonia", 10)
		attacking = 0
		action = ""
		update_icons()
		T.update_icon()
	else if(istype(A, /obj/structure/sink))
		if(!tank || tank.reagents.total_volume >= tank.reagents.maximum_volume)
			return
		action = "water"
		update_icons()
		visible_message(SPAN_NOTICE("69src69 starts refilling its tank from \the 69A69."))
		playsound(loc, "robot_talk_heavy", 100, 0, 0)
		attacking = 1
		while(do_after(src, 10) && tank.reagents.total_volume < tank.reagents.maximum_volume)
			tank.reagents.add_reagent("water", 10)
			if(prob(5))
				playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		attacking = 0
		action = ""
		update_icons()
		visible_message(SPAN_NOTICE("69src69 finishes refilling its tank."))
		playsound(loc, "robot_talk_heavy", 100, 0, 0)
	else if(emagged && ishuman(A))
		var/action = pick("weed", "water")
		attacking = 1
		spawn(50) // Some delay
			attacking = 0
		switch(action)
			if("weed")
				flick("farmbot_hoe", src)
				do_attack_animation(A)
				if(prob(50))
					visible_message(SPAN_DANGER("69src69 swings wildly at 69A69 with a69inihoe,69issing completely!"))
					playsound(loc, "robot_talk_heavy", 100, 0, 0)
					return
				var/t = pick("slashed", "sliced", "cut", "clawed")
				A.attack_generic(src, 5, t)
				playsound(loc, "robot_talk_heavy", 200, 0, 0)
				var/message = pick("I WILL PURGE THIS.", "YOU HAVE69O PLACE HERE.")
				say(message)
			if("water")
				flick("farmbot_water", src)
				visible_message(SPAN_DANGER("69src69 splashes 69A69 with water!")) // That's it. RP effect.

/mob/living/bot/farmbot/explode()
	visible_message(SPAN_DANGER("69src69 blows apart!"))
	playsound(loc, "robot_talk_heavy", 100, 2, 0)
	var/turf/Tsec = get_turf(src)

	new /obj/item/tool/minihoe(Tsec)
	new /obj/item/reagent_containers/glass/bucket(Tsec)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/device/scanner/plant(Tsec)

	if(tank)
		tank.loc = Tsec

	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/bot/farmbot/proc/process_tray(var/obj/machinery/portable_atmospherics/hydroponics/tray)
	if(!tray || !istype(tray))
		return 0

	if(tray.closed_system || !tray.seed)
		return 0

	if(tray.dead && removes_dead || tray.harvest && collects_produce)
		return FARMBOT_COLLECT

	else if(refills_water && tray.waterlevel < 40 && !tray.reagents.has_reagent("water"))
		return FARMBOT_WATER

	else if(uproots_weeds && tray.weedlevel > 3)
		return FARMBOT_UPROOT

	else if(replaces_nutriment && tray.nutrilevel < 1 && tray.reagents.total_volume < 1)
		return FARMBOT_NUTRIMENT

	return 0

// Assembly

/obj/item/farmbot_arm_assembly
	name = "water tank/robot arm assembly"
	desc = "A water tank with a robot arm permanently grafted to it."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "water_arm"
	var/build_step = 0
	var/created_name = "Farmbot"
	w_class = ITEM_SIZE_NORMAL

/obj/item/farmbot_arm_assembly/Initialize()
	. = ..()
	var tank = locate(/obj/structure/reagent_dispensers/watertank) in contents
	if(!tank)
		new /obj/structure/reagent_dispensers/watertank(src)


/obj/structure/reagent_dispensers/watertank/attackby(var/obj/item/robot_parts/S,69ob/user as69ob)
	if ((!istype(S, /obj/item/robot_parts/l_arm)) && (!istype(S, /obj/item/robot_parts/r_arm)))
		..()
		return

	var/obj/item/farmbot_arm_assembly/A =69ew /obj/item/farmbot_arm_assembly(loc)

	to_chat(user, "You add the robot arm to 69src69.")
	playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
	loc = A //Place the water tank into the assembly, it will be69eeded for the finished bot
	user.drop_from_inventory(S)
	qdel(S)

/obj/item/farmbot_arm_assembly/attackby(obj/item/W as obj,69ob/user as69ob)
	..()
	if((istype(W, /obj/item/device/scanner/plant)) && (build_step == 0))
		build_step++
		to_chat(user, "You add the plant analyzer to 69src69.")
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		name = "farmbot assembly"
		user.remove_from_mob(W)
		qdel(W)

	else if((istype(W, /obj/item/reagent_containers/glass/bucket)) && (build_step == 1))
		build_step++
		to_chat(user, "You add a bucket to 69src69.")
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		name = "farmbot assembly with bucket"
		user.remove_from_mob(W)
		qdel(W)

	else if((istype(W, /obj/item/tool/minihoe)) && (build_step == 2))
		build_step++
		to_chat(user, "You add a69inihoe to 69src69.")
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		name = "farmbot assembly with bucket and69inihoe"
		user.remove_from_mob(W)
		qdel(W)

	else if((is_proximity_sensor(W)) && (build_step == 3))
		build_step++
		to_chat(user, "You complete the Farmbot! Beep boop.")
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		var/mob/living/bot/farmbot/S =69ew /mob/living/bot/farmbot(get_turf(src))
		for(var/obj/structure/reagent_dispensers/watertank/wTank in contents)
			wTank.loc = S
			S.tank = wTank
		S.name = created_name
		user.remove_from_mob(W)
		qdel(W)
		qdel(src)

	else if(istype(W, /obj/item/pen))
		var/t = input(user, "Enter69ew robot69ame",69ame, created_name) as text
		t = sanitize(t,69AX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return

		created_name = t

/obj/item/farmbot_arm_assembly/attack_hand(mob/user as69ob)
	return //it's a converted watertank,69o you cannot pick it up and put it in your backpack
