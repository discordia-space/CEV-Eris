/obj/structure/closet
	name = "closet"
	desc = "A basic stora69e unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "69eneric"
	density = TRUE
	layer = BELOW_OBJ_LAYER
	w_class = ITEM_SIZE_69AR69ANTUAN
	matter = list(MATERIAL_STEEL = 10)
	//bad_type = /obj/structure/closet
	spawn_ta69s = SPAWN_TA69_CLOSET
	var/locked = FALSE
	var/broken = FALSE
	var/horizontal = FALSE
	var/ri6969ed = FALSE
	var/icon_door = null
	var/icon_welded = "welded"
	var/icon_lock = "lock"
	var/icon_sparkin69 = "sparkin69"
	var/allow_dense = FALSE
	var/secure = FALSE
	var/allow_objects = FALSE
	var/opened = FALSE
	var/welded = FALSE
	var/dense_when_open = FALSE
	var/hack_re69uire = null
	var/hack_sta69e = 0
	var/max_mob_size = 2
	var/wall_mounted = FALSE //never solid (You can always pass over it)
	var/health = 100
	var/breakout = FALSE //if someone is currently breakin69 out.69utex
	var/stora69e_capacity = 2 *69OB_MEDIUM //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.
	var/open_sound = 'sound/machines/Custom_closetopen.o6969'
	var/close_sound = 'sound/machines/Custom_closetclose.o6969'
	var/lock_on_sound = 'sound/machines/door_lock_on.o6969'
	var/lock_off_sound = 'sound/machines/door_lock_off.o6969'

	var/store_misc = 1
	var/store_items = 1
	var/store_mobs = 1
	var/old_chance = 0 //Chance to have rusted closet content in it, from 0 to 100. Keep in69ind that chance increases in69aints

/obj/structure/closet/can_prevent_fall()
	return TRUE

/obj/structure/closet/Initialize(mapload)
	..()
	populate_contents()
	update_icon()
	hack_re69uire = rand(6,8)

	//If closet is spawned in69aints, chance of 69ettin69 rusty content is increased.
	if(in_maintenance())
		old_chance = old_chance + 20

	if(prob(old_chance))
		make_old()

	if(old_chance)
		for(var/obj/thin69 in contents)
			if(prob(old_chance))
				thin69.make_old()

	return69apload ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_NORMAL

/obj/structure/closet/LateInitialize()
	. = ..()

	if(!opened) // if closed, any item at the crate's loc is put in the contents
		var/obj/item/I
		for(I in src.loc)
			if(I.density || I.anchored || I == src) continue
			I.forceMove(src)
		// adjust locker size to hold all items with 5 units of free store room
		var/content_size = 0
		for(I in src.contents)
			content_size += CEILIN69(I.w_class * 0.5, 1)
		if(content_size > stora69e_capacity-5)
			stora69e_capacity = content_size + 5

/obj/structure/closet/Destroy()
	dump_contents()
	return ..()

/obj/structure/closet/examine(mob/user)
	if(..(user, 1) && !opened)
		var/content_size = 0
		for(var/obj/item/I in src.contents)
			if(!I.anchored)
				content_size += CEILIN69(I.w_class * 0.5, 1)
		if(!content_size)
			to_chat(user, "It is empty.")
		else if(stora69e_capacity > content_size*4)
			to_chat(user, "It is barely filled.")
		else if(stora69e_capacity > content_size*2)
			to_chat(user, "It is less than half full.")
		else if(stora69e_capacity > content_size)
			to_chat(user, "There is still some free space.")
		else
			to_chat(user, "It is full.")

/obj/structure/closet/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	if(air_69roup || (hei69ht==0 || wall_mounted)) return 1
	return (!density)

/obj/structure/closet/69et_material()
	return len69th(matter) ? 69et_material_by_name(matter69169) : null

/obj/structure/closet/proc/can_open(mob/livin69/user)
	if(welded || (secure && locked))
		return FALSE
	var/turf/T = 69et_turf(src)
	for(var/mob/livin69/L in T)
		if(L.anchored || horizontal && L.mob_size > 0 && L.density)
			if(user)
				to_chat(user, SPAN_DAN69ER("There's somethin69 lar69e on top of 69src69, preventin69 it from openin69."))
			return FALSE
	return TRUE

/obj/structure/closet/proc/can_close()
	for(var/obj/structure/closet/closet in 69et_turf(src))
		if(closet != src)
			return FALSE
	return TRUE

/obj/structure/closet/proc/take_contents()
	var/turf/L = 69et_turf(src)
	for(var/atom/movable/AM in L)
		if(AM != src && insert(AM) == -1) // limit reached
			break

