/obj/machinery/pipelayer

	name = "automatic pipe layer"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	var/turf/old_turf
	var/old_dir
	var/on = FALSE
	var/a_dis = 0
	var/P_type = 0
	var/P_type_t = ""
	var/max_metal = 50
	var/metal = 10
	var/obj/item/tool/wrench/W
	var/list/Pipes = list("re69ular pipes"=0,"scrubbers pipes"=31,"supply pipes"=29,"heat exchan69e pipes"=2)

/obj/machinery/pipelayer/New()
	W = new(src)
	..()

/obj/machinery/pipelayer/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	. = ..()

	if(on && a_dis)
		dismantleFloor(old_turf)
	layPipe(old_turf,Dir,old_dir)

	old_turf = NewLoc
	old_dir = turn(Dir,180)

/obj/machinery/pipelayer/attack_hand(mob/user as69ob)
	if(!metal&&!on)
		to_chat(user, SPAN_WARNIN69("\The 69src69 doesn't work without69etal."))
		return
	on=!on
	user.visible_messa69e(SPAN_NOTICE("69user69 has 69!on?"de":""69activated \the 69src69."), SPAN_NOTICE("You 69!on?"de":""69activate \the 69src69."))
	return

/obj/machinery/pipelayer/attackby(var/obj/item/I,69ar/mob/user)

	var/tool_type = I.69et_tool_type(user, list(69UALITY_SCREW_DRIVIN69, 69UALITY_PRYIN69, 69UALITY_BOLT_TURNIN69), src)
	switch(tool_type)
		if(69UALITY_SCREW_DRIVIN69)
			if(!I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				return
			if(metal)
				var/m = round(input(usr,"Please specify the amount of69etal to remove","Remove69etal",min(round(metal),50)) as num, 1)
				m =69in(m, 50)
				m =69in(m, round(metal))
				m = round(m)
				if(m)
					use_metal(m)
					var/obj/item/stack/material/steel/MM = new (69et_turf(src))
					MM.amount =69
					user.visible_messa69e(
						SPAN_NOTICE("69user69 removes 69m69 sheet\s of69etal from the \the 69src69."),
						SPAN_NOTICE("You remove 69m69 sheet\s of69etal from \the 69src69"))
			else
				to_chat(user, "\The 69src69 is empty.")
			return

		if(69UALITY_PRYIN69)
			if(!I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				return
			a_dis=!a_dis
			user.visible_messa69e(
				SPAN_NOTICE("69user69 has 69!a_dis?"de":""69activated auto-dismantlin69."),
				SPAN_NOTICE("You 69!a_dis?"de":""69activate auto-dismantlin69."))
			return

		if(69UALITY_BOLT_TURNIN69)
			if(!I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				return
			P_type_t = input("Choose pipe type", "Pipe type") as null|anythin69 in Pipes
			P_type = Pipes69P_type_t69
			user.visible_messa69e(
				SPAN_NOTICE("69user69 has set \the 69src69 to69anufacture 69P_type_t69."),
				SPAN_NOTICE("You set \the 69src69 to69anufacture 69P_type_t69."))
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/material) && I.69et_material_name() ==69ATERIAL_STEEL)

		var/result = load_metal(I)
		if(isnull(result))
			to_chat(user, SPAN_WARNIN69("Unable to load 69I69 - no69etal found."))
		else if(!result)
			to_chat(user, SPAN_NOTICE("\The 69src69 is full."))
		else
			user.visible_messa69e(SPAN_NOTICE("69user69 has loaded69etal into \the 69src69."), SPAN_NOTICE("You load69etal into \the 69src69"))

		return

	return

/obj/machinery/pipelayer/examine(mob/user)
	..()
	to_chat(user, "\The 69src69 has 69metal69 sheet\s, is set to produce 69P_type_t69, and auto-dismantlin69 is 69!a_dis?"de":""69activated.")

/obj/machinery/pipelayer/proc/reset()
	on=0
	return

/obj/machinery/pipelayer/proc/load_metal(var/obj/item/stack/MM)
	if(istype(MM) &&69M.69et_amount())
		var/cur_amount =69etal
		var/to_load =69ax(max_metal - round(cur_amount),0)
		if(to_load)
			to_load =69in(MM.69et_amount(), to_load)
			metal += to_load
			MM.use(to_load)
			return to_load
		else
			return 0
	return

/obj/machinery/pipelayer/proc/use_metal(amount)
	if(!metal ||69etal<amount)
		visible_messa69e("\The 69src69 deactivates as its69etal source depletes.")
		return
	metal-=amount
	return 1

/obj/machinery/pipelayer/proc/dismantleFloor(var/turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_platin69())
			T.make_platin69(!(T.broken || T.burnt))
	return new_turf.is_platin69()

/obj/machinery/pipelayer/proc/layPipe(var/turf/w_turf,var/M_Dir,var/old_dir)
	if(!on || !(M_Dir in list(1, 2, 4, 8)) ||69_Dir==old_dir)
		return reset()
	if(!use_metal(0.25))
		return reset()
	var/fdirn = turn(M_Dir,180)
	var/p_type
	var/p_dir

	if (fdirn!=old_dir)
		p_type=1+P_type
		p_dir=old_dir+M_Dir
	else
		p_type=0+P_type
		p_dir=M_Dir

	var/obj/item/pipe/P = new (w_turf, pipe_type=p_type, dir=p_dir)
	P.attackby(W , src)

	return 1
