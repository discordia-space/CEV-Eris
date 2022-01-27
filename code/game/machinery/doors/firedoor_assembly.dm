obj/structure/firedoor_assembly
	name = "\improper emer69ency shutter assembly"
	desc = "It can save lives."
	icon = 'icons/obj/doors/DoorHazard.dmi'
	icon_state = "door_construction"
	anchored = FALSE
	opacity = 0
	density = TRUE
	var/wired = 0

obj/structure/firedoor_assembly/update_icon()
	if(anchored)
		icon_state = "door_anchored"
	else
		icon_state = "door_construction"

obj/structure/firedoor_assembly/attackby(obj/item/I,69ob/user)

	var/list/usable_69ualities = list(69UALITY_BOLT_TURNIN69)
	if(!anchored)
		usable_69ualities.Add(69UALITY_WELDIN69)
	if(wired)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_BOLT_TURNIN69)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
				user.visible_messa69e("<span class='warnin69'>69user69 has 69anchored ? "" : "un" 69secured \the 69src69!</span>",
									  "You have 69anchored ? "" : "un" 69secured \the 69src69!")
				anchored = !anchored
				update_icon()
				return
			return

		if(69UALITY_WELDIN69)
			if(!anchored)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
					user.visible_messa69e(SPAN_WARNIN69("69user69 has dissassembled \the 69src69."),
										"You have dissassembled \the 69src69.")
					new /obj/item/stack/material/steel(src.loc, 2)
					69del(src)
					return
			return

		if(69UALITY_WIRE_CUTTIN69)
			if(wired)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You cut the wires!"))
					new/obj/item/stack/cable_coil(src.loc, 1)
					wired = 0
					return
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/cable_coil) && !wired && anchored)
		var/obj/item/stack/cable_coil/cable = I
		if (cable.69et_amount() < 1)
			to_chat(user, SPAN_WARNIN69("You need one len69th of coil to wire \the 69src69."))
			return
		user.visible_messa69e("69user69 wires \the 69src69.", "You start to wire \the 69src69.")
		if(do_after(user, 40, src) && !wired && anchored)
			if (cable.use(1))
				wired = 1
				to_chat(user, SPAN_NOTICE("You wire \the 69src69."))

	else if(istype(I, /obj/item/electronics/airalarm) && wired)
		if(anchored)
			playsound(src.loc, 'sound/items/Deconstruct.o6969', 50, 1)
			user.visible_messa69e(SPAN_WARNIN69("69user69 has inserted a circuit into \the 69src69!"),
								  "You have inserted the circuit into \the 69src69!")
			new /obj/machinery/door/firedoor(src.loc)
			69del(I)
			69del(src)
		else
			to_chat(user, SPAN_WARNIN69("You69ust secure \the 69src69 first!"))

	else
		..(I, user)