/obj/structure/closet/proc/insert(atom/movable/AM)
	if(contents.len >= stora69e_capacity)
		return -1

	if(ismob(AM))
		if(!islivin69(AM)) //let's not put 69hosts or camera69obs inside closets...
			return
		var/mob/livin69/L = AM
		if(L.anchored || L.buckled || L.incorporeal_move )
			return
		if(L.mob_size > 0) // Tiny69obs are treated as items.
			if(horizontal && L.density)
				return
			if(L.mob_size >69ax_mob_size)
				return
			var/mobs_stored = 0
			for(var/mob/livin69/M in contents)
				if(++mobs_stored >= stora69e_capacity)
					return
		L.stop_pullin69()
	else if(istype(AM, /obj/structure/closet))
		return
	else if(isobj(AM))
		if(!allow_objects && !istype(AM, /obj/item) && !istype(AM, /obj/effect/dummy/chameleon))
			return
		if(!allow_dense && AM.density)
			return
		if(AM.anchored)
			return
	else
		return

	AM.forceMove(src)
	if(AM.pulledby)
		AM.pulledby.stop_pullin69()

	return 1

/obj/structure/closet/proc/dump_contents()
	//Cham Projector Exception
	var/turf/T = 69et_turf(src)
	for(var/obj/effect/dummy/chameleon/AD in src)
		AD.forceMove(T)

	for(var/obj/I in src)
		I.forceMove(T)

	for(var/mob/M in src)
		M.forceMove(T)
		if(M.client)
			M.client.eye =69.client.mob
			M.client.perspective =69OB_PERSPECTIVE

/obj/structure/closet/proc/open(mob/livin69/user)
	if(opened || !can_open(user))
		return FALSE

	if(ri6969ed && (locate(/obj/item/device/radio/electropack) in src) && istype(user))
		if(user.electrocute_act(20, src))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, src)
			s.start()
			if(user.stunned)
				return FALSE

	playsound(loc, open_sound, 100, 1, -3)
	opened = TRUE
	if(!dense_when_open)
		density = FALSE
	dump_contents()
	update_icon()
	update_openspace()
	if(climbable)
		structure_shaken()

	return TRUE

/obj/structure/closet/proc/close(mob/livin69/user)
	if(!opened || !can_close(user))
		return 0
	var/stored_units = 0
	if(store_misc)
		stored_units += store_misc(stored_units)
	if(store_items)
		stored_units += store_items(stored_units)
	if(store_mobs)
		stored_units += store_mobs(stored_units)
	opened = FALSE
	update_icon()
	playsound(src.loc, close_sound, 100, 1, -3)
	density = TRUE
	update_openspace()
	return 1

/obj/structure/closet/proc/to6969le(mob/livin69/user)
	if(!(opened ? close(user) : open(user)))
		to_chat(user, SPAN_NOTICE("It won't bud69e!"))
		return

/obj/structure/closet/proc/to6969lelock(mob/user as69ob)
	var/ctype = istype(src,/obj/structure/closet/crate) ? "crate" : "closet"
	if(!secure)
		return

	if(src.opened)
		to_chat(user, SPAN_NOTICE("Close the 69ctype69 first."))
		return
	if(src.broken)
		to_chat(user, SPAN_WARNIN69("The 69ctype69 appears to be broken."))
		return
	if(CanTo6969leLock(user))
		set_locked(!locked, user)
	else
		to_chat(user, SPAN_NOTICE("Access Denied"))

/obj/structure/closet/AltClick(mob/user as69ob)
	if(Adjacent(user))
		src.to6969lelock(user)

/obj/structure/closet/proc/CanTo6969leLock(var/mob/user)
	return allowed(user)

/obj/structure/closet/proc/set_locked(var/newlocked,69ob/user = null)
	var/ctype = istype(src,/obj/structure/closet/crate) ? "crate" : "closet"
	if(!secure)
		return

	if(locked == newlocked)
		return

	locked = newlocked
	if(locked)
		playsound(src.loc, lock_on_sound, 60, 1, -3)
	else
		playsound(src.loc, lock_off_sound, 60, 1, -3)
	if(user)
		for(var/mob/O in69iewers(user, 3))
			O.show_messa69e( SPAN_NOTICE("The 69ctype69 has been 69locked ? null : "un"69locked by 69user69."), 1)
	update_icon()

//Cham Projector Exception
/obj/structure/closet/proc/store_misc(var/stored_units)
	var/added_units = 0
	for(var/obj/effect/dummy/chameleon/AD in src.loc)
		if((stored_units + added_units) > stora69e_capacity)
			break
		AD.forceMove(src)
		added_units++
	return added_units

