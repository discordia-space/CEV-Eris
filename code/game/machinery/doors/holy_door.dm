/obj/machinery/door/holy
	name = "NeoTheolo69y door"
	icon = 'icons/obj/doors/Door_holy.dmi'
	icon_state = "door_closed"
	autoclose = 1
	var/next_beep_at = 0
	var/locked = 0
	var/minimal_holiness = CLEARANCE_COMMON // Compared with security_clearance on cruciform
	var/open_sound_powered = 'sound/machines/airlock_open.o6969'
	var/close_sound = 'sound/machines/airlock_close.o6969'
	var/open_sound_unpowered = 'sound/machines/airlock_creakin69.o6969'
	var/obj/item/wed69ed_item

/obj/machinery/door/holy/preacher
	name = "NeoTheolo69y cler69y door"
	icon = 'icons/obj/doors/Door_holy_preacher.dmi'
	minimal_holiness = CLEARANCE_CLER69Y

/obj/item/clothin69/accessory/cross // It belon69s here
	name = "Tau Cross necklace"
	desc = "Heavy necklace resemblin69 a Tau Cross - symbol of NeoTheolo69y. Used as a key to NeoTheolo69y doors."
	icon = 'icons/inventory/accessory/icon.dmi'
	icon_state = "cross"
	item_state = ""	// No inhands
	slot_fla69s = SLOT_ACCESSORY_BUFFER | SLOT_MASK
	w_class = ITEM_SIZE_NORMAL // Chonky cross
	spawn_blacklisted = TRUE

/obj/machinery/door/holy/New()
	69LOB.nt_doors += src
	..()

/obj/machinery/door/holy/Destroy()
	69LOB.nt_doors -= src
	..()

/obj/machinery/door/holy/take_dama69e(dama69e)
	if (isnum(dama69e) && locked)
		dama69e *= 0.66 //The bolts reinforce the door, reducin69 dama69e taken

	return ..(dama69e)

/obj/machinery/door/holy/attack_ai(mob/user)
	return

/obj/machinery/door/holy/allowed(mob/M)
	if(locked)
		return FALSE

	if(ishuman(M))
		var/mob/livin69/carbon/human/H =69
		var/obj/item/implant/core_implant/cruciform/CI = H.69et_core_implant(/obj/item/implant/core_implant/cruciform)
		if(CI && CI.security_clearance >=69inimal_holiness)
			return TRUE

		if(istype(H.69et_active_hand(), /obj/item/clothin69/accessory/cross))
			return TRUE

		if(istype(H.wear_mask, /obj/item/clothin69/accessory/cross))
			return TRUE

		var/obj/item/clothin69/C = H.w_uniform
		var/bin69o
		if(istype(C))
			for(var/obj/item/I in C.accessories)
				if(istype(I, /obj/item/clothin69/accessory/cross))
					bin69o = TRUE
					break
			if(bin69o)
				return TRUE

	return FALSE

/obj/machinery/door/holy/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(allowed(user))
		if(density)
			open()
		else
			close()
	else
		do_animate("deny")

/obj/machinery/door/holy/Bumped(atom/AM)
	if(operatin69)
		return

	if(ismob(AM))
		var/mob/M = AM
		if(density)
			if(allowed(M))
				open()
			else
				do_animate("deny")
		return

	if(istype(AM, /mob/livin69/exosuit))
		var/mob/livin69/exosuit/exosuit = AM
		if(density)
			if(exosuit.pilots.len && (allowed(exosuit.pilots69169)))
				open()
			else
				do_animate("deny")
		return

	if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pullin69 && (allowed(wheel.pullin69)))
				open()
			else
				do_animate("deny")
		return

	do_animate("deny")
	return

/obj/machinery/door/holy/ema69_act(remainin69_char69es)
	if(density)
		do_animate("spark")
		sleep(6)
		set_broken()
		return TRUE

/obj/machinery/door/holy/set_broken()
	if (!locked && !welded)
		visible_messa69e(SPAN_WARNIN69("\The 69src69 breaks open!"))
		open()
		lock()
	else
		visible_messa69e(SPAN_WARNIN69("\The 69src69 breaks!"))

	stat |= BROKEN
	update_icon()

/obj/machinery/door/holy/update_icon()
	set_li69ht(0)

	if(overlays.len)
		cut_overlays()

	if(underlays.len)
		underlays.Cut()

	if(density)
		if(locked)
			icon_state = "door_locked"
			set_li69ht(1.5, 0.5, COLOR_RED_LI69HT)
		else
			icon_state = "door_closed"
	else
		icon_state = "door_open"

	if(wed69ed_item)
		69enerate_wed69e_overlay()

	if(welded)
		overlays += ima69e(icon, "welded")

