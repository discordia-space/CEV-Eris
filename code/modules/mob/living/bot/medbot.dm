/mob/living/bot/medbot
	name = "Medbot"
	desc = "A little69edical robot. He looks somewhat underwhelmed."
	icon_state = "medibot0"
	req_one_access = list(access_moebius, access_robotics)

	var/skin =69ull //Set to "tox", "ointment" or "o2" for the other two firstaid kits.
	botcard_access = list(access_moebius, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)

	//AI69ars
	var/frustration = 0
	var/list/path = list()
	var/mob/living/carbon/human/patient =69ull
	var/mob/ignored = list() // Used by emag
	var/last_newpatient_speak = 0
	var/vocal = 1

	//Healing69ars
	var/obj/item/reagent_containers/glass/reagent_glass =69ull //Can be set to draw from this for reagents.
	var/currently_healing = 0
	var/injection_amount = 15 //How69uch reagent do we inject at a time?
	var/heal_threshold = 10 //Start healing when they have this69uch damage in a category
	var/use_beaker = 0 //Use reagents in beaker instead of default treatment agents.
	var/treatment_brute = "tricordrazine"
	var/treatment_oxy = "tricordrazine"
	var/treatment_fire = "tricordrazine"
	var/treatment_tox = "tricordrazine"
	var/treatment_virus = "spaceacillin"
	var/treatment_emag = "toxin"
	var/declare_treatment = 0 //When attempting to treat a patient, should it69otify everyone wearing69edhuds?

/mob/living/bot/medbot/Life()
	..()

	if(!on)
		return

	if(!client)

		if(vocal && prob(1))
			var/message = pick("Radar, put a69ask on!", "There's always a catch, and it's the best there is.", "I knew it, I should've been a plastic surgeon.", "What kind of69edbay is this? Everyone's dropping like dead flies.", "Delicious!")
			say(message)
			playsound(loc, "robot_talk_light", 100, 0, 0)

		if(patient)
			if(Adjacent(patient))
				if(!currently_healing)
					UnarmedAttack(patient)
			else
				if(path.len && (get_dist(patient, path69path.len69) > 2)) // We have a path, but it's off
					path = list()
				if(!path.len && (get_dist(src, patient) > 1))
					spawn(0)
						path = AStar(loc, get_turf(patient), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id = botcard)
						if(!path)
							path = list()
				if(path.len)
					step_to(src, path69169)
					path -= path69169
					++frustration
				if(get_dist(src, patient) > 7 || frustration > 8)
					patient =69ull
		else
			for(var/mob/living/carbon/human/H in69iew(7, src)) // Time to find a patient!
				if(valid_healing_target(H))
					patient = H
					frustration = 0
					if(last_newpatient_speak + 300 < world.time)
						var/message = pick("Hey, 69H.name69! Hold on, I'm coming.", "Wait 69H.name69! I want to help!", "69H.name69, you appear to be injured!")
						say(message)
						playsound(loc, "robot_talk_light", 100, 0, 0)
						visible_message("69src69 points at 69H.name69.")
						last_newpatient_speak = world.time
					break

/mob/living/bot/medbot/UnarmedAttack(var/mob/living/carbon/human/H,69ar/proximity)
	if(!..())
		return

	if(!on)
		return

	if(!istype(H))
		return

	if(H.stat == DEAD)
		var/death_message = pick("No!69O!", "Live, damnit! LIVE!", "I... I've69ever lost a patient before.69ot today, I69ean.")
		say(death_message)
		playsound(loc, "robot_talk_light", 100, 0, 0)
		patient =69ull
		return

	var/t =69alid_healing_target(H)
	if(!t)
		var/message = pick("All patched up!", "An apple a day keeps69e away.", "Feel better soon!")
		say(message)
		playsound(loc, "robot_talk_light", 100, 0, 0)
		patient =69ull
		return

	icon_state = "medibots"
	visible_message(SPAN_WARNING("69src69 is trying to inject 69H69!"))
	if(declare_treatment)
		var/area/location = get_area(src)
		broadcast_medical_hud_message("69src69 is treating <b>69H69</b> in <b>69location69</b>", src)
	currently_healing = 1
	update_icons()
	if(do_mob(src, H, 30))
		if(t == 1)
			reagent_glass.reagents.trans_to_mob(H, injection_amount, CHEM_BLOOD)
		else
			H.reagents.add_reagent(t, injection_amount)
		visible_message(SPAN_WARNING("69src69 injects 69H69 with the syringe!"))
	currently_healing = 0
	update_icons()

