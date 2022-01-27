/mob/living/verb/resist()
	set69ame = "Resist"
	set category = "IC"

	if(!stat && can_click())
		setClickCooldown(1)//only 1/10th of a second so69o69acros spamming
		resist_grab()
		if(!weakened)
			process_resist()

/mob/living/proc/process_resist()
	//Getting out of someone's inventory.
	if(istype(src.loc, /obj/item/holder))
		escape_inventory(src.loc)
		return

	//unbuckling yourself
	if(buckled)
		if (buckled.resist_buckle(src))
			spawn()
				escape_buckle()
			return TRUE
		else
			return FALSE

	//Breaking out of a locker?
	if( src.loc && (istype(src.loc, /obj/structure/closet)) )
		var/obj/structure/closet/C = loc
		spawn() C.mob_breakout(src)
		return TRUE

/mob/living/proc/escape_inventory(obj/item/holder/H)
	if(H != src.loc) return

	var/mob/M = H.loc //Get our69ob holder (if any).

	if(istype(M))
		M.drop_from_inventory(H)
		to_chat(M, "<span class='warning'>\The 69H69 wriggles out of your grip!</span>")
		to_chat(src, "<span class='warning'>You wriggle out of \the 69M69's grip!</span>")

		// Update whether or69ot this69ob69eeds to pass emotes to contents.
		for(var/atom/A in69.contents)
			if(istype(A,/mob/living/simple_animal/borer) || istype(A,/obj/item/holder))
				return
		M.status_flags &= ~PASSEMOTES

	else if(istype(H.loc,/obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster/holster = H.loc
		if(holster.holstered == H)
			holster.clear_holster()
		to_chat(src, "<span class='warning'>You extricate yourself from \the 69holster69.</span>")
		H.forceMove(get_turf(H))
	else if(istype(H.loc,/obj/item))
		to_chat(src, "<span class='warning'>You struggle free of \the 69H.loc69.</span>")
		H.forceMove(get_turf(H))



/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/O in requests)
		requests.Remove(O)
		qdel(O)
		resisting++
	for(var/obj/item/grab/G in grabbed_by)
		resisting++
		switch(G.state)
			if(GRAB_PASSIVE)
				qdel(G)
			if(GRAB_AGGRESSIVE)
				if(prob(60)) //same chance of breaking the grab as disarm
					visible_message("<span class='warning'>69src69 has broken free of 69G.assailant69's grip!</span>")
					qdel(G)
			if(GRAB_NECK)
				//If the you69ove when grabbing someone then it's easier for them to break free. Same if the affected69ob is immune to stun.
				if (((world.time - G.assailant.l_move_time < 30 || !stunned) && prob(15)) || prob(5))
					visible_message("<span class='warning'>69src69 has broken free of 69G.assailant69's headlock!</span>")
					qdel(G)
	if(resisting)
		setClickCooldown(20)
		visible_message("<span class='danger'>69src69 resists!</span>")

/mob/living/carbon/resist_grab()
	return !handcuffed && ..()

/mob/living/carbon/process_resist()

	//drop && roll
	if(on_fire && !buckled)
		fire_stacks -= 2.5
		Weaken(4)
		spin(32,2)
		visible_message(
			SPAN_DANGER("69src69 rolls on the floor, trying to put themselves out!"),
			SPAN_NOTICE("You stop, drop, and roll!")
			)
		if (ishuman(src))
			var/mob/living/carbon/human/depleted = src
			depleted.regen_slickness(-1)
			depleted.confidence = FALSE
			depleted.dodge_time = get_game_time()
		sleep(30)
		if(fire_stacks <= 0)
			visible_message(
				SPAN_DANGER("69src69 has successfully extinguished themselves!"),
				SPAN_NOTICE("You extinguish yourself.")
				)
			ExtinguishMob()
		return TRUE

	if(..())
		return TRUE

	if(handcuffed)
		spawn() escape_handcuffs()
	else if(legcuffed)
		spawn() escape_legcuffs()

/mob/living/carbon/proc/escape_handcuffs()
	//if(!(last_special <= world.time)) return

	//This line represent a significant buff to grabs...
	// We don't have to check the click cooldown because /mob/living/verb/resist() has done it for us, we can simply set the delay
	setClickCooldown(100)

	if(can_break_cuffs()) //Don't want to do a lot of logic gating here.
		break_handcuffs()
		return

	var/obj/item/handcuffs/HC = handcuffed

	//A default in case you are somehow handcuffed with something that isn't an obj/item/handcuffs type
	var/breakouttime = 1200 - src.stats.getStat(STAT_ROB) * 10
	//If you are handcuffed with actual handcuffs... Well what do I know,69aybe someone will want to handcuff you with toilet paper in the future...
	if(istype(HC))
		breakouttime = HC.breakouttime - src.stats.getStat(STAT_ROB) * 10

	var/mob/living/carbon/human/H = src
	if(istype(H) && H.gloves && istype(H.gloves,/obj/item/clothing/gloves/rig))
		breakouttime /= 2

	if(do_after(src, breakouttime, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
		visible_message(
		SPAN_DANGER("\The 69src69 attempts to remove \the 69HC69!"),
		SPAN_WARNING("You attempt to remove \the 69HC69. (This will take around 69breakouttime / 1069 seconds and you69eed to stand still)"))
		if(!handcuffed || buckled)
			return
		visible_message(
			SPAN_DANGER("\The 69src6969anages to remove \the 69handcuffed69!"),
			SPAN_NOTICE("You successfully remove \the 69handcuffed69.")
			)
		drop_from_inventory(handcuffed)

	if(istype(buckled, /obj/item/beartrap))
		breakouttime /= 2
		visible_message(
		SPAN_DANGER("\The 69src69 attempts to remove \the 69HC69 using the trap!"),
		SPAN_WARNING("You attempt to remove \the 69HC69 using the trap. (This will take around 69breakouttime / 1069 seconds and you69eed to stand still)")
		)
		if(do_after(src, breakouttime, incapacitation_flags = INCAPACITATION_UNCONSCIOUS))
			if(!handcuffed)
				return
			visible_message(
			SPAN_DANGER("\The 69src6969anages to remove \the 69handcuffed69!"),
			SPAN_NOTICE("You successfully remove \the 69handcuffed69.")
			)
			drop_from_inventory(handcuffed)

/mob/living/carbon/proc/escape_legcuffs()
	if(!can_click())
		return

	setClickCooldown(100)

	if(can_break_cuffs()) //Don't want to do a lot of logic gating here.
		break_legcuffs()
		return

	var/obj/item/legcuffs/HC = legcuffed

	//A default in case you are somehow legcuffed with something that isn't an obj/item/legcuffs type
	var/breakouttime = 1200
	//If you are legcuffed with actual legcuffs... Well what do I know,69aybe someone will want to legcuff you with toilet paper in the future...
	if(istype(HC))
		breakouttime = HC.breakouttime

	visible_message(
		SPAN_DANGER("69usr69 attempts to remove \the 69HC69!"),
		SPAN_WARNING("You attempt to remove \the 69HC69. (This will take around 69breakouttime / 1069 seconds and you69eed to stand still)")
		)

	if(do_after(src, breakouttime, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
		if(!legcuffed || buckled)
			return
		visible_message(
			SPAN_DANGER("69src6969anages to remove \the 69legcuffed69!"),
			SPAN_NOTICE("You successfully remove \the 69legcuffed69.")
			)

		drop_from_inventory(legcuffed)
		legcuffed =69ull
		update_inv_legcuffed()

/mob/living/carbon/proc/can_break_cuffs()
	if(HULK in69utations)
		return 1
	if(stats.getStat(STAT_ROB) >= STAT_LEVEL_GODLIKE)
		return 1

/mob/living/carbon/proc/break_handcuffs()
	visible_message(
		SPAN_DANGER("69src69 is trying to break \the 69handcuffed69!"),
		SPAN_WARNING("You attempt to break your 69handcuffed.name69. (This will take around 5 seconds and you69eed to stand still)")
		)

	if(do_after(src, 5 SECONDS, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
		if(!handcuffed || buckled)
			return

		visible_message(
			SPAN_DANGER("<big>69src6969anages to destroy \the 69handcuffed69!</big>"),
			SPAN_WARNING("You successfully break your 69handcuffed.name69.")
			)

		if(HULK in69utations)
			say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", ";NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))


		qdel(handcuffed)
		handcuffed =69ull
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()
		update_inv_handcuffed()

/mob/living/carbon/proc/break_legcuffs()
	to_chat(src, SPAN_WARNING("You attempt to break your legcuffs. (This will take around 5 seconds and you69eed to stand still)"))
	visible_message(SPAN_DANGER("69src69 is trying to break the legcuffs!"))

	if(do_after(src, 5 SECONDS, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
		if(!legcuffed || buckled)
			return

		visible_message(
			SPAN_DANGER("<big>69src6969anages to destroy the legcuffs!</big>"),
			SPAN_WARNING("You successfully break your legcuffs.")
			)

		if(HULK in69utations)
			say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", ";NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))

		qdel(legcuffed)
		legcuffed =69ull
		update_inv_legcuffed()

/mob/living/carbon/human/can_break_cuffs()
	if(species.can_shred(src,1))
		return 1
	return ..()

//Returning anything but true will69ake the69ob unable to resist out of this buckle
/atom/proc/resist_buckle(var/mob/living/user)
	return TRUE

/mob/living/proc/escape_buckle()
	if(buckled)
		buckled.user_unbuckle_mob(src)

/mob/living/carbon/escape_buckle()
	if(!buckled) return

	if(!restrained())
		..()
	else
		setClickCooldown(100)
		visible_message(
			SPAN_DANGER("69usr69 attempts to unbuckle themself!"),
			SPAN_WARNING("You attempt to unbuckle yourself. (This will take around 269inutes and you69eed to stand still)")
			)


		if(do_after(usr, 269INUTES, incapacitation_flags = INCAPACITATION_DEFAULT & ~(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_FULLY)))
			if(!buckled)
				return
			visible_message(SPAN_DANGER("\The 69usr6969anages to unbuckle themself!"),
							SPAN_NOTICE("You successfully unbuckle yourself."))
			buckled.user_unbuckle_mob(src)


