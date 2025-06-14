/obj/machinery/holoposter
	name = "Holographic Poster"
	desc = "A wall-mounted holographic projector displaying advertisements by all manner of factions. How much do they pay to advertise here?"
	icon = 'icons/obj/holoposter.dmi'
	icon_state = "off"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 80
	power_channel = STATIC_ENVIRON

	var/static/list/poster_types = list(
		"ironhammer" = COLOR_LIGHTING_BLUE_BRIGHT,
		"frozenstar" = COLOR_LIGHTING_BLUE_BRIGHT,
		"neotheology" = COLOR_LIGHTING_ORANGE_BRIGHT,
		"asters" = COLOR_LIGHTING_GREEN_BRIGHT,
		"tehnomancers" = COLOR_LIGHTING_ORANGE_BRIGHT,
		"moebius" = COLOR_LIGHTING_PURPLE_BRIGHT,
		"med" = COLOR_LIGHTING_GREEN_BRIGHT
	)

	var/selected_icon = "moebius"
	var/icon_forced = FALSE
	var/last_launch = 0

/obj/machinery/holoposter/update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
		set_light(0)
		return

	var/new_color = COLOR_LIGHTING_DEFAULT_BRIGHT
	if(stat & BROKEN)
		icon_state = "glitch"
		new_color = COLOR_LIGHTING_SCI_BRIGHT
	else
		var/decl/security_state/security_state = decls_repository.get_decl(SSmapping.security_state)
		if(security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level))
			icon_state = "attention"
			new_color =  "#AA7039"
		else if(selected_icon)
			new_color = poster_types[selected_icon]

	set_light(l_range = 2, l_power = 2, l_color = new_color)

/obj/machinery/holoposter/attackby(obj/item/W, mob/user)
	add_fingerprint(user)
	if(stat & (NOPOWER))
		return

	if(istype(W, /obj/item/tool/multitool))
		ui_interact(user)
		return

/obj/machinery/holoposter/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/holoposter/power_change()
	var/wasUnpowered = stat & NOPOWER
	..()
	if(wasUnpowered != (stat & NOPOWER))
		update_icon()

/obj/machinery/holoposter/emp_act()
	stat |= BROKEN
	update_icon()

/obj/machinery/holoposter/Process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!icon_forced && world.time > last_launch + 1 MINUTES)
		last_launch = world.time
		select_icon(null)
		update_icon()

/obj/machinery/holoposter/ui_state(mob/user)
	return GLOB.holoposter_state

/obj/machinery/holoposter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Holoposter", name)
		ui.open()

/obj/machinery/holoposter/ui_static_data(mob/user)
	return list(
		"posterTypes" = poster_types,
	)

/obj/machinery/holoposter/ui_data(mob/user)
	var/static/list/icon_chache
	if(!icon_chache)
		for(var/icon_state as anything in poster_types)
			LAZYADD(icon_chache, icon_state)
			icon_chache[icon_state] = icon(icon, icon_state, frame = 1)

	return list(
		"isRandom" = !icon_forced,
		"selected" = selected_icon,
		"icon" = icon2base64html(icon_chache[selected_icon])
	)

/obj/machinery/holoposter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("change")
			change(params["value"])
			. = TRUE

		if("random")
			random()
			. = TRUE

/obj/machinery/holoposter/proc/change(new_icon_state)
	select_icon(new_icon_state)
	stat &= ~BROKEN
	update_icon()

/obj/machinery/holoposter/proc/random()
	icon_forced = !icon_forced
	stat &= ~BROKEN

/obj/machinery/holoposter/proc/select_icon(new_icon)
	selected_icon = (new_icon in poster_types) ? new_icon : pick(poster_types)
	icon_forced = !isnull(new_icon)
	icon_state = selected_icon
