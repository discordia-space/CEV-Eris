#define GOODS_SCREEN "goods"
#define OFFER_SCREEN "offers"
#define CART_SCREEN "cart"
#define ORDER_SCREEN "orders"
#define SAVED_SCREEN "saved"
#define LOG_SCREEN "logs"
#define LOG_SHIPPING "Shipping"
#define LOG_EXPORT "Export"
#define LOG_OFFER "Offer"
#define LOG_ORDER "Order"
#define PRG_MAIN TRUE
#define PRG_TREE FALSE
#define TRADESCREEN list(GOODS_SCREEN, OFFER_SCREEN, CART_SCREEN, ORDERS_SCREEN, SAVED_SCREEN)
#define LOG_SCREEN_LIST list(LOG_SHIPPING, LOG_EXPORT, LOG_OFFER, LOG_ORDER)

/datum/computer_file/program/trade
	filename = "trade"
	filedesc = "Trading Program"
	nanomodule_path = /datum/nano_module/program/trade
	program_icon_state = "supply"
	program_key_state = "rd_key"
	program_menu_icon = "cart"
	extended_desc = "A trade tool, requires sending and receiving beacons."
	size = 21
	available_on_ntnet = FALSE
	requires_ntnet = TRUE

	var/program_type = "master"	// master, slave, ordering

	var/prg_screen = PRG_TREE
	var/trade_screen = GOODS_SCREEN
	var/log_screen

	var/obj/machinery/trade_beacon/sending/sending
	var/obj/machinery/trade_beacon/receiving/receiving
	var/datum/money_account/account

	var/list/shoppinglist = list()		// list(
										// 		station reference = list(
										//			"category" = list(
										//				path to buy = amount
										//				)
										//			)
										//		)
	var/list/saved_shopping_lists = list()
	var/saved_cart_id = 0
	var/saved_cart_page = 1
	var/saved_cart_page_max

	var/datum/trade_station/station
	var/chosen_category

	var/cart_station_index
	var/cart_category_index

	var/current_order
	var/current_order_page = 1
	var/order_page_max
	var/orders_locked = FALSE			// For preventing order spam

	var/current_log_page = 1
	var/log_page_max

/datum/computer_file/program/trade/proc/set_chosen_category(value)
	chosen_category = value

/datum/computer_file/program/trade/proc/open_shop_list()
	var/list/category_list = list()
	var/list/inventory_list = list()

	LAZYDISTINCTADD(shoppinglist, station)				// Add the station reference to the shopping list if it doesn't already exist

	if(!islist(shoppinglist[station]))					// If nothing has been added under this station, create an empty list
		shoppinglist[station] = list()

	category_list = shoppinglist[station]				// Make the category list point to the current station's category list
	LAZYDISTINCTADD(category_list, chosen_category)		// Add the category to the shopping list if it doesn't already exist

	if(!islist(category_list[chosen_category]))			// If nothing has been added under this category, create an empty list
		category_list[chosen_category] = list()

	inventory_list = category_list[chosen_category]		// Make the inventory list point to the current category's inventory list

	return inventory_list								// Return a reference to the current category's list of items

/datum/computer_file/program/trade/proc/sanitize_shop_list()
	var/list/category_list = list()

	for(var/station in shoppinglist)
		category_list = shoppinglist[station]
		for(var/category in category_list)
			if(!LAZYLEN(category_list[category]))
				category_list -= category
		if(!LAZYLEN(category_list))
			shoppinglist -= station
			cart_station_index = null

	if(!LAZYLEN(shoppinglist))
		cart_category_index = null
		cart_station_index = null

/datum/computer_file/program/trade/proc/add_to_shop_list(path, amount, limit)
	if(!path)
		return
	var/list/inventory_list = open_shop_list()		// Get reference to inventory list
	LAZYDISTINCTADD(inventory_list, path)
	LAZYAPLUS(inventory_list, path, max(0, amount))

	if(inventory_list[path] > limit)
		LAZYSET(inventory_list, path, limit)

/datum/computer_file/program/trade/proc/remove_from_shop_list(path, amount)
	var/list/inventory_list = open_shop_list()		// Get reference to inventory list
	if(inventory_list.Find(path))					// If path exists, subtract from amount
		inventory_list[path] -= amount					// Not using LAZYAMINUS() because we only want to sanitize the whole list if the path is removed
		if(inventory_list[path] < 1)				// If amount is less than 1, remove from list
			inventory_list -= path
			sanitize_shop_list()					// Don't need to sanitize every time, just when we're removing a path from the list

/datum/computer_file/program/trade/proc/reset_shop_list()
	shoppinglist = list()
	cart_category_index = null
	cart_station_index = null

