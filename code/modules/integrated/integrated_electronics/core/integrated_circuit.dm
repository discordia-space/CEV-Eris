/*
	Integrated circuits are essentially69odular69achines.  Each circuit has a specific function, and combining them inside Electronic Assemblies allows
a creative player the69eans to solve69any problems.  Circuits are held inside an electronic assembly, and are wired using special tools.
*/

/obj/item/integrated_circuit
	matter = list(MATERIAL_PLASTIC = 1,69ATERIAL_STEEL = 1)
	matter_reagents = list("silicon" = 5)

/obj/item/integrated_circuit/examine(mob/user)
	. = ..()
	external_examine(user)
	interact(user)


// This should be used when someone is examining while the case is opened.
/obj/item/integrated_circuit/proc/internal_examine(mob/user)
	to_chat(user, "This board has 69inputs.len69 input pin\s, 69outputs.len69 output pin\s and 69activators.len69 activation pin\s.")
	for(var/datum/integrated_io/input/I in inputs)
		if(I.linked.len)
			to_chat(user, "The '69I69' is connected to 69I.get_linked_to_desc()69.")
	for(var/datum/integrated_io/output/O in outputs)
		if(O.linked.len)
			to_chat(user, "The '69O69' is connected to 69O.get_linked_to_desc()69.")
	for(var/datum/integrated_io/activate/A in activators)
		if(A.linked.len)
			to_chat(user, "The '69A69' is connected to 69A.get_linked_to_desc()69.")
	any_examine(user)
	interact(user)

// This should be used when someone is examining from an 'outside' perspective, e.g. reading a screen or LED.
/obj/item/integrated_circuit/proc/external_examine(mob/user)
	any_examine(user)

/obj/item/integrated_circuit/proc/any_examine(mob/user)
	return

/obj/item/integrated_circuit/New()
	setup_io(inputs, /datum/integrated_io/input)
	setup_io(outputs, /datum/integrated_io/output)
	setup_io(activators, /datum/integrated_io/activate)
	..()

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

/obj/item/integrated_circuit/Destroy()
	for(var/datum/integrated_io/I in inputs)
		qdel(I)
	for(var/datum/integrated_io/O in outputs)
		qdel(O)
	for(var/datum/integrated_io/A in activators)
		qdel(A)
	. = ..()

