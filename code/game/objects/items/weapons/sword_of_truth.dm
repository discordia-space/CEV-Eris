/obj/item/weapon/tool/sword/nt_sword
	name = "Sword of Truth"
	desc = "Sword out of unknown alloy, humming from unknown power source."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "nt_sword"
	item_state = "nt_sword"
	slot_flags = FALSE
	origin_tech = list(TECH_COMBAT = 5, TECH_POWER = 4, TECH_MATERIAL = 8)
	price_tag = 20000
	var/flash_cooldown = 1 MINUTES
	var/last_use = 0

/obj/item/weapon/tool/sword/nt_sword/wield(mob/living/user)
	..()
	set_light(l_range = 1.7, l_power = 1.3, l_color = COLOR_YELLOW)

/obj/item/weapon/tool/sword/nt_sword/unwield(mob/living/user)
	..()
	set_light(l_range = 0, l_power = 0, l_color = COLOR_YELLOW)

/obj/item/weapon/tool/sword/nt_sword/attack_self(mob/user)
	if(isBroken)
		to_chat(user, SPAN_WARNING("\The [src] is broken."))
		return
	if(!wielded)
		to_chat(user, SPAN_WARNING("You cannot use [src] special ability with one hand!"))
		return
	if(world.time <= last_use + flash_cooldown)
		to_chat(user, SPAN_WARNING("[src] still charging!"))
		return
	if(!do_after(user, 2.5 SECONDS))
		to_chat(src, SPAN_DANGER("You was interrupted!"))
		return

	for(var/obj/structure/closet/L in hear(7, get_turf(src)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				var/obj/item/weapon/implant/core_implant/I = M.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform)
				if(I && I.active && I.wearer)
					continue
				bang(get_turf(src), M)


	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		var/obj/item/weapon/implant/core_implant/I = M.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform)
		if(I && I.active && I.wearer)
			continue
		bang(get_turf(src), M)

	for(var/obj/effect/blob/B in hear(8,get_turf(src)))       		//Blob damage here
		var/damage = round(30/(get_dist(B,get_turf(src))+1))
		B.health -= damage
		B.update_icon()

	new/obj/effect/sparks(loc)
	new/obj/effect/effect/smoke/illumination(loc, brightness=15)
	last_use = world.time
	return

/obj/item/weapon/tool/sword/nt_sword/proc/bang(var/turf/T , var/mob/living/carbon/M)					// Added a new proc called 'bang' that takes a location and a person to be banged.
	to_chat(M, SPAN_DANGER(pick("HOLY LIGHT!", "GOD HAVE MERCY!", "HOLY HAVEN!", "YOU SEE THE LIGHT!")))								// Called during the loop that bangs people in lockers/containers and when banging
	playsound(loc, 'sound/effects/bang.ogg', 50, 1, 5)		// people in normal view.  Could theroetically be called during other explosions.
																// -- Polymorph

//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		if(ishuman(M))
			if(istype(M:l_ear, /obj/item/clothing/ears/earmuffs) || istype(M:r_ear, /obj/item/clothing/ears/earmuffs))
				ear_safety += 2
			if(HULK in M.mutations)
				ear_safety += 1
			if(istype(M:head, /obj/item/clothing/head/armor/helmet))
				ear_safety += 1

//Flashing everyone
	if(eye_safety < FLASH_PROTECTION_MODERATE)
		if (M.HUDtech.Find("flash"))
			flick("e_flash", M.HUDtech["flash"])
		M.Stun(2)
		M.Weaken(10)



//Now applying sound
	if((get_dist(M, T) <= 2 || loc == M.loc || loc == M))
		if(ear_safety > 0)
			M.Stun(2)
			M.Weaken(1)
		else
			M.Stun(10)
			M.Weaken(3)
			if ((prob(14) || (M == loc && prob(70))))
				M.ear_damage += rand(1, 10)
			else
				M.ear_damage += rand(0, 5)
				M.ear_deaf = max(M.ear_deaf,15)

	else if(get_dist(M, T) <= 5)
		if(!ear_safety)
			M.Stun(8)
			M.ear_damage += rand(0, 3)
			M.ear_deaf = max(M.ear_deaf,10)

	else if(!ear_safety)
		M.Stun(4)
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

	//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, SPAN_DANGER("Your eyes start to burn badly!"))
	if (M.ear_damage >= 15)
		to_chat(M, SPAN_DANGER("Your ears start to ring badly!"))
	else
		if (M.ear_damage >= 5)
			to_chat(M, SPAN_DANGER("Your ears start to ring!"))
	M.update_icons()

/obj/structure/nt_pedestal
	name = "Sword of Truth Pedestal"
	desc = "Pedestal of glorious weapon named: \"Sword of Truth\"."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "nt_pedestal0"
	anchored = TRUE
	density = TRUE
	breakable = FALSE
	var/obj/item/weapon/tool/sword/nt_sword/sword = null

/obj/structure/nt_pedestal/New(var/loc, var/turf/anchor)
	..()
	sword = new /obj/item/weapon/tool/sword/nt_sword(src)
	update_icon()

/obj/structure/nt_pedestal/attackby(obj/item/I, mob/user)
	if(I.has_quality(QUALITY_BOLT_TURNING))
		if(!anchored)
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You've secured the [src] assembly!"))
				anchored = TRUE
		else if(anchored)
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You've unsecured the [src] assembly!"))
				anchored = FALSE
	if(istype(I, /obj/item/weapon/tool/sword/nt_sword))
		if(sword)
			to_chat(user, SPAN_WARNING("[src] already has a sword in it!"))
		insert_item(I, user)
		sword = I
		update_icon()
		visible_message(SPAN_NOTICE("[user] placed [sword] into [src]."))

/obj/structure/nt_pedestal/attack_hand(mob/user)
	..()
	if(sword && istype(user, /mob/living/carbon))
		var/mob/living/carbon/H = user
		var/obj/item/weapon/implant/core_implant/I = H.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform)
		if(I && I.active && I.wearer)
			H.put_in_hands(sword)
			visible_message(SPAN_NOTICE("[user] removed [sword] from the [src]."))
			sword = null
			update_icon()
			return

		visible_message(SPAN_WARNING("[user] is trying to remove [sword] from the [src]!"))
		if(!do_after(user, 30 SECONDS))
			to_chat(src, SPAN_DANGER("You were interrupted!"))
			return
		if(H.stats.getStat(STAT_ROB) >= 60)
			H.put_in_hands(sword)
			visible_message(SPAN_DANGER("[user] succsesufully removed [sword] from the [src]!"))
			sword = null
			update_icon()
		else
			visible_message(SPAN_WARNING("[user] failed to remove [sword] from the [src]"))

/obj/structure/nt_pedestal/update_icon()
	icon_state = "nt_pedestal[sword?"1":"0"]"

/obj/item/weapon/storage/pouch/nt_sheath
	name = "Sword of Truth sheath"
	desc = "Can hold a Sword of Truth."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "nt_sheath0"
	item_state = "nt_sheath0"
	slot_flags = SLOT_BELT
	price_tag = 1000
	storage_slots = 1
	max_w_class = ITEM_SIZE_BULKY

	can_hold = list(
		/obj/item/weapon/tool/sword/nt_sword
		)

	sliding_behavior = TRUE

/obj/item/weapon/storage/pouch/nt_sheath/update_icon()
	icon_state = "nt_sheath[contents.len?"1":"0"]"
	item_state = "nt_sheath[contents.len?"1":"0"]"
	..()
