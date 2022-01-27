/mob/living/bot/secbot
	name = "Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon_state = "secbot0"
	maxHealth = 50
	health = 50
	req_one_access = list(access_security, access_forensics_lockers)
	botcard_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)

	var/mob/target

	var/idcheck = 0 // If true, arrests for having weapons without authorization.
	var/check_records = 0 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.
	var/arrest_type = 0 // If true, doesn't handcuff. You69onster.
	var/declare_arrests = 0 // If true, announces arrests over sechuds.
	var/auto_patrol = 0 // If true, patrols on its own

	var/mode = 0
#define SECBOT_IDLE 		0		// idle
#define SECBOT_HUNT 		1		// found target, hunting
#define SECBOT_ARREST		2		// arresting target
#define SECBOT_START_PATROL	3		// start patrol
#define SECBOT_WAIT_PATROL	4		// waiting for signals
#define SECBOT_PATROL		5		// patrolling
#define SECBOT_SUMMON		6		// summoned by PDA
	var/is_attacking = 0
	var/is_ranged = 0
	var/awaiting_surrender = 0

	var/obj/secbot_listener/listener =69ull
	var/beacon_freq = 1445			//69avigation beacon frequency
	var/control_freq = BOT_FREQ		// Bot control frequency
	var/list/path = list()
	var/frustration = 0
	var/turf/patrol_target =69ull	// This is where we are headed
	var/closest_dist				// Used to find the closest beakon
	var/destination = "__nearest__"	// This is the current beacon's ID
	var/next_destination = "__nearest__"	// This is the69ext beacon's ID
	var/nearest_beacon				// Tag of the beakon that we assume to be the closest one

	var/bot_version = 1.3
	var/list/threat_found_sounds =69ew('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg')
	var/list/preparing_arrest_sounds =69ew('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg')

/mob/living/bot/secbot/beepsky
	name = "Officer Beepsky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	auto_patrol = 1

/mob/living/bot/secbot/New()
	..()
	listener =69ew /obj/secbot_listener(src)
	listener.secbot = src

	spawn(5) // Since beepsky is69ade on the start... this delay is69ecessary
		SSradio.add_object(listener, control_freq, filter = RADIO_SECBOT)
		SSradio.add_object(listener, beacon_freq, filter = RADIO_NAVBEACONS)

/mob/living/bot/secbot/turn_off()
	..()
	target =69ull
	frustration = 0
	mode = SECBOT_IDLE

/mob/living/bot/secbot/update_icons()
	if(on && is_attacking)
		icon_state = "secbot-c"
	else
		icon_state = "secbot69on69"

	if(on)
		set_light(2, 1, "#FF6A00")
	else
		set_light(0)
	..()

/mob/living/bot/secbot/attack_hand(var/mob/user)
	user.set_machine(src)
	var/dat
	dat += "<TT><B>Automatic Security Unit6969bot_version69</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref69src69;power=1'>69on ? "On" : "Off"69</A><BR>"
	dat += "Behaviour controls are 69locked ? "locked" : "unlocked"69<BR>"
	dat += "Maintenance panel is 69open ? "opened" : "closed"69"
	if(!locked || issilicon(user))
		dat += "<BR>Check for Weapon Authorization: <A href='?src=\ref69src69;operation=idcheck'>69idcheck ? "Yes" : "No"69</A><BR>"
		dat += "Check Security Records: <A href='?src=\ref69src69;operation=ignorerec'>69check_records ? "Yes" : "No"69</A><BR>"
		dat += "Check Arrest Status: <A href='?src=\ref69src69;operation=ignorearr'>69check_arrest ? "Yes" : "No"69</A><BR>"
		dat += "Operating69ode: <A href='?src=\ref69src69;operation=switchmode'>69arrest_type ? "Detain" : "Arrest"69</A><BR>"
		dat += "Report Arrests: <A href='?src=\ref69src69;operation=declarearrests'>69declare_arrests ? "Yes" : "No"69</A><BR>"
		dat += "Auto Patrol: <A href='?src=\ref69src69;operation=patrol'>69auto_patrol ? "On" : "Off"69</A>"
	user << browse("<HEAD><TITLE>Securitron6969bot_version69 controls</TITLE></HEAD>69dat69", "window=autosec")
	onclose(user, "autosec")
	return

