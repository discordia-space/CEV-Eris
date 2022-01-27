/obj/machinery/rechar69er
	name = "rechar69er"
	desc = "A char69in69 dock for power cells, power tools, computer devices and ener69y based weaponry."
	icon = 'icons/obj/machines/rechar69er.dmi'
	icon_state = "rechar69er"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 4
	circuit = /obj/item/electronics/circuitboard/rechar69er
	var/max_power_usa69e = 40000	//40 kW. This is the hi69hest power the char69er can draw and use,
	//thou69h it69ay draw less when char69in69 weak cells due to their char69in69 rate limits
	active_power_usa69e = 40000//The actual power the char69er uses ri69ht now. This is recalculated based on the cell when it's inserted
	var/efficiency = 0.90
	var/obj/item/char69in69 = null
	var/list/allowed_devices = list(
		/obj/item/cell,
		/obj/item/tool, /obj/item/device/scanner,
		/obj/item/69un/ener69y, /obj/item/melee/baton, /obj/item/modular_computer,
	)
	var/portable = TRUE

/obj/machinery/rechar69er/examine(user)
	..()
	var/obj/item/cell/cell = char69in69?.69et_cell()
	if(cell)
		to_chat(user, "The char69e69eter reads 69round(cell.percent())69%.")

/obj/machinery/rechar69er/attackby(obj/item/I,69ob/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(portable && I.has_69uality(69UALITY_BOLT_TURNIN69))
		if(char69in69)
			to_chat(user, SPAN_WARNIN69("Remove 69char69in6969 first!"))
			return
		anchored = !anchored
		to_chat(user, "You 69anchored ? "attached" : "detached"69 69src69.")
		playsound(loc, 'sound/items/Ratchet.o6969', 75, 1)
		return

	else if (istype(I, /obj/item/69ripper))//Code for allowin69 cybor69s to use rechar69ers
		var/obj/item/69ripper/69ri = I
		if (char69in69)//If there's somethin69 in the char69er
			if (69ri.69rip_item(char69in69, user))//we attempt to 69rab it
				char69in69 = null
				update_icon()
			else
				to_chat(user, "<span class='dan69er'>Your 69ripper cannot hold \the 69char69in6969.</span>")

	if(!anchored)
		to_chat(user, SPAN_WARNIN69("Attach 69src69 first!"))
		return

	if(!user.canUnE69uip(I))
		return

	if(is_type_in_list(I, allowed_devices))
		if(char69in69)
			to_chat(user, SPAN_WARNIN69("\A 69char69in6969 is already char69in69 here."))
			return
		// Checks to69ake sure he's not in space doin69 it, and that the area 69ot proper power.
		if(!powered())
			to_chat(user, SPAN_WARNIN69("69src69 blinks red as you try to insert the item!"))
			return

		if (istype(I, /obj/item/69un/ener69y))
			var/obj/item/69un/ener69y/W = I
			if (W.disposable)
				to_chat(user, SPAN_NOTICE("Your 69un is disposable, it cannot be char69ed."))
				return
		if(istype(I, /obj/item/69un/ener69y/nuclear) || istype(I, /obj/item/69un/ener69y/crossbow))
			to_chat(user, SPAN_NOTICE("Your 69un's rechar69e port was removed to69ake room for a69iniaturized reactor."))
			return
		var/obj/item/cell/cell = I.69et_cell()

		if(!cell && istool(I))
			var/obj/item/tool/T = I

			if(!T.suitable_cell)
				return

			to_chat(user, SPAN_WARNIN69("This tool does not have a battery installed."))
			return

		if(!cell)
			to_chat(user, SPAN_WARNIN69("This device does not have a battery installed."))
			return //We don't want to 69o any farther if we failed to find a cell

		active_power_usa69e =69in(max_power_usa69e, (cell.maxchar69e*cell.max_char69erate)/CELLRATE)
		//If tryin69 to char69e a really small cell, we won't waste69ore power than it can intake

		user.unE69uip(I, src)
		char69in69 = I
		update_icon()




/obj/machinery/rechar69er/attack_hand(mob/user)
	if(issilicon(user))
		return

	add_fin69erprint(user)

	if(char69in69)
		char69in69.update_icon()
		user.put_in_hands(char69in69)
		char69in69 = null
		update_icon()

/obj/machinery/rechar69er/Process()
	if((stat & (NOPOWER|BROKEN)) || !anchored)
		update_icon()
		return

	var/obj/item/cell/cell = char69in69?.69et_cell()

	if(cell && !cell.fully_char69ed())
		cell.69ive((active_power_usa69e*CELLRATE)*efficiency)
		update_use_power(ACTIVE_POWER_USE)
	else
		update_use_power(IDLE_POWER_USE)
	update_icon()

/obj/machinery/rechar69er/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	var/obj/item/cell/cell = char69in69?.69et_cell()
	if(cell)
		cell.emp_act(severity)

	..(severity)

/obj/machinery/rechar69er/handle_atom_del(atom/A)
	..()
	if(A == char69in69)
		char69in69 = null
		update_icon()

/obj/machinery/rechar69er/update_icon()
	icon_state = initial(icon_state)

	if(panel_open)
		icon_state = "69icon_state69_open"

	else if((stat & (NOPOWER|BROKEN)) || !anchored)
		icon_state = "69icon_state69_off"
	else
		var/obj/item/cell/cell = char69in69?.69et_cell()

		if(cell)
			if(cell.fully_char69ed())
				icon_state = "69icon_state69_done"
			else
				icon_state = "69icon_state69_work"
		else if(char69in69)
			icon_state = "69icon_state69_done"

/obj/machinery/rechar69er/RefreshParts()
	..()
	var/ratin69 = 1
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		ratin69 += C.ratin69 - 1

	max_power_usa69e = initial(max_power_usa69e) * ratin69
	efficiency =69in(initial(efficiency) + (0.05 * (ratin69 - 1)), 0.99)



/obj/machinery/rechar69er/wallchar69er
	name = "wall rechar69er"
	desc = "A wall-mounted weapon char69in69 dock."
	icon_state = "wrechar69er"
	allowed_devices = list(/obj/item/69un/ener69y, /obj/item/melee/baton)
	portable = FALSE
	circuit = null
