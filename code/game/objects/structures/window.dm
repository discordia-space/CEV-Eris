/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures.dmi'
	density = 1
	w_class = ITEM_SIZE_NORMAL

	layer = 3.2//Just above doors
	anchored = 1.0
	flags = ON_BORDER
	var/maxhealth = 40
	var/maximal_heat = T0C + 100 		// Maximal heat before this window begins taking damage from fire
	var/damage_per_fire_tick = 2.0 		// Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/health
	var/ini_dir = null
	var/state = 2
	var/reinf = 0
	var/basestate
	var/shardtype = /obj/item/weapon/material/shard
	var/glasstype = null // Set this in subtypes. Null is assumed strange or otherwise impossible to dismantle, such as for shuttle glass.
	var/silicate = 0 // number of units of silicate

/obj/structure/window/can_prevent_fall()
	return !is_fulltile()

/obj/structure/window/examine(mob/user)
	. = ..(user)

	if(health == maxhealth)
		user << SPAN_NOTICE("It looks fully intact.")
	else
		var/perc = health / maxhealth
		if(perc > 0.75)
			user << SPAN_NOTICE("It has a few cracks.")
		else if(perc > 0.5)
			user << SPAN_WARNING("It looks slightly damaged.")
		else if(perc > 0.25)
			user << SPAN_WARNING("It looks moderately damaged.")
		else
			user << SPAN_DANGER("It looks heavily damaged.")
	if(silicate)
		if (silicate < 30)
			user << SPAN_NOTICE("It has a thin layer of silicate.")
		else if (silicate < 70)
			user << SPAN_NOTICE("It is covered in silicate.")
		else
			user << SPAN_NOTICE("There is a thick layer of silicate covering it.")

/obj/structure/window/proc/take_damage(var/damage = 0,  var/sound_effect = 1)
	var/initialhealth = health

	if(silicate)
		damage = damage * (1 - silicate / 200)

	health = max(0, health - damage)

	if(health <= 0)
		shatter()
	else
		if(sound_effect)
			playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
		if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
			visible_message("[src] looks like it's about to shatter!" )
		else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
			visible_message("[src] looks seriously damaged!" )
		else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
			visible_message("Cracks begin to appear in [src]!" )
	return

/obj/structure/window/proc/apply_silicate(var/amount)
	if(health < maxhealth) // Mend the damage
		health = min(health + amount * 3, maxhealth)
		if(health == maxhealth)
			visible_message("[src] looks fully repaired." )
	else // Reinforce
		silicate = min(silicate + amount, 100)
		updateSilicate()

/obj/structure/window/proc/updateSilicate()
	if (overlays)
		overlays.Cut()

	var/image/img = image(src.icon, src.icon_state)
	img.color = "#ffffff"
	img.alpha = silicate * 255 / 100
	overlays += img

/obj/structure/window/proc/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	if(dir == SOUTHWEST)
		var/index = null
		index = 0
		while(index < 2)
			new shardtype(loc) //todo pooling?
			if(reinf) PoolOrNew(/obj/item/stack/rods, loc)
			index++
	else
		new shardtype(loc) //todo pooling?
		if(reinf) PoolOrNew(/obj/item/stack/rods, loc)
	qdel(src)
	return


/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)

	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return

	..()
	take_damage(proj_damage)
	return


/obj/structure/window/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			shatter(0)
			return
		if(3.0)
			if(prob(50))
				shatter(0)
				return

//TODO: Make full windows a separate type of window.
//Once a full window, it will always be a full window, so there's no point
//having the same type for both.
/obj/structure/window/proc/is_full_window()
	return (dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(is_full_window())
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) & dir)
		return !density
	else
		return 1


/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1


/obj/structure/window/hitby(AM as mob|obj)
	..()
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf) tforce *= 0.25
	if(health - tforce <= 7 && !reinf)
		set_anchored(FALSE)
		step(src, get_dir(AM, src))
	take_damage(tforce)

/obj/structure/window/attack_tk(mob/user as mob)
	user.visible_message(SPAN_NOTICE("Something knocks on [src]."))
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)

