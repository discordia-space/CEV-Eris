/obj/structure/railing
	name = "orange railing"
	desc = "A standard steel railing painted in copper color. Prevents stupid people from falling to their doom."
	description_info = "Can be deconstructed by screwing and wrenching."
	description_antag = "Hopping above these leaves fingerprints. You can also grab a person and throw them over the ledge instantly."
	icon = 'icons/obj/railing.dmi'
	density = TRUE
	throwpass = TRUE
	climbable = TRUE
	layer = 3.2	//Just above doors
	anchored = TRUE
	flags = ON_BORDER
	icon_state = "railing0"
	matter = list(MATERIAL_STEEL = 2)
	var/broken = 0
	health=70
	maxHealth=70
	explosion_coverage = 0
	var/check = 0
	var/reinforced = FALSE
	var/reinforcement_security = 0 // extra health from being reinforced, hardcoded to 40 on add
	var/icon_modifier = ""	//adds string to icon path for color variations

/obj/structure/railing/grey
	name = "grey railing"
	desc = "A standard steel railing. Prevents stupid people from falling to their doom."
	icon_modifier = "grey_"
	icon_state = "grey_railing0"

/obj/structure/railing/Initialize()
	. = ..()
	update_icon(FALSE)

/obj/structure/railing/New(loc)
	..()
	if(climbable)
		verbs += /obj/structure/proc/climb_on

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

	if(!reinforced && istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1
//32 and 4 - in the same turf

/obj/structure/railing/examine(mob/user)
	. = ..()
	if(health < maxHealth)
		switch(health / maxHealth)
			if(0 to 0.25)
				to_chat(user, SPAN_WARNING("It looks severely damaged!"))
			if(0.25 to 0.5)
				to_chat(user, SPAN_WARNING("It looks damaged!"))
			if(0.5 to 1)
				to_chat(user, SPAN_NOTICE("It has a few scrapes and dents."))
	if(reinforced)
		var/reinforcement_text = "It is reinforced with rods"
		switch(reinforcement_security)
			if (0 to 1)
				reinforcement_text += ", which are barely hanging on"
			if (1 to 20)
				reinforcement_text += ", which are loosely attached"
			if (20 to 30)
				reinforcement_text += ", which are a bit loose"
		to_chat(user, SPAN_NOTICE("[reinforcement_text].")) // MY rods(?) were a bit loose while writing this

/obj/structure/railing/take_damage(amount)
	. = health - amount < 0 ? amount - health : amount
	. *= explosion_coverage
	if (reinforced)
		if (reinforcement_security == 0)
			visible_message(SPAN_WARNING("[src]'s reinforcing rods fall off!"))
			reinforced = FALSE
			var/obj/item/stack/rodtoedit = new /obj/item/stack/rods(src.loc)
			rodtoedit.amount = 2
			playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
			return
		reinforcement_security = max(0, reinforcement_security - amount)
		return
	health -= amount
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] breaks down!"))
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		new /obj/item/stack/rods(get_turf(usr))
		qdel(src)
	return

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

/obj/structure/railing/update_icon(var/UpdateNeighbors = 1)
	NeighborsCheck(UpdateNeighbors)
	cut_overlays()
	if (!check || !anchored)
		icon_state = "[icon_modifier][reinforced ? "reinforced_": null]railing0"
	else
		icon_state = "[icon_modifier][reinforced ? "reinforced_": null]railing1"
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
	if(!reinforced && istype(O) && O.checkpass(PASSTABLE))
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
			target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been slammed by [user.name] ([user.ckey] against \the [src])</font>"
			user.attack_log += "\[[time_stamp()]\] <font color='red'>Slammed [target.name] ([target.ckey] against over \the [src])</font>"
			msg_admin_attack("[user] slammed a [target] against \the [src].")
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
		target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been throwed by [user.name] ([user.ckey] over \the [src])</font>"
		user.attack_log += "\[[time_stamp()]\] <font color='red'>Throwed [target.name] ([target.ckey] over \the [src])</font>"
		msg_admin_attack("[user] throwed a [target] over \the [src].")
	return TRUE

/obj/structure/railing/attackby(obj/item/I, mob/user)
	var/list/usable_qualities = list(QUALITY_SCREW_DRIVING)
	if(health < maxHealth)
		usable_qualities.Add(QUALITY_WELDING)
	if(!anchored || reinforced)
		usable_qualities.Add(QUALITY_BOLT_TURNING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_SCREW_DRIVING)
			if(reinforcement_security)
				to_chat(user, SPAN_NOTICE("You cannot remove [src]'s reinforcement when it's this tightly secured."))
			else if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				if(!reinforced)
					to_chat(user, (anchored ? SPAN_NOTICE("You have unfastened \the [src] from the floor.") : SPAN_NOTICE("You have fastened \the [src] to the floor.")))
					anchored = !anchored
					update_icon()
				else if (!reinforcement_security)
					to_chat(user, SPAN_NOTICE("You remove the reinforcing rods from [src]"))
					var/obj/item/stack/rodtoedit = new /obj/item/stack/rods(get_turf(usr))
					rodtoedit.amount = 2
					reinforced = FALSE
					reinforcement_security = 0
					update_icon()
			return

		if(QUALITY_WELDING)
			if(health < maxHealth)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					user.visible_message(SPAN_NOTICE("\The [user] repairs some damage to \the [src]."), SPAN_NOTICE("You repair some damage to \the [src]."))
					health = min(health+(maxHealth/5), maxHealth)//max(health+(maxHealth/5), maxHealth) // 20% repair per application
			return

		if(QUALITY_BOLT_TURNING)
			if(!anchored)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You dismantle \the [src]."))
					drop_materials(get_turf(user), user)
					qdel(src)
			if(reinforced)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					if(reinforcement_security)
						user.visible_message(SPAN_NOTICE("[user] unsecures [src]'s reinforcing rods."), SPAN_NOTICE("You unsecure [src]'s reinforcing rods."))
						reinforcement_security = 0
					else
						user.visible_message(SPAN_NOTICE("[user] secures [src]'s reinforcing rods."), SPAN_NOTICE("You secure [src]'s reinforcing rods."))
						reinforcement_security = 40

			return

		if(ABORT_CHECK)
			return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(I, /obj/item/stack/rods) && user.a_intent != I_HURT)
		if(!reinforced && anchored)
			var/obj/item/stack/rod = I
			if(rod.get_amount() >= 2)
				rod.use(2)
				reinforced = TRUE
				reinforcement_security = 40
				user.visible_message(SPAN_NOTICE("[user] reinforces [src] with rods."), SPAN_NOTICE("You reinforce [src] with rods."))
				update_icon()
				return
			else
				to_chat(user, SPAN_NOTICE("This is not enough rods to reinforce [src], it requires two."))
		else
			to_chat(user, SPAN_NOTICE("In its current state, [src] is not valid to reinforce."))
			return
	playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
	take_damage(I.force)

	return ..()

/obj/structure/railing/attack_generic(mob/M, damage, attack_message)
	if(damage)
		M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		M.do_attack_animation(src)
		M.visible_message(SPAN_DANGER("\The [M] [attack_message] \the [src]!"))
		playsound(loc, 'sound/effects/metalhit2.ogg', 50, 1)
		take_damage(damage)
	else
		attack_hand(M)

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
	if(!anchored)	take_damage(maxHealth) // Fatboy
	climbers -= user

/obj/structure/railing/get_fall_damage(var/turf/from, var/turf/dest)
	var/damage = health * 0.4

	if (from && dest)
		damage *= abs(from.z - dest.z)

	return damage

/obj/structure/railing/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	take_damage(P.get_structure_damage())