/obj/item/integrated_circuit/nano_host()
	if(istype(src.loc, /obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/assembly = loc
		return assembly.resolve_nano_host()
	return ..()

/obj/item/integrated_circuit/emp_act(severity)
	for(var/datum/integrated_io/io in inputs + outputs + activators)
		io.scramble()

/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	if(!CanInteract(M,GLOB.physical_state))
		return

	var/input = sanitizeSafe(input("What do you want to name the circuit?", "Rename", src.name) as null|text,69AX_NAME_LEN)
	if(src && input && CanInteract(M,GLOB.physical_state))
		to_chat(M, SPAN_NOTICE("The circuit '69src.name69' is now labeled '69input69'."))
		name = input

/obj/item/integrated_circuit/interact(mob/user)
	if(!CanInteract(user,GLOB.physical_state))
		return

	var/window_height = 350
	var/window_width = 600

	//var/table_edge_width = "69(window_width - window_width * 0.1) / 469px"
	//var/table_middle_width = "69(window_width - window_width * 0.1) - (table_edge_width * 2)69px"
	var/table_edge_width = "30%"
	var/table_middle_width = "40%"

	var/HTML = list()
	HTML += "<html><head><title>69src.name69</title></head><body>"
	HTML += "<div align='center'>"
	HTML += "<table border='1' style='undefined;table-layout: fixed; width: 80%'>"

	HTML += "<br><a href='?src=\ref69src69;'>\69Refresh\69</a>  |  "
	HTML += "<a href='?src=\ref69src69;rename=1'>\69Rename\69</a>  |  "
	HTML += "<a href='?src=\ref69src69;scan=1'>\69Scan with Debugger\69</a>  |  "
	HTML += "<a href='?src=\ref69src69;remove=1'>\69Remove\69</a><br>"

	HTML += "<colgroup>"
	HTML += "<col style='width: 69table_edge_width69'>"
	HTML += "<col style='width: 69table_middle_width69'>"
	HTML += "<col style='width: 69table_edge_width69'>"
	HTML += "</colgroup>"

	var/column_width = 3
	var/row_height =69ax(inputs.len, outputs.len, 1)

	for(var/i = 1 to row_height)
		HTML += "<tr>"
		for(var/j = 1 to column_width)
			var/datum/integrated_io/io = null
			var/words = list()
			var/height = 1
			switch(j)
				if(1)
					io = get_pin_ref(IC_INPUT, i)
					if(io)
						if(io.linked.len)
							words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69><b>69io.name69 69io.display_data()69</b></a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69>\6969linked.name69\69</a> \
								@ <a href=?src=\ref69linked.holder69;examine=1;>69linked.holder69</a><br>"
						else
							words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69>69io.name69 69io.display_data()69</a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69>\6969linked.name69\69</a> \
								@ <a href=?src=\ref69linked.holder69;examine=1;>69linked.holder69</a><br>"
						if(outputs.len > inputs.len)
							height = 1
				if(2)
					if(i == 1)
						words += "69src.name69<br><br>69src.desc69"
						height = row_height
					else
						continue
				if(3)
					io = get_pin_ref(IC_OUTPUT, i)
					if(io)
						if(io.linked.len)
							words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69><b>69io.name69 69io.display_data()69</b></a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69>\6969linked.name69\69</a> \
								@ <a href=?src=\ref69linked.holder69;examine=1;user=\ref69user69>69linked.holder69</a><br>"
						else
							words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69>69io.name69 69io.display_data()69</a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69>\6969linked.name69\69</a> \
								@ <a href=?src=\ref69linked.holder69;examine=1;>69linked.holder69</a><br>"
						if(inputs.len > outputs.len)
							height = 1
			HTML += "<td align='center' rowspan='69height69'>69jointext(words, null)69</td>"
		HTML += "</tr>"

	for(var/activator in activators)
		var/datum/integrated_io/io = activator
		var/words = list()
		if(io.linked.len)
			words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69><font color='FF0000'><b>69io.name69</b></font></a><br>"
			for(var/datum/integrated_io/linked in io.linked)
				words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69>\6969linked.name69\69</a> \
				@ <a href=?src69src69;examine=1;user=\ref69user69>69linked.holder69</a><br>"
		else
			words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69><font color='FF0000'>69io.name69</font></a><br>"
			for(var/datum/integrated_io/linked in io.linked)
				words += "<a href=?src=\ref69src69;wire=1;pin=\ref69io69>\6969linked.name69\69</a> \
				@ <a href=?src=\ref69linked.holder69;examine=1;>69linked.holder69</a><br>"
		HTML += "<tr>"
		HTML += "<td colspan='3' align='center'>69jointext(words, null)69</td>"
		HTML += "</tr>"

	HTML += "</table>"
	HTML += "</div>"

	if(autopulse != -1)
		HTML += "<br><font color='33CC33'>Meta69ariables;</font>"
		HTML += "<br><font color='33CC33'><a href='?src=\ref69src69;autopulse=1'>\69Autopulse\69</a> = <b>69autopulse ? "ON" : "OFF"69</b></font>"
		HTML += "<br>"

	HTML += "<br><font color='0000AA'>Complexity: 69complexity69</font>"
	if(power_draw_idle)
		HTML += "<br><font color='0000AA'>Power Draw: 69power_draw_idle69 W (Idle)</font>"
	if(power_draw_per_use)
		HTML += "<br><font color='0000AA'>Power Draw: 69power_draw_per_use69 W (Active)</font>" // Borgcode says that powercells' checked_use() takes joules as input.
	HTML += "<br><font color='0000AA'>69extended_desc69</font>"

	HTML += "</body></html>"
	user << browse(jointext(HTML, null), "window=circuit-\ref69src69;size=69window_width69x69window_height69;border=1;can_resize=1;can_close=1;can_minimize=1")

	onclose(user, "circuit-\ref69src69")

/obj/item/integrated_circuit/Topic(href, href_list, state =GLOB.physical_state)
	if(..())
		return 1
	var/pin = locate(href_list69"pin"69) in inputs + outputs + activators

	var/obj/held_item = usr.get_active_hand()
	if(href_list69"wire"69)
		if(istype(held_item, /obj/item/device/electronics/integrated/wirer))
			var/obj/item/device/electronics/integrated/wirer/wirer = held_item
			if(pin)
				wirer.wire(pin, usr)

		else if(istype(held_item, /obj/item/device/electronics/integrated/debugger))
			var/obj/item/device/electronics/integrated/debugger/debugger = held_item
			if(pin)
				debugger.write_data(pin, usr)
		else
			to_chat(usr, SPAN_WARNING("You can't do a whole lot without the proper tools."))

	if(href_list69"examine"69)
		examine(usr)

	if(href_list69"rename"69)
		rename_component(usr)

	if(href_list69"scan"69)
		if(istype(held_item, /obj/item/device/electronics/integrated/debugger))
			var/obj/item/device/electronics/integrated/debugger/D = held_item
			if(D.accepting_refs)
				D.afterattack(src, usr, TRUE)
			else
				to_chat(usr, SPAN_WARNING("The Debugger's 'ref scanner' needs to be on."))
		else
			to_chat(usr, SPAN_WARNING("You need a Debugger set to 'ref'69ode to do that."))

	if(href_list69"autopulse"69)
		if(autopulse != -1)
			autopulse = !autopulse

	if(href_list69"remove"69)
		if(istype(held_item, /obj/item/tool/screwdriver))
			if(!removable)
				to_chat(usr, SPAN_WARNING("\The 69src69 seems to be permanently attached to the case."))
				return
			disconnect_all()
			var/turf/T = get_turf(src)
			forceMove(T)
			assembly = null
			playsound(T, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(usr, SPAN_NOTICE("You pop \the 69src69 out of the case, and slide it out."))
		else
			to_chat(usr, SPAN_WARNING("You need a screwdriver to remove components."))
		var/obj/item/device/electronic_assembly/ea = loc
		if(istype(ea))
			ea.interact(usr)
		return

	interact(usr) // To refresh the UI.

/obj/item/integrated_circuit/proc/push_data()
	for(var/datum/integrated_io/output/O in outputs)
		O.push_data()

/obj/item/integrated_circuit/proc/pull_data()
	for(var/datum/integrated_io/input/I in inputs)
		I.push_data()

/obj/item/integrated_circuit/proc/draw_idle_power()
	if(assembly)
		return assembly.draw_power(power_draw_idle)

// Override this for special behaviour when there's no power left.
/obj/item/integrated_circuit/proc/power_fail()
	return

// Returns true if there's enough power to work().
/obj/item/integrated_circuit/proc/check_power()
	if(!assembly)
		return FALSE // Not in an assembly, therefore no power.
	if(assembly.draw_power(power_draw_per_use))
		return TRUE // Battery has enough.
	return FALSE // Not enough power.

/obj/item/integrated_circuit/proc/check_then_do_work(var/ignore_power = FALSE)
	if(world.time < next_use) 	// All intergrated circuits have an internal cooldown, to protect from spam.
		return
	if(power_draw_per_use && !ignore_power)
		if(!check_power())
			power_fail()
			return
	next_use = world.time + cooldown_per_use
	do_work()

/obj/item/integrated_circuit/proc/do_work()
	return

/obj/item/integrated_circuit/proc/disconnect_all()
	for(var/datum/integrated_io/input/I in inputs)
		I.disconnect()
	for(var/datum/integrated_io/output/O in outputs)
		O.disconnect()
	for(var/datum/integrated_io/activate/A in activators)
		A.disconnect()
