/obj/item/implant/explosive
	name = "explosive implant"
	desc = "A military grade micro bio-explosive. Highly dangerous."
	var/death_react = "Safe Hand"
	var/explosion_delay = 70
	var/removal_authorized = FALSE
	var/phrase = "supercalifragilisticexpialidocious"
	icon_state = "implant_explosive"
	implant_overlay = "implantstorage_explosive"
	is_legal = FALSE
	origin_tech = list(TECH_MATERIAL=2, TECH_COMBAT=3, TECH_BIO=4, TECH_COVERT=4)

/obj/item/implant/explosive/New()
	..()
	add_hearing()
	update_icon()

/obj/item/implant/explosive/Destroy()
	remove_hearing()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/implant/explosive/get_data()
	var/data = {"
		<b>Implant Specifications:</b><BR>
		<b>Name:</b> Robust Corp RX-78 Intimidation Class Implant<BR>
		<b>Life:</b> Activates upon codephrase.<BR>
		<b>Important Notes:</b> Explodes<BR>
		<HR>
		<b>Implant Details:</b><BR>
		<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
		<b>Special Features:</b> Explodes<BR>
		<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	return data

/obj/item/implant/explosive/hear_talk(mob/M, msg, verb, datum/language/speaking, speech_volume)
	hear(msg)

/obj/item/implant/explosive/hear(var/msg)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	msg = replace_characters(msg, replacechars)
	if(findtext(msg,phrase))
		activate()
		qdel(src)

/obj/item/implant/explosive/proc/do_boom()
	playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
	sleep(25)
	explosion(get_turf(src), 400, 75)
	qdel(src)

/obj/item/implant/explosive/activate(delay)
	if (malfunction == MALFUNCTION_PERMANENT)
		return

	STOP_PROCESSING(SSobj, src)
	sleep(delay)

	if(istype(wearer, /mob/))
		var/mob/T = wearer
		message_admins("Explosive implant triggered in [T] ([T.key]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>) ")
		log_game("Explosive implant triggered in [T] ([T.key]).")

		if(ishuman(wearer))
			if(part)
				wearer.visible_message("<span class='warning'>Something beeps inside [wearer][part ? "'s [part.name]" : ""]!</span>")
				playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
				sleep(25)
				if (part.organ_tag in list(BP_CHEST, BP_HEAD, BP_GROIN))
					part.createwound(BRUISE, 60)
					explosion(get_turf(src), 400, 75)
					qdel(src)
				else
					explosion(get_turf(src), 400, 75)
					part.droplimb(0,DROPLIMB_BLUNT)
					qdel(src)

		else
			do_boom()
	else
		do_boom()

	var/turf/t = get_turf(wearer)

	if(t)
		t.hotspot_expose(3500,125)

/obj/item/implant/explosive/on_uninstall()
	if(!istype(wearer) || !wearer.mind)
		return
	if(removal_authorized)
		wearer.visible_message(SPAN_DANGER("\The [src] rips through \the [wearer]'s [part.name]!"))
		part.take_damage(rand(20,40))
		removal_authorized = FALSE
	else
		wearer.visible_message(SPAN_DANGER("As \the [src] is removed from \the [wearer]..."))
		if(prob(66))
			wearer.visible_message(SPAN_DANGER("\The [wearer]'s [part.name] violently explodes from within!"))
			wearer.adjustBrainLoss(200)
			part.droplimb(FALSE, DROPLIMB_BLUNT)
		else
			wearer.visible_message(SPAN_NOTICE("Something fizzles in \the [wearer]'s [part.name], but nothing interesting happens."))

/obj/item/implant/explosive/proc/configure()
	death_react = alert("Should implant be activated on user's death?", "Implant Intent", "Safe Hand", "Dead Hand")
	phrase = input("Choose activation phrase:") as text
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	phrase = replace_characters(phrase, replacechars)
	STOP_PROCESSING(SSobj, src)

	if (death_react == "Dead Hand")
		explosion_delay = (input("Set detonation delay in seconds:") as num) * 10
		START_PROCESSING(SSobj, src)

/obj/item/implant/explosive/Process()
	if (!implanted)
		STOP_PROCESSING(SSobj, src)
		return

	if(isnull(wearer))
		activate()

	else if(wearer.stat == DEAD)
		activate(explosion_delay)

/obj/item/implant/explosive/malfunction(severity)
	if (malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY
	switch (severity)
		if (2)
			if (prob(15))
				activate()
		if (1)
			if (prob(50))
				activate()
			else
				meltdown()
	spawn (20)
		malfunction = MALFUNCTION_NONE


/obj/item/implantcase/explosive
	name = "glass case - 'explosive'"
	desc = "A case containing an explosive implant."
	implant = /obj/item/implant/explosive


/obj/item/implanter/explosive
	name = "implanter (E)"
	implant = /obj/item/implant/explosive
	spawn_tags = null