/mob/living/bot/medbot/update_icons()
	overlays.Cut()
	if(skin)
		overlays += image('icons/obj/aibots.dmi', "medskin_69skin69")
	if(currently_healing)
		icon_state = "medibots"
	else
		icon_state = "medibot69on69"
	..()

/mob/living/bot/medbot/attack_hand(var/mob/user)
	var/dat
	dat += "<TT><B>Automatic69edical Unit691.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref69src69;power=1'>69on ? "On" : "Off"69</A><BR>"
	dat += "Maintenance panel is 69open ? "opened" : "closed"69<BR>"
	dat += "Beaker: "
	if (reagent_glass)
		dat += "<A href='?src=\ref69src69;eject=1'>Loaded \6969reagent_glass.reagents.total_volume69/69reagent_glass.reagents.maximum_volume69\69</a>"
	else
		dat += "None Loaded"
	dat += "<br>Behaviour controls are 69locked ? "locked" : "unlocked"69<hr>"
	if(!locked || issilicon(user))
		dat += "<TT>Healing Threshold: "
		dat += "<a href='?src=\ref69src69;adj_threshold=-10'>--</a> "
		dat += "<a href='?src=\ref69src69;adj_threshold=-5'>-</a> "
		dat += "69heal_threshold69 "
		dat += "<a href='?src=\ref69src69;adj_threshold=5'>+</a> "
		dat += "<a href='?src=\ref69src69;adj_threshold=10'>++</a>"
		dat += "</TT><br>"

		dat += "<TT>Injection Level: "
		dat += "<a href='?src=\ref69src69;adj_inject=-5'>-</a> "
		dat += "69injection_amount69 "
		dat += "<a href='?src=\ref69src69;adj_inject=5'>+</a> "
		dat += "</TT><br>"

		dat += "Reagent Source: "
		dat += "<a href='?src=\ref69src69;use_beaker=1'>69use_beaker ? "Loaded Beaker (When available)" : "Internal Synthesizer"69</a><br>"

		dat += "Treatment report is 69declare_treatment ? "on" : "off"69. <a href='?src=\ref69src69;declaretreatment=69169'>Toggle</a><br>"

		dat += "The speaker switch is 69vocal ? "on" : "off"69. <a href='?src=\ref69src69;togglevoice=69169'>Toggle</a><br>"

	user << browse("<HEAD><TITLE>Medibot691.0 controls</TITLE></HEAD>69dat69", "window=automed")
	onclose(user, "automed")
	return

/mob/living/bot/medbot/attackby(var/obj/item/O,69ar/mob/user)
	if(istype(O, /obj/item/reagent_containers/glass))
		if(locked)
			to_chat(user, SPAN_NOTICE("You cannot insert a beaker because the panel is locked."))
			return
		if(!isnull(reagent_glass))
			to_chat(user, SPAN_NOTICE("There is already a beaker loaded."))
			return

		user.drop_item()
		O.loc = src
		reagent_glass = O
		to_chat(user, SPAN_NOTICE("You insert 69O69."))
		return
	else
		..()

/mob/living/bot/medbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if ((href_list69"power"69) && access_scanner.allowed(usr))
		if (on)
			turn_off()
		else
			turn_on()

	else if((href_list69"adj_threshold"69) && (!locked || issilicon(usr)))
		var/adjust_num = text2num(href_list69"adj_threshold"69)
		heal_threshold += adjust_num
		if(heal_threshold < 5)
			heal_threshold = 5
		if(heal_threshold > 75)
			heal_threshold = 75

	else if((href_list69"adj_inject"69) && (!locked || issilicon(usr)))
		var/adjust_num = text2num(href_list69"adj_inject"69)
		injection_amount += adjust_num
		if(injection_amount < 5)
			injection_amount = 5
		if(injection_amount > 15)
			injection_amount = 15

	else if((href_list69"use_beaker"69) && (!locked || issilicon(usr)))
		use_beaker = !use_beaker

	else if (href_list69"eject"69 && (!isnull(reagent_glass)))
		if(!locked)
			reagent_glass.loc = get_turf(src)
			reagent_glass =69ull
		else
			to_chat(usr, SPAN_NOTICE("You cannot eject the beaker because the panel is locked."))

	else if ((href_list69"togglevoice"69) && (!locked || issilicon(usr)))
		vocal = !vocal

	else if ((href_list69"declaretreatment"69) && (!locked || issilicon(usr)))
		declare_treatment = !declare_treatment

	attack_hand(usr)
	return