/obj/structure/window/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message(SPAN_DANGER("[user] smashes through [src]!"))
		user.do_attack_animation(src)
		shatter()

	else if (usr.a_intent == I_HURT)

		if (ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if(H.species.can_shred(H))
				attack_generic(H,25)
				return

		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.do_attack_animation(src)
		usr.visible_message(SPAN_DANGER("\The [usr] bangs against \the [src]!"),
							SPAN_DANGER("You bang against \the [src]!"),
							"You hear a banging sound.")
	else
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		usr.visible_message("[usr.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
	return

/obj/structure/window/attack_generic(var/mob/user, var/damage)
	if(istype(user))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
	if(!damage)
		return
	if(damage >= 10)
		visible_message(SPAN_DANGER("[user] smashes into [src]!"))
		take_damage(damage)
	else
		visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly."))
	return 1

/obj/structure/window/affect_grab(var/mob/living/user, var/mob/living/target, var/state)
	switch(state)
		if(GRAB_PASSIVE)
			visible_message(SPAN_WARNING("[user] slams [target] against \the [src]!"))
			target.apply_damage(7)
			hit(10)
		if(GRAB_AGGRESSIVE)
			visible_message(SPAN_DANGER("[user] bashes [target] against \the [src]!"))
			if(prob(50))
				target.Weaken(1)
			target.apply_damage(10)
			hit(25)
		if(GRAB_NECK)
			visible_message(SPAN_DANGER("<big>[user] crushes [target] against \the [src]!</big>"))
			target.Weaken(5)
			target.apply_damage(20)
			hit(50)
	admin_attack_log(user, target,
		"Smashed [key_name(target)] against \the [src]",
		"Smashed against \the [src] by [key_name(user)]",
		"smashed [key_name(target)] against \the [src]."
	)
	return TRUE


/obj/structure/window/attackby(obj/item/I, mob/user)

	var/list/usable_qualities = list()
	if(!anchored && (!state || !reinf))
		usable_qualities.Add(QUALITY_BOLT_TURNING)
	if((reinf && state >= 1) || (reinf && state == 0) || (!reinf))
		usable_qualities.Add(QUALITY_SCREW_DRIVING)
	if(reinf && state >= 1)
		usable_qualities.Add(QUALITY_PRYING)

	var/tool_type = I.get_tool_type(user, usable_qualities)
	switch(tool_type)

		if(QUALITY_BOLT_TURNING)
			if(!anchored && (!state || !reinf))
				if(!glasstype)
					user << SPAN_NOTICE("You're not sure how to dismantle \the [src] properly.")
					return
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_PRD))
					visible_message(SPAN_NOTICE("[user] dismantles \the [src]."))
					if(dir == SOUTHWEST)
						var/obj/item/stack/material/mats = new glasstype(loc)
						mats.amount = is_fulltile() ? 4 : 2
					else
						new glasstype(loc)
					qdel(src)
					return
			return

		if(QUALITY_PRYING)
			if(reinf && state <= 1)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_PRD))
					state = 1 - state
					user << (state ? SPAN_NOTICE("You have pried the window into the frame.") : SPAN_NOTICE("You have pried the window out of the frame."))
			return


		if(QUALITY_SCREW_DRIVING)
			if(reinf && state >= 1)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY, required_stat = STAT_PRD))
					state = 3 - state
					update_nearby_icons()
					user << (state == 1 ? SPAN_NOTICE("You have unfastened the window from the frame.") : SPAN_NOTICE("You have fastened the window to the frame."))
					return
			if(reinf && state == 0)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY, required_stat = STAT_PRD))
					set_anchored(!anchored)
					user << (anchored ? SPAN_NOTICE("You have fastened the frame to the floor.") : SPAN_NOTICE("You have unfastened the frame from the floor."))
					return
			if(!reinf)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY))
					set_anchored(!anchored)
					user << (anchored ? SPAN_NOTICE("You have fastened the window to the floor.") : SPAN_NOTICE("You have unfastened the window."))
					return
			return

		if(ABORT_CHECK)
			return

	if(!istype(I)) return//I really wish I did not need this
	if(I.flags & NOBLUDGEON) return

	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(I.damtype == BRUTE || I.damtype == BURN)
			user.do_attack_animation(src)
			hit(I.force)
			if(health <= 7)
				set_anchored(FALSE)
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/proc/hit(var/damage, var/sound_effect = 1)
	if(reinf) damage *= 0.5
	take_damage(damage)
	return


/obj/structure/window/proc/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 90))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return


/obj/structure/window/proc/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 270))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return

/obj/structure/window/New(Loc, start_dir=null, constructed=0)
	..()

	//player-constructed windows
	if (constructed)
		set_anchored(FALSE)

	if (start_dir)
		set_dir(start_dir)

	health = maxhealth

	ini_dir = dir

	update_nearby_tiles(need_rebuild=1)
	update_nearby_icons()


/obj/structure/window/Destroy()
	density = 0
	update_nearby_tiles()
	var/turf/location = loc
	loc = null
	for(var/obj/structure/window/W in orange(location, 1))
		W.update_icon()
	loc = location
	. = ..()

/obj/structure/window/Move()
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