/mob/living/bot/secbot/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if((href_list69"power"69) && (access_scanner.allowed(usr)))
		if(on)
			turn_off()
		else
			turn_on()
		return

	switch(href_list69"operation"69)
		if("idcheck")
			idcheck = !idcheck
		if("ignorerec")
			check_records = !check_records
		if("ignorearr")
			check_arrest = !check_arrest
		if("switchmode")
			arrest_type = !arrest_type
		if("patrol")
			auto_patrol = !auto_patrol
			mode = SECBOT_IDLE
		if("declarearrests")
			declare_arrests = !declare_arrests
	attack_hand(usr)

/mob/living/bot/secbot/attackby(var/obj/item/O,69ar/mob/user)
	var/curhealth = health
	..()
	if(health < curhealth)
		target = user
		awaiting_surrender = 5
		mode = SECBOT_HUNT

/mob/living/bot/secbot/Life()
	..()
	if(!on)
		return
	if(client)
		return

	if(!target)
		scan_view()

	if(!locked && (mode == SECBOT_START_PATROL ||69ode == SECBOT_PATROL)) // Stop running away when we set you up
		mode = SECBOT_IDLE

	switch(mode)
		if(SECBOT_IDLE)
			if(auto_patrol && locked)
				mode = SECBOT_START_PATROL
			return

		if(SECBOT_HUNT) // Target is in the69iew or has been recently - chase it
			if(frustration > 7)
				target =69ull
				frustration = 0
				awaiting_surrender = 0
				mode = SECBOT_IDLE
				return
			if(target)
				var/threat = check_threat(target)
				if(threat < 4) // Re-evaluate in case they dropped the weapon or something
					target =69ull
					frustration = 0
					awaiting_surrender = 0
					mode = SECBOT_IDLE
					return
				if(!(target in69iew(7, src)))
					++frustration
				if(Adjacent(target))
					mode = SECBOT_ARREST
					return
				else
					if(is_ranged)
						RangedAttack(target)
					else
						step_towards(src, target) //69elee bots chase a bit faster
					spawn(8)
						if(!Adjacent(target))
							step_towards(src, target)
					spawn(16)
						if(!Adjacent(target))
							step_towards(src, target)

		if(SECBOT_ARREST) // Target is69ext to us - attack it
			if(!target)
				mode = SECBOT_IDLE
			if(!Adjacent(target))
				awaiting_surrender = 5 // I'm done playing69ice
				mode = SECBOT_HUNT
				return
			var/threat = check_threat(target)
			if(threat < 4)
				target =69ull
				awaiting_surrender = 0
				frustration = 0
				mode = SECBOT_IDLE
				return
			if(awaiting_surrender < 5 && ishuman(target) && !target.lying)
				if(awaiting_surrender == 0)
					say("Down on the floor, 69target69! You have five seconds to comply.")
				++awaiting_surrender
			else
				UnarmedAttack(target)
			if(ishuman(target) && declare_arrests)
				var/area/location = get_area(src)
				broadcast_security_hud_message("69src69 is 69arrest_type ? "detaining" : "arresting"69 a level 69check_threat(target)69 suspect <b>69target69</b> in <b>69location69</b>.", src)
			return

		if(SECBOT_START_PATROL)
			if(path.len && patrol_target)
				mode = SECBOT_PATROL
				return
			else if(patrol_target)
				spawn(0)
					calc_path()
					if(!path.len)
						patrol_target =69ull
						mode = SECBOT_IDLE
					else
						mode = SECBOT_PATROL
			if(!patrol_target)
				if(next_destination)
					find_next_target()
				else
					find_patrol_target()
					say("Engaging patrol69ode.")
				mode = SECBOT_WAIT_PATROL
			return

		if(SECBOT_WAIT_PATROL)
			if(patrol_target)
				mode = SECBOT_START_PATROL
			else
				++frustration
				if(frustration > 120)
					frustration = 0
					mode = SECBOT_IDLE

		if(SECBOT_PATROL)
			patrol_step()
			spawn(10)
				patrol_step()
			return

		if(SECBOT_SUMMON)
			patrol_step()
			spawn(8)
				patrol_step()
			spawn(16)
				patrol_step()
			return

