/obj/structure/computerframe
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	density = TRUE
	anchored = FALSE
	matter = list(MATERIAL_STEEL = 5)
	var/state = 0
	var/obj/item/electronics/circuitboard/circuit
	spawn_ta69s = SPAWN_TA69_MACHINE_FRAME

//	wei69ht = 1.0E8

/obj/structure/computerframe/verb/rotate()
	set name = "Rotate Clockwise"
	set cate69ory = "Object"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return
	if(anchored)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	set_dir(turn(dir, -90))
	return 1

/obj/structure/computerframe/AltClick(mob/user)
	..()
	if(user.incapacitated())
		to_chat(user, SPAN_WARNIN69("You can't do that ri69ht now!"))
		return
	if(!in_ran69e(src, user))
		return
	else
		rotate()

/obj/structure/computerframe/69et_matter()
	var/list/matter = ..()
	. =69atter.Copy()
	if(state >= 4)
		LAZYAPLUS(.,69ATERIAL_69LASS, 2)

/obj/structure/computerframe/attackby(obj/item/I,69ob/user)
	var/list/usable_69ualities = list()
	if(state == 0 || state == 1)
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)
	if(state == 0)
		usable_69ualities.Add(69UALITY_WELDIN69)
	if((state == 1 && circuit) || (state == 2 && circuit) || (state == 4))
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
	if((state == 1 && circuit) || (state == 4))
		usable_69ualities.Add(69UALITY_PRYIN69)
	if(state == 3)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)
		if(69UALITY_BOLT_TURNIN69)
			if(state == 0)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You wrench the frame into place."))
					anchored = TRUE
					state = 1
					return
			if(state == 1)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unfasten the frame."))
					anchored = FALSE
					state = 0
					return
			return

		if(69UALITY_WELDIN69)
			if(state == 0)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You deconstruct the frame."))
					drop_materials(drop_location())
					69del(src)
					return
			return

		if(69UALITY_PRYIN69)
			if(state == 1 && circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the circuit board."))
					state = 1
					icon_state = "0"
					circuit.forceMove(drop_location())
					circuit = null
					return
			if(state == 4)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the 69lass panel."))
					state = 3
					icon_state = "3"
					new /obj/item/stack/material/69lass(drop_location(), 2)
					return
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(state == 1 && circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You screw the circuit board into place."))
					state = 2
					icon_state = "2"
					return
			if(state == 2 && circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unfasten the circuit board."))
					state = 1
					icon_state = "1"
					return
			if(state == 4)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You connect the69onitor."))
					var/B = new circuit.build_path(drop_location(), src.dir)
					circuit.construct(B)
					69del(src)
					return
			return

		if(69UALITY_WIRE_CUTTIN69)
			if(state == 3)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the cables."))
					state = 2
					icon_state = "2"
					new /obj/item/stack/cable_coil(drop_location(), 5)
					return
			return

		if(ABORT_CHECK)
			return

	switch(state)
		if(1)
			if(istype(I, /obj/item/electronics/circuitboard) && !circuit)
				var/obj/item/electronics/circuitboard/B = I
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.o6969', 50, 1)
					to_chat(user, SPAN_NOTICE("You place the circuit board inside the frame."))
					src.icon_state = "1"
					src.circuit = I
					user.drop_from_inventory(I)
					I.forceMove(src)
				else
					to_chat(user, SPAN_WARNIN69("This frame does not accept circuit boards of this type!"))
		if(2)
			if(istype(I, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = I
				if (C.69et_amount() < 5)
					to_chat(user, SPAN_WARNIN69("You need five coils of wire to add them to the frame."))
					return
				to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
				playsound(src.loc, 'sound/items/Deconstruct.o6969', 50, 1)
				if(do_after(user, 20, src) && state == 2)
					if (C.use(5))
						to_chat(user, SPAN_NOTICE("You add cables to the frame."))
						state = 3
						icon_state = "3"
		if(3)
			if(istype(I, /obj/item/stack/material) && I.69et_material_name() ==69ATERIAL_69LASS)
				var/obj/item/stack/69 = I
				if (69.69et_amount() < 2)
					to_chat(user, SPAN_WARNIN69("You need two sheets of 69lass to put in the 69lass panel."))
					return
				playsound(src.loc, 'sound/items/Deconstruct.o6969', 50, 1)
				to_chat(user, SPAN_NOTICE("You start to put in the 69lass panel."))
				if(do_after(user, 20, src) && state == 3)
					if (69.use(2))
						to_chat(user, SPAN_NOTICE("You put in the 69lass panel."))
						src.state = 4
						src.icon_state = "4"
