#define GOODS_SCREEN TRUE
#define OFFER_SCREEN FALSE
/datum/computer_file/program/trade
	filename = "trade"
	filedesc = "Trading Program"
	nanomodule_path = /datum/nano_module/program/trade
	program_icon_state = "supply"
	program_key_state = "rd_key"
	program_menu_icon = "cart"
	extended_desc = "A trade tool, require sending and reseiving beacons."
	size = 21
	available_on_ntnet = FALSE
	requires_ntnet = TRUE

	var/trade_screen = GOODS_SCREEN

	var/list/shoppinglist = list()
	var/choosed_category

	var/obj/machinery/trade_beacon/sending/sending
	var/obj/machinery/trade_beacon/receiving/receiving

	var/datum/trade_station/station

	var/datum/money_account/account

/datum/computer_file/program/trade/proc/set_choosed_category(value)
	choosed_category = value

/datum/computer_file/program/trade/proc/reset_shoplist()
	RecursiveCut(shoppinglist)
	if(station)
		for(var/i in station.inventory)
			shoppinglist[i] = list()

/datum/computer_file/program/trade/proc/get_price_of_cart()
	. = 0
	for(var/i in shoppinglist)
		var/list/l = shoppinglist[i]
		if(islist(l))
			for(var/b in l)
				. += l[b] * SStrade.get_import_cost(b, station)

/datum/computer_file/program/trade

/datum/computer_file/program/trade/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["PRG_goods_category"])
		if(!choosed_category || !(choosed_category in station.inventory))
			set_choosed_category()
		set_choosed_category((text2num(href_list["PRG_goods_category"]) <= length(station.inventory)) ? station.inventory[text2num(href_list["PRG_goods_category"])] : "")
		return TRUE

	if(href_list["PRG_trade_screen"])
		trade_screen = !trade_screen
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

	if(href_list["PRG_station"])
		var/datum/trade_station/S = input("Select trade station", "Trade Station", null) as null|anything in SStrade.discovered_stations
		set_choosed_category()
		station = S
		reset_shoplist()
		return TRUE

	if(station)
		if(href_list["PRG_station_unlink"])
			station = null
			return TRUE

	if(href_list["PRG_receiving"])
		var/obj/machinery/trade_beacon/receiving/B = LAZYACCESS(SStrade.beacons_receiving, text2num(href_list["PRG_receiving"]))
		receiving = B
		return TRUE

	if(href_list["PRG_sending"])
		var/obj/machinery/trade_beacon/sending/B = LAZYACCESS(SStrade.beacons_sending, text2num(href_list["PRG_sending"]))
		sending = B
		return TRUE

	if(href_list["PRG_cart_reset"])
		reset_shoplist()
		return TRUE

	if(href_list["PRG_cart_add"] || href_list["PRG_cart_add_input"])
		var/ind
		var/count2buy = 1
		if(href_list["PRG_cart_add_input"])
			count2buy = input(usr, "Input how many you want to add", "Trade", 2) as num
			ind = text2num(href_list["PRG_cart_add_input"])
		else
			ind = text2num(href_list["PRG_cart_add"])
		var/list/category = station.inventory[choosed_category]
		if(!islist(category))
			return
		var/path = LAZYACCESS(category, ind)
		if(!path)
			return
		var/good_amount = station.get_good_amount(choosed_category, ind)
		if(!good_amount)
			return

		set_2d_matrix_cell(shoppinglist, choosed_category, path, clamp(get_2d_matrix_cell(shoppinglist, choosed_category, path) + count2buy, 0, good_amount))
		return TRUE

	if(href_list["PRG_cart_remove"])
		var/list/category = station.inventory[choosed_category]
		if(!islist(category))
			return
		var/path = LAZYACCESS(category, text2num(href_list["PRG_cart_remove"]))
		if(!path)
			return
		var/good_amount = station.get_good_amount(choosed_category, text2num(href_list["PRG_cart_remove"]))

		set_2d_matrix_cell(shoppinglist, choosed_category, path, clamp(get_2d_matrix_cell(shoppinglist, choosed_category, path) - 1, 0, good_amount))
		return TRUE

	if(account)
		if(href_list["PRG_receive"])
			SStrade.buy(receiving, account, shoppinglist, station)
			reset_shoplist()
			return TRUE
		if(href_list["PRG_account_unlink"])
			account = null
			return TRUE

		if(href_list["PRG_offer_fulfill"])
			var/datum/trade_station/S = LAZYACCESS(SStrade.discovered_stations, text2num(href_list["PRG_offer_fulfill"]))
			if(!S)
				return
			var/atom/movable/path = text2path(href_list["PRG_offer_fulfill_path"])
			SStrade.fulfill_offer(sending, account, station, path)
			return TRUE

	if(sending)
		if(href_list["PRG_export"])
			SStrade.export(sending)
			return TRUE


