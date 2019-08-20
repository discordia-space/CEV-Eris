/obj/structure/computerframe
	density = 1
	anchored = 0
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null
//	weight = 1.0E8

/obj/structure/computerframe/verb/rotate()
	set name = "Rotate Clockwise"
	set category = "Object"
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
		to_chat(user, SPAN_WARNING("You can't do that right now!"))
		return
	if(!in_range(src, user))
		return
	else
		rotate()

/obj/structure/computerframe/attackby(obj/item/I, mob/user)

	var/list/usable_qualities = list()
	if(state == 0 || state == 1)
		usable_qualities.Add(QUALITY_BOLT_TURNING)
	if(state == 0)
		usable_qualities.Add(QUALITY_WELDING)
	if((state == 1 && circuit) || (state == 2 && circuit) || (state == 4))
		usable_qualities.Add(QUALITY_SCREW_DRIVING)
	if((state == 1 && circuit) || (state == 4))
		usable_qualities.Add(QUALITY_PRYING)
	if(state == 3)
		usable_qualities.Add(QUALITY_WIRE_CUTTING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_BOLT_TURNING)
			if(state == 0)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You wrench the frame into place."))
					anchored = 1
					state = 1
					return
			if(state == 1)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unfasten the frame."))
					anchored = 0
					state = 0
					return
			return

		if(QUALITY_WELDING)
			if(state == 0)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You deconstruct the frame."))
					new /obj/item/stack/material/steel( src.loc, 5 )
					qdel(src)
					return
			return

		if(QUALITY_PRYING)
			if(state == 1 && circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the circuit board."))
					state = 1
					icon_state = "0"
					circuit.loc = src.loc
					circuit = null
					return
			if(state == 4)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the glass panel."))
					state = 3
					icon_state = "3"
					new /obj/item/stack/material/glass(src.loc, 2)
					return
			return

		if(QUALITY_SCREW_DRIVING)
			if(state == 1 && circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You screw the circuit board into place."))
					state = 2
					icon_state = "2"
					return
			if(state == 2 && circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unfasten the circuit board."))
					state = 1
					icon_state = "1"
					return
			if(state == 4)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You connect the monitor."))
					var/B = new src.circuit.build_path(src.loc, src.dir)
					src.circuit.construct(B)
					qdel(src)
					return
			return

		if(QUALITY_WIRE_CUTTING)
			if(state == 3)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the cables."))
					state = 2
					icon_state = "2"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(src.loc)
					A.amount = 5
					return
			return

		if(ABORT_CHECK)
			return

	switch(state)
		if(1)
			if(istype(I, /obj/item/weapon/circuitboard) && !circuit)
				var/obj/item/weapon/circuitboard/B = I
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, SPAN_NOTICE("You place the circuit board inside the frame."))
					src.icon_state = "1"
					src.circuit = I
					user.drop_from_inventory(I)
					I.forceMove(src)
				else
					to_chat(user, SPAN_WARNING("This frame does not accept circuit boards of this type!"))
		if(2)
			if(istype(I, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = I
				if (C.get_amount() < 5)
					to_chat(user, SPAN_WARNING("You need five coils of wire to add them to the frame."))
					return
				to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20, src) && state == 2)
					if (C.use(5))
						to_chat(user, SPAN_NOTICE("You add cables to the frame."))
						state = 3
						icon_state = "3"
		if(3)
			if(istype(I, /obj/item/stack/material) && I.get_material_name() == "glass")
				var/obj/item/stack/G = I
				if (G.get_amount() < 2)
					to_chat(user, SPAN_WARNING("You need two sheets of glass to put in the glass panel."))
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, SPAN_NOTICE("You start to put in the glass panel."))
				if(do_after(user, 20, src) && state == 3)
					if (G.use(2))
						to_chat(user, SPAN_NOTICE("You put in the glass panel."))
						src.state = 4
						src.icon_state = "4"