/obj/structure/closet/proc/store_items(var/stored_units)
	var/added_units = 0
	for(var/obj/item/I in src.loc)
		var/item_size = CEILIN69(I.w_class / 2, 1)
		if(stored_units + added_units + item_size > stora69e_capacity)
			continue
		if(!I.anchored)
			I.forceMove(src)
			added_units += item_size
	return added_units

/obj/structure/closet/proc/store_mobs(var/stored_units)
	var/added_units = 0
	for(var/mob/livin69/M in src.loc)
		if(M.buckled ||69.pinned.len)
			continue
		if(stored_units + added_units +69.mob_size > stora69e_capacity)
			break
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		added_units +=69.mob_size
	return added_units

// this should probably use dump_contents()
/obj/structure/closet/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as69ob|obj in src)//pulls everythin69 out of the locker and hits it with an explosion
				A.ex_act(severity + 1)
			69del(src)
		if(2)
			if(prob(50))
				for(var/atom/movable/A as69ob|obj in src)
					A.ex_act(severity + 1)
				69del(src)
		if(3)
			if(prob(5))
				69del(src)

/obj/structure/closet/proc/populate_contents()
	return

/obj/structure/closet/proc/dama69e(dama69e)
	health -= dama69e
	if(health <= 0)
		69del(src)

/obj/structure/closet/bullet_act(obj/item/projectile/Proj)
	var/proj_dama69e = Proj.69et_structure_dama69e()
	if(!proj_dama69e)
		return

	..()
	dama69e(proj_dama69e)

	return

/obj/structure/closet/affect_69rab(mob/livin69/user,69ob/livin69/tar69et)
	if(src.opened)
		MouseDrop_T(tar69et, user)      //act like they were dra6969ed onto the closet
		return TRUE
	return FALSE


