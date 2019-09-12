/obj/structure/railing
	name = "orange railing"
	desc = "A standard steel railing painted in copper color. Prevents stupid people from falling to their doom."
	icon = 'icons/obj/railing.dmi'
	density = 1
	throwpass = 1
	climbable = 1
	layer = 3.2	//Just above doors
	anchored = 1
	flags = ON_BORDER
	icon_state = "railing0"
	var/broken = 0
	var/health=70
	var/maxhealth=70
	var/check = 0
	var/icon_modifier = ""	//adds string to icon path for color variations

/obj/structure/railing/grey
	name = "grey railing"
	desc = "A standard steel railing. Prevents stupid people from falling to their doom."
	icon_modifier = "grey_"
	icon_state = "grey_railing0"

/obj/structure/railing/New(loc)
	..()
	if(climbable)
		verbs += /obj/structure/proc/climb_on
	update_icon(FALSE)

/obj/structure/railing/Created(var/mob/user)
	anchored = FALSE
	// this way its much easier to build it, and there is no need to update_icon after that, flip will take care of that
	spawn()
		flip(user)

/obj/structure/railing/Destroy()
	anchored = null
	flags = null
	broken = 1
	for(var/obj/structure/railing/R in oview(src, 1))
		R.update_icon()
	. = ..()

/obj/structure/railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1
//32 and 4 - in the same turf

/obj/structure/railing/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				to_chat(user, SPAN_WARNING("It looks severely damaged!"))
			if(0.25 to 0.5)
				to_chat(user, SPAN_WARNING("It looks damaged!"))
			if(0.5 to 1.0)
				to_chat(user, SPAN_NOTICE("It has a few scrapes and dents."))

/obj/structure/railing/proc/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] breaks down!"))
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		new /obj/item/stack/rods(get_turf(usr))
		qdel(src)

/obj/structure/railing/proc/NeighborsCheck(var/UpdateNeighbors = 1)
	check = 0
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)

	for(var/obj/structure/railing/R in src.loc)	// analyzing turf
		if ((R.dir == Lturn) && R.anchored)	//checking left side
			check |= 32
			if (UpdateNeighbors)
				R.update_icon(0)
		if ((R.dir == Rturn) && R.anchored)	//checking right side
			check |= 2
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, Lturn))	//analysing left turf
		if ((R.dir == src.dir) && R.anchored)
			check |= 16
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, Rturn))	//analysing right turf
		if ((R.dir == src.dir) && R.anchored)
			check |= 1
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))	//analysing upper-left turf from src direction
		if ((R.dir == Rturn) && R.anchored)
			check |= 64
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, (Rturn + src.dir)))	//analysing upper-right turf from src direction
		if ((R.dir == Lturn) && R.anchored)
			check |= 4
			if (UpdateNeighbors)
				R.update_icon(0)

/obj/structure/railing/update_icon(var/UpdateNeighgors = 1)
	NeighborsCheck(UpdateNeighgors)
	overlays.Cut()
	if (!check || !anchored)
		icon_state = "[icon_modifier]railing0"
	else
		icon_state = "[icon_modifier]railing1"
		//left side
		if (check & 32)
			overlays += image ('icons/obj/railing.dmi', src, "[icon_modifier]corneroverlay")
		if ((check & 16) || !(check & 32) || (check & 64))
			overlays += image ('icons/obj/railing.dmi', src, "[icon_modifier]frontoverlay_l")
		if (!(check & 2) || (check & 1) || (check & 4))
			overlays += image ('icons/obj/railing.dmi', src, "[icon_modifier]frontoverlay_r")
			if(check & 4)
				switch (src.dir)
					if (NORTH)
						overlays += image ('icons/obj/railing.dmi', src, "[icon_modifier]mcorneroverlay", pixel_x = 32)
					if (SOUTH)
						overlays += image ('icons/obj/railing.dmi', src, "[icon_modifier]mcorneroverlay", pixel_x = -32)
					if (EAST)
						overlays += image ('icons/obj/railing.dmi', src, "[icon_modifier]mcorneroverlay", pixel_y = -32)
					if (WEST)
						overlays += image ('icons/obj/railing.dmi', src, "[icon_modifier]mcorneroverlay", pixel_y = 32)

