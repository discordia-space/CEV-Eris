var/list/floor_light_cache = list()

/obj/machinery/floor_light
	name = "floor light"
	icon = 'icons/obj/machines/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = FALSE
	use_power = ACTIVE_POWER_USE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = STATIC_LIGHT
	matter = list(MATERIAL_STEEL = 2, MATERIAL_GLASS = 3)

	var/on
	var/damaged
	var/default_light_range = 4
	var/default_light_power = 2
	var/default_light_colour = COLOR_LIGHTING_DEFAULT_BRIGHT

/obj/machinery/floor_light/prebuilt
	anchored = TRUE

/obj/machinery/floor_light/attackby(var/obj/item/I, var/mob/user)

	var/list/usable_qualities = list(QUALITY_PULSING, QUALITY_SCREW_DRIVING)
	if((damaged || (stat & BROKEN)))
		usable_qualities.Add(QUALITY_WELDING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_PULSING)
			if(on)
				to_chat(user, SPAN_WARNING("\The [src] must be turn off to change a color."))
				return
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				var/new_light_colour = input("Please select color.", "Color", rgb(255,255,255)) as color|null
				default_light_colour = new_light_colour
				update_brightness()
				return
			return

		if(QUALITY_WELDING)
			if((damaged || (stat & BROKEN)))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					visible_message(SPAN_NOTICE("\The [user] has repaired \the [src]."))
					stat &= ~BROKEN
					damaged = null
					update_brightness()
					return
			return

		if(QUALITY_SCREW_DRIVING)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				anchored = !anchored
				visible_message("<span class='notice'>\The [user] has [anchored ? "attached" : "detached"] \the [src].</span>")
				return
			return

		if(ABORT_CHECK)
			return

	if(I.force && user.a_intent == "hurt")
		attack_hand(user)
	return

/obj/machinery/floor_light/attack_hand(var/mob/user)

	if(user.a_intent == I_HURT && !issmall(user))
		if(!isnull(damaged) && !(stat & BROKEN))
			visible_message(SPAN_DANGER("\The [user] smashes \the [src]!"))
			playsound(src, "shatter", 70, 1)
			stat |= BROKEN
		else
			visible_message(SPAN_DANGER("\The [user] attacks \the [src]!"))
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
			if(isnull(damaged)) damaged = 0
		update_brightness()
		return
	else

		if(!anchored)
			to_chat(user, SPAN_WARNING("\The [src] must be screwed down first."))
			return

		if(stat & BROKEN)
			to_chat(user, SPAN_WARNING("\The [src] is too damaged to be functional."))
			return

		if(stat & NOPOWER)
			to_chat(user, SPAN_WARNING("\The [src] is unpowered."))
			return

		on = !on
		if(on) use_power = ACTIVE_POWER_USE
		visible_message("<span class='notice'>\The [user] turns \the [src] [on ? "on" : "off"].</span>")
		update_brightness()
		return

/obj/machinery/floor_light/Process()
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
		update_brightness()

/obj/machinery/floor_light/proc/update_brightness()
	if(on && use_power == 2)
		if(light_range != default_light_range || light_power != default_light_power || light_color != default_light_colour)
			set_light(default_light_range, default_light_power, default_light_colour)
	else
		use_power = NO_POWER_USE
		if(light_range || light_power)
			set_light(0)

	active_power_usage = ((light_range + light_power) * 10)
	update_icon()

/obj/machinery/floor_light/update_icon()
	overlays.Cut()
	if(use_power && !broken())
		if(isnull(damaged))
			var/cache_key = "floorlight-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("on")
				I.color = default_light_colour
				I.layer = ABOVE_OPEN_TURF_LAYER
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]
		else
			if(damaged == 0) //Needs init.
				damaged = rand(1,4)
			var/cache_key = "floorlight-broken[damaged]-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("flicker[damaged]")
				I.color = default_light_colour
				I.layer = ABOVE_OPEN_TURF_LAYER
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]

/obj/machinery/floor_light/proc/broken()
	return (stat & (BROKEN|NOPOWER))

/obj/machinery/floor_light/take_damage(amount)
	. = ..()
	if(QDELETED(src))
		return 0
	if(health/maxHealth < 0.5)
		stat |= BROKEN
	if(isnull(damaged))
		damaged = 0
	return 0

/obj/machinery/floor_light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = FALSE
	. = ..()
