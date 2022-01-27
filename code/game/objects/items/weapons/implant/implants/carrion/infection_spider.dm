/obj/item/implant/carrion_spider/infection
	name = "infection spider"
	icon_state = "spiderling_infection"
	spider_price = 50
	gene_price = 7
	var/active = FALSE

/obj/item/implant/carrion_spider/infection/activate()
	..()
	if(!wearer)
		to_chat(owner_mob, SPAN_WARNING("69src69 doesn't have a host"))
		return
	if(!istype(wearer)) //wearer type is automaticaly set to human
		to_chat(owner_mob, SPAN_WARNING("69src69 only works on humanoids"))
		return
	if(wearer.stat == DEAD)
		to_chat(owner_mob, SPAN_WARNING("69wearer69 is dead"))
		return
	if(is_neotheology_disciple(wearer))
		to_chat(owner_mob, SPAN_WARNING("69wearer69's cruciform prevents activation"))
		return
	var/obj/item/organ/external/affected = wearer.organs_by_name69BP_HEAD || BP_CHEST69
	if(BP_IS_ROBOTIC(affected))
		to_chat(owner_mob, SPAN_WARNING("69src69 cannot be activated in a prosthetic limb."))
		return

	if(is_carrion(wearer))
		to_chat(owner_mob, SPAN_WARNING("Another core inside prevents activation"))
		return

	if(active)
		to_chat(owner_mob, SPAN_WARNING("69src69 is already active"))
		return

	active = TRUE
	to_chat(owner_mob, SPAN_NOTICE("\The 69src69 is active"))

	spawn(569INUTES)
		if(wearer && istype(wearer) && !(wearer.stat == DEAD) && !is_neotheology_disciple(wearer) && active && !is_carrion(wearer))
			to_chat(wearer, SPAN_DANGER("The transformation is complete, you are not human anymore, you are something69ore"))
			to_chat(owner_mob, SPAN_NOTICE("\The 69src69 was succesfull"))
			wearer.make_carrion()
			die()
		else
			active = FALSE
			to_chat(owner_mob, SPAN_WARNING("Conversion failed."))

/obj/item/implant/carrion_spider/infection/Process()
	..()
	if(wearer && active)
		if(prob(15)) //around 2269essages over 569inutes on avarage
			var/pain_message = pick(list(
				"You feel a sharp pain in your upper body!",
				"You feel something s69uirm in your upper body!",
				"You feel immense agony pulsating through your body!",
				"You feel like something is69oving inside your body!",
				"You feel intense pain!",
				"You feel like something is taking control of you!",
				"You feel weak, like something is growing inside of your body!"
			))
			wearer.adjustHalLoss(10) //Flat 10 agony damage
			to_chat(wearer, "\red <font size=3><b>69pain_message69</b></font>")
		if(prob(1)) //around 0.75 limbs per transformation
			if(prob(50))
				var/obj/item/organ/external/E = wearer.get_organ(pick(list(BP_L_ARM, BP_L_LEG, BP_R_ARM, BP_R_LEG)))
				if(E)
					E.droplimb(FALSE, DROPLIMB_BLUNT)
				else
					visible_message(SPAN_DANGER("A69eaty spike shoots out of 69wearer69's limb stump"))
