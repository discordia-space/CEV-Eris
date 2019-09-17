/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "generic"
	density = 1
	layer = BELOW_OBJ_LAYER
	w_class = ITEM_SIZE_HUGE
	var/locked = FALSE
	var/broken = FALSE
	var/horizontal = FALSE
	var/icon_door = null
	var/icon_welded = "welded"
	var/icon_lock = "lock"
	var/icon_sparking = "sparking"
	var/allow_dense = FALSE
	var/secure = FALSE
	var/allow_objects = FALSE
	var/opened = FALSE
	var/welded = FALSE
	var/dense_when_open = FALSE
	var/hack_require = null
	var/hack_stage = 0
	var/max_mob_size = 2
	var/wall_mounted = FALSE //never solid (You can always pass over it)
	var/health = 100
	var/breakout = FALSE //if someone is currently breaking out. mutex
	var/storage_capacity = 2 * MOB_MEDIUM //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.
	var/open_sound = 'sound/machines/Custom_closetopen.ogg'
	var/close_sound = 'sound/machines/Custom_closetclose.ogg'
	var/lock_on_sound = 'sound/machines/door_lock_on.ogg'
	var/lock_off_sound = 'sound/machines/door_lock_off.ogg'

	var/store_misc = 1
	var/store_items = 1
	var/store_mobs = 1
	var/old_chance = 0 //Chance to have rusted closet content in it, from 0 to 100. Keep in mind that chance increases in maints

	var/dismantle_material = /obj/item/stack/material/steel

/obj/structure/closet/can_prevent_fall()
	return TRUE

/obj/structure/closet/New()
	..()
	update_icon()

/obj/structure/closet/Initialize(mapload)
	..()

	populate_contents()
	update_icon()
	hack_require = rand(6,8)

	//If closet is spawned in maints, chance of getting rusty content is increased.
	if (in_maintenance())
		old_chance = old_chance + 20

	if (prob(old_chance))
		make_old()

	if (old_chance)
		for (var/atom/thing in contents)
			if (prob(old_chance))
				thing.make_old()

	return mapload ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_NORMAL

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
			content_size += CEILING(I.w_class * 0.5, 1)
		if(content_size > storage_capacity-5)
			storage_capacity = content_size + 5

/obj/structure/closet/examine(mob/user)
	if(..(user, 1) && !opened)
		var/content_size = 0
		for(var/obj/item/I in src.contents)
			if(!I.anchored)
				content_size += CEILING(I.w_class * 0.5, 1)
		if(!content_size)
			to_chat(user, "It is empty.")
		else if(storage_capacity > content_size*4)
			to_chat(user, "It is barely filled.")
		else if(storage_capacity > content_size*2)
			to_chat(user, "It is less than half full.")
		else if(storage_capacity > content_size)
			to_chat(user, "There is still some free space.")
		else
			to_chat(user, "It is full.")

/obj/structure/closet/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0 || wall_mounted)) return 1
	return (!density)

/obj/structure/closet/proc/can_open(mob/living/user)
	if(welded || (secure && locked))
		return FALSE
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		if(L.anchored || horizontal && L.mob_size > 0 && L.density)
			if(user)
				to_chat(user, SPAN_DANGER("There's something large on top of [src], preventing it from opening."))
			return FALSE
	return TRUE

/obj/structure/closet/proc/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			return FALSE
	return TRUE

/obj/structure/closet/proc/take_contents()
	var/turf/L = get_turf(src)
	for(var/atom/movable/AM in L)
		if(AM != src && insert(AM) == -1) // limit reached
			break

/obj/structure/closet/proc/insert(atom/movable/AM)
	if(contents.len >= storage_capacity)
		return -1

	if(ismob(AM))
		if(!isliving(AM)) //let's not put ghosts or camera mobs inside closets...
			return
		var/mob/living/L = AM
		if(L.anchored || L.buckled || L.incorporeal_move )
			return
		if(L.mob_size > 0) // Tiny mobs are treated as items.
			if(horizontal && L.density)
				return
			if(L.mob_size > max_mob_size)
				return
			var/mobs_stored = 0
			for(var/mob/living/M in contents)
				if(++mobs_stored >= storage_capacity)
					return
		L.stop_pulling()
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
		AM.pulledby.stop_pulling()

	return 1

