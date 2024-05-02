/turf/wall/attack_generic(mob/user, damage, attack_message)
	if(!is_simulated)
		return
	ASSERT(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!damage)
		attack_hand(user)
	else if(damage >= hardness)
		to_chat(user, SPAN_DANGER("You smash through the wall!"))
		user.do_attack_animation(src)
		dismantle_wall(user)
	else
		playsound(src, pick(WALLHIT_SOUNDS), 50, 1)
		to_chat(user, SPAN_DANGER("You smash against the wall!"))
		user.do_attack_animation(src)
		take_damage(rand(15,45))

/turf/wall/attackby(obj/item/I, mob/user, params)
	if(!is_simulated)
		return
	ASSERT(I)
	ASSERT(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return
	// If user is not on turf, not in a mech, and holds a mech kit - do nothing?
	// Bruh. Makes little sense, but surely SPCR knew what he was doing
	if(!istype(user.loc, /turf))
		if(!(ismech(user.loc) && istype(I, /obj/item/tool/mech_kit)))
			return
	if(istype(I,/obj/item/rcd) || istype(I, /obj/item/reagent_containers))
		return

	var/list/usable_qualities = list(QUALITY_WELDING)
	if(window_type)
		usable_qualities.Add(QUALITY_PRYING) // Removing a window

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_WELDING)
			if(locate(/obj/effect/overlay/wallrot) in src)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You burn away the fungi with \the [I]."))
					for(var/obj/effect/overlay/wallrot/WR in src)
						qdel(WR)
			else if(thermite)
				if(I.use_tool(user, src, WORKTIME_INSTANT,tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You ignite the thermite with the [I]!"))
					thermitemelt(user)
			else if(health < maxHealth)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You repair the damage to [src]."))
					clear_bulletholes()
					take_damage(-health)
			else
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You dismantle the [src]."))
					dismantle_wall()
			return
		if(QUALITY_PRYING)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				var/material/glass/window_material = get_material_by_name(window_type)
				window_material.place_sheet(src, 6)
				window_type = null
				window_health = null
				window_maxHealth = null
				window_heat_resistance = null
				window_damage_resistance = null
				blocks_air = FALSE
				SSair.mark_for_update(src)
				update_icon()
				to_chat(user, SPAN_NOTICE("You pry the glass out of the frame."))
			return
	if(!is_low_wall && istype(I, /obj/item/frame))
		var/obj/item/frame/F = I
		F.try_build(src)

	else if(is_low_wall && istype(I, /obj/item/stack/material/glass))
		var/obj/item/stack/material/glass/glass_stack = I
		if(glass_stack.get_amount() < 6)
			to_chat(user, SPAN_NOTICE("There isn't enough glass sheets, you need at least six."))
		else if(do_after(user, 40, src) && glass_stack.use(6))
			create_window(glass_stack.material)

	else if(is_low_wall && user.a_intent != I_HURT && user.unEquip(I, loc))
		set_pixel_click_offset(I, params) // Place something on a low wall
	else if(I.force)
		var/attackforce = I.force * I.structure_damage_factor
		if(window_type)
			if(attackforce > (window_maxHealth / 10))
				take_damage(attackforce) // Playsound is included here
				visible_message(SPAN_DANGER("\The [user] hits the window with \the [I]!"))
			else
				visible_message(SPAN_DANGER("\The [user] hits the window with \the [I], but it bounces off!"))
		else if(attackforce > (maxHealth / 10))
			playsound(src, pick(WALLHIT_SOUNDS), 100, 5)
			take_damage(attackforce)
			visible_message(SPAN_DANGER("\The [user] attacks \the [src] with \the [I]!"))
		else
			visible_message(SPAN_DANGER("\The [user] attacks \the [src] with \the [I], but it bounces off!"))
		user.do_attack_animation(src)
	else
		attack_hand(user)

/turf/wall/attack_hand(mob/user)
	if(!is_simulated)
		return
	ASSERT(user)
	add_fingerprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	if(locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, SPAN_DANGER("The wall crumbles under your touch!"))
		dismantle_wall(user)
		return
	to_chat(user, SPAN_NOTICE("You push the wall, but nothing happens."))
	playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