/obj/structure/railing/verb/rotate()
	set name = "Rotate Railing Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, SPAN_NOTICE("It is fastened to the floor therefore you can't rotate it!"))
		return 0

	set_dir(turn(dir, 90))
	update_icon()
	return

/obj/structure/railing/verb/revrotate()
	set name = "Rotate Railing Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, SPAN_NOTICE("It is fastened to the floor therefore you can't rotate it!"))
		return 0

	set_dir(turn(dir, -90))
	update_icon()
	return

/obj/structure/railing/verb/flip(var/mob/living/user as mob) // This will help push railing to remote places, such as open space turfs
	set name = "Flip Railing"
	set category = "Object"
	set src in oview(1)

	if(user.incapacitated())
		return 0

	if(anchored)
		to_chat(user, SPAN_NOTICE("It is fastened to the floor therefore you can't flip it!"))
		return 0

	if(!neighbor_turf_passable())
		to_chat(user, SPAN_NOTICE("You can't flip the [src] because something blocking it."))
		return 0

	src.loc = get_step(src, src.dir)
	set_dir(turn(dir, 180))
	update_icon()
	return



/obj/structure/railing/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/railing/affect_grab(var/mob/user, var/mob/living/target, var/state)
	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, SPAN_DANGER("There's \a [occupied] in the way."))
		return
	if (state < GRAB_AGGRESSIVE)
		if(user.a_intent == I_HURT)
			if(prob(15))
				target.Weaken(5)
			target.damage_through_armor(8, BRUTE, BP_HEAD, ARMOR_MELEE)
			take_damage(8)
			visible_message(SPAN_DANGER("[user] slams [target]'s face against \the [src]!"))
			playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		else
			to_chat(user, SPAN_DANGER("You need a better grip to do that!"))
			return
	else
		if (get_turf(target) == get_turf(src))
			target.forceMove(get_step(src, src.dir))
		else
			target.forceMove(get_turf(src))
		target.Weaken(5)
		visible_message(SPAN_DANGER("[user] throws [target] over \the [src]!"))
	return TRUE

/obj/structure/railing/attackby(obj/item/I, mob/user)
	var/list/usable_qualities = list(QUALITY_SCREW_DRIVING)
	if(health < maxhealth)
		usable_qualities.Add(QUALITY_WELDING)
	if(!anchored)
		usable_qualities.Add(QUALITY_BOLT_TURNING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_SCREW_DRIVING)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				to_chat(user, (anchored ? SPAN_NOTICE("You have unfastened \the [src] from the floor.") : SPAN_NOTICE("You have fastened \the [src] to the floor.")))
				anchored = !anchored
				update_icon()
			return

		if(QUALITY_WELDING)
			if(health < maxhealth)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					user.visible_message(SPAN_NOTICE("\The [user] repairs some damage to \the [src]."), SPAN_NOTICE("You repair some damage to \the [src]."))
					health = min(health+(maxhealth/5), maxhealth)//max(health+(maxhealth/5), maxhealth) // 20% repair per application
			return

		if(QUALITY_BOLT_TURNING)
			if(!anchored)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You dismantle \the [src]."))
					new /obj/item/stack/material/steel(src.loc, 4)
					qdel(src)
			return

		if(ABORT_CHECK)
			return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
	take_damage(I.force)

	return ..()

/obj/structure/railing/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

/obj/structure/railing/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	usr.visible_message(SPAN_WARNING("[user] starts climbing onto \the [src]!"))
	climbers |= user

	var/delay = (issmall(user) ? 20 : 34)
	var/duration = max(delay * user.stats.getMult(STAT_VIG, STAT_LEVEL_EXPERT), delay * 0.66)
	if(!do_after(user, duration))
		climbers -= user
		return

	if(!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	if(!neighbor_turf_passable())
		to_chat(user, SPAN_DANGER("You can't climb there, the way is blocked."))
		climbers -= user
		return

	if(get_turf(user) == get_turf(src))
		usr.forceMove(get_step(src, src.dir))
	else
		usr.forceMove(get_turf(src))

	usr.visible_message(SPAN_WARNING("[user] climbed over \the [src]!"))
	if(!anchored)	take_damage(maxhealth) // Fatboy
	climbers -= user

/obj/structure/railing/get_fall_damage(var/turf/from, var/turf/dest)
	var/damage = health * 0.4

	if (from && dest)
		damage *= abs(from.z - dest.z)

	return damage