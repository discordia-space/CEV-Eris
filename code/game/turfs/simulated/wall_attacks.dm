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
	// Bruh. Makes little sense to me, but surely SPCR knew what he was doing --KIROV
	if(!istype(user.loc, /turf))
		if(!(ismech(user.loc) && istype(I, /obj/item/tool/mech_kit)))
			return
	if(istype(I,/obj/item/rcd) || istype(I, /obj/item/reagent_containers))
		return

	var/list/usable_qualities = list(QUALITY_WELDING)
	if(is_low_wall)
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
		if(QUALITY_PRYING)
			return
			//
			//
			//

	if(istype(I, /obj/item/frame))
		var/obj/item/frame/F = I
		F.try_build(src)
	else if(is_low_wall && user.a_intent != I_HURT && user.unEquip(I, loc))
		set_pixel_click_offset(I, params) // Place something on a low wall
	else if(I.force)
		var/attackforce = I.force * I.structure_damage_factor
		if(attackforce > (maxHealth / 10))
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
	playsound(src, hitsound, 25, 1)