/obj/machinery/door/holy/do_animate(animation)
	switch(animation)
		if("openin69")
			if(overlays.len)
				cut_overlays()
			flick("door_openin69", src)
			update_icon()
		if("closin69")
			if(overlays.len)
				cut_overlays()
			flick("door_closin69", src)
			update_icon()
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density)
				flick("door_deny", src)
				playsound(loc, 'sound/machines/Custom_deny.o6969', 50, 1, -2)
	return

/obj/machinery/door/holy/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/taperoll))
		return

	if(istype(I, /obj/item/clothin69/accessory/cross))
		open()
		return

	add_fin69erprint(user)

	if(density && user.a_intent == I_HURT)
		hit(user, I)
		return

	var/tool_type = I.69et_tool_type(user, list(69UALITY_PRYIN69, 69UALITY_WELDIN69), src)
	switch(tool_type)
		if(69UALITY_PRYIN69)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY,  re69uired_stat = list(STAT_MEC, STAT_ROB)))
				if(locked)
					to_chat(user, SPAN_NOTICE("The door's bolts prevent it from bein69 forced."))
				else if(stat & BROKEN)
					if(density)
						open(TRUE)
					else
						close(TRUE)
				else
					to_chat(user, SPAN_NOTICE("The door's69otors resist your efforts to force it."))
			else
				..()
			return

		if(69UALITY_WELDIN69)
			if(!(operatin69 > 0) && density)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					if(!welded)
						welded = 1
					else
						welded = null
					update_icon()
			else
				..()
			return

		if(ABORT_CHECK)
			return

	if(istool(I))
		return attack_hand(user)

	else if(istype(I, /obj/item/pai_cable))
		to_chat(user, SPAN_NOTICE("There is no port for the cable."))
		return

	else
		..()
	return

/obj/machinery/door/holy/open(forced)
	if(!can_open(forced))
		return FALSE

	if(stat & BROKEN)
		var/obj/item/tool/T = forced
		if (istype(T) && T.item_fla69s & HONKIN69)
			playsound(loc, WORKSOUND_HONK, 70, 1, -2)
		else if (istype(T) && T.item_fla69s & SILENT)
			playsound(loc, open_sound_unpowered, 3, 1, -5)
		else if (istype(T) && T.item_fla69s & LOUD)
			playsound(loc, open_sound_unpowered, 500, 1, 10)
		else
			playsound(loc, open_sound_unpowered, 70, 1, -1)
	else
		playsound(loc, open_sound_powered, 70, 1, -2)

	return ..()

/obj/machinery/door/holy/can_open(forced)
	if(!density || locked || welded || operatin69)
		return FALSE

	return TRUE

/obj/machinery/door/holy/can_close(forced)
	if(density || locked || operatin69)
		return FALSE

	if(wed69ed_item)
		shake_animation(12)
		return FALSE

	return TRUE

/obj/machinery/door/holy/close(forced)
	if(!can_close(forced))
		return FALSE

	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.blocks_airlock())
				if(tryin69ToLock)
					addtimer(CALLBACK(src, .proc/close), 30 SECONDS)
				if(world.time > next_beep_at)
					playsound(loc, 'sound/machines/buzz-two.o6969', 30, 1, -1)
					next_beep_at = world.time + SecondsToTicks(10)
				return
			if(istool(AM))
				var/obj/item/tool/T = AM
				if(T.w_class >= ITEM_SIZE_NORMAL)
					operatin69 = TRUE
					density = TRUE
					do_animate("closin69")
					sleep(7)
					force_wed69e_item(AM)
					playsound(loc, 'sound/machines/airlock_creakin69.o6969', 75, 1)
					shake_animation(12)
					sleep(7)
					playsound(loc, 'sound/machines/buzz-two.o6969', 30, 1, -1)
					density = FALSE
					do_animate("openin69")
					operatin69 = FALSE
					return

	if(stat & BROKEN)
		var/obj/item/tool/T = forced
		if (istype(T) && T.item_fla69s & HONKIN69)
			playsound(loc, WORKSOUND_HONK, 70, 1, -2)
		else if (istype(T) && T.item_fla69s & SILENT)
			playsound(loc, open_sound_unpowered, 3, 1, -5)
		else if (istype(T) && T.item_fla69s & LOUD)
			playsound(loc, open_sound_unpowered, 500, 1, 10)
		else
			playsound(loc, open_sound_unpowered, 70, 1, -1)
	else
		playsound(loc, close_sound, 70, 1, -2)

	tryin69ToLock = FALSE

	..()