/datum/computer_file/program/trade/proc/save_shop_list(name, list/shop_list = null)
	// Need to open and copy every list within the list since copying the list just makes a list of references
	var/list/list_to_copy

	if(!shop_list)
		list_to_copy = shoppinglist
	else if(islist(shop_list))
		list_to_copy = shop_list

	var/list/list_to_save = list_to_copy.Copy()

	for(var/station in list_to_copy)
		var/list/categories = list_to_copy[station]
		var/list/categories_copy = categories.Copy()
		for(var/category in categories)
			var/list/goods = categories[category]
			LAZYSET(categories_copy, category, goods.Copy())
		LAZYSET(list_to_save, station, categories_copy)

	var/list_name = name ? name : "Saved Cart #[++saved_cart_id]"

	LAZYDISTINCTADD(saved_shopping_lists, list_name)
	LAZYSET(saved_shopping_lists, list_name, list_to_save)

/datum/computer_file/program/trade/proc/load_shop_list(name)
	if(!saved_shopping_lists.Find(name))
		return

	// Need to open and copy every list within the list since copying the list just makes a list of references
	var/list/list_to_copy = saved_shopping_lists[name]
	var/list/list_to_load = list_to_copy.Copy()

	for(var/station in list_to_copy)
		var/list/categories = list_to_copy[station]
		var/list/categories_copy = categories.Copy()
		for(var/category in categories)
			var/list/goods = categories[category]
			LAZYSET(categories_copy, category, goods.Copy())
		LAZYSET(list_to_load, station, categories_copy)

	return list_to_load.Copy()

/datum/computer_file/program/trade/proc/delete_shop_list(name)
	if(!saved_shopping_lists.Find(name))
		return

	saved_shopping_lists -= name

/datum/computer_file/program/trade/proc/unlock_ordering()
	orders_locked = FALSE