/mob/living/bot/medbot/emag_act(var/remaining_uses,69ar/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, SPAN_WARNING("You short out 69src69's reagent synthesis circuits."))
		visible_message(SPAN_WARNING("69src69 buzzes oddly!"))
		playsound(loc, "robot_talk_light", 100, 0, 0)
		flick("medibot_spark", src)
		patient =69ull
		currently_healing = 0
		emagged = 1
		on = TRUE
		update_icons()
		. = 1
	ignored |= user

/mob/living/bot/medbot/explode()
	on = FALSE
	visible_message(SPAN_DANGER("69src69 blows apart!"))
	playsound(loc, "robot_talk_light", 100, 2, 0)
	var/turf/Tsec = get_turf(src)

	new /obj/item/storage/firstaid(Tsec)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/device/scanner/health(Tsec)
	if (prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	if(reagent_glass)
		reagent_glass.loc = Tsec
		reagent_glass =69ull

	var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/bot/medbot/proc/valid_healing_target(var/mob/living/carbon/human/H)
	if(H.stat == DEAD) // He's dead, Jim
		return69ull

	if(H in ignored)
		return69ull

	if(emagged)
		return treatment_emag

	// If they're injured, we're using a beaker, and they don't have on of the chems in the beaker
	if(reagent_glass && use_beaker && ((H.getBruteLoss() >= heal_threshold) || (H.getToxLoss() >= heal_threshold) || (H.getToxLoss() >= heal_threshold) || (H.getOxyLoss() >= (heal_threshold + 15))))
		for(var/datum/reagent/R in reagent_glass.reagents.reagent_list)
			if(!H.reagents.has_reagent(R))
				return 1
			continue

	if((H.getBruteLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_brute)))
		return treatment_brute //If they're already69edicated don't bother!

	if((H.getOxyLoss() >= (15 + heal_threshold)) && (!H.reagents.has_reagent(treatment_oxy)))
		return treatment_oxy

	if((H.getFireLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_fire)))
		return treatment_fire

	if((H.getToxLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_tox)))
		return treatment_tox

/* Construction */

/obj/item/storage/firstaid/attackby(var/obj/item/robot_parts/S,69ob/user as69ob)
	if ((!istype(S, /obj/item/robot_parts/l_arm)) && (!istype(S, /obj/item/robot_parts/r_arm)))
		..()
		return

	if(contents.len >= 1)
		to_chat(user, SPAN_NOTICE("You69eed to empty 69src69 out first."))
		return

	var/obj/item/firstaid_arm_assembly/A =69ew /obj/item/firstaid_arm_assembly
	if(istype(src, /obj/item/storage/firstaid/fire))
		A.skin = "ointment"
	else if(istype(src, /obj/item/storage/firstaid/toxin))
		A.skin = "tox"
	else if(istype(src, /obj/item/storage/firstaid/o2))
		A.skin = "o2"

	qdel(S)
	user.put_in_hands(A)
	to_chat(user, SPAN_NOTICE("You add the robot arm to the first aid kit."))
	playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
	user.drop_from_inventory(src)
	qdel(src)

/obj/item/firstaid_arm_assembly
	name = "first aid/robot arm assembly"
	desc = "A first aid kit with a robot arm permanently grafted to it."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "firstaid_arm"
	var/build_step = 0
	var/created_name = "Medibot" //To preserve the69ame if it's a unique69edbot I guess
	var/skin =69ull //Same as69edbot, set to tox or ointment for the respective kits.
	w_class = ITEM_SIZE_NORMAL

/obj/item/firstaid_arm_assembly/New()
	..()
	spawn(5) // Terrible. TODO: fix
		if(skin)
			overlays += image('icons/obj/aibots.dmi', "kit_skin_69src.skin69")

/obj/item/firstaid_arm_assembly/attackby(obj/item/W as obj,69ob/user as69ob)
	..()
	if(istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter69ew robot69ame",69ame, created_name),69AX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
	else
		switch(build_step)
			if(0)
				if(istype(W, /obj/item/device/scanner/health))
					user.drop_item()
					qdel(W)
					build_step++
					to_chat(user, SPAN_NOTICE("You add the health sensor to 69src69."))
					playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
					name = "First aid/robot arm/health analyzer assembly"
					overlays += image('icons/obj/aibots.dmi', "na_scanner")

			if(1)
				if(is_proximity_sensor(W))
					user.drop_item()
					qdel(W)
					to_chat(user, SPAN_NOTICE("You complete the69edibot! Beep boop."))
					playsound(src.loc, 'sound/effects/insert.ogg', 50, 1)
					var/turf/T = get_turf(src)
					var/mob/living/bot/medbot/S =69ew /mob/living/bot/medbot(T)
					S.skin = skin
					S.name = created_name
					user.drop_from_inventory(src)
					qdel(src)
