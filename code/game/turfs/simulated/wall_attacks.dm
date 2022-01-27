//Interactions
/turf/simulated/wall/proc/to6969le_open(var/mob/user)

	if(can_open == WALL_OPENIN69)
		return

	if(density)
		can_open = WALL_OPENIN69
		//flick("69material.icon_base69fwall_openin69", src)
		sleep(15)
		density = FALSE
		set_opacity(FALSE)
		update_icon()
		set_li69ht(0)
	else
		can_open = WALL_OPENIN69
		//flick("69material.icon_base69fwall_closin69", src)
		density = TRUE
		set_opacity(TRUE)
		update_icon()
		sleep(15)
		set_li69ht(1)

	can_open = WALL_CAN_OPEN
	update_icon()

/turf/simulated/wall/proc/fail_smash(var/mob/user)
	to_chat(user, SPAN_DAN69ER("You smash a69ainst the wall!"))
	user.do_attack_animation(src)
	take_dama69e(rand(25,75))

/turf/simulated/wall/proc/success_smash(var/mob/user)
	to_chat(user, SPAN_DAN69ER("You smash throu69h the wall!"))
	user.do_attack_animation(src)
	spawn(1)
		dismantle_wall(1)

/turf/simulated/wall/proc/try_touch(var/mob/user,69ar/rottin69)

	if(rottin69)
		if(reinf_material)
			to_chat(user, SPAN_DAN69ER("\The 69reinf_material.display_name69 feels porous and crumbly."))
		else
			to_chat(user, SPAN_DAN69ER("\The 69material.display_name69 crumbles under your touch!"))
			dismantle_wall()
			return 1

	if(!can_open)
		to_chat(user, SPAN_NOTICE("You push the wall, but69othin69 happens."))
		playsound(src, hitsound, 25, 1)
		user.do_attack_animation(src)
	else
		to6969le_open(user)
	return 0


/turf/simulated/wall/attack_hand(var/mob/user)

	radiate()
	add_fin69erprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/rottin69 = (locate(/obj/effect/overlay/wallrot) in src)
	if (HULK in user.mutations)
		if (rottin69 || !prob(material.hardness))
			success_smash(user)
		else
			fail_smash(user)
			return 1

	try_touch(user, rottin69)

/turf/simulated/wall/attack_69eneric(var/mob/user,69ar/dama69e,69ar/attack_messa69e,69ar/wallbreaker)

	radiate()
	if(!istype(user))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/rottin69 = (locate(/obj/effect/overlay/wallrot) in src)
	if(!dama69e || !wallbreaker)
		try_touch(user, rottin69)
		return

	if(rottin69)
		return success_smash(user)

	if(reinf_material)
		if((wallbreaker == 2) || (dama69e >=69ax(material.hardness,reinf_material.hardness)))
			return success_smash(user)
	else if(dama69e >=69aterial.hardness)
		return success_smash(user)
	return fail_smash(user)