/obj/structure/window/proc/set_anchored(var/new_anchored)
	if(anchored == new_anchored)
		return
	anchored = new_anchored
	update_verbs()
	update_nearby_icons()

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

//Updates the availabiliy of the rotation verbs
/obj/structure/window/proc/update_verbs()
	if(anchored)
		verbs -= /obj/structure/window/proc/rotate
		verbs -= /obj/structure/window/proc/revrotate
	else
		verbs += /obj/structure/window/proc/rotate
		verbs += /obj/structure/window/proc/revrotate

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	overlays.Cut()
	if(!is_fulltile())
		icon_state = "[basestate]"
		return
	var/list/dirs = list()
	if(anchored)
		for(var/obj/structure/window/W in orange(src,1))
			if(W.anchored && W.density && W.type == src.type && W.is_fulltile()) //Only counts anchored, not-destroyed fill-tile windows.
				dirs += get_dir(src, W)

	var/list/connections = dirs_to_corner_states(dirs)

	icon_state = ""
	for(var/i = 1 to 4)
		var/image/I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1))
		overlays += I

	return

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > maximal_heat)
		hit(damage_per_fire_tick, 0)
	..()



/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... anything, really should shatter it."
	icon_state = "window"
	basestate = "window"
	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 100
	damage_per_fire_tick = 2.0
	maxhealth = 60

/obj/structure/window/basic/full
	dir = SOUTH|EAST
	icon_state = "fwindow"

/obj/structure/window/plasmabasic
	name = "plasma window"
	desc = "A borosilicate alloy window. It seems to be quite strong."
	basestate = "plasmawindow"
	icon_state = "plasmawindow"
	shardtype = /obj/item/weapon/material/shard/plasma
	glasstype = /obj/item/stack/material/glass/plasmaglass
	maximal_heat = T0C + 2000
	damage_per_fire_tick = 1.0
	maxhealth = 300

/obj/structure/window/plasmabasic/full
	dir = SOUTH|EAST
	icon_state = "plasmawindow_mask"

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	maxhealth = 200
	reinf = 1
	maximal_heat = T0C + 750
	damage_per_fire_tick = 2.0
	glasstype = /obj/item/stack/material/glass/reinforced

/obj/structure/window/New(Loc, constructed=0)
	..()

	//player-constructed windows
	if (constructed)
		state = 0

/obj/structure/window/reinforced/full
	dir = SOUTH|EAST
	icon_state = "fwindow"

/obj/structure/window/reinforced/plasma
	name = "reinforced borosilicate window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	basestate = "plasmarwindow"
	icon_state = "plasmarwindow"
	shardtype = /obj/item/weapon/material/shard/plasma
	glasstype = /obj/item/stack/material/glass/plasmarglass
	maximal_heat = T0C + 9000
	damage_per_fire_tick = 1.0 // This should last for 80 fire ticks if the window is not damaged at all. The idea is that borosilicate windows have something like ablative layer that protects them for a while.
	maxhealth = 600

/obj/structure/window/reinforced/plasma/full
	dir = SOUTH|EAST
	icon_state = "plasmarwindow_mask"

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	basestate = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	basestate = "fwindow"
	maxhealth = 250

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "window"
	basestate = "window"
	maxhealth = 800
	reinf = 1
	basestate = "w"
	dir = 5

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	var/id

/obj/structure/window/reinforced/polarized/proc/toggle()
	if(opacity)
		animate(src, color="#FFFFFF", time=5)
		set_opacity(0)
	else
		animate(src, color="#222222", time=5)
		set_opacity(1)

/obj/structure/window/reinforced/crescent/attack_hand()
	return

/obj/structure/window/reinforced/crescent/attackby()
	return

/obj/structure/window/reinforced/crescent/ex_act()
	return

/obj/structure/window/reinforced/crescent/hitby()
	return

/obj/structure/window/reinforced/crescent/take_damage()
	return

/obj/structure/window/reinforced/crescent/shatter()
	return

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for polarized windows."
	var/range = 7

/obj/machinery/button/windowtint/attack_hand(mob/user as mob)
	if(..())
		return 1

	toggle_tint()

/obj/machinery/button/windowtint/proc/toggle_tint()
	use_power(5)

	active = !active
	update_icon()

	for(var/obj/structure/window/reinforced/polarized/W in range(src,range))
		if (W.id == src.id || !W.id)
			spawn(0)
				W.toggle()
				return

/obj/machinery/button/windowtint/power_change()
	..()
	if(active && !powered(power_channel))
		toggle_tint()

/obj/machinery/button/windowtint/update_icon()
	icon_state = "light[active]"