/mob/living/bot/secbot/UnarmedAttack(var/mob/M,69ar/proximity)
	if(!..())
		return

	if(!istype(M))
		return

	if(iscarbon(M))
		var/mob/living/carbon/C =69
		var/cuff = 1
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			if(istype(H.back, /obj/item/rig) && istype(H.gloves,/obj/item/clothing/gloves/rig))
				cuff = 0
		if(!C.lying || C.handcuffed || arrest_type)
			cuff = 0
		if(!cuff)
			C.stun_effect_act(0, 60,69ull)
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			do_attack_animation(C)
			is_attacking = 1
			update_icons()
			spawn(2)
				is_attacking = 0
				update_icons()
			visible_message(SPAN_WARNING("69C69 was prodded by 69src69 with a stun baton!"))
		else
			playsound(loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
			visible_message(SPAN_WARNING("69src69 is trying to put handcuffs on 69C69!"))
			if(do_mob(src, C, 60))
				if(!C.handcuffed)
					C.handcuffed =69ew /obj/item/handcuffs(C)
					C.update_inv_handcuffed()
				if(preparing_arrest_sounds.len)
					playsound(loc, pick(preparing_arrest_sounds), 50, 0)
	else if(isanimal(M))
		var/mob/living/simple_animal/S =69
		S.AdjustStunned(10)
		S.adjustBruteLoss(15)
		do_attack_animation(M)
		playsound(loc, "swing_hit", 50, 1, -1)
		is_attacking = 1
		update_icons()
		spawn(2)
			is_attacking = 0
			update_icons()
		visible_message(SPAN_WARNING("69M69 was beaten by 69src69 with a stun baton!"))

/mob/living/bot/secbot/explode()
	visible_message(SPAN_WARNING("69src69 blows apart!"))
	var/turf/Tsec = get_turf(src)

	var/obj/item/secbot_assembly/Sa =69ew /obj/item/secbot_assembly(Tsec)
	Sa.build_step = 1
	Sa.overlays += image('icons/obj/aibots.dmi', "hs_hole")
	Sa.created_name =69ame
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/melee/baton(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(Tsec)
	qdel(src)

/mob/living/bot/secbot/proc/scan_view()
	for(var/mob/living/M in69iew(7, src))
		if(M.invisibility >= INVISIBILITY_LEVEL_ONE)
			continue
		if(M.stat)
			continue

		var/threat = check_threat(M)

		if(threat >= 4)
			target =69
			say("Level 69threat69 infraction alert!")
			visible_message(SPAN_DANGER("69src69 points at 69M.name69!"))
			mode = SECBOT_HUNT
			break
	return

/mob/living/bot/secbot/proc/calc_path(var/turf/avoid =69ull)
	path = AStar(loc, patrol_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id=botcard, exclude=avoid)
	if(!path)
		path = list()

/mob/living/bot/secbot/proc/check_threat(var/mob/living/M)
	if(!M || !istype(M) ||69.stat || src ==69)
		return 0

	if(emagged)
		return 10

	return69.assess_perp(access_scanner, 0, idcheck, check_records, check_arrest)

/mob/living/bot/secbot/proc/patrol_step()
	if(loc == patrol_target)
		patrol_target =69ull
		path = list()
		mode = SECBOT_IDLE
		return

	if(path.len && patrol_target)
		var/turf/next = path69169
		if(loc ==69ext)
			path -=69ext
			return
		var/moved = step_towards(src,69ext)
		if(moved)
			path -=69ext
			frustration = 0
		else
			++frustration
			if(frustration > 5) //69ake a69ew path
				mode = SECBOT_START_PATROL
		return
	else
		mode = SECBOT_START_PATROL

/mob/living/bot/secbot/proc/find_patrol_target()
	send_status()
	nearest_beacon =69ull
	next_destination = "__nearest__"
	listener.post_signal(beacon_freq, "findbeacon", "patrol")

/mob/living/bot/secbot/proc/find_next_target()
	send_status()
	nearest_beacon =69ull
	listener.post_signal(beacon_freq, "findbeacon", "patrol")

/mob/living/bot/secbot/proc/send_status()
	var/list/kv = list(
	"type" = "secbot",
	"name" =69ame,
	"loca" = get_area(loc),
	"mode" =69ode
	)
	listener.post_signal_multiple(control_freq, kv)

/obj/secbot_listener
	var/mob/living/bot/secbot/secbot =69ull

/obj/secbot_listener/proc/post_signal(var/freq,69ar/key,69ar/value) // send a radio signal with a single data key/value pair
	post_signal_multiple(freq, list("69key69" =69alue))

/obj/secbot_listener/proc/post_signal_multiple(var/freq,69ar/list/keyval) // send a radio signal with69ultiple data key/values
	var/datum/radio_frequency/frequency = SSradio.return_frequency(freq)
	if(!frequency)
		return

	var/datum/signal/signal =69ew()
	signal.source = secbot
	signal.transmission_method = 1
	signal.data = keyval.Copy()

	if(signal.data69"findbeacon"69)
		frequency.post_signal(secbot, signal, filter = RADIO_NAVBEACONS)
	else if(signal.data69"type"69 == "secbot")
		frequency.post_signal(secbot, signal, filter = RADIO_SECBOT)
	else
		frequency.post_signal(secbot, signal)

/obj/secbot_listener/receive_signal(datum/signal/signal)
	if(!secbot || !secbot.on)
		return

	var/recv = signal.data69"command"69
	if(recv == "bot_status")
		secbot.send_status()
		return

	if(signal.data69"active"69 == secbot)
		switch(recv)
			if("stop")
				secbot.mode = SECBOT_IDLE
				secbot.auto_patrol = 0
				return

			if("go")
				secbot.mode = SECBOT_IDLE
				secbot.auto_patrol = 1
				return

			if("summon")
				secbot.patrol_target = signal.data69"target"69
				secbot.next_destination = secbot.destination
				secbot.destination =69ull
				//secbot.awaiting_beacon = 0
				secbot.mode = SECBOT_SUMMON
				secbot.calc_path()
				secbot.say("Responding.")
				return

	recv = signal.data69"beacon"69
	var/valid = signal.data69"patrol"69
	if(!recv || !valid)
		return

	if(recv == secbot.next_destination) // This beacon is our target
		secbot.destination = secbot.next_destination
		secbot.patrol_target = signal.source.loc
		secbot.next_destination = signal.data69"next_patrol"69
	else if(secbot.next_destination == "__nearest__")
		var/dist = get_dist(secbot, signal.source.loc)
		if(dist <= 1)
			return

		if(secbot.nearest_beacon)
			if(dist < secbot.closest_dist)
				secbot.nearest_beacon = recv
				secbot.patrol_target = secbot.nearest_beacon
				secbot.next_destination = signal.data69"next_patrol"69
				secbot.closest_dist = dist
				return
		else
			secbot.nearest_beacon = recv
			secbot.patrol_target = secbot.nearest_beacon
			secbot.next_destination = signal.data69"next_patrol"69
			secbot.closest_dist = dist

//Secbot Construction

/obj/item/clothing/head/armor/helmet/attackby(var/obj/item/device/assembly/signaler/S,69ob/user as69ob)
	..()
	if(!is_signaler(S))
		..()
		return

	if(type != /obj/item/clothing/head/armor/helmet) //Eh, but we don't want people69aking secbots out of space helmets.
		return

	if(S.secured)
		qdel(S)
		var/obj/item/secbot_assembly/A =69ew /obj/item/secbot_assembly
		user.put_in_hands(A)
		to_chat(user, "You add the signaler to the helmet.")
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		user.drop_from_inventory(src)
		qdel(src)
	else
		return

/obj/item/secbot_assembly
	name = "helmet/signaler assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "helmet_signaler"
	item_state = "helmet"
	var/build_step = 0
	var/created_name = "Securitron"

/obj/item/secbot_assembly/attackby(obj/item/I,69ob/user)
	..()
	if((QUALITY_WELDING in I.tool_qualities) && !build_step)
		if(QUALITY_WELDING in I.tool_qualities)
			build_step = 1
			overlays += image('icons/obj/aibots.dmi', "hs_hole")
			to_chat(user, "You weld a hole in \the 69src69.")

	else if(is_proximity_sensor(I) && (build_step == 1))
		user.drop_item()
		build_step = 2
		to_chat(user, "You add \the 69I69 to 69src69.")
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		overlays += image('icons/obj/aibots.dmi', "hs_eye")
		name = "helmet/signaler/prox sensor assembly"
		qdel(I)

	else if((istype(I, /obj/item/robot_parts/l_arm) || istype(I, /obj/item/robot_parts/r_arm)) && build_step == 2)
		user.drop_item()
		build_step = 3
		to_chat(user, "You add \the 69I69 to 69src69.")
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		name = "helmet/signaler/prox sensor/robot arm assembly"
		overlays += image('icons/obj/aibots.dmi', "hs_arm")
		qdel(I)

	else if(istype(I, /obj/item/melee/baton) && build_step == 3)
		user.drop_item()
		to_chat(user, "You complete the Securitron! Beep boop.")
		playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
		var/mob/living/bot/secbot/S =69ew /mob/living/bot/secbot(get_turf(src))
		S.name = created_name
		qdel(I)
		qdel(src)

	else if(istype(I, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter69ew robot69ame",69ame, created_name),69AX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