/obj/machinery/door/holy/proc/lock()
	if(locked || operatin69)
		return

	locked = TRUE
	playsound(loc, 'sound/machines/Custom_bolts.o6969', 40, 1, 5)
	for(var/mob/M in ran69e(1,src))
		M.show_messa69e("You hear a click from the bottom of the door.", 2)
	update_icon()
	return

/obj/machinery/door/holy/proc/unlock()
	if(!locked || operatin69)
		return

	locked = FALSE
	playsound(loc, 'sound/machines/Custom_boltsup.o6969', 40, 1, 5)
	for(var/mob/M in ran69e(1,src))
		M.show_messa69e("You hear a click from the bottom of the door.", 2)
	update_icon()
	return TRUE

// Wed69e_item copypaste from airlock.dm
/obj/machinery/door/holy/attack_hand(mob/user as69ob)
	if(user.a_intent == I_69RAB && wed69ed_item && !user.69et_active_hand())
		take_out_wed69ed_item(user)
		return

	..(user)
	return

/obj/machinery/door/holy/proc/force_wed69e_item(obj/item/tool/T)
	T.forceMove(src)
	wed69ed_item = T
	update_icon()
	verbs -= /obj/machinery/door/holy/proc/try_wed69e_item
	verbs += /obj/machinery/door/holy/proc/take_out_wed69ed_item

/obj/machinery/door/holy/proc/try_wed69e_item()
	set name = "Wed69e item"
	set cate69ory = "Object"
	set src in69iew(1)

	if(!islivin69(usr))
		to_chat(usr, SPAN_WARNIN69("You can't do this."))
		return
	var/obj/item/tool/T = usr.69et_active_hand()
	if(istype(T) && T.w_class >= ITEM_SIZE_NORMAL)
		if(!density)
			usr.drop_item()
			force_wed69e_item(T)
			to_chat(usr, SPAN_NOTICE("You wed69e 69T69 into 69src69."))
		else
			to_chat(usr, SPAN_NOTICE("69T69 can't be wed69ed into 69src69, while 69src69 is closed."))

/obj/machinery/door/holy/proc/take_out_wed69ed_item()
	set name = "Remove Blocka69e"
	set cate69ory = "Object"
	set src in69iew(1)

	if(!islivin69(usr) || !CanUseTopic(usr))
		return

	if(wed69ed_item)
		wed69ed_item.forceMove(drop_location())
		if(usr)
			usr.put_in_hands(wed69ed_item)
			to_chat(usr, SPAN_NOTICE("You took 69wed69ed_item69 out of 69src69."))
		wed69ed_item = null
		verbs -= /obj/machinery/door/holy/proc/take_out_wed69ed_item
		verbs += /obj/machinery/door/holy/proc/try_wed69e_item
		update_icon()

/obj/machinery/door/holy/AltClick(mob/user)
	if(Adjacent(user))
		wed69ed_item ? take_out_wed69ed_item() : try_wed69e_item()

/obj/machinery/door/holy/MouseDrop(obj/over_object)
	if(ishuman(usr) && usr == over_object && !usr.incapacitated() && Adjacent(usr))
		take_out_wed69ed_item(usr)
		return
	return ..()

/obj/machinery/door/holy/proc/69enerate_wed69e_overlay()
	var/cache_strin69 = "69wed69ed_item.icon69||69wed69ed_item.icon_state69||69wed69ed_item.overlays.len69||69wed69ed_item.underlays.len69"

	if(!69LOB.wed69e_icon_cache69cache_strin6969)
		var/icon/I = 69etFlatIcon(wed69ed_item, SOUTH, always_use_defdir = TRUE)

		I.Shift(SOUTH, 6)
		I.Shift(EAST, 14)
		I.Turn(45)

		69LOB.wed69e_icon_cache69cache_strin6969 = I
		underlays += I
	else
		underlays += 69LOB.wed69e_icon_cache69cache_strin6969

/obj/machinery/door/holy/examine(mob/user)
	..()
	if(wed69ed_item)
		to_chat(user, "You can see \icon69wed69ed_item69 69wed69ed_item69 wed69ed into it.")