/datum/nano_module/program/trade
	name = "Trading Program"

/datum/nano_module/program/trade/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "trade.tmpl", name, 750, 700, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/trade/ui_data()
	. = ..()
	var/datum/computer_file/program/trade/PRG = program
	if(!istype(PRG))
		return

	.["tradescreen"] = PRG.trade_screen

	.["station_name"] = PRG.station?.name
	.["station_desc"] = PRG.station?.desc
	.["station_index"] = SStrade.discovered_stations.Find(PRG.station)

	.["station_favor"] = PRG.station?.favor
	.["station_favor_needed"] = max(PRG.station?.hidden_inv_threshold, PRG.station?.recommendation_threshold)

	.["offer_time"] = time2text((PRG.station?.update_time - (world.time - PRG.station?.update_timer_start)), "mm:ss")

	.["receiving_index"] =  SStrade.beacons_receiving.Find(PRG.receiving)
	.["sending_index"] = SStrade.beacons_sending.Find(PRG.sending)

	if(PRG.sending)
		.["export_time_max"] = round(PRG.sending.export_cooldown / (1 SECOND))
		.["export_time_start"] = PRG.sending.export_timer_start
		.["export_time_elapsed"] = PRG.sending.export_timer_start ? round((world.time - PRG.sending.export_timer_start) / (1 SECOND)) : 0
		.["export_ready"] = PRG.sending.export_timer_start ? FALSE : TRUE
		log_debug("Export cooldown: [round(PRG.sending.export_cooldown / (1 SECOND))]. Export time elapsed: [PRG.sending.export_timer_start ? round((world.time - PRG.sending.export_timer_start) / (1 SECOND)) : 0]")

	if(PRG.account)
		.["account"] = "[PRG.account.get_name()] #[PRG.account.account_number]"

	if(!QDELETED(PRG.receiving))
		.["receiving"] = PRG.receiving.get_id()

	if(!QDELETED(PRG.sending))
		.["sending"] = PRG.sending.get_id()

	.["station_list"] = list()
	for(var/datum/trade_station/S in SStrade.discovered_stations)
		.["station_list"] += list(list("name" = S.name, "desc" = S.desc, "index" = SStrade.discovered_stations.Find(S)))

	.["receiving_list"] = list()
	for(var/obj/machinery/trade_beacon/receiving/B in SStrade.beacons_receiving)
		// check area
		.["receiving_list"] += list(list("id" = B.get_id(), "index" = SStrade.beacons_receiving.Find(B)))

	.["sending_list"] = list()
	for(var/obj/machinery/trade_beacon/sending/B in SStrade.beacons_sending)
		// check area
		.["sending_list"] += list(list("id" = B.get_id(), "index" = SStrade.beacons_sending.Find(B)))

	if(PRG.station)
		if(!PRG.choosed_category || !(PRG.choosed_category in PRG.station.inventory))
			PRG.set_choosed_category()
		.["current_category"] = PRG.choosed_category ? PRG.station.inventory.Find(PRG.choosed_category) : null
		.["goods"] = list()
		.["categories"] = list()
		.["total"] = PRG.get_price_of_cart()
		for(var/i in PRG.station.inventory)
			if(istext(i))
				.["categories"] += list(list("name" = i, "index" = PRG.station.inventory.Find(i)))
		if(PRG.choosed_category)
			var/list/assort = PRG.station.inventory[PRG.choosed_category]
			if(islist(assort))
				for(var/path in assort)
					if(!ispath(path, /atom/movable))
						continue
					var/atom/movable/AM = path

					var/index = assort.Find(path)

					var/amount = PRG.station.get_good_amount(PRG.choosed_category, index)

					var/pathname = initial(AM.name)

					var/list/good_packet = assort[path]
					if(islist(good_packet))
						pathname = good_packet["name"] ? good_packet["name"] : pathname
					var/price = SStrade.get_import_cost(path, PRG.station)

					var/count = max(0, get_2d_matrix_cell(PRG.shoppinglist, PRG.choosed_category, path))

					.["goods"] += list(list(
						"name" = pathname,
						"price" = price,
						"count" = count ? count : 0,
						"amount_available" = amount,
						"index" = index,
					))
		if(!recursiveLen(.["goods"]))
			.["goods"] = null

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
				offer["available"] = length(SStrade.assess_offer(PRG.sending, PRG.station, offer_path))
			.["offers"] += list(offer)

		if(!recursiveLen(.["offers"]))
			.["offers"] = null

#undef GOODS_SCREEN
#undef OFFER_SCREEN
