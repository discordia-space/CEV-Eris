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

	// In case player wants to just drop a sheet of glass on a low wall, or smack it with an RCD
	if(user.a_intent == I_HURT)
		attackby_harm(I, user)
		return

	if((user.a_intent == I_GRAB) && is_low_wall && !window_type && user.unEquip(I, src))
		set_pixel_click_offset(I, params)
		return

	if(istype(I,/obj/item/rcd) || istype(I, /obj/item/reagent_containers))
		return

	if(isnull(deconstruction_steps_left))
		deconstruction_steps_left = is_reinforced ? 5 : 1

	// Most qualities available to try at all times
	var/list/usable_qualities = list(QUALITY_WELDING, QUALITY_HAMMERING, QUALITY_WIRE_CUTTING, QUALITY_PRYING, QUALITY_BOLT_TURNING)
	if(thermite)
		usable_qualities.Add(QUALITY_CAUTERIZING) // Can ignite thermite with a cigarette and such


	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_BOLT_TURNING) // deconstruction_steps_left == 5
			if(isnull(deconstruction_steps_left) || deconstruction_steps_left == 5) // Starting deconstruction
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					deconstruction_steps_left = 4 // Non-null value indicates that special overlay should be added on update_icon()
					update_icon()
					to_chat(user, SPAN_NOTICE("You remove the bolts that hold armor plates in place."))
			else if(deconstruction_steps_left == 4) // Reversing deconstruction
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					deconstruction_steps_left = null
					update_icon()
					to_chat(user, SPAN_NOTICE("You bolt the armor plates to the wall."))
			else
				to_chat(user, SPAN_NOTICE("There doesn't seem to be anything [tool_type] can acomplish."))
			return

		if(QUALITY_PRYING) // deconstruction_steps_left == 4
			if(window_type)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					var/material/glass/window_material = get_material_by_name(window_type)
					window_material.place_sheet(src, 6)
					window_type = null
					window_health = null
					window_max_health = null
					window_heat_resistance = null
					window_damage_resistance = null
					blocks_air = FALSE
					update_icon()
					SSair.mark_for_update(src)
					to_chat(user, SPAN_NOTICE("You pry the glass out of the frame."))
			else if(deconstruction_steps_left == 4) // Progressing deconstruction
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					deconstruction_steps_left = 3
					to_chat(user, SPAN_NOTICE("You pry off the armor plates."))
			else if(deconstruction_steps_left == 3) // Reversing deconstruction
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					deconstruction_steps_left = 4
					to_chat(user, SPAN_NOTICE("You lift the armor plates back in place."))
			else
				to_chat(user, SPAN_NOTICE("There doesn't seem to be anything [tool_type] can acomplish."))
			return

		if(QUALITY_WIRE_CUTTING) // deconstruction_steps_left == 3
			if(deconstruction_steps_left == 3) // Progressing deconstruction
				var/cutting_speed = WORKTIME_NORMAL
				if(I.get_tool_quality(QUALITY_HAMMERING) < 30)
					cutting_speed = WORKTIME_LONG
				else if(I.get_tool_quality(QUALITY_HAMMERING) > 30)
					cutting_speed = WORKTIME_FAST
				if(I.use_tool(user, src, cutting_speed, tool_type, FAILCHANCE_HARD, required_stat = STAT_MEC))
					deconstruction_steps_left = 2
					to_chat(user, SPAN_NOTICE("You cut the support beams."))
			else if(deconstruction_steps_left == 2) // Need a different tool to reverse this step
				to_chat(user, SPAN_NOTICE("You can't fix the cut support beams with more cutting, try welding instead."))
			else
				to_chat(user, SPAN_NOTICE("There doesn't seem to be anything [tool_type] can acomplish."))
			return

		if(QUALITY_HAMMERING) // deconstruction_steps_left == 2
			if(deconstruction_steps_left == 2) // Progressing deconstruction
				if(I.get_tool_quality(QUALITY_HAMMERING) < 15)
					to_chat(user, SPAN_NOTICE("This doesn't seem to be enough, you need a real hammer."))
				else if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					deconstruction_steps_left = 1
					to_chat(user, SPAN_NOTICE("You hammer the fragments of support beams out."))
			else if((deconstruction_steps_left == 1) && is_reinforced) // Reversing deconstruction for walls that require multiple steps
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					deconstruction_steps_left = 2
					to_chat(user, SPAN_NOTICE("You hammer the cut support beams back in place."))
			else
				to_chat(user, SPAN_NOTICE("There doesn't seem to be anything [tool_type] can acomplish."))
			return

		if(QUALITY_WELDING) // deconstruction_steps_left == 1
			if(thermite)
				if(I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You ignite the thermite!"))
					thermitemelt(user)

			else if(locate(/obj/effect/overlay/wallrot) in src)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You burn away the fungi."))
					for(var/obj/effect/overlay/wallrot/wallrot in src)
						qdel(wallrot)

			else if(deconstruction_steps_left == 1) // Finishing deconstruction
				if(I.use_tool(user, src, WORKTIME_SLOW, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You dismantle the [src]."))
					dismantle_wall()

			else if(deconstruction_steps_left == 2) // Reversing the wire cutting step
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					deconstruction_steps_left = 3
					to_chat(user, SPAN_NOTICE("You weld the cut pieces of support beams together."))

			else if(health < max_health)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					health = max_health
					deconstruction_steps_left = is_reinforced ? 5 : 1
					to_chat(user, SPAN_NOTICE("You repair the [src]."))
					clear_bulletholes()
					update_icon()
			else
				to_chat(user, SPAN_NOTICE("There doesn't seem to be anything [tool_type] can acomplish."))
			return

		if(QUALITY_CAUTERIZING)
			if(I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You ignite the thermite!"))
				thermitemelt(user)
			return

	if(!is_low_wall && istype(I, /obj/item/frame))
		var/obj/item/frame/F = I
		F.try_build(src)

	else if(is_low_wall && !window_type && ispath(I.type, /obj/item/stack/material/glass))
		var/obj/item/stack/material/glass/glass_stack = I
		if(glass_stack.get_amount() < 6)
			to_chat(user, SPAN_NOTICE("There isn't enough glass sheets, you need at least six."))
		else if(do_after(user, 40, src) && glass_stack.use(6))
			create_window(glass_stack.material.name)

	else if(is_low_wall && !window_type && user.unEquip(I, src))
		set_pixel_click_offset(I, params) // Place something on a low wall
	else
		attackby_harm(I, user)

// This exists to avoid code duplication in /turf/wall/attackby()
/turf/wall/proc/attackby_harm(obj/item/I, mob/user)
	if(I.force)
		var/attackforce = I.force * I.structure_damage_factor
		if(window_type)
			if(attackforce > (window_max_health / 20))
				take_damage(attackforce) // Playsound is included here
				visible_message(SPAN_DANGER("\The [user] hits the window with \the [I]!"))
			else
				visible_message(SPAN_DANGER("\The [user] hits the window with \the [I], but it bounces off!"))
		else if(attackforce > (max_health / 20))
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
	if(window_type)
		if(user.a_intent == I_HURT)
			playsound(src, 'sound/effects/glassknock.ogg', 100, 1, 10, 10)
			user.do_attack_animation(src)
			user.visible_message(SPAN_DANGER("\The [user] bangs against \the [src]!"),
								SPAN_DANGER("You bang against \the [src]!"),
								"You hear a banging sound.")
		else
			playsound(src, 'sound/effects/glassknock.ogg', 80, 1, 5, 5)
			user.visible_message("[user.name] knocks on the [name].",
								"You knock on the [name].",
								"You hear a knocking sound.")
		return

	to_chat(user, SPAN_NOTICE("You push the wall, but nothing happens."))
	playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