/turf/simulated/wall/attackby(obj/item/I,69ob/user)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNIN69("You don't have the dexterity to do this!"))
		return

	//69et the user's location
	if(!istype(user.loc, /turf))	return	//can't do this stuff whilst inside objects and such

	if(I)
		radiate()
		if(is_hot(I))
			burn(is_hot(I))

	var/list/usable_69ualities = list()
	if(construction_sta69e == 2)
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)
	if((locate(/obj/effect/overlay/wallrot) in src) || thermite || dama69e || isnull(construction_sta69e) || !reinf_material || construction_sta69e == 4 || construction_sta69e == 1)
		usable_69ualities.Add(69UALITY_WELDIN69)
	if(construction_sta69e == 3 || construction_sta69e == 0)
		usable_69ualities.Add(69UALITY_PRYIN69)
	if(construction_sta69e == 5)
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
	if(construction_sta69e == 6)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_BOLT_TURNIN69)
			if(construction_sta69e == 2)
				to_chat(user, SPAN_NOTICE("You be69in removin69 the bolts anchorin69 the support rods..."))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					construction_sta69e = 1
					update_icon()
					to_chat(user, SPAN_NOTICE("You remove the bolts anchorin69 the support rods."))
					return
			return

		if(69UALITY_WELDIN69)
			if(locate(/obj/effect/overlay/wallrot) in src)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You burn away the fun69i with \the 69I69."))
					for(var/obj/effect/overlay/wallrot/WR in src)
						69del(WR)
					return
			if(thermite)
				if(I.use_tool(user, src, WORKTIME_INSTANT,tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You i69nite the thermite with the 69I69!"))
					thermitemelt(user)
					return
			if(dama69e)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You repair the dama69e to 69src69."))
					clear_bulletholes()
					take_dama69e(-dama69e)
					return
			if(isnull(construction_sta69e) || !reinf_material)
				to_chat(user, SPAN_NOTICE("You be69in removin69 the outer platin69..."))
				if(I.use_tool(user, src, WORKTIME_LON69, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the outer platin69."))
					dismantle_wall()
					user.visible_messa69e(SPAN_WARNIN69("The wall was torn open by 69user69!"))
					return
			if(construction_sta69e == 4)
				to_chat(user, SPAN_NOTICE("You be69in removin69 the outer platin69..."))
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					construction_sta69e = 3
					update_icon()
					to_chat(user, SPAN_NOTICE("You press firmly on the cover, dislod69in69 it."))
					return
			if(construction_sta69e == 1)
				to_chat(user, SPAN_NOTICE("You be69in removin69 the support rods..."))
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					construction_sta69e = 0
					update_icon()
					new /obj/item/stack/rods(user.loc)
					to_chat(user, SPAN_NOTICE("The support rods drop out as you cut them loose from the frame."))
					return
			return

		if(69UALITY_PRYIN69)
			if(construction_sta69e == 3)
				to_chat(user, SPAN_NOTICE("You be69in to pryin69 off the cover..."))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					construction_sta69e = 2
					update_icon()
					to_chat(user, SPAN_NOTICE("You pry off the cover."))
					return
			if(construction_sta69e == 0)
				to_chat(user, SPAN_NOTICE("You stru6969le to pry off the outer sheath..."))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You pry off the outer sheath."))
					dismantle_wall(user)
					return
			return

		if(69UALITY_WIRE_CUTTIN69)
			if(construction_sta69e == 6)
				to_chat(user, SPAN_NOTICE("You be69in removin69 the outer 69rille..."))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					construction_sta69e = 5
					new /obj/item/stack/rods(user.loc)
					to_chat(user, SPAN_NOTICE("You removin69 the outer 69rille."))
					update_icon()
					return
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(construction_sta69e == 5)
				to_chat(user, SPAN_NOTICE("You be69in removin69 the support lines..."))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					construction_sta69e = 4
					update_icon()
					to_chat(user, SPAN_NOTICE("You remove the support lines."))
					return
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/rods))
		if(construction_sta69e == 5)
			var/obj/item/stack/O = I
			if(O.69et_amount()>0)
				O.use(1)
				construction_sta69e = 6
				update_icon()
				to_chat(user, SPAN_NOTICE("You replace the outer 69rille."))
				return

	if(istype(I,/obj/item/frame))
		var/obj/item/frame/F = I
		F.try_build(src)
		return

	else if(!istype(I,/obj/item/rcd) && !istype(I, /obj/item/rea69ent_containers))
		if(!I.force)
			return attack_hand(user)
		var/attackforce = I.force*I.structure_dama69e_factor
		var/dam_threshhold =69aterial.inte69rity
		if(reinf_material)
			dam_threshhold = CEILIN69(max(dam_threshhold,reinf_material.inte69rity) * 0.5, 1)
		var/dam_prob =69aterial.hardness * 1.4
		if (locate(/obj/effect/overlay/wallrot) in src)
			dam_prob *= 0.5 //Rot69akes reinforced walls breakable
		if(ishuman(user))
			var/mob/livin69/carbon/human/attacker = user
			dam_prob -= attacker.stats.69etStat(STAT_ROB)
		if(dam_prob < 100 && attackforce > (dam_threshhold/10))
			playsound(src, hitsound, 80, 1)
			if(!prob(dam_prob))
				visible_messa69e(SPAN_DAN69ER("\The 69user69 attacks \the 69src69 with \the 69I69!"))
				playsound(src, pick(WALLHIT_SOUNDS), 100, 5)
				take_dama69e(attackforce)
			else
				visible_messa69e(SPAN_WARNIN69("\The 69user69 attacks \the 69src69 with \the 69I69!"))
		else
			visible_messa69e(SPAN_DAN69ER("\The 69user69 attacks \the 69src69 with \the 69I69, but it bounces off!"))
		user.do_attack_animation(src)
		return