/datum/computer_file/program/trade/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["PRG_prg_screen"])
		prg_screen = !prg_screen
		return TRUE

	if(href_list["PRG_trade_screen"])
		trade_screen = href_list["PRG_trade_screen"]
		return TRUE

	if(href_list["PRG_log_screen"])
		log_screen = input("Select log type", "Log Type", null) as null|anything in LOG_SCREEN_LIST
		current_log_page = 1
		return TRUE

	if(href_list["PRG_goods_category"])
		if(!chosen_category || !(chosen_category in station.inventory))
			set_chosen_category()
		set_chosen_category((text2num(href_list["PRG_goods_category"]) <= length(station.inventory)) ? station.inventory[text2num(href_list["PRG_goods_category"])] : "")
		return TRUE

	if(href_list["PRG_account"])
		var/acc_num = input("Enter account number", "Account linking", computer?.card_slot?.stored_card?.associated_account_number) as num|null
		if(!acc_num)
			return

		var/acc_pin = input("Enter PIN", "Account linking") as num|null
		if(!acc_pin)
			return

		var/card_check = computer?.card_slot?.stored_card?.associated_account_number == acc_num
		var/datum/money_account/A = attempt_account_access(acc_num, acc_pin, card_check ? 2 : 1, TRUE)
		if(!A)
			to_chat(usr, SPAN_WARNING("Unable to link account: access denied."))
			return

		account = A
		return TRUE

	if(href_list["PRG_account_unlink"])
		account = null
		current_order = null
		return TRUE

	if(href_list["PRG_station"])
		var/datum/trade_station/S = SStrade.get_discovered_station_by_uid(href_list["PRG_station"])
		if(!S)
			return
		set_chosen_category()
		station = S
		return TRUE

	// Cart buttons
	if(href_list["PRG_cart_reset"])
		reset_shop_list()
		return TRUE

	if(href_list["PRG_cart_add"] || href_list["PRG_cart_add_input"])
		if(!account)
			to_chat(usr, SPAN_WARNING("ERROR: No account linked."))
			return
		var/ind
		var/count2buy = 1
		if(href_list["PRG_cart_add_input"])
			count2buy = input(usr, "Input how many you want to add", "Trade", 2) as num
			ind = text2num(href_list["PRG_cart_add_input"])
		else
			ind = text2num(href_list["PRG_cart_add"])
		var/list/category = station.inventory[chosen_category]
		if(!islist(category))
			return
		var/path = LAZYACCESS(category, ind)
		if(!path)
			return
		var/good_amount = station.get_good_amount(chosen_category, ind)
		if(!good_amount)
			return

		add_to_shop_list(path, count2buy, good_amount)
		return TRUE

	if(href_list["PRG_cart_remove"])
		if(!account)
			to_chat(usr, SPAN_WARNING("ERROR: No account linked."))
			return
		var/list/category = station.inventory[chosen_category]
		if(!islist(category))
			return
		var/path = LAZYACCESS(category, text2num(href_list["PRG_cart_remove"]))
		if(!path)
			return

		remove_from_shop_list(path, 1)
		return TRUE

	if(href_list["PRG_cart_category"])
		cart_category_index = text2num(href_list["PRG_cart_category"])
		return TRUE

	if(href_list["PRG_cart_station"])
		cart_station_index = text2num(href_list["PRG_cart_station"])
		cart_category_index = null
		return TRUE

	if(href_list["PRG_cart_save"])
		var/name = sanitizeName(input("Would you like to name the saved cart? (Not required)", "Save Cart"), MAX_NAME_LEN)
		save_shop_list(name)
		return TRUE

	if(href_list["PRG_cart_load"])
		var/name = input("Choose a cart to load", "Load Cart", null) as null|anything in saved_shopping_lists
		if(!name)
			to_chat(usr, SPAN_WARNING("ERROR: Invalid cart."))
			return
		shoppinglist = load_shop_list(name)
		trade_screen = CART_SCREEN
		return TRUE

	if(href_list["PRG_cart_load_direct"])
		var/name = saved_shopping_lists[text2num(href_list["PRG_cart_load_direct"])]
		if(!name)
			to_chat(usr, SPAN_WARNING("ERROR: Invalid cart."))
			return
		shoppinglist = load_shop_list(name)
		trade_screen = CART_SCREEN
		return TRUE

	if(href_list["PRG_cart_delete"])
		var/name = saved_shopping_lists[text2num(href_list["PRG_cart_delete"])]
		delete_shop_list(name)
		return TRUE

	// Order requests
	if(href_list["PRG_reason"])
		var/reason = sanitizeName(input("Enter reason(s) for order", "Request Reason", ""), MAX_NAME_LEN)
		var/list/order = SStrade.order_queue[current_order]
		order["reason"] = reason
		return TRUE

	if(href_list["PRG_build_order"])
		if(orders_locked)
			to_chat(usr, SPAN_WARNING("ERROR: You cannot place an order at this time. Please wait 10 seconds."))
			return
		var/reason = sanitizeName(input("Enter reason(s) for order", "Request Reason", ""), MAX_NAME_LEN)
		current_order = SStrade.build_order(account, reason, shoppinglist)
		shoppinglist = list()
		trade_screen = ORDER_SCREEN
		if(account != department_accounts[DEPARTMENT_GUILD])
			orders_locked = TRUE
			addtimer(CALLBACK(src, PROC_REF(unlock_ordering)), 10 SECONDS, TIMER_STOPPABLE)
		return TRUE

	if(href_list["PRG_view_order"])
		current_order = href_list["PRG_view_order"]
		return TRUE

	if(href_list["PRG_remove_order"])
		SStrade.order_queue.Remove(href_list["PRG_remove_order"])
		if(current_order == href_list["PRG_remove_order"])
			current_order = null
		return TRUE

	if(href_list["PRG_save_order"])
		var/order_id = href_list["PRG_save_order"]
		if(!order_id || !SStrade.order_queue.Find(order_id))
			to_chat(usr, SPAN_WARNING("ERROR: Order does not exist."))
			return
		var/name = sanitizeName(input("Would you like to name the saved cart? (Not required)", "Save Cart"), MAX_NAME_LEN)
		var/list/order_data = SStrade.order_queue[order_id]
		save_shop_list(name, order_data["contents"])
		return TRUE

	// Logs
	if(href_list["PRG_print"] || href_list["PRG_print_internal"])
		var/log_id = href_list["PRG_print"] || href_list["PRG_print_internal"]
		if(computer?.printer)
			var/list/log_data = SStrade.get_log_data_by_id(log_id)

			if(!log_data.len)
				to_chat(usr, SPAN_WARNING("Unable to print invoice: no log with id \"[log_id]\" found."))
				return

			var/id_data = splittext(log_id, "-")
			var/log_type = id_data[2]

			switch(log_type)
				if("S")
					log_type = "Shipping"
				if("E")
					log_type = "Export"
				if("SO")
					log_type = "Special Offer"
				if("O")
					log_type = "Order"
				else
					return

			var/title
			title = "[lowertext(log_type)] invoice - #[log_id]"
			title += href_list["PRG_print_internal"] ? " (internal)" : null

			var/text
			text += "<h3>[log_type] Invoice - #[log_id]</h3>"
			text += "<hr><font size = \"2\">"
			text += href_list["PRG_print_internal"] ? "FOR INTERNAL USE ONLY<br><br>" : null
			text += log_type != "Shipping" && log_type ? "Recipient: [log_data["ordering_acct"]]<br>" : "Recipient: \[field\]<br>"
			text += log_type == "Shipping" ? "Package Name: \[field\]<br>" : null
			text += "Contents:<br>"
			text += "<ul>"
			text += log_data["contents"]
			text += "</ul>"
			text += href_list["PRG_print_internal"] ? "Order Cost: [log_data["total_paid"]]<br>" : null
			text += log_type == "Shipping" ? "Total Credits Paid: \[field\]<br>" : "Total Credits Paid: [log_data["total_paid"]]<br>"
			text += "</font>"
			text += log_type == "Shipping" ? "<hr><h5>Stamp below to confirm receipt of goods:</h5>" : null

			computer.printer.print_text(text, title)
		else
			to_chat(usr, SPAN_WARNING("Unable to print invoice: no printer component installed."))
		return TRUE

	// Page navigation
	if(href_list["PRG_page_first"])
		switch(href_list["PRG_page_first"])
			if(ORDER_SCREEN)
				current_order_page = 1
			if(SAVED_SCREEN)
				saved_cart_page = 1
			if(LOG_SCREEN)
				current_log_page = 1
		return TRUE

	if(href_list["PRG_page_prev_10"])
		switch(href_list["PRG_page_prev_10"])
			if(ORDER_SCREEN)
				current_order_page = max(1, current_order_page - 10)
			if(SAVED_SCREEN)
				saved_cart_page = max(1, saved_cart_page - 10)
			if(LOG_SCREEN)
				current_log_page = max(1, current_log_page - 10)
		return TRUE

	if(href_list["PRG_page_prev"])
		switch(href_list["PRG_page_prev"])
			if(ORDER_SCREEN)
				current_order_page = max(1, --current_order_page)
			if(SAVED_SCREEN)
				saved_cart_page = max(1, --saved_cart_page)
			if(LOG_SCREEN)
				current_log_page = max(1, --current_log_page)
		return TRUE

	if(href_list["PRG_page_select"])
		var/input
		switch(href_list["PRG_page_select"])
			if(ORDER_SCREEN)
				input = input("Enter page number (1-[order_page_max])", "Page Selection") as num|null
				if(!input)
					return
				current_order_page = clamp(input, 1, order_page_max)
			if(SAVED_SCREEN)
				input = input("Enter page number (1-[saved_cart_page_max])", "Page Selection") as num|null
				if(!input)
					return
				saved_cart_page = clamp(input, 1, saved_cart_page_max)
			if(LOG_SCREEN)
				current_log_page = clamp(input, 1, log_page_max)
		return TRUE

	if(href_list["PRG_page_next"])
		switch(href_list["PRG_page_next"])
			if(ORDER_SCREEN)
				current_order_page = min(order_page_max, ++current_order_page)
			if(SAVED_SCREEN)
				saved_cart_page = min(saved_cart_page_max, ++saved_cart_page)
			if(LOG_SCREEN)
				current_log_page = min(log_page_max, ++current_log_page)
		return TRUE

	if(href_list["PRG_page_next_10"])
		switch(href_list["PRG_page_next_10"])
			if(ORDER_SCREEN)
				current_order_page = min(order_page_max, current_order_page + 10)
			if(SAVED_SCREEN)
				saved_cart_page = min(saved_cart_page_max, saved_cart_page + 10)
			if(LOG_SCREEN)
				current_log_page = min(log_page_max, current_log_page + 10)
		return TRUE

	if(href_list["PRG_page_last"])
		switch(href_list["PRG_page_last"])
			if(ORDER_SCREEN)
				current_order_page = order_page_max
			if(SAVED_SCREEN)
				saved_cart_page = saved_cart_page_max
			if(LOG_SCREEN)
				current_log_page = log_page_max
		return TRUE

	// Functions used by the regular trading programs
	if(program_type != "ordering")
		if(href_list["PRG_receiving"])
			var/list/beacons_by_id = list()
			for(var/obj/machinery/trade_beacon/receiving/beacon in SStrade.beacons_receiving)
				if(get_area(beacon) == get_area(computer) || program_type == "master")
					var/beacon_id = beacon.get_id()
					beacons_by_id.Insert(beacon_id, beacon_id)
					beacons_by_id[beacon_id] = beacon
			if(beacons_by_id.len == 1)
				receiving = beacons_by_id[beacons_by_id[1]]
			else
				var/id = input("Select nearby receiving beacon", "Receiving Beacon", null) as null|anything in beacons_by_id
				receiving = beacons_by_id[id]
			return TRUE

		if(href_list["PRG_sending"])
			var/list/beacons_by_id = list()
			for(var/obj/machinery/trade_beacon/sending/beacon in SStrade.beacons_sending)
				if(get_area(beacon) == get_area(computer) || program_type == "master")
					var/beacon_id = beacon.get_id()
					beacons_by_id.Insert(beacon_id, beacon_id)
					beacons_by_id[beacon_id] = beacon
			if(beacons_by_id.len == 1)
				sending = beacons_by_id[beacons_by_id[1]]
			else
				var/id = input("Select nearby sending beacon", "Sending Beacon", null) as null|anything in beacons_by_id
				sending = beacons_by_id[id]
			return TRUE

		if(account)
			if(href_list["PRG_offer_fulfill"])
				if(get_area(sending) != get_area(computer) && program_type != "master")
					to_chat(usr, SPAN_WARNING("ERROR: Sending beacon is too far from \the [computer]."))
					return
				var/datum/trade_station/S = LAZYACCESS(SStrade.discovered_stations, text2num(href_list["PRG_offer_fulfill"]))
				if(!S)
					return
				var/atom/movable/path = text2path(href_list["PRG_offer_fulfill_path"])
				var/is_slaved = (program_type == "slave") ? TRUE : FALSE
				SStrade.fulfill_offer(sending, account, station, path, is_slaved)
				return TRUE

			if(href_list["PRG_offer_fulfill_all"])
				if(get_area(sending) != get_area(computer) && program_type != "master")
					to_chat(usr, SPAN_WARNING("ERROR: Sending beacon is too far from \the [computer]."))
					return
				var/is_slaved = (program_type == "slave") ? TRUE : FALSE
				SStrade.fulfill_all_offers(sending, account, is_slaved)
				return TRUE

		if(receiving)
			if(href_list["PRG_receive"])
				if(!account)
					to_chat(usr, SPAN_WARNING("ERROR: no account linked."))
					return
				if(get_area(receiving) != get_area(computer) && program_type != "master")
					to_chat(usr, SPAN_WARNING("ERROR: Receiving beacon is too far from \the [computer]."))
					return
				SStrade.buy(receiving, account, shoppinglist)
				reset_shop_list()
				return TRUE

		if(sending)
			if(href_list["PRG_export"])
				if(get_area(sending) != get_area(computer) && program_type != "master")
					to_chat(usr, SPAN_WARNING("ERROR: Sending beacon is too far from \the [computer]."))
					return
				SStrade.export(sending)
				return TRUE

		if(href_list["PRG_approve_order"])
			if(!account)
				return
			var/order = href_list["PRG_approve_order"]
			var/list/order_data = SStrade.order_queue[order]
			var/order_cost = order_data["cost"]
			var/requestor_cost = order_data["cost"] + order_data["fee"]
			var/datum/money_account/requesting_account = order_data["requesting_acct"]

			if(account.money < order_cost)
				to_chat(usr, SPAN_WARNING("ERROR: Not enough funds in account ([account.get_name()] #[account.account_number])."))
				return
			if(requesting_account.money < requestor_cost)
				to_chat(usr, SPAN_WARNING("ERROR: Not enough funds in requesting account ([requesting_account.get_name()] #[requesting_account.account_number])."))
				return

			SStrade.purchase_order(receiving, order)
			SStrade.order_queue.Remove(order)
			if(current_order == order)
				current_order = null
			return TRUE

