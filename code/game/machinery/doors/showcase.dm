/obj/machinery/door/blast/shutters/glass
	name = "showcase"
	icon = 'icons/obj/doors/showcase.dmi'
	icon_state = "closed"
	health = 200
	maxhealth = 200
	opacity = 0
	layer = 4.2
	var/have_glass = TRUE

/obj/machinery/door/blast/shutters/glass/is_block_dir(target_dir, border_only, atom/target)
	if((stat&BROKEN) || !have_glass)
		return FALSE
	else
		return ..(target_dir, FALSE, target)

/obj/machinery/door/blast/shutters/glass/attackby(obj/item/I, mob/user, params)
	if(density)
		if(QUALITY_WELDING in I.tool_qualities)
			if((stat&BROKEN) && have_glass)
				if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_PRD))
					have_glass = FALSE
					update_icon()
					return
			else
				if(user.a_intent == I_HELP)
					if(health < maxhealth)
						if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_PRD))
							health = maxhealth
							update_icon()
					return
		else if(istype(I,/obj/item/stack/material/glass/reinforced))
			if(!have_glass)
				var/obj/item/stack/material/glass/reinforced/G = I
				if(G.get_amount() >= 2)
					playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << SPAN_NOTICE("You start to put the glass into [src]...")
					if(do_after(user, 10, src))
						if (density && G.use(2))
							health = maxhealth
							stat &= ~BROKEN
							have_glass = TRUE
							update_icon()
							return

		if(I.damtype == BRUTE || I.damtype == BURN)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			user.do_attack_animation(src)
			hit(I.force)
			user.visible_message(
				SPAN_DANGER("[user] has hit the [name] with [I]!"),
			)

	else
		user << SPAN_WARNING("It must be closed!")

/obj/machinery/door/blast/shutters/glass/attack_hand(mob/user)
	return

/obj/machinery/door/blast/shutters/glass/hitby(AM as mob|obj)
	..()
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/throw_force = 0
	if(ismob(AM))
		throw_force = 10

	else if(isobj(AM))
		var/obj/item/I = AM
		throw_force = I.throwforce

	hit(throw_force)

/obj/machinery/door/blast/shutters/glass/ex_act(severity, target)
	..()
	if(stat&BROKEN)
		qdel(src)
		return
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			hit(200, 0)
			return
		if(3.0)
			hit(rand(50, 100), 0)
			return

/obj/machinery/door/blast/shutters/glass/bullet_act(var/obj/item/projectile/Proj)
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		hit(Proj.damage)
	..()

/obj/machinery/door/blast/shutters/glass/proc/hit(var/damage, var/sound_effect = 1)
	if(stat&BROKEN)
		return

	health = max(0, health - damage)
	if(sound_effect)
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
	if(health <= 0)
		stat |= BROKEN
		playsound(loc, 'sound/effects/Glassbr3.ogg', 75, 1)
		new /obj/item/weapon/material/shard(src.loc)
	update_icon()

/obj/machinery/door/blast/shutters/glass/Destroy()
	playsound(loc, 'sound/effects/Glassbr3.ogg', 75, 1)
	new /obj/item/weapon/material/shard(src.loc)
	return ..()

/obj/machinery/door/blast/shutters/glass/update_icon()
	overlays.Cut()
	if(density)
		icon_state = "closed"
		if(!have_glass)
			icon_state += "_empty"
		else if(stat&BROKEN)
			icon_state += "-broken"
		else if(health < maxhealth)
			var/ratio = health / maxhealth
			ratio = Ceiling(ratio * 4) * 25
			overlays += "damage[ratio]"
	else
		icon_state = "open"

/obj/machinery/door/blast/shutters/glass/open()
	if(operating)
		return
	operating = TRUE

	if(!have_glass)
		flick("opening-empty", src)

	else if(stat&BROKEN)
		flick("opening-broken", src)

	else
		var/ratio = health / maxhealth
		ratio = Ceiling(ratio * 4) * 25
		overlays.Cut()
		flick("opening[ratio]", src)

	density = 0
	operating = FALSE
	update_icon()


/obj/machinery/door/blast/shutters/glass/close()
	if(operating)
		return

	operating = TRUE
	overlays.Cut()
	if(!have_glass)
		flick("closing-empty", src)
		icon_state = "closed-empty"

	else if(stat&BROKEN)
		flick("closing-broken", src)
		icon_state = "closed-broken"

	else
		var/ratio = health / maxhealth
		ratio = Ceiling(ratio * 4) * 25
		flick("closing[ratio]", src)

	density = 1
	update_icon()
	crush()
	operating = FALSE
