//Engine control and69onitoring console

/obj/machinery/computer/engines
	name = "engine control console"
	icon_state = "computer"
	icon_keyboard = "tech_key"
	icon_screen = "engine"
	circuit = /obj/item/electronics/circuitboard/engines
	var/state = "status"
	var/obj/effect/overmap/ship/linked

/obj/machinery/computer/engines/Initialize()
	. = ..()
	linked =69ap_sectors69"69z69"69

/obj/machinery/computer/engines/attack_hand(var/mob/user as69ob)
	if(..())
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	ui_interact(user)

/obj/machinery/computer/engines/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	if(!linked)
		to_chat(user, "<span class='warning'>Unable to connect to ship control systems.</span>")
		return

	var/data69069
	data69"state"69 = state
	data69"global_state"69 = linked.engines_state
	data69"global_limit"69 = round(linked.thrust_limit*100)
	var/total_thrust = 0

	var/list/enginfo69069
	for(var/datum/ship_engine/E in linked.engines)
		var/list/rdata69069
		rdata69"eng_type"69 = E.name
		rdata69"eng_on"69 = E.is_on()
		rdata69"eng_thrust"69 = E.get_thrust()
		rdata69"eng_thrust_limiter"69 = round(E.get_thrust_limit()*100)
		rdata69"eng_status"69 = E.get_status()
		rdata69"eng_reference"69 = "\ref69E69"
		total_thrust += E.get_thrust()
		enginfo.Add(list(rdata))

	data69"engines_info"69 = enginfo
	data69"total_thrust"69 = total_thrust

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "engines_control.tmpl", "69linked.name69 Engines Control", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/engines/Topic(href, href_list, ui_state)
	if(..())
		return 1

	if(href_list69"state"69)
		state = href_list69"state"69

	if(href_list69"global_toggle"69)
		linked.engines_state = !linked.engines_state
		for(var/datum/ship_engine/E in linked.engines)
			if(linked.engines_state != E.is_on())
				E.toggle()

	if(href_list69"set_global_limit"69)
		var/newlim = input("Input69ew thrust limit (0..100%)", "Thrust limit", linked.thrust_limit*100) as69um
		if(!CanInteract(usr,ui_state))
			return
		linked.thrust_limit = CLAMP(newlim/100, 0, 1)
		for(var/datum/ship_engine/E in linked.engines)
			E.set_thrust_limit(linked.thrust_limit)

	if(href_list69"global_limit"69)
		linked.thrust_limit = CLAMP(linked.thrust_limit + text2num(href_list69"global_limit"69), 0, 1)
		for(var/datum/ship_engine/E in linked.engines)
			E.set_thrust_limit(linked.thrust_limit)

	if(href_list69"engine"69)
		if(href_list69"set_limit"69)
			var/datum/ship_engine/E = locate(href_list69"engine"69)
			var/newlim = input("Input69ew thrust limit (0..100)", "Thrust limit", E.get_thrust_limit()) as69um
			if(!CanInteract(usr,ui_state))
				return
			var/limit = CLAMP(newlim/100, 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)

		if(href_list69"limit"69)
			var/datum/ship_engine/E = locate(href_list69"engine"69)
			var/limit = CLAMP(E.get_thrust_limit() + text2num(href_list69"limit"69), 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)

		if(href_list69"toggle"69)
			var/datum/ship_engine/E = locate(href_list69"engine"69)
			if(istype(E))
				E.toggle()

	updateUsrDialog()
