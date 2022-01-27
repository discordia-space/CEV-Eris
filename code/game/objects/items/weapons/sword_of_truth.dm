/obj/item/tool/sword/nt_sword
	name = "Sword of Truth"
	desc = "Sword69ade out of a unknown alloy, humming from an unknown power source."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "nt_sword_truth"
	item_state = "nt_sword_truth"
	slot_flags = FALSE
	origin_tech = list(TECH_COMBAT = 5, TECH_POWER = 4, TECH_MATERIAL = 8)
	aspects = list(SANCTIFIED)
	price_tag = 20000
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	force = WEAPON_FORCE_BRUTAL
	var/crusade_force = WEAPON_FORCE_NORMAL * 0.8
	var/flash_cooldown = 169INUTES
	var/last_use = 0

/obj/item/tool/sword/nt_sword/crusade_activated()
	. = ..()
	if(!.) return
	force += crusade_force

/obj/item/tool/sword/nt_sword/New()
	..()
	GLOB.all_faction_items69src69 = GLOB.department_church

/obj/item/tool/sword/nt_sword/Destroy()
	for(var/mob/living/carbon/human/H in69iewers(get_turf(src)))
		SEND_SIGNAL(H, COMSIG_OBJ_FACTION_ITEM_DESTROY, src)
	GLOB.all_faction_items -= src
	GLOB.neotheology_faction_item_loss++
	..()

/obj/item/tool/sword/nt_sword/attackby(obj/item/I,69ob/user, params)
	if(nt_sword_attack(I, user))
		return FALSE
	..()

/obj/item/tool/sword/nt_sword/wield(mob/living/user)
	..()
	set_light(l_range = 1.7, l_power = 1.3, l_color = COLOR_YELLOW)

/obj/item/tool/sword/nt_sword/unwield(mob/living/user)
	..()
	set_light(l_range = 0, l_power = 0, l_color = COLOR_YELLOW)

/obj/item/tool/sword/nt_sword/attack_self(mob/user)
	if(isBroken)
		to_chat(user, SPAN_WARNING("\The 69src69 is broken."))
		return
	if(!wielded)
		to_chat(user, SPAN_WARNING("You cannot use 69src69 special ability with one hand!"))
		return
	if(world.time <= last_use + flash_cooldown)
		to_chat(user, SPAN_WARNING("69src69 still charging!"))
		return
	if(!do_after(user, 2.5 SECONDS))
		to_chat(src, SPAN_DANGER("You was interrupted!"))
		return

	var/bang_text = pick("HOLY LIGHT!", "GOD HAVE69ERCY!", "HOLY HAVEN!", "YOU SEE THE LIGHT!")

	for(var/obj/structure/closet/L in hear(7, get_turf(src)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				var/obj/item/implant/core_implant/I =69.get_core_implant(/obj/item/implant/core_implant/cruciform)
				if(I && I.active && I.wearer)
					continue
				M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
				M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
				M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
				M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
				M.stats.addTempStat(STAT_COG, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
				M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
				flashbang_bang(get_turf(src),69, bang_text, FALSE)


	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		var/obj/item/implant/core_implant/I =69.get_core_implant(/obj/item/implant/core_implant/cruciform)
		if(I && I.active && I.wearer)
			continue
		M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
		M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
		M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
		M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
		M.stats.addTempStat(STAT_COG, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
		M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_ADEPT, 45 SECONDS, "Sword of truth")
		flashbang_bang(get_turf(src),69, bang_text, FALSE)

	for(var/obj/effect/blob/B in hear(8,get_turf(src)))       		//Blob damage here
		var/damage = round(30/(get_dist(B,get_turf(src))+1))
		B.health -= damage
		B.update_icon()

	new/obj/effect/sparks(loc)
	new/obj/effect/effect/smoke/illumination(loc, brightness=15)
	last_use = world.time
	return

/obj/item/tool/sword/nt_sword/e69uipped(mob/living/M)
	. = ..()
	if(is_held() && is_neotheology_disciple(M))
		embed_mult = 0.1
	else
		embed_mult = initial(embed_mult)

/obj/structure/nt_pedestal
	name = "Sword of Truth Pedestal"
	desc = "A pedestal for a glorious weapon named the: \"Sword of Truth\"."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "nt_pedestal0"
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	anchored = TRUE
	density = TRUE
	breakable = FALSE
	var/obj/item/tool/sword/nt_sword/sword

/obj/structure/nt_pedestal/New(var/loc,69ar/turf/anchor)
	..()
	sword = new /obj/item/tool/sword/nt_sword(src)
	update_icon()

/obj/structure/nt_pedestal/attackby(obj/item/I,69ob/user)
	if(I.has_69uality(69UALITY_BOLT_TURNING))
		if(!anchored)
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You've secured the 69src69 assembly!"))
				anchored = TRUE
		else if(anchored)
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You've unsecured the 69src69 assembly!"))
				anchored = FALSE
	if(istype(I, /obj/item/tool/sword/nt_sword))
		if(sword)
			to_chat(user, SPAN_WARNING("69src69 already has a sword in it!"))
		insert_item(I, user)
		sword = I
		update_icon()
		visible_message(SPAN_NOTICE("69user69 placed 69sword69 into 69src69."))

/obj/structure/nt_pedestal/attack_hand(mob/user)
	..()
	if(sword && istype(user, /mob/living/carbon))
		var/mob/living/carbon/H = user
		var/obj/item/implant/core_implant/I = H.get_core_implant(/obj/item/implant/core_implant/cruciform)
		if(I && I.active && I.wearer)
			H.put_in_hands(sword)
			visible_message(SPAN_NOTICE("69user69 removed 69sword69 from the 69src69."))
			sword = null
			update_icon()
			return

		visible_message(SPAN_WARNING("69user69 is trying to remove 69sword69 from the 69src69!"))
		if(!do_after(user, 30 SECONDS))
			to_chat(src, SPAN_DANGER("You were interrupted!"))
			return
		if(H.stats.getStat(STAT_ROB) >= 60)
			H.put_in_hands(sword)
			visible_message(SPAN_DANGER("69user69 succsesufully removed 69sword69 from the 69src69!"))
			sword = null
			update_icon()
		else
			visible_message(SPAN_WARNING("69user69 failed to remove 69sword69 from the 69src69"))

/obj/structure/nt_pedestal/update_icon()
	icon_state = "nt_pedestal69sword?"1":"0"69"