/datum/nano_module/program/trade
	name = "Trading Program"

/datum/nano_module/program/trade/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = nano_ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "trade.tmpl", name, 910, 800, state = state)

		// template keys starting with _ are not appended to the UI automatically and have to be called manually
		ui.add_template("_goods", "trade_goods.tmpl")
		ui.add_template("_offers", "trade_offers.tmpl")
		ui.add_template("_cart", "trade_cart.tmpl")
		ui.add_template("_orders", "trade_orders.tmpl")
		ui.add_template("_saved", "trade_saved.tmpl")
		ui.add_template("_logs", "trade_log.tmpl")

		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/trade/nano_ui_data()
	. = ..()
	var/datum/computer_file/program/trade/PRG = program
	if(!istype(PRG))
		return

	var/is_all_access = FALSE		// Used for log and order access
	var/account

	.["prg_type"] = PRG.program_type

	.["prg_screen"] = PRG.prg_screen
	.["tradescreen"] = PRG.trade_screen
	.["log_screen"] = PRG.log_screen

	.["receiving_index"] =  SStrade.beacons_receiving.Find(PRG.receiving)
	.["sending_index"] = SStrade.beacons_sending.Find(PRG.sending)

	if(PRG.station)
		.["station_name"] = PRG.station.name
		.["station_desc"] = PRG.station.desc
		.["station_id"] = PRG.station.uid
		.["station_index"] = SStrade.discovered_stations.Find(PRG.station)
		.["station_favor"] = PRG.station.favor
		.["station_favor_needed"] = max(PRG.station.hidden_inv_threshold, PRG.station.recommendation_threshold)
		.["station_recommendations_needed"] = PRG.station.recommendations_needed
		.["offer_time"] = time2text((PRG.station.update_time - (world.time - PRG.station.update_timer_start)), "mm:ss")

	if(PRG.sending)
		.["export_time_max"] = round(PRG.sending.export_cooldown / (1 SECOND))
		.["export_time_start"] = PRG.sending.export_timer_start
		.["export_time_elapsed"] = PRG.sending.export_timer_start ? round((world.time - PRG.sending.export_timer_start) / (1 SECOND)) : 0
		.["export_ready"] = PRG.sending.export_timer_start ? FALSE : TRUE

	if(PRG.account)
		account = "[PRG.account.get_name()] #[PRG.account.account_number]"
		.["account"] = account
		.["balance"] = PRG.account.money
		var/dept_id = PRG.account.department_id
		if(dept_id)
			is_all_access = (dept_id == DEPARTMENT_GUILD) ? TRUE : FALSE

	.["is_all_access"] = is_all_access

	if(!QDELETED(PRG.receiving))
		.["receiving"] = PRG.receiving.get_id()

	if(!QDELETED(PRG.sending))
		.["sending"] = PRG.sending.get_id()

	if(PRG.prg_screen == PRG_TREE)
		var/list/line_list = list()
		var/list/trade_tree = list()

		for(var/station in SStrade.all_stations)
			var/datum/trade_station/TS = station
			var/is_discovered = (locate(TS) in SStrade.discovered_stations) ? TRUE : FALSE
			var/ts_tree_x = round(TS.tree_x*100)
			var/ts_tree_y = round(TS.tree_y*100)
			var/list/trade_tree_data = list(
				"id" =				"[TS.uid]",
				"name" =			"[TS.name]",
				"description" =		"[TS.desc]",
				"is_discovered" =	"[is_discovered]",
				"x" =				ts_tree_x,
				"y" =				ts_tree_y,
				"icon" =			"[TS.overmap_object.icon_stages[2 - is_discovered]]"
			)
			LAZYADD(trade_tree, list(trade_tree_data))

			if(LAZYLEN(TS.stations_recommended))
				for(var/id in TS.stations_recommended)
					if(!istext(id))
						break
					var/datum/trade_station/RS = SStrade.get_station_by_uid(id)
					if(RS)
						var/rs_tree_x = round(RS.tree_x*100)
						var/rs_tree_y = round(RS.tree_y*100)
						var/line_x = (min(rs_tree_x, ts_tree_x))
						var/line_y = (min(rs_tree_y, ts_tree_y))
						var/width = (abs(rs_tree_x - ts_tree_x))
						var/height = (abs(rs_tree_y - ts_tree_y))

						var/istop = FALSE
						if(RS.tree_y > TS.tree_y)
							istop = TRUE
						var/isright = FALSE
						if(RS.tree_x < TS.tree_x)
							isright = TRUE

						var/list/line_data = list(
							"line_x" =           line_x,
							"line_y" =           line_y,
							"width" =            width,
							"height" =           height,
							"istop" =            istop,
							"isright" =          isright,
						)
						LAZYADD(line_list, list(line_data))

		.["trade_tree"] = trade_tree
		.["tree_lines"] = line_list

	if(PRG.prg_screen == PRG_MAIN)
		if(!PRG.station)
			return

		if(PRG.trade_screen == GOODS_SCREEN)
			if(!PRG.chosen_category || !(PRG.chosen_category in PRG.station.inventory))
				PRG.set_chosen_category()
			.["current_category"] = PRG.chosen_category ? PRG.station.inventory.Find(PRG.chosen_category) : null
			.["goods"] = list()
			.["categories"] = list()
			.["total"] = SStrade.collect_price_for_list(PRG.shoppinglist)
			for(var/i in PRG.station.inventory)
				if(istext(i))
					.["categories"] += list(list("name" = i, "index" = PRG.station.inventory.Find(i)))
			if(PRG.chosen_category)
				var/list/assort = PRG.station.inventory[PRG.chosen_category]
				if(islist(assort))
					for(var/path in assort)
						if(!ispath(path, /atom/movable))
							continue
						var/atom/movable/AM = path

						var/index = assort.Find(path)

						var/amount = PRG.station.get_good_amount(PRG.chosen_category, index)

						var/pathname = initial(AM.name)

						var/list/good_packet = assort[path]
						if(islist(good_packet))
							pathname = good_packet["name"] ? good_packet["name"] : pathname
						var/price = SStrade.get_import_cost(path, PRG.station)

						var/list/shop_list_station = PRG.shoppinglist[PRG.station]
						var/count = 0
						if(shop_list_station)
							var/list/shop_list_category = list()
							if(shop_list_station.Find(PRG.chosen_category))
								shop_list_category = shop_list_station[PRG.chosen_category]
								if(shop_list_category.Find(path))
									count = shop_list_category[path]

						.["goods"] += list(list(
							"name" = pathname,
							"price" = price,
							"count" = count ? count : 0,
							"amount_available" = amount,
							"index" = index,
						))
			if(!recursiveLen(.["goods"]))
				.["goods"] = null

		if(PRG.trade_screen == OFFER_SCREEN)
			.["offers"] = list()
			for(var/offer_path in PRG.station.special_offers)
				var/path = offer_path
				var/list/offer_content = PRG.station.special_offers[offer_path]
				var/list/offer = list(
					"station" = PRG.station.name,
					"name" = offer_content["name"],
					"amount" = offer_content["amount"],
					"price" = offer_content["price"],
					"index" = SStrade.discovered_stations.Find(PRG.station),
					"path" = path,
				)
				if(PRG.sending)
					offer["available"] = length(SStrade.assess_offer(PRG.sending, offer_path, offer_content["attachments"], offer_content["attach_count"]))
				.["offers"] += list(offer)

			if(!recursiveLen(.["offers"]))
				.["offers"] = null

		if(PRG.trade_screen == CART_SCREEN)
			.["current_cart_station"] = PRG.cart_station_index
			.["current_cart_category"] = PRG.cart_category_index
			.["cart_stations"] = list()
			.["cart_categories"] = list()
			.["cart_goods"] = list()
			.["total"] = SStrade.collect_price_for_list(PRG.shoppinglist)
			for(var/datum/trade_station/TS in PRG.shoppinglist)
				.["cart_stations"] += list(list("name" = TS.name, "index" = PRG.shoppinglist.Find(TS)))
			if(PRG.cart_station_index)
				PRG.station = PRG.shoppinglist[PRG.cart_station_index]
				var/list/categories = PRG.shoppinglist[PRG.station]
				for(var/category in categories)
					.["cart_categories"] += list(list("name" = category, "index" = categories.Find(category)))
				if(PRG.cart_category_index)
					PRG.chosen_category = categories[PRG.cart_category_index]
					var/list/goods = categories[PRG.chosen_category]
					for(var/path in goods)
						if(!ispath(path, /atom/movable))
							continue
						var/atom/movable/AM = path

						var/list/inventory = PRG.station.inventory[PRG.chosen_category]
						var/index = inventory.Find(path)
						var/amount = PRG.station.get_good_amount(PRG.chosen_category, index)

						var/pathname = initial(AM.name)

						var/list/good_packet = goods[path]
						if(islist(good_packet))
							pathname = good_packet["name"] ? good_packet["name"] : pathname
						var/price = SStrade.get_import_cost(path, PRG.station)

						var/count = goods[path]

						.["cart_goods"] += list(list(
							"name" = pathname,
							"price" = price,
							"count" = count ? count : 0,
							"amount_available" = amount,
							"index" = index,
						))
			if(!recursiveLen(.["cart_goods"]))
				.["cart_goods"] = null

		if(PRG.trade_screen == ORDER_SCREEN)
			if(!SStrade.order_queue.Find(PRG.current_order))		// If the order was removed from the queue by someone else (guild/lonestar or hacker),
				PRG.current_order = null							// clear the current order. Else we get a window of undefined values

			var/list/current_orders = list()

			.["current_order"] = PRG.current_order
			.["order_page"] = PRG.current_order_page

			for(var/order in SStrade.order_queue)
				var/list/order_data = SStrade.order_queue[order]
				var/datum/money_account/requesting_account =  order_data["requesting_acct"]

				// Check if the request is the one we want to view
				if(order == PRG.current_order)
					.["requesting_acct"] = "[requesting_account.get_name()] #[requesting_account.account_number]"
					.["reason"] = order_data["reason"]
					.["order_cost"] = order_data["cost"]
					.["handling_fee"] = order_data["fee"]
					.["order_contents"] = order_data["viewable_contents"]

				// Store values for the request list
				current_orders += list(list(
					"id" = order,
					"requesting_acct" = "[requesting_account.get_name()] #[requesting_account.account_number]",
					"reason" = order_data["reason"],
					"order_cost" = order_data["cost"],
					"handling_fee" = order_data["fee"],
					"order_contents" = order_data["viewable_contents"]
				))

			// If not the master account, only show the requests from the linked account
			if(!is_all_access)
				for(var/request in current_orders)
					var/list/request_data = request
					if(request_data["requesting_acct"] != account)
						current_orders -= list(request)

			// Page building logic
			var/orders_per_page = 10
			var/orders_to_display = orders_per_page
			PRG.order_page_max = round(current_orders.len / orders_per_page, 1)
			var/page_remainder = current_orders.len % orders_per_page
			if(current_orders.len < orders_per_page * PRG.current_order_page)
				orders_to_display = page_remainder
			if(page_remainder < orders_per_page / 2)
				++PRG.order_page_max

			.["page_max"] = PRG.order_page_max ? PRG.order_page_max : 1

			var/list/page_of_orders = list()

			if(orders_to_display)
				for(var/i in 1 to orders_to_display)
					page_of_orders += list(current_orders[i + (orders_per_page * (PRG.current_order_page - 1))])

			.["order_data"] = page_of_orders

			if(!recursiveLen(.["order_data"]))
				.["order_data"] = null

		if(PRG.trade_screen == SAVED_SCREEN)
			var/list/saved_carts = list()

			.["cart_page"] = PRG.saved_cart_page

			for(var/list_name in PRG.saved_shopping_lists)
				saved_carts += list(list(
					"name" = list_name,
					"index" = PRG.saved_shopping_lists.Find(list_name)
				))

			// Page building logic
			var/carts_per_page = 10
			var/carts_to_display = carts_per_page
			PRG.saved_cart_page_max = round(saved_carts.len / carts_per_page, 1)
			var/page_remainder = saved_carts.len % carts_per_page
			if(saved_carts.len < carts_per_page * PRG.saved_cart_page)
				carts_to_display = page_remainder
			if(page_remainder < carts_per_page / 2)
				++PRG.saved_cart_page_max

			.["page_max"] = PRG.saved_cart_page_max ? PRG.saved_cart_page_max : 1

			var/list/page_of_carts = list()

			if(carts_to_display)
				for(var/i in 1 to carts_to_display)
					page_of_carts += list(saved_carts[i + (carts_per_page * (PRG.saved_cart_page - 1))])

			.["saved_carts"] = page_of_carts

		if(PRG.trade_screen == LOG_SCREEN)
			var/list/current_log = list()

			if(PRG.account)
				.["account"] = "[PRG.account.get_name()] #[PRG.account.account_number]"
				var/dept_id = PRG.account.department_id
				if(dept_id)
					is_all_access = (dept_id == DEPARTMENT_GUILD) ? TRUE : FALSE

			.["log_page"] = PRG.current_log_page

			switch(PRG.log_screen)
				if(LOG_SHIPPING)
					current_log = SStrade.shipping_log
				if(LOG_EXPORT)
					current_log = SStrade.export_log
				if(LOG_OFFER)
					current_log = SStrade.offer_log
				if(LOG_ORDER)
					current_log = SStrade.order_log
				else
					current_log = list()

			if(!is_all_access)
				var/list/sanitized_log = list()
				for(var/log_entry in current_log)
					var/list/log_data = log_entry
					if(log_data["ordering_acct"] == PRG.account.get_name())
						sanitized_log |= list(log_data)
				current_log = sanitized_log

			var/logs_per_page = 10
			var/logs_to_display = logs_per_page
			PRG.log_page_max = round(current_log.len / logs_per_page, 1)
			var/page_remainder = current_log.len % logs_per_page
			if(current_log.len < logs_per_page * PRG.current_log_page)
				logs_to_display = page_remainder
			if(page_remainder < logs_per_page / 2)
				++PRG.log_page_max

			.["page_max"] = PRG.log_page_max ? PRG.log_page_max : 1

			var/list/page_of_logs = list()

			if(logs_to_display)
				for(var/i in 1 to logs_to_display)
					page_of_logs += list(current_log[i + (logs_per_page * (PRG.current_log_page - 1))])

			.["current_log_data"] = page_of_logs


#undef GOODS_SCREEN
#undef OFFER_SCREEN
#undef CART_SCREEN
#undef ORDER_SCREEN
#undef SAVED_SCREEN
#undef PRG_MAIN
#undef PRG_TREE
#undef LOG_SCREEN
#undef LOG_SHIPPING
#undef LOG_EXPORT
#undef LOG_OFFER
#undef LOG_ORDER
#undef TRADESCREEN
#undef LOG_SCREEN_LIST