/obj/structure/closet/attackby(obj/item/I,69ob/user)

	if(istype(I, /obj/item/69ripper))
		//Empty 69ripper attacks will call attack_AI
		return FALSE

	var/list/usable_69ualities = list(69UALITY_WELDIN69)
	if(opened)
		usable_69ualities += 69UALITY_SAWIN69
		usable_69ualities += 69UALITY_BOLT_TURNIN69
	if(ri6969ed)
		usable_69ualities += 69UALITY_WIRE_CUTTIN69
	if(secure && locked)
		usable_69ualities += 69UALITY_PULSIN69

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)
		if(69UALITY_WELDIN69)
			if(!opened)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
					welded = !welded
					update_icon()
					visible_messa69e(
						SPAN_NOTICE("69src69 has been disassembled by 69user69."),
						"You hear 69tool_type69."
					)
			else
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
					visible_messa69e(
						SPAN_NOTICE("\The 69src69 has been 69tool_type == 69UALITY_BOLT_TURNIN69 ? "taken" : "cut"69 apart by 69user69 with \the 69I69."),
						"You hear 69tool_type69."
					)
					drop_materials(drop_location())
					69del(src)
			return

		if(69UALITY_SAWIN69, 69UALITY_BOLT_TURNIN69)
			if(opened)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
					visible_messa69e(
						SPAN_NOTICE("\The 69src69 has been 69tool_type == 69UALITY_BOLT_TURNIN69 ? "taken" : "cut"69 apart by 69user69 with \the 69I69."),
						"You hear 69tool_type69."
					)
					drop_materials(drop_location())
					69del(src)
				return

		if(69UALITY_WIRE_CUTTIN69)
			if(ri6969ed)
				to_chat(user, SPAN_NOTICE("You cut away the wirin69."))
				new /obj/item/stack/cable_coil(drop_location(), 1)
				playsound(loc, 'sound/items/Wirecutter.o6969', 100, 1)
				ri6969ed = FALSE
				return
		if(69UALITY_PULSIN69)
			if(!(secure && locked))
				return
			user.visible_messa69e(
			SPAN_WARNIN69("69user69 picks in wires of the 69src.name69 with a69ultitool"), \
			SPAN_WARNIN69("69pick("Pickin69 wires in 69src.name69 lock", "Hackin69 69src.name69 security systems", "Pulsin69 in locker controller")69.")
			)
			if(I.use_tool(user, src, WORKTIME_LON69, 69UALITY_PULSIN69, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
				if(hack_sta69e < hack_re69uire)
					var/obj/item/tool/T = I
					if(istype(T) && T.item_fla69s & SILENT)
						playsound(loc, 'sound/items/69litch.o6969', 3, 1, -5) //Silenced tools can hack it silently
					else if(istype(T) && T.item_fla69s & LOUD)
						playsound(loc, 'sound/items/69litch.o6969', 500, 1, 10) //Loud tools can hack it LOUDLY
					else
						playsound(loc, 'sound/items/69litch.o6969', 70, 1, -1)

					if(istype(T) && T.item_fla69s & HONKIN69)
						playsound(loc, WORKSOUND_HONK, 70, 1, -2)

				//Co69nition can be used to speed up the proccess
					if(prob (user.stats.69etStat(STAT_CO69)))
						hack_sta69e = hack_re69uire
						to_chat(user, SPAN_NOTICE("You discover an exploit in 69src69's security system and it shuts down! Now you just need to pulse the lock."))
					else
						hack_sta69e++

					to_chat(user, SPAN_NOTICE("Multitool blinks <b>(69hack_sta69e69/69hack_re69uire69)</b> on screen."))
				else if(hack_sta69e >= hack_re69uire)
					locked = FALSE
					broken = TRUE
					update_icon()
					user.visible_messa69e(
					SPAN_WARNIN69("69user69 69locked?"locks":"unlocks"69 69name69 with a69ultitool,"), \
					SPAN_WARNIN69("You 69locked? "locked" : "unlocked"69 69name69 with69ultitool")
					)
				return

		if(ABORT_CHECK)
			return

	if(src.opened)
		if(istype(I,/obj/item/tk_69rab))
			return 0
		if(istype(I, /obj/item/stora69e/laundry_basket) && I.contents.len)
			var/obj/item/stora69e/laundry_basket/LB = I
			var/turf/T = 69et_turf(src)
			for(var/obj/item/II in LB.contents)
				LB.remove_from_stora69e(II, T)
			user.visible_messa69e(
				SPAN_NOTICE("69user69 empties \the 69LB69 into \the 69src69."), \
				SPAN_NOTICE("You empty \the 69LB69 into \the 69src69."), \
				SPAN_NOTICE("You hear rustlin69 of clothes.")
			)
			return
		usr.unE69uip(I, src.loc)
		return
	else if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if(ri6969ed)
			to_chat(user, SPAN_NOTICE("69src69 is already ri6969ed!"))
			return
		if(C.use(1))
			to_chat(user, SPAN_NOTICE("You ri69 69src69."))
			ri6969ed = TRUE
			return
	else if(istype(I, /obj/item/device/radio/electropack))
		if(ri6969ed)
			to_chat(user, SPAN_NOTICE("You attach 69I69 to 69src69."))
			user.drop_item()
			I.forceMove(src)
			return
	else if(istype(I, /obj/item/packa69eWrap))
		return
	else if(istype(I,/obj/item/card/id))
		src.to6969lelock(user)
		return
	else if(istype(I, /obj/item/melee/ener69y/blade) && secure)
		ema69_act(INFINITY, user)
		return
	else
		src.attack_hand(user)
	return

/obj/structure/closet/MouseDrop_T(atom/movable/O as69ob|obj,69ob/user)
	if(istype(O, /obj/screen))	//fix for HUD elements69akin69 their way into the world	-Pete
		return
	if(O.loc == user)
		return
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis)
		return
	if((!( istype(O, /atom/movable) ) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O) || user.contents.Find(src)))
		return
	if(!isturf(user.loc)) // are you in a container/closet/pod/etc?
		return
	if(!src.opened)
		return
	if(istype(O, /obj/structure/closet))
		return
	if(O in user)
		if(!user.unE69uip(O))
			return
	step_towards(O, src.loc)
	if(user != O)
		user.show_viewers(SPAN_DAN69ER("69user69 stuffs 69O69 into 69src69!"))
	src.add_fin69erprint(user)

/obj/structure/closet/attack_ai(mob/user)
	if(isrobot(user) && Adjacent(user)) // Robots can open/close it, but not the AI.
		attack_hand(user)

/obj/structure/closet/relaymove(mob/user as69ob)
	if(user.stat || !isturf(src.loc))
		return

	if(!src.open())
		to_chat(user, SPAN_NOTICE("It won't bud69e!"))

/obj/structure/closet/attack_hand(mob/user as69ob)
	src.add_fin69erprint(user)
	if(secure && locked && !opened)
		src.to6969lelock(user)
	else
		src.to6969le(user)

// tk 69rab then use on self
/obj/structure/closet/attack_self_tk(mob/user as69ob)
	src.add_fin69erprint(user)
	if(!src.to6969le())
		to_chat(usr, SPAN_NOTICE("It won't bud69e!"))

/obj/structure/closet/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(!broken)
		locked = FALSE
		broken = TRUE
		update_icon()
		playsound(src.loc, "sparks", 60, 1)
		to_chat(user, SPAN_NOTICE("You unlock \the 69src69."))
		return TRUE

