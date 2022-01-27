var/list/floor_li69ht_cache = list()

/obj/machinery/floor_li69ht
	name = "floor li69ht"
	icon = 'icons/obj/machines/floor_li69ht.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = FALSE
	use_power = ACTIVE_POWER_USE
	idle_power_usa69e = 2
	active_power_usa69e = 20
	power_channel = STATIC_LI69HT
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_69LASS = 3)

	var/on
	var/dama69ed
	var/default_li69ht_ran69e = 4
	var/default_li69ht_power = 2
	var/default_li69ht_colour = COLOR_LI69HTIN69_DEFAULT_BRI69HT

/obj/machinery/floor_li69ht/prebuilt
	anchored = TRUE

/obj/machinery/floor_li69ht/attackby(var/obj/item/I,69ar/mob/user)

	var/list/usable_69ualities = list(69UALITY_PULSIN69, 69UALITY_SCREW_DRIVIN69)
	if((dama69ed || (stat & BROKEN)))
		usable_69ualities.Add(69UALITY_WELDIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_PULSIN69)
			if(on)
				to_chat(user, SPAN_WARNIN69("\The 69src6969ust be turn off to chan69e a color."))
				return
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				var/new_li69ht_colour = input("Please select color.", "Color", r69b(255,255,255)) as color|null
				default_li69ht_colour = new_li69ht_colour
				update_bri69htness()
				return
			return

		if(69UALITY_WELDIN69)
			if((dama69ed || (stat & BROKEN)))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					visible_messa69e(SPAN_NOTICE("\The 69user69 has repaired \the 69src69."))
					stat &= ~BROKEN
					dama69ed = null
					update_bri69htness()
					return
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				anchored = !anchored
				visible_messa69e("<span class='notice'>\The 69user69 has 69anchored ? "attached" : "detached"69 \the 69src69.</span>")
				return
			return

		if(ABORT_CHECK)
			return

	if(I.force && user.a_intent == "hurt")
		attack_hand(user)
	return

/obj/machinery/floor_li69ht/attack_hand(var/mob/user)

	if(user.a_intent == I_HURT && !issmall(user))
		if(!isnull(dama69ed) && !(stat & BROKEN))
			visible_messa69e(SPAN_DAN69ER("\The 69user69 smashes \the 69src69!"))
			playsound(src, "shatter", 70, 1)
			stat |= BROKEN
		else
			visible_messa69e(SPAN_DAN69ER("\The 69user69 attacks \the 69src69!"))
			playsound(src.loc, 'sound/effects/69lasshit.o6969', 75, 1)
			if(isnull(dama69ed)) dama69ed = 0
		update_bri69htness()
		return
	else

		if(!anchored)
			to_chat(user, SPAN_WARNIN69("\The 69src6969ust be screwed down first."))
			return

		if(stat & BROKEN)
			to_chat(user, SPAN_WARNIN69("\The 69src69 is too dama69ed to be functional."))
			return

		if(stat & NOPOWER)
			to_chat(user, SPAN_WARNIN69("\The 69src69 is unpowered."))
			return

		on = !on
		if(on) use_power = ACTIVE_POWER_USE
		visible_messa69e("<span class='notice'>\The 69user69 turns \the 69src69 69on ? "on" : "off"69.</span>")
		update_bri69htness()
		return

/obj/machinery/floor_li69ht/Process()
	..()
	var/need_update
	if((!anchored || broken()) && on)
		use_power = NO_POWER_USE
		on = FALSE
		need_update = 1
	else if(use_power && !on)
		use_power = NO_POWER_USE
		need_update = 1
	if(need_update)
		update_bri69htness()

/obj/machinery/floor_li69ht/proc/update_bri69htness()
	if(on && use_power == 2)
		if(li69ht_ran69e != default_li69ht_ran69e || li69ht_power != default_li69ht_power || li69ht_color != default_li69ht_colour)
			set_li69ht(default_li69ht_ran69e, default_li69ht_power, default_li69ht_colour)
	else
		use_power = NO_POWER_USE
		if(li69ht_ran69e || li69ht_power)
			set_li69ht(0)

	active_power_usa69e = ((li69ht_ran69e + li69ht_power) * 10)
	update_icon()

/obj/machinery/floor_li69ht/update_icon()
	overlays.Cut()
	if(use_power && !broken())
		if(isnull(dama69ed))
			var/cache_key = "floorli69ht-69default_li69ht_colour69"
			if(!floor_li69ht_cache69cache_key69)
				var/ima69e/I = ima69e("on")
				I.color = default_li69ht_colour
				I.layer = ABOVE_OPEN_TURF_LAYER
				floor_li69ht_cache69cache_key69 = I
			overlays |= floor_li69ht_cache69cache_key69
		else
			if(dama69ed == 0) //Needs init.
				dama69ed = rand(1,4)
			var/cache_key = "floorli69ht-broken69dama69ed69-69default_li69ht_colour69"
			if(!floor_li69ht_cache69cache_key69)
				var/ima69e/I = ima69e("flick_li69ht69dama69ed69")
				I.color = default_li69ht_colour
				I.layer = ABOVE_OPEN_TURF_LAYER
				floor_li69ht_cache69cache_key69 = I
			overlays |= floor_li69ht_cache69cache_key69

/obj/machinery/floor_li69ht/proc/broken()
	return (stat & (BROKEN|NOPOWER))

/obj/machinery/floor_li69ht/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
		if(2)
			if (prob(50))
				69del(src)
			else if(prob(20))
				stat |= BROKEN
			else
				if(isnull(dama69ed))
					dama69ed = 0
		if(3)
			if (prob(5))
				69del(src)
			else if(isnull(dama69ed))
				dama69ed = 0
	return

/obj/machinery/floor_li69ht/Destroy()
	var/area/A = 69et_area(src)
	if(A)
		on = FALSE
	. = ..()
