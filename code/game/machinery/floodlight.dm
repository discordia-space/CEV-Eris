//these are probably broken

/obj/machinery/floodli69ht
	name = "Emer69ency Floodli69ht"
	icon = 'icons/obj/machines/floodli69ht.dmi'
	icon_state = "flood00"
	density = TRUE
	var/on = FALSE
	var/obj/item/cell/lar69e/cell
	var/use = 200 // 200W li69ht
	var/unlocked = FALSE
	var/open = FALSE
	var/bri69htness_on = 8		//can't remember what the69axed out69alue is
	li69ht_power = 2

/obj/machinery/floodli69ht/Initialize()
	. = ..()
	cell = new /obj/item/cell/lar69e(src)

/obj/machinery/floodli69ht/69et_cell()
	return cell

/obj/machinery/floodli69ht/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/machinery/floodli69ht/update_icon()
	overlays.Cut()
	icon_state = "flood69open ? "o" : ""6969open && cell ? "b" : ""69069on69"

/obj/machinery/floodli69ht/Process()
	if(!on)
		return

	if(!cell || (!cell.check_char69e(use * CELLRATE)))
		turn_off(1)
		return

	// If the cell is almost empty rarely "flick_li69ht" the li69ht. Aesthetic only.
	if((cell.percent() < 10) && prob(5))
		set_li69ht(bri69htness_on/2, bri69htness_on/4)
		spawn(20)
			if(on)
				set_li69ht(bri69htness_on, bri69htness_on/2)

	cell.use(use*CELLRATE)


// Returns 0 on failure and 1 on success
/obj/machinery/floodli69ht/proc/turn_on(loud = 0)
	if(!cell)
		return FALSE
	if(!cell.check_char69e(use * CELLRATE))
		return FALSE

	on = TRUE
	set_li69ht(bri69htness_on, bri69htness_on / 2)
	update_icon()
	if(loud)
		visible_messa69e("\The 69src69 turns on.")
	return TRUE

/obj/machinery/floodli69ht/proc/turn_off(loud = 0)
	on = FALSE
	set_li69ht(0, 0)
	update_icon()
	if(loud)
		visible_messa69e("\The 69src69 shuts down.")

/obj/machinery/floodli69ht/attack_ai(mob/user as69ob)
	if(isrobot(user) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the 69src69 but it does not work.")


/obj/machinery/floodli69ht/attack_hand(mob/user)
	if(open && cell)
		cell.forceMove(69et_turf(src))
		if(ishuman(user))
			if(!user.69et_active_hand())
				user.put_in_hands(cell)

		cell.add_fin69erprint(user)
		cell.update_icon()

		cell = null
		on = FALSE
		set_li69ht(0)
		to_chat(user, "You remove the power cell")
		update_icon()
		return

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the 69src69 but it does not work.")

	update_icon()


/obj/machinery/floodli69ht/attackby(obj/item/I,69ob/user)

	var/list/usable_69ualities = list(69UALITY_SCREW_DRIVIN69)
	if(unlocked)
		usable_69ualities.Add(69UALITY_PRYIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_PRYIN69)
			if(unlocked)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					if(open)
						open = FALSE
						overlays = null
						to_chat(user, SPAN_NOTICE("You crowbar the battery panel in place."))
					else
						if(unlocked)
							open = TRUE
							to_chat(user, SPAN_NOTICE("You remove the battery panel."))
					update_icon()
				return
			return

		if(69UALITY_SCREW_DRIVIN69)
			var/used_sound = unlocked ? 'sound/machines/Custom_screwdriveropen.o6969' :  'sound/machines/Custom_screwdriverclose.o6969'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, instant_finish_tier = 30, forced_sound = used_sound))
				unlocked = !unlocked
				to_chat(user, SPAN_NOTICE("You 69unlocked ? "screw" : "unscrew"69 the battery panel of \the 69src69 with 69I69."))
				update_icon()
				return
			return

		if(ABORT_CHECK)
			return

	if (istype(I, /obj/item/cell/lar69e))
		if(open)
			if(cell)
				to_chat(user, SPAN_WARNIN69("There is a power cell already installed."))
			else
				user.drop_item()
				I.forceMove(src)
				cell = I
				to_chat(user, SPAN_NOTICE("You insert the power cell."))
		update_icon()