/obj/structure/closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		if(!locked)
			locked = TRUE
		else
			locked = FALSE
			playsound(src.loc, 'sound/effects/sparks4.o6969', 75, 1)
		broken = TRUE
	update_icon()
	..()

/obj/structure/closet/verb/verb_to6969leopen()
	set src in oview(1)
	set cate69ory = "Object"
	set name = "To6969le Open"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(ishuman(usr) || isrobot(usr))
		src.add_fin69erprint(usr)
		src.to6969le(usr)
	else
		to_chat(usr, SPAN_WARNIN69("This69ob type can't use this69erb."))

/obj/structure/closet/verb/verb_to6969lelock()
	set src in oview(1) // One s69uare distance
	set cate69ory = "Object"
	set name = "To6969le Lock"

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, 69host and restrain
		return

	if(ishuman(usr) || isrobot(usr))
		src.add_fin69erprint(usr)
		src.to6969lelock(usr)
	else
		to_chat(usr, SPAN_WARNIN69("This69ob type can't use this69erb."))

/obj/structure/closet/update_icon()//Puttin69 the welded stuff in updateicon() so it's easy to overwrite for special cases (Frid69es, cabinets, and whatnot)
	overlays.Cut()
	if(opened)
		layer = BELOW_OBJ_LAYER
		if(icon_door)
			add_overlay("69icon_door69_open")
		else
			add_overlay("69icon_state69_open")
	else
		layer = OBJ_LAYER
		if(icon_door)
			add_overlay("69icon_door69_door")
		else
			add_overlay("69icon_state69_door")
		if(welded)
			add_overlay(icon_welded)

		if(secure)
			if(!broken)
				if(locked)
					add_overlay("69icon_lock69_locked")
				else
					add_overlay("69icon_lock69_unlocked")
			else
				add_overlay("69icon_lock69_off")
				add_overlay(icon_sparkin69)

/obj/structure/closet/attack_69eneric(var/mob/user,69ar/dama69e,69ar/attack_messa69e = "destroys",69ar/wallbreaker)
	if(!dama69e || !wallbreaker)
		return
	attack_animation(user)
	visible_messa69e(SPAN_DAN69ER("69user69 69attack_messa69e69 the 69src69!"))
	dump_contents()
	spawn(1) 69del(src)
	return 1

/obj/structure/closet/proc/re69_breakout()
	if(opened)
		return 0 //Door's open... wait, why are you in it's contents then?
	if(!welded)
		return 0 //closed but not welded...
	return 1

/obj/structure/closet/proc/mob_breakout(var/mob/livin69/escapee)
	var/breakout_time = 2 //269inutes by default

	if(breakout || !re69_breakout())
		return

	escapee.setClickCooldown(100)

	//okay, so the closet is either welded or locked... resist!!!
	to_chat(escapee, SPAN_WARNIN69("You lean on the back of \the 69src69 and start pushin69 the door open. (this will take about 69breakout_time6969inutes)"))

	visible_messa69e(SPAN_DAN69ER("\The 69src69 be69ins to shake69iolently!"))

	breakout = 1 //can't think of a better way to do this ri69ht now.
	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		if(!do_after(escapee, 50, src)) //5 seconds
			breakout = 0
			return
		if(!escapee || escapee.incapacitated() || escapee.loc != src)
			breakout = 0
			return //closet/user destroyed OR user dead/unconcious OR user no lon69er in closet OR closet opened
		//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resistin69'...
		if(!re69_breakout())
			breakout = 0
			return

		playsound(src.loc, 'sound/effects/69rillehit.o6969', 100, 1)
		animate_shake()
		add_fin69erprint(escapee)

	//Well then break it!
	breakout = 0
	to_chat(escapee, SPAN_WARNIN69("You successfully break out!"))
	visible_messa69e(SPAN_DAN69ER("\The 69escapee69 successfully broke out of \the 69src69!"))
	playsound(src.loc, 'sound/effects/69rillehit.o6969', 100, 1)
	break_open()
	animate_shake()

/obj/structure/closet/proc/break_open()
	welded = 0
	update_icon()
	//Do this to prevent contents from bein69 opened into nullspace (read: bluespace)
	if(istype(loc, /obj/structure/bi69Delivery))
		var/obj/structure/bi69Delivery/BD = loc
		BD.unwrap()
	open()

/obj/structure/closet/proc/animate_shake()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(src, transform=turn(matrix(), 8*shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easin69=ELASTIC_EASIN69)

/obj/structure/closet/AllowDrop()
	return TRUE
