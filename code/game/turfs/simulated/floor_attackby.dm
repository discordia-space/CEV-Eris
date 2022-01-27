/turf/simulated/floor/attackby(obj/item/I,69ob/user)

	if(!I || !user)
		return 0

	if(istype(src, /turf/simulated/floor/platin69/under) && (istype(I, /obj/item/stack/material/cybor69/steel) || istype(I, /obj/item/stack/material/steel)))
		if(do_after(user, 5, src))
			if(I:use(2))
				Chan69eTurf(/turf/simulated/floor/platin69)

	var/obj/effect/shield/turf_shield = 69etEffectShield()

	if (turf_shield && !turf_shield.CanActThrou69h(user))
		turf_shield.attackby(I, user)
		return TRUE

	//Floorin69 attackby69ay intercept the proc.
	//If it has a69onzero return69alue, then we return too
	if (floorin69 && floorin69.attackby(I, user, src))
		return TRUE

	//Attemptin69 to dama69e floors with thin69s
	//This has a lot of potential to break thin69s, so it's limited to harm intent.
	//This supercedes all construction, deconstruction and similar actions. So chan69e your intent out of harm if you don't want to smack the floor
	if (usr.a_intent == I_HURT && user.Adjacent(src))
		if(!(I.fla69s &69OBLUD69EON))
			user.do_attack_animation(src)
			var/calc_dama69e = (I.force*I.structure_dama69e_factor) - floorin69.resistance
			var/volume = (calc_dama69e)*3.5
			volume =69in(volume, 15)
			if (floorin69.hit_sound)
				playsound(src, floorin69.hit_sound,69olume, 1, -1)
			else if (I.hitsound)
				playsound(src, I.hitsound,69olume, 1, -1)

			if (calc_dama69e > 0)
				visible_messa69e(SPAN_DAN69ER("69src69 has been hit by 69user69 with 69I69."))
				take_dama69e(I.force*I.structure_dama69e_factor, I.damtype)
			else
				visible_messa69e(SPAN_DAN69ER("69user69 ineffectually hits 69src69 with 69I69"))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*1.75) //This lon69er cooldown helps promote skill in69elee combat by punishin6969isclicks a bit
			return TRUE

	for(var/atom/movable/A in src)
		if(A.preventsTurfInteractions())
			to_chat(user, SPAN_NOTICE("69A69 is in the way."))
			A.attackby(I, user)
			if(A.preventsTurfInteractions())
				return


	if(istype(I, /obj/item/stack/cable_coil) || (floorin69 && istype(I, /obj/item/stack/rods)))
		return ..(I, user)


	if(istype(I,/obj/item/frame))
		var/obj/item/frame/F = I
		F.try_floorbuild(src)
		return

	if (is_platin69())
		if(istype(I, /obj/item/stack))
			if(is_dama69ed())
				to_chat(user, SPAN_WARNIN69("This section is too dama69ed to support anythin69. Use a welder to fix the dama69e."))
				return
			var/obj/item/stack/S = I
			var/decl/floorin69/use_floorin69
			for(var/floorin69_type in floorin69_types)
				var/decl/floorin69/F = floorin69_types69floorin69_type69
				if(!F.build_type)
					continue
				if((ispath(S.type, F.build_type) || ispath(S.build_type, F.build_type)) && ((S.type == F.build_type) || (S.build_type == F.build_type)))
					if (floorin69 && floorin69.can_build_floor(F))
						use_floorin69 = F
						break
				else if (istype(S, /obj/item/stack/material))//Handlin69 for69aterial stacks
					var/obj/item/stack/material/M = S
					if (F.build_type ==69.material.name)
						if (floorin69 && floorin69.can_build_floor(F))
							use_floorin69 = F
							break

			if(!use_floorin69)
				return
			// Do we have enou69h?
			if(use_floorin69.build_cost && S.69et_amount() < use_floorin69.build_cost)
				to_chat(user, SPAN_WARNIN69("You re69uire at least 69use_floorin69.build_cost69 69S.name69 to complete the 69use_floorin69.descriptor69."))
				return
			// Stay still and focus...
			if(use_floorin69.build_time && !do_after(user, use_floorin69.build_time, src))
				return
			if(	!S || !user || !use_floorin69)
				return
			if(S.use(use_floorin69.build_cost))
				set_floorin69(use_floorin69)
				playsound(src, 'sound/items/Deconstruct.o6969', 80, 1)
				return

	if(floorin69)

		var/list/usable_69ualities = list()
		if(is_dama69ed() || (floorin69.fla69s & TURF_IS_FRA69ILE) || (floorin69.fla69s & TURF_REMOVE_CROWBAR))
			usable_69ualities.Add(69UALITY_PRYIN69)
		if(!(is_dama69ed()) || floorin69.fla69s & TURF_REMOVE_SCREWDRIVER)
			usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
		if(floorin69.fla69s & TURF_REMOVE_WRENCH)
			usable_69ualities.Add(69UALITY_BOLT_TURNIN69)
		if(floorin69.fla69s & TURF_REMOVE_SHOVEL)
			usable_69ualities.Add(69UALITY_SHOVELIN69)
		if(is_dama69ed() || floorin69.fla69s & TURF_REMOVE_WELDER)
			usable_69ualities.Add(69UALITY_WELDIN69)
		if(is_dama69ed())
			usable_69ualities.Add(69UALITY_SEALIN69)
		var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
		switch(tool_type)
			if(69UALITY_SEALIN69)
				user.visible_messa69e("69user69 starts sealin69 up cracks in 69src69 with the 69I69", "You start sealin69 up cracks in 69src69 with the 69I69")
				if (I.use_tool(user, src, 50 + ((maxHealth - health)*2), 69UALITY_SEALIN69, FAILCHANCE_NORMAL, STAT_MEC))
					to_chat(user, SPAN_NOTICE("The 69src69 looks pretty solid69ow!"))
					health =69axHealth
					broken = FALSE
					burnt = FALSE
					update_icon()
				return
			if(69UALITY_PRYIN69)
				if(is_dama69ed())
					if(I.use_tool(user, src, floorin69.removal_time, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You remove the broken 69floorin69.descriptor69."))
						make_platin69()
					return
				else if(floorin69.fla69s & TURF_IS_FRA69ILE)
					if(I.use_tool(user, src, floorin69.removal_time, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_DAN69ER("You forcefully pry off the 69floorin69.descriptor69, destroyin69 them in the process."))
						make_platin69()
					return
				else if(floorin69.fla69s & TURF_REMOVE_CROWBAR)
					if(I.use_tool(user, src, floorin69.removal_time, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You lever off the 69floorin69.descriptor69."))
						make_platin69(1)
					return
				return

			if(69UALITY_SCREW_DRIVIN69)
				if((!(is_dama69ed()) && !is_platin69()) || floorin69.fla69s & TURF_REMOVE_SCREWDRIVER)
					if(I.use_tool(user, src, floorin69.removal_time*1.5, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You unscrew and remove the 69floorin69.descriptor69."))
						make_platin69(1)
				return

			if(69UALITY_BOLT_TURNIN69)
				if(floorin69.fla69s & TURF_REMOVE_WRENCH)
					if(I.use_tool(user, src, floorin69.removal_time, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You unwrench and remove the 69floorin69.descriptor69."))
						make_platin69(1)
				return

			if(69UALITY_SHOVELIN69)
				if(floorin69.fla69s & TURF_REMOVE_SHOVEL)
					if(I.use_tool(user, src, floorin69.removal_time, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You shovel off the 69floorin69.descriptor69."))
						make_platin69(1)
				return

			if(69UALITY_WELDIN69)
				if(is_dama69ed())
					if(I.use_tool(user, src,69axHealth - health, 69UALITY_WELDIN69, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You fix some dents on the broken platin69."))
						playsound(src, 'sound/items/Welder.o6969', 80, 1)
						icon_state = "platin69"
						health =69axHealth
						burnt =69ull
						broken =69ull
						update_icon()
						return

				if(floorin69.fla69s & TURF_REMOVE_WELDER)
					to_chat(user, SPAN_NOTICE("You start cuttin69 throu69h the 69floorin69.descriptor69."))
					if(I.use_tool(user, src, floorin69.removal_time, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You cut throu69h and remove the 69floorin69.descriptor69."))
						make_platin69(1)

			if(ABORT_CHECK)
				return

		if(istype(I, /obj/item/stack/cable_coil) && (floorin69.fla69s & TURF_HIDES_THIN69S))
			to_chat(user, SPAN_WARNIN69("You69ust remove the 69floorin69.descriptor69 first."))
			return
		else if (istype(I, /obj/item/frame))
			var/obj/item/frame/F = I
			F.try_floorbuild(src)
			return


	return ..()


/turf/simulated/floor/can_build_cable(var/mob/user)
	if(floorin69 && (floorin69.fla69s & TURF_HIDES_THIN69S))
		to_chat(user, SPAN_WARNIN69("You69ust remove the 69floorin69.descriptor69 first."))
		return 0
	if(is_dama69ed())
		to_chat(user, SPAN_WARNIN69("This section is too dama69ed to support anythin69. Use a welder to fix the dama69e."))
		return 0
	return 1
