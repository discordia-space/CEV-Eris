#define STATE_NONE 		1
#define STATE_WIRES 	2
#define STATE_CIRCUIT 	3

//Circuit boards are in /code/game/objects/items/weapons/circuitboards/machinery/

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"

	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = TRUE
	anchored = TRUE
	use_power = 0
	var/base_state = "box"			//base icon for creating subtypes of machine frame
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = STATE_NONE
	frame_type = FRAME_DEFAULT

/obj/machinery/constructable_frame/examine(var/mob/user)
	update_desc()
	.=..()


/obj/machinery/constructable_frame/proc/update_desc()
	var/D
	if (state == STATE_NONE)
		D = "The beginning of a machine. Add wires, a circuitboard, and any extra required parts"
	else if (state == STATE_WIRES)
		D = "Now it needs a circuitboard, this will decide what kind of machine it becomes."
	else if (state == STATE_CIRCUIT)
		if (!component_check())
			D = "Now it needs a few extra parts, listed below."
		else
			D = "It's almost complete! Now just use a screwdriver to apply the finishing touch."
	D += "\n\n"
	if(req_components)
		var/list/component_list = new
		for(var/I in req_components)
			if(req_components[I] > 0)
				component_list += "[num2text(req_components[I])] [req_component_names[I]]"
		D += "Requires [english_list(component_list)]."
	desc = D
	..()

/obj/machinery/constructable_frame/machine_frame/attackby(obj/item/I, mob/user)

	var/list/usable_qualities = list()
	if(state == STATE_CIRCUIT)
		usable_qualities.Add(QUALITY_SCREW_DRIVING)
	if(state == STATE_WIRES)
		usable_qualities.Add(QUALITY_WIRE_CUTTING)
	if(state == STATE_CIRCUIT)
		usable_qualities.Add(QUALITY_PRYING)
	if(state == STATE_NONE)
		usable_qualities.Add(QUALITY_BOLT_TURNING)


	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_SCREW_DRIVING)
			if(state == STATE_CIRCUIT)

				if(component_check())
					if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY))
						var/obj/machinery/new_machine = new src.circuit.build_path(src.loc, src.dir)
						qdel(new_machine.circuit)
						new_machine.circuit = circuit

						if(new_machine.component_parts)
							new_machine.component_parts.Cut()
						else
							new_machine.component_parts = list()

						src.circuit.construct(new_machine)

						new_machine.component_parts += circuit
						circuit.loc = null

						for(var/obj/O in src)
							new_machine.component_parts += O
							O.loc = null

						new_machine.RefreshParts()
						qdel(src)
						return
				return

		if(QUALITY_WIRE_CUTTING)
			if(state == STATE_WIRES)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the cables."))
					state = STATE_NONE
					icon_state = "[base_state]_0"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
					A.amount = 5
					return
			return

		if(QUALITY_PRYING)
			if(state == STATE_CIRCUIT)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					state = STATE_WIRES
					circuit.loc = src.loc
					circuit = null
					if(components.len == 0)
						to_chat(user, SPAN_NOTICE("You remove the circuit board."))
					else
						to_chat(user, SPAN_NOTICE("You remove the circuit board and other components."))
						for(var/obj/item/weapon/W in components)
							W.loc = src.loc
					desc = initial(desc)
					req_components = null
					components = null
					icon_state = "[base_state]_1"
					return
			return

		if(QUALITY_BOLT_TURNING)
			if(state == STATE_NONE)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You dismantle the frame"))
					new /obj/item/stack/material/steel(src.loc, 8)
					qdel(src)
					return
				return

		if(ABORT_CHECK)
			return

	switch(state)
		if(STATE_NONE)
			if(istype(I, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = I
				if (C.get_amount() < 5)
					to_chat(user, SPAN_WARNING("You need five lengths of cable to add them to the frame."))
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
				if(do_after(user, 20, src) && state == STATE_NONE)
					if(C.use(5))
						to_chat(user, SPAN_NOTICE("You add cables to the frame."))
						state = STATE_WIRES
						icon_state = "[base_state]_1"

		if(STATE_WIRES)
			if(istype(I, /obj/item/weapon/circuitboard))
				var/obj/item/weapon/circuitboard/B = I
				if(B.board_type == "machine" && frame_type == B.frame_type)
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, SPAN_NOTICE("You add the circuit board to the frame."))
					circuit = I
					user.drop_from_inventory(I)
					I.forceMove(src)
					icon_state = "[base_state]_2"
					state = STATE_CIRCUIT
					components = list()
					req_components = circuit.req_components.Copy()
					for(var/A in circuit.req_components)
						req_components[A] = circuit.req_components[A]
					req_component_names = circuit.req_components.Copy()
					for(var/A in req_components)
						var/obj/ct = new A // have to quickly instantiate it get name
						req_component_names[A] = ct.name
					update_desc()
					to_chat(user, desc)
				else
					to_chat(user, SPAN_WARNING("This frame does not accept circuit boards of this type!"))

		if(STATE_CIRCUIT)

			if(istype(I, /obj/item))
				for(var/CM in req_components)
					if(istype(I, CM) && (req_components[CM] > 0))
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
						if(istype(I, /obj/item/stack/cable_coil))
							var/obj/item/stack/cable_coil/CP = I
							if(CP.get_amount() > 1)
								// amount of cable to take, idealy amount required,
								// but limited by amount provided
								var/camt = min(CP.amount, req_components[CM])
								var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src)
								CC.amount = camt
								CC.update_icon()
								CP.use(camt)
								components += CC
								req_components[CM] -= camt
								update_desc()
								break
						if(user.drop_from_inventory(I))
							I.forceMove(src)
							components += I
							req_components[CM]--
							update_desc()
							break
				to_chat(user, desc)
				if(I && I.loc != src && !istype(I, /obj/item/stack/cable_coil))
					to_chat(user, SPAN_WARNING("You cannot add that component to the machine!"))
	update_icon()

/obj/machinery/constructable_frame/proc/component_check()
	var/ready = TRUE
	for(var/R in req_components)
		if(req_components[R] > 0)
			ready = FALSE
			break
	return ready

/obj/machinery/constructable_frame/machine_frame/vertical
	name = "vertical machine frame"
	icon_state = "v2box_0"
	base_state = "v2box"
	frame_type = FRAME_VERTICAL

/obj/machinery/constructable_frame/machine_frame/vertical/New()
	..()
	update_icon()

/obj/machinery/constructable_frame/machine_frame/vertical/update_icon()
	overlays.Cut()

	var/image/I = image(icon, "[icon_state]1")
	I.layer = WALL_OBJ_LAYER
	I.pixel_z = 32
	overlays.Add(I)