/obj/structure/closet/proc/dump_contents()
	//Cham Projector Exception
	for(var/obj/effect/dummy/chameleon/AD in src)
		AD.forceMove(loc)

	for(var/obj/I in src)
		I.forceMove(loc)

	for(var/mob/M in src)
		M.forceMove(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/proc/open(mob/living/user)
	if(opened || !can_open(user))
		return
	playsound(loc, open_sound, 100, 1, -3)
	opened = TRUE
	if(!dense_when_open)
		density = FALSE
	dump_contents()
	update_icon()
	update_openspace()
	return 1

/obj/structure/closet/proc/close(mob/living/user)
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
	density = 1
	update_openspace()
	return 1

/obj/structure/closet/proc/toggle(mob/living/user)
	if(!(opened ? close(user) : open(user)))
		to_chat(user, SPAN_NOTICE("It won't budge!"))
		return
	update_icon()

/obj/structure/closet/proc/togglelock(mob/user as mob, var/obj/item/weapon/card/id/id_card)
	var/ctype = istype(src,/obj/structure/closet/crate) ? "crate" : "closet"
	if(!secure)
		return

	if(src.opened)
		to_chat(user, SPAN_NOTICE("Close the [ctype] first."))
		return
	if(src.broken)
		to_chat(user, SPAN_WARNING("The [ctype] appears to be broken."))
		return
	if(CanToggleLock(user, id_card))
		set_locked(!locked, user)
	else
		to_chat(user, SPAN_NOTICE("Access Denied"))

/obj/structure/closet/AltClick(mob/user as mob)
	if(Adjacent(user))
		src.togglelock(user)

/obj/structure/closet/proc/CanToggleLock(var/mob/user, var/obj/item/weapon/card/id/id_card)
	if (istype(user))
		id_card = id_card || user.GetIdCard()

	if (istype(id_card))
		return check_access_list(id_card.GetAccess())

	return allowed(user)

/obj/structure/closet/proc/set_locked(var/newlocked, mob/user = null)
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
		for(var/mob/O in viewers(user, 3))
			O.show_message( SPAN_NOTICE("The [ctype] has been [locked ? null : "un"]locked by [user]."), 1)
	update_icon()

//Cham Projector Exception
/obj/structure/closet/proc/store_misc(var/stored_units)
	var/added_units = 0
	for(var/obj/effect/dummy/chameleon/AD in src.loc)
		if((stored_units + added_units) > storage_capacity)
			break
		AD.forceMove(src)
		added_units++
	return added_units

/obj/structure/closet/proc/store_items(var/stored_units)
	var/added_units = 0
	for(var/obj/item/I in src.loc)
		var/item_size = CEILING(I.w_class / 2, 1)
		if(stored_units + added_units + item_size > storage_capacity)
			continue
		if(!I.anchored)
			I.forceMove(src)
			added_units += item_size
	return added_units

/obj/structure/closet/proc/store_mobs(var/stored_units)
	var/added_units = 0
	for(var/mob/living/M in src.loc)
		if(M.buckled || M.pinned.len)
			continue
		if(stored_units + added_units + M.mob_size > storage_capacity)
			break
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		added_units += M.mob_size
	return added_units

// this should probably use dump_contents()
/obj/structure/closet/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as mob|obj in src)//pulls everything out of the locker and hits it with an explosion
				A.forceMove(src.loc)
				A.ex_act(severity + 1)
			qdel(src)
		if(2)
			if(prob(50))
				for (var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					A.ex_act(severity + 1)
				qdel(src)
		if(3)
			if(prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
				qdel(src)

/obj/structure/closet/proc/populate_contents()
	return

/obj/structure/closet/proc/damage(var/damage)
	health -= damage
	if(health <= 0)
		for(var/atom/movable/A in src)
			A.forceMove(src.loc)
		qdel(src)

/obj/structure/closet/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage)
		return

	..()
	damage(proj_damage)

	return

/obj/structure/closet/affect_grab(var/mob/living/user, var/mob/living/target)
	if(src.opened)
		MouseDrop_T(target, user)      //act like they were dragged onto the closet
		return TRUE
	return FALSE


/obj/structure/closet/attackby(obj/item/I, mob/user)

	if (istype(I, /obj/item/weapon/gripper))
		//Empty gripper attacks will call attack_AI
		return 0

	if(src.opened)
		if(istype(I,/obj/item/tk_grab))
			return 0
		if(QUALITY_WELDING in I.tool_qualities)
			if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				new dismantle_material(src.loc, 10)
				src.visible_message(
					SPAN_NOTICE("\The [src] has been cut apart by [user] with \the [I]."),
					"You hear welding."
				)
				qdel(src)
				return
		if(istype(I, /obj/item/weapon/storage/laundry_basket) && I.contents.len)
			var/obj/item/weapon/storage/laundry_basket/LB = I
			var/turf/T = get_turf(src)
			for(var/obj/item/II in LB.contents)
				LB.remove_from_storage(II, T)
			user.visible_message(
				SPAN_NOTICE("[user] empties \the [LB] into \the [src]."), \
				SPAN_NOTICE("You empty \the [LB] into \the [src]."), \
				SPAN_NOTICE("You hear rustling of clothes.")
			)
			return
		usr.unEquip(I, src.loc)
		return
	else if(istype(I, /obj/item/weapon/packageWrap))
		return
	else if(QUALITY_WELDING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			welded = !src.welded
			update_icon()
			for(var/mob/M in viewers(src))
				M.show_message(SPAN_WARNING("[src] has been [welded?"welded shut":"unwelded"] by [user.name]."), 3, SPAN_WARNING("You hear welding."), 2)
	else if(istype(I,/obj/item/weapon/card/id))
		src.togglelock(user)
		return
	else if(istype(I, /obj/item/weapon/melee/energy/blade) && secure)
		emag_act(INFINITY, user)
		return
	else if((QUALITY_PULSING in I.tool_qualities) && secure && locked)
		user.visible_message(
		SPAN_WARNING("[user] picks in wires of the [src.name] with a multitool"), \
		SPAN_WARNING("[pick("Picking wires in [src.name] lock", "Hacking [src.name] security systems", "Pulsing in locker controller")].")
		)
		if(I.use_tool(user, src, WORKTIME_LONG, QUALITY_PULSING, FAILCHANCE_HARD, required_stat = STAT_MEC))
			if(hack_stage < hack_require)

				var/obj/item/weapon/tool/T = I
				if (istype(T) && T.item_flags & SILENT)
					playsound(src.loc, 'sound/items/glitch.ogg', 3, 1, -5) //Silenced tools can hack it silently
				else
					playsound(src.loc, 'sound/items/glitch.ogg', 70, 1, -1)

				hack_stage++
				to_chat(user, SPAN_NOTICE("Multitool blinks <b>([hack_stage]/[hack_require])</b> on screen."))
			else if(hack_stage >= hack_require)
				locked = FALSE
				broken = TRUE
				src.update_icon()
				user.visible_message(
				SPAN_WARNING("[user] [locked?"locks":"unlocks"] [name] with a multitool,"), \
				SPAN_WARNING("You [locked? "locked" : "unlocked"] [name] with multitool")
				)
				return
	else
		src.attack_hand(user)
	return

/obj/structure/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if(istype(O, /obj/screen))	//fix for HUD elements making their way into the world	-Pete
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
		if(!user.unEquip(O))
			return
	step_towards(O, src.loc)
	if(user != O)
		user.show_viewers(SPAN_DANGER("[user] stuffs [O] into [src]!"))
	src.add_fingerprint(user)

/obj/structure/closet/attack_ai(mob/user)
	if(isrobot(user) && Adjacent(user)) // Robots can open/close it, but not the AI.
		attack_hand(user)

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(src.loc))
		return

	if(!src.open())
		to_chat(user, SPAN_NOTICE("It won't budge!"))

/obj/structure/closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(secure && locked && !opened)
		src.togglelock(user)
	else
		src.toggle(user)

// tk grab then use on self
/obj/structure/closet/attack_self_tk(mob/user as mob)
	src.add_fingerprint(user)
	if(!src.toggle())
		to_chat(usr, SPAN_NOTICE("It won't budge!"))

/obj/structure/closet/emag_act(var/remaining_charges, var/mob/user)
	if(!broken)
		locked = FALSE
		broken = TRUE
		update_icon()
		playsound(src.loc, "sparks", 60, 1)
		to_chat(user, SPAN_NOTICE("You unlock \the [src]."))
		return TRUE

/obj/structure/closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		if(!locked)
			locked = TRUE
		else
			locked = FALSE
			playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		broken = TRUE
	update_icon()
	..()

/obj/structure/closet/verb/verb_toggleopen()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(ishuman(usr) || isrobot(usr))
		src.add_fingerprint(usr)
		src.toggle(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr) || isrobot(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/update_icon()//Putting the welded stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	overlays.Cut()
	if(opened)
		layer = BELOW_OBJ_LAYER
		if(icon_door)
			add_overlay("[icon_door]_open")
		else
			add_overlay("[icon_state]_open")
	else
		layer = OBJ_LAYER
		if(icon_door)
			add_overlay("[icon_door]_door")
		else
			add_overlay("[icon_state]_door")
		if(welded)
			add_overlay(icon_welded)

		if(secure)
			if(!broken)
				if(locked)
					add_overlay("[icon_lock]_locked")
				else
					add_overlay("[icon_lock]_unlocked")
			else
				add_overlay("[icon_lock]_off")
				add_overlay(icon_sparking)

/obj/structure/closet/attack_generic(var/mob/user, var/damage, var/attack_message = "destroys", var/wallbreaker)
	if(!damage || !wallbreaker)
		return
	attack_animation(user)
	visible_message(SPAN_DANGER("[user] [attack_message] the [src]!"))
	dump_contents()
	spawn(1) qdel(src)
	return 1

/obj/structure/closet/proc/req_breakout()
	if(opened)
		return 0 //Door's open... wait, why are you in it's contents then?
	if(!welded)
		return 0 //closed but not welded...
	return 1

/obj/structure/closet/proc/mob_breakout(var/mob/living/escapee)
	var/breakout_time = 2 //2 minutes by default

	if(breakout || !req_breakout())
		return

	escapee.setClickCooldown(100)

	//okay, so the closet is either welded or locked... resist!!!
	to_chat(escapee, SPAN_WARNING("You lean on the back of \the [src] and start pushing the door open. (this will take about [breakout_time] minutes)"))

	visible_message(SPAN_DANGER("\The [src] begins to shake violently!"))

	breakout = 1 //can't think of a better way to do this right now.
	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		if(!do_after(escapee, 50, src)) //5 seconds
			breakout = 0
			return
		if(!escapee || escapee.incapacitated() || escapee.loc != src)
			breakout = 0
			return //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened
		//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
		if(!req_breakout())
			breakout = 0
			return

		playsound(src.loc, 'sound/effects/grillehit.ogg', 100, 1)
		animate_shake()
		add_fingerprint(escapee)

	//Well then break it!
	breakout = 0
	to_chat(escapee, SPAN_WARNING("You successfully break out!"))
	visible_message(SPAN_DANGER("\The [escapee] successfully broke out of \the [src]!"))
	playsound(src.loc, 'sound/effects/grillehit.ogg', 100, 1)
	break_open()
	animate_shake()

/obj/structure/closet/proc/break_open()
	welded = 0
	update_icon()
	//Do this to prevent contents from being opened into nullspace (read: bluespace)
	if(istype(loc, /obj/structure/bigDelivery))
		var/obj/structure/bigDelivery/BD = loc
		BD.unwrap()
	open()

/obj/structure/closet/proc/animate_shake()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(src, transform=turn(matrix(), 8*shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

/obj/structure/closet/AllowDrop()
	return TRUE
