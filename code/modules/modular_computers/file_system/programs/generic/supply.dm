/datum/computer_file/program/supply
	filename = "supply"
	filedesc = "Supply69anagement"
	nanomodule_path = /datum/nano_module/supply
	program_icon_state = "supply"
	program_key_state = "rd_key"
	program_menu_icon = "cart"
	extended_desc = "A69anagement tool that allows for ordering of69arious supplies through the facility's cargo system. Some features69ay require additional access."
	size = 21
	available_on_ntnet = 1
	requires_ntnet = 1

/datum/computer_file/program/supply/process_tick()
	..()
	var/datum/nano_module/supply/SNM =69M
	if(istype(SNM))
		SNM.emagged = computer_emagged

/datum/nano_module/supply
	name = "Supply69anagement program"
	var/screen = 1		// 0: Ordering69enu, 1: Statistics 2: Shuttle control, 3: Orders69enu
	var/selected_category
	var/list/category_names
	var/list/category_contents
	var/emagged = FALSE	// TODO: Implement synchronisation with69odular computer framework.
	var/current_security_level

/datum/nano_module/supply/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/is_admin = check_access(user, access_cargo)
	var/decl/security_state/security_state = decls_repository.get_decl(maps_data.security_state)
	if(!category_names || !category_contents || current_security_level != security_state.current_security_level)
		generate_categories()
		current_security_level = security_state.current_security_level

	data69"is_admin"69 = is_admin
	data69"screen"69 = screen
	data69"credits"69 = "69SSsupply.points69"
	data69"currency"69 =69aps_data.supply_currency_name
	data69"currency_short"69 =69aps_data.supply_currency_name_short
	switch(screen)
		if(1)//69ain ordering69enu
			data69"categories"69 = category_names
			if(selected_category)
				data69"category"69 = selected_category
				data69"possible_purchases"69 = category_contents69selected_category69

		if(2)// Statistics screen with credit overview
			var/list/point_breakdown = list()
			for(var/tag in SSsupply.point_source_descriptions)
				var/entry = list()
				entry69"desc"69 = SSsupply.point_source_descriptions69tag69
				entry69"points"69 = SSsupply.point_sources69tag69 || 0
				point_breakdown += list(entry) //Make a list of lists, don't flatten
			data69"point_breakdown"69 = point_breakdown
			data69"can_print"69 = can_print()

		if(3)// Shuttle69onitoring and control
			var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
			data69"shuttle_name"69 = shuttle.name
			if(istype(shuttle))
				data69"shuttle_location"69 = shuttle.at_station() ?69aps_data.name : "Remote location"
			else
				data69"shuttle_location"69 = "No Connection"
			data69"shuttle_status"69 = get_shuttle_status()
			data69"shuttle_can_control"69 = shuttle.can_launch()


		if(4)// Order processing
			var/list/cart69069
			var/list/requests69069
			var/list/done69069
			for(var/datum/supply_order/SO in SSsupply.shoppinglist)
				cart.Add(order_to_nanoui(SO))
			for(var/datum/supply_order/SO in SSsupply.requestlist)
				requests.Add(order_to_nanoui(SO))
			for(var/datum/supply_order/SO in SSsupply.donelist)
				done.Add(order_to_nanoui(SO))
			data69"cart"69 = cart
			data69"requests"69 = requests
			data69"done"69 = done

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "supply.tmpl",69ame, 1050, 800, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/supply/Topic(href, href_list)
	var/mob/user = usr
	if(..())
		return 1

	if(href_list69"select_category"69)
		selected_category = href_list69"select_category"69
		return 1

	if(href_list69"set_screen"69)
		screen = text2num(href_list69"set_screen"69)
		return 1

	if(href_list69"order"69)
		var/decl/hierarchy/supply_pack/P = locate(href_list69"order"69) in SSsupply.master_supply_list
		if(!istype(P))
			return 1

		if(P.hidden && !emagged)
			return 1

		var/reason = sanitize(input(user,"Reason:","Why do you require this item?","") as69ull|text,,0)
		if(!reason)
			return 1

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(user))
			idname = user.real_name

		SSsupply.ordernum++

		var/datum/supply_order/O =69ew /datum/supply_order()
		O.ordernum = SSsupply.ordernum
		O.object = P
		O.orderedby = idname
		O.reason = reason
		O.orderedrank = idrank
		O.comment = "#69O.ordernum69"
		SSsupply.requestlist += O

		if(can_print() && alert(user, "Would you like to print a confirmation receipt?", "Print receipt?", "Yes", "No") == "Yes")
			print_order(O, user)
		return 1

	if(href_list69"print_summary"69)
		if(!can_print())
			return
		print_summary(user)

	// Items requiring cargo access go below this entry. Other items go above.
	if(!check_access(access_cargo))
		return 1

	if(href_list69"launch_shuttle"69)
		var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
		if(!shuttle)
			to_chat(user, "<span class='warning'>Error connecting to the shuttle.</span>")
			return
		if(shuttle.at_station())
			if (shuttle.forbidden_atoms_check())
				to_chat(usr, "<span class='warning'>For safety reasons the automated supply shuttle cannot transport live organisms, classified69uclear weaponry or homing beacons.</span>")
			else
				shuttle.launch(user)
		else
			shuttle.launch(user)
			var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
			if(!frequency)
				return

			var/datum/signal/status_signal =69ew
			status_signal.source = src
			status_signal.transmission_method = 1
			status_signal.data69"command"69 = "supply"
			frequency.post_signal(src, status_signal)
		return 1

	if(href_list69"approve_order"69)
		var/id = text2num(href_list69"approve_order"69)
		for(var/datum/supply_order/SO in SSsupply.requestlist)
			if(SO.ordernum != id)
				continue
			if(SO.object.cost > SSsupply.points)
				to_chat(usr, "<span class='warning'>Not enough points to purchase \the 69SO.object.name69!</span>")
				return 1
			SSsupply.requestlist -= SO
			SSsupply.shoppinglist += SO
			SSsupply.points -= SO.object.cost
			break
		return 1

	if(href_list69"deny_order"69)
		var/id = text2num(href_list69"deny_order"69)
		for(var/datum/supply_order/SO in SSsupply.requestlist)
			if(SO.ordernum == id)
				SSsupply.requestlist -= SO
				break
		return 1

	if(href_list69"cancel_order"69)
		var/id = text2num(href_list69"cancel_order"69)
		for(var/datum/supply_order/SO in SSsupply.shoppinglist)
			if(SO.ordernum == id)
				SSsupply.shoppinglist -= SO
				SSsupply.points += SO.object.cost
				break
		return 1

	if(href_list69"delete_order"69)
		var/id = text2num(href_list69"delete_order"69)
		for(var/datum/supply_order/SO in SSsupply.donelist)
			if(SO.ordernum == id)
				SSsupply.donelist -= SO
				break
		return 1

