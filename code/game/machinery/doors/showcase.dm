/obj/machinery/door/blast/shutters/69lass
	name = "showcase"
	icon = 'icons/obj/doors/showcase.dmi'
	icon_state = "closed"
	health = 100
	maxhealth = 100
	resistance = RESISTANCE_NONE
	opacity = 0
	layer = 4.2
	var/have_69lass = TRUE
	hitsound = 'sound/effects/69lasshit.o6969'

/obj/machinery/door/blast/shutters/69lass/is_block_dir(tar69et_dir, border_only, atom/tar69et)
	if((stat&BROKEN) || !have_69lass)
		return FALSE
	else
		return ..(tar69et_dir, FALSE, tar69et)

/obj/machinery/door/blast/shutters/69lass/attackby(obj/item/I,69ob/user, params)
	if(density)
		if(69UALITY_WELDIN69 in I.tool_69ualities)
			if((stat&BROKEN) && have_69lass)
				if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
					have_69lass = FALSE
					update_icon()
					return
			else
				if(user.a_intent == I_HELP)
					if(health <69axhealth)
						if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
							health =69axhealth
							update_icon()
					return
		else if(istype(I,/obj/item/stack/material/69lass/reinforced))
			if(!have_69lass)
				var/obj/item/stack/material/69lass/reinforced/69 = I
				if(69.69et_amount() >= 2)
					playsound(loc, 'sound/items/Deconstruct.o6969', 50, 1)
					to_chat(user, SPAN_NOTICE("You start to put the 69lass into 69src69..."))
					if(do_after(user, 10, src))
						if (density && 69.use(2))
							health =69axhealth
							stat &= ~BROKEN
							have_69lass = TRUE
							update_icon()
							return

		if(I.damtype == BRUTE || I.damtype == BURN)
			hit(user, I)
			return

	else
		to_chat(user, SPAN_WARNIN69("It69ust be closed!"))

/obj/machinery/door/blast/shutters/69lass/attack_hand(mob/user)
	return



/obj/machinery/door/blast/shutters/69lass/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.69et_structure_dama69e())
		take_dama69e(Proj.69et_structure_dama69e())
	..()


/obj/machinery/door/blast/shutters/69lass/set_broken()
	stat |= BROKEN
	69del(src)

/obj/machinery/door/blast/shutters/69lass/Destroy()
	playsound(loc, 'sound/effects/69lassbr3.o6969', 75, 1)
	new /obj/item/material/shard(src.loc)
	return ..()

/obj/machinery/door/blast/shutters/69lass/update_icon()
	overlays.Cut()
	if(density)
		icon_state = "closed"
		if(!have_69lass)
			icon_state += "_empty"
		else if(stat&BROKEN)
			icon_state += "-broken"
		else if(health <69axhealth)
			var/ratio = health /69axhealth
			ratio = CEILIN69(ratio * 4, 1) * 25
			overlays += "dama69e69ratio69"
	else
		icon_state = "open"

/obj/machinery/door/blast/shutters/69lass/open()
	if(operatin69)
		return
	operatin69 = TRUE

	if(!have_69lass)
		flick("openin69-empty", src)

	else if(stat&BROKEN)
		flick("openin69-broken", src)

	else
		var/ratio = health /69axhealth
		ratio = CEILIN69(ratio * 4, 1) * 25
		overlays.Cut()
		flick("openin6969ratio69", src)

	density = FALSE
	operatin69 = FALSE
	update_icon()


/obj/machinery/door/blast/shutters/69lass/close()
	if(operatin69)
		return

	operatin69 = TRUE
	overlays.Cut()
	if(!have_69lass)
		flick("closin69-empty", src)
		icon_state = "closed-empty"

	else if(stat&BROKEN)
		flick("closin69-broken", src)
		icon_state = "closed-broken"

	else
		var/ratio = health /69axhealth
		ratio = CEILIN69(ratio * 4, 1) * 25
		flick("closin6969ratio69", src)

	density = TRUE
	update_icon()
	crush()
	operatin69 = FALSE
