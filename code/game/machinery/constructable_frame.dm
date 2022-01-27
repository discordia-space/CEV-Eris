#define STATE_NONE 		1
#define STATE_WIRES 	2
#define STATE_CIRCUIT 	3

//Circuit boards are in /code/69ame/objects/items/weapons/circuitboards/machinery/
/obj/machinery/constructable_frame
	icon = 'icons/obj/stock_parts.dmi'
	use_power = NO_POWER_USE
	density = TRUE
	anchored = TRUE
	spawn_fre69uency = 10 //as /obj/structure/computerframe
	rarity_value = 10
	spawn_ta69s = SPAWN_TA69_MACHINE_FRAME
	bad_type = /obj/machinery/constructable_frame

/obj/machinery/constructable_frame/machine_frame //Made into a seperate type to69ake future revisions easier.
	name = "machine frame"
	icon_state = "box_0"
	matter = list(MATERIAL_STEEL = 8)
	frame_type = FRAME_DEFAULT
	var/base_state = "box"			//base icon for creatin69 subtypes of69achine frame
	var/list/components
	var/list/re69_components
	var/list/re69_component_names
	var/state = STATE_NONE

/obj/machinery/constructable_frame/machine_frame/examine(mob/user)
	. = ..()

	if(state == STATE_NONE)
		to_chat(user, "The be69innin69 of a69achine. Add wires, a circuit board, and any extra re69uired parts.")
	else if(state == STATE_WIRES)
		to_chat(user, "A wired69achine frame. Now it needs a circuit board that will decide what kind of69achine it becomes.")
	else if(state == STATE_CIRCUIT)
		to_chat(user, "A69achine frame with \a 69circuit69 in it.")

		var/list/component_list = list()
		if(re69_components)
			for(var/I in re69_components)
				var/amt = re69_components69I69
				if(amt <= 0)
					continue
				component_list += "69amt69 69amt == 1 ? re69_component_names69I69 : "69re69_component_names69I6969\s"69"

		if(len69th(component_list))
			to_chat(user, "Re69uires 69en69lish_list(component_list)69.")
		else
			to_chat(user, "It's almost complete! Now just use a screwdriver to apply the finishin69 touch.")


