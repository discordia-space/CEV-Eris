/turf/simulated/floor/attackby(obj/item/I, mob/user)

	if(!I || !user)
		return 0

	if(istype(I, /obj/item/stack/cable_coil) || (flooring && istype(I, /obj/item/stack/rods)))
		return ..(I, user)


	if(istype(I,/obj/item/frame))
		var/obj/item/frame/F = I
		F.try_floorbuild(src)
		return

	if (is_plating())
		if(istype(I, /obj/item/stack))
			if(is_damaged())
				user << SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage.")
				return
			var/obj/item/stack/S = I
			var/decl/flooring/use_flooring
			for(var/flooring_type in flooring_types)
				var/decl/flooring/F = flooring_types[flooring_type]
				if(!F.build_type)
					continue
				if((ispath(S.type, F.build_type) || ispath(S.build_type, F.build_type)) && ((S.type == F.build_type) || (S.build_type == F.build_type)))
					use_flooring = F
					break
			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				user << SPAN_WARNING("You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor].")
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time, src))
				return
			if(flooring || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return

	if(flooring)

		var/list/usable_qualities = list()
		if(is_damaged() || (flooring.flags & TURF_IS_FRAGILE) || (flooring.flags & TURF_REMOVE_CROWBAR))
			usable_qualities.Add(QUALITY_PRYING)
		if(!(is_damaged()) || flooring.flags & TURF_REMOVE_SCREWDRIVER)
			usable_qualities.Add(QUALITY_SCREW_DRIVING)
		if(flooring.flags & TURF_REMOVE_WRENCH)
			usable_qualities.Add(QUALITY_BOLT_TURNING)
		if(flooring.flags & TURF_REMOVE_SHOVEL)
			usable_qualities.Add(QUALITY_SHOVELING)
		if(is_damaged() || flooring.flags & TURF_REMOVE_WELDER)
			usable_qualities.Add(QUALITY_WELDING)

		var/tool_type = I.get_tool_type(user, usable_qualities)
		switch(tool_type)

			if(QUALITY_PRYING)
				if(is_damaged())
					if(I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
						user << SPAN_NOTICE("You remove the broken [flooring.descriptor].")
						make_plating()
					return
				else if(flooring.flags & TURF_IS_FRAGILE)
					if(I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
						user << SPAN_DANGER("You forcefully pry off the [flooring.descriptor], destroying them in the process.")
						make_plating()
					return
				else if(flooring.flags & TURF_REMOVE_CROWBAR)
					if(I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
						user << SPAN_NOTICE("You lever off the [flooring.descriptor].")
						make_plating(1)
					return
				return

			if(QUALITY_SCREW_DRIVING)
				if(!(is_damaged()) || flooring.flags & TURF_REMOVE_SCREWDRIVER)
					if(I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
						user << SPAN_NOTICE("You unscrew and remove the [flooring.descriptor].")
						make_plating(1)
				return

			if(QUALITY_BOLT_TURNING)
				if(flooring.flags & TURF_REMOVE_WRENCH)
					if(I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
						user << SPAN_NOTICE("You unwrench and remove the [flooring.descriptor].")
						make_plating(1)
				return

			if(QUALITY_SHOVELING)
				if(flooring.flags & TURF_REMOVE_SHOVEL)
					if(I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
						user << SPAN_NOTICE("You shovel off the [flooring.descriptor].")
						make_plating(1)
				return

			if(QUALITY_WELDING)
				if(is_damaged())
					if(I.use_tool(user, src, maxHealth - health, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_MEC))
						user << SPAN_NOTICE("You fix some dents on the broken plating.")
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						icon_state = "plating"
						health = maxHealth
						burnt = null
						broken = null
						update_icon()
						return

			if(ABORT_CHECK)
				return

		if(istype(I, /obj/item/stack/cable_coil) && flooring.flags & TURF_HIDES_THINGS)
			user << SPAN_WARNING("You must remove the [flooring.descriptor] first.")
			return
		else if (istype(I, /obj/item/frame))
			var/obj/item/frame/F = I
			F.try_floorbuild(src)
			return

	return ..()


/turf/simulated/floor/can_build_cable(var/mob/user)
	if(!is_plating() || flooring)
		user << SPAN_WARNING("Removing the tiling first.")
		return 0
	if(is_damaged())
		user << SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage.")
		return 0
	return 1
