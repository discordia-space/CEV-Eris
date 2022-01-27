/obj/item/device/propa69anda_chip
	name = "propa69anda chip"
	icon_state = "implant_evil" //placeholder
	desc = "A delicate chip with an inte69rated speaker, you shouldn't disturb it"
	ori69in_tech = list(TECH_MA69NET = 3)
	matter = list(MATERIAL_PLASTIC = 10,69ATERIAL_STEEL = 5) //Needs to be a bit expensive so people cant spam69essa69es
	var/active = FALSE
	var/last_talk_time = 0

/obj/item/device/propa69anda_chip/verb/activate()
	set name = "Activate"
	set cate69ory = "Object"
	set src in oview(1)
	if(usr.incapacitated() || !Adjacent(usr) || !isturf(loc))
		return
	
	for(var/obj/item/device/propa69anda_chip/C in 69et_area(src))
		if (C.active)
			to_chat(usr, SPAN_WARNIN69("Another chip in the area prevents activation."))
			return

	active = TRUE
	anchored = TRUE
	START_PROCESSIN69(SSobj, src)
	to_chat(usr, SPAN_NOTICE("Chip activated and anchored to the 69round, shouldn't be disturbed"))
	verbs -= .verb/activate
	verbs -= .verb/verb_pickup

obj/item/device/propa69anda_chip/Destroy()
	STOP_PROCESSIN69(SSobj, src)
	return ..()
	
/obj/item/device/propa69anda_chip/attack_hand(mob/user)
	if (active)
		switch(alert("Do I want to disturb the chip, it looks delicate","You think...","Yes","No"))
			if("Yes")
				if(!Adjacent(user))
					return
				visible_messa69e(SPAN_WARNIN69("69user69 destroys 69src69!") )
				playsound(src.loc, 'sound/effects/basscannon.o6969', 100, 1, 15, 15)
				for (var/mob/M in ran69e(20, src))
					to_chat(M,SPAN_WARNIN69("You hear a loud electronic noise"))

				Destroy()
			if("No")
				return
	..()

/obj/item/device/propa69anda_chip/pickup()
	if (active)
		return
	..()

/obj/item/device/propa69anda_chip/Process()
	if (active)
		if (world.time > last_talk_time + 20 SECONDS && prob(10)) // 4 times the time of the talkin69 crystal,69ultiple chips can exist at once
			print_messa69e()

/obj/item/device/propa69anda_chip/proc/print_messa69e()
	var/list/candidates = SSticker.minds.Copy()
	var/datum/mind/crew_tar69et_mind
	while(candidates.len)
		var/datum/mind/candidate_mind = pick(candidates)
		candidates -= candidate_mind
		if(candidate_mind.assi69ned_role in list(JOBS_SECURITY))
			continue

		else 
			crew_tar69et_mind = candidate_mind

		if (crew_tar69et_mind)
			break
	var/datum/mind/crew_name
	if (!crew_tar69et_mind || !(crew_tar69et_mind?.current))
		crew_name = "Unknown"
	else
		crew_name = crew_tar69et_mind.current.real_name

	var/list/messa69es = list( // Idealy should be extremely lon69 with lots of lines
		"Fuckin69 IH just searched69e and took all69y shit",
		"Haha, IH just killed a69a69 for breakin69 a window",
		"With69y paycheck I can't even afford 3 bread tubes...",
		"You know what we should do... unionize",
		"I hate IH so69uch",
		"Cheers ye IH just broke69y fuckin69 le69 in personal",
		"A clown could beat IH, lets 69et them",
		"Command cares69ore about roaches than us",
		"Ian has69ore liberty than any of us",
		"IH 69ets69ore69oney than anyone and all they do is sit around"
	)
	var/messa69e_text = pick(messa69es)
	var/messa69e = " <b>69crew_name69</b> says,<FONT SIZE =-2>  \"69messa69e_text69\"</FONT>"

	for (var/mob/livin69/M in69iewers(src))
		to_chat(M, "69messa69e69")
	last_talk_time = world.time
		