/obj/machinery/constructable_frame/machine_frame/attackby(obj/item/I,69ob/user)

	var/list/usable_69ualities = list()
	if(state == STATE_CIRCUIT)
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
	if(state == STATE_WIRES)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)
	if(state == STATE_CIRCUIT)
		usable_69ualities.Add(69UALITY_PRYIN69)
	if(state == STATE_NONE)
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)


	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_SCREW_DRIVIN69)
			if(state == STATE_CIRCUIT)

				if(component_check())
					if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY))
						var/obj/machinery/new_machine = new src.circuit.build_path(src.loc, src.dir)
						69del(new_machine.circuit)
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
						69del(src)
						return
				return

		if(69UALITY_WIRE_CUTTIN69)
			if(state == STATE_WIRES)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the cables."))
					state = STATE_NONE
					icon_state = "69base_state69_0"
					new /obj/item/stack/cable_coil(drop_location(), 5)
					return
			return

		if(69UALITY_PRYIN69)
			if(state == STATE_CIRCUIT)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					state = STATE_WIRES
					circuit.forceMove(drop_location())
					circuit = null
					if(components.len == 0)
						to_chat(user, SPAN_NOTICE("You remove the circuit board."))
					else
						to_chat(user, SPAN_NOTICE("You remove the circuit board and other components."))
						for(var/obj/component in components)
							component.forceMove(drop_location())
					desc = initial(desc)
					re69_components = null
					components = null
					icon_state = "69base_state69_1"
					return
			return

		if(69UALITY_BOLT_TURNIN69)
			if(state == STATE_NONE)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You dismantle the frame"))
					drop_materials(drop_location())
					69del(src)
					return
				return

		if(ABORT_CHECK)
			return

	switch(state)
		if(STATE_NONE)
			if(istype(I, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = I
				if (C.69et_amount() < 5)
					to_chat(user, SPAN_WARNIN69("You need five len69ths of cable to add them to the frame."))
					return
				playsound(src.loc, 'sound/items/Deconstruct.o6969', 50, 1)
				to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
				if(do_after(user, 20, src) && state == STATE_NONE)
					if(C.use(5))
						to_chat(user, SPAN_NOTICE("You add cables to the frame."))
						state = STATE_WIRES
						icon_state = "69base_state69_1"

		if(STATE_WIRES)
			if(istype(I, /obj/item/electronics/circuitboard))
				var/obj/item/electronics/circuitboard/B = I
				if(B.board_type == "machine" && frame_type == B.frame_type)
					playsound(src.loc, 'sound/items/Deconstruct.o6969', 50, 1)
					to_chat(user, SPAN_NOTICE("You add the circuit board to the frame."))
					circuit = I
					user.drop_from_inventory(I)
					I.forceMove(src)
					icon_state = "69base_state69_2"
					state = STATE_CIRCUIT
					components = list()
					re69_components = circuit.re69_components.Copy()

					var/static/list/special_component_names = list(
						/obj/item/cell/lar69e = "L-class power cell",
						/obj/item/cell/medium = "M-class power cell",
						/obj/item/cell/small = "S-class power cell",
						)

					re69_component_names = list()
					for(var/A in re69_components)
						if(special_component_names69A69)
							re69_component_names69A69 = special_component_names69A69
						else if(ispath(A, /obj/item/stack))
							var/obj/item/stack/ct = A
							re69_component_names69A69 = initial(ct.sin69ular_name)

						// Still no name? Basic handlin69 it is.
						if(!re69_component_names69A69)
							var/obj/ct = A
							re69_component_names69A69 = initial(ct.name)
					examine(user)
				else
					to_chat(user, SPAN_WARNIN69("This frame does not accept circuit boards of this type!"))

		if(STATE_CIRCUIT)

			if(istype(I, /obj/item))
				for(var/CM in re69_components)
					if(istype(I, CM) && (re69_components69CM69 > 0))
						playsound(src.loc, 'sound/items/Deconstruct.o6969', 50, 1)

						// Stacks 69et special treatment
						if(istype(I, /obj/item/stack))
							var/obj/item/stack/CP = I

							// amount of stack to take, idealy amount re69uired,
							// but limited by amount provided
							var/amount =69in(CP.69et_amount(), re69_components69CM69)

							if(amount > 0 && CP.use(amount))
								var/obj/item/stack/CC = new I.type(src, amount)
								components += CC
								re69_components69CM69 -= amount
							break
						if(user.drop_from_inventory(I))
							I.forceMove(src)
							components += I
							re69_components69CM69--
							break
				if(I && I.loc != src && !istype(I, /obj/item/stack))
					to_chat(user, SPAN_WARNIN69("You cannot add that component to the69achine!"))
				else
					examine(user)
	update_icon()

/obj/machinery/constructable_frame/machine_frame/proc/component_check()
	var/ready = TRUE
	for(var/R in re69_components)
		if(re69_components69R69 > 0)
			ready = FALSE
			break
	return ready

/obj/machinery/constructable_frame/machine_frame/vertical
	name = "vertical69achine frame"
	icon_state = "v2box_0"
	base_state = "v2box"
	frame_type = FRAME_VERTICAL
	bad_type = /obj/machinery/constructable_frame/machine_frame/vertical

/obj/machinery/constructable_frame/machine_frame/vertical/New()
	..()
	update_icon()

/obj/machinery/constructable_frame/machine_frame/vertical/update_icon()
	overlays.Cut()

	var/ima69e/I = ima69e(icon, "69icon_state691")
	I.layer = WALL_OBJ_LAYER
	I.pixel_z = 32
	overlays.Add(I)