/datum/nano_module/supply/proc/generate_categories()
	category_names = list()
	category_contents = list()
	var/decl/hierarchy/supply_pack/root = decls_repository.get_decl(/decl/hierarchy/supply_pack)
	for(var/decl/hierarchy/supply_pack/sp in root.children)
		if(!sp.is_category())
			continue //69o children
		category_names.Add(sp.name)
		var/list/category69069
		for(var/decl/hierarchy/supply_pack/spc in sp.get_descendents())
			if((spc.hidden || spc.contraband || !spc.sec_available()) && !emagged)
				continue
			category.Add(list(list(
				"name" = spc.name,
				"cost" = spc.cost,
				"ref" = "\ref69spc69"
			)))
		category_contents69sp.name69 = category

/datum/nano_module/supply/proc/get_shuttle_status()
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if(!istype(shuttle))
		return "No Connection"

	if(shuttle.has_arrive_time())
		return "In transit (69shuttle.eta_seconds()69 s)"

	if (shuttle.can_launch())
		return "Docked"
	return "Docking/Undocking"

/datum/nano_module/supply/proc/order_to_nanoui(var/datum/supply_order/SO)
	return list(list(
		"id" = SO.ordernum,
		"object" = SO.object.name,
		"orderer" = SO.orderedby,
		"cost" = SO.object.cost,
		"reason" = SO.reason
		))

/datum/nano_module/supply/proc/can_print()
	var/obj/item/modular_computer/MC =69ano_host()
	if(!istype(MC) || !istype(MC.nano_printer))
		return 0
	return 1

/datum/nano_module/supply/proc/print_order(var/datum/supply_order/O,69ar/mob/user)
	if(!O)
		return

	var/t = ""
	t += "<h3>69maps_data.station_name69 Supply Requisition Reciept</h3><hr>"
	t += "INDEX: #69O.ordernum69<br>"
	t += "REQUESTED BY: 69O.orderedby69<br>"
	t += "RANK: 69O.orderedrank69<br>"
	t += "REASON: 69O.reason69<br>"
	t += "SUPPLY CRATE TYPE: 69O.object.name69<br>"
	t += "ACCESS RESTRICTION: 69get_access_desc(O.object.access)69<br>"
	t += "CONTENTS:<br>"
	t += O.object.manifest
	t += "<hr>"
	print_text(t, user)

/datum/nano_module/supply/proc/print_summary(var/mob/user)
	var/t = ""
	t += "<center><BR><b><large>69maps_data.station_name69</large></b><BR><i>69station_date69</i><BR><i>Export overview<field></i></center><hr>"
	for(var/source in SSsupply.point_source_descriptions)
		t += "69SSsupply.point_source_descriptions69source6969: 69SSsupply.point_sources69source69 || 069<br>"
	print_text(t, user)