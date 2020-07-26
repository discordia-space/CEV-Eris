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

	var/obj/machinery/trade_beacon/sending/sending
	var/obj/machinery/trade_beacon/receiving/receiving

	var/datum/trade_station/station

	var/datum/money_account/account

/datum/computer_file/program/trade/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["PRG_trade_screen"])
		trade_screen = !trade_screen
		return 1

	if(href_list["PRG_send"])
		SStrade.sell(sending, account)
		return 1

	if(href_list["PRG_receive"])
		SStrade.buy(receiving, account, shoppinglist)
		return 1

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
		return 1

	if(href_list["PRG_account_unlink"])
		account = null
		return 1

	if(href_list["PRG_station"])
		var/datum/trade_station/S = LAZYACCESS(SStrade.discovered_stations, text2num(href_list["PRG_station"]))
		station = S
		shoppinglist.Cut()
		return 1

	if(href_list["PRG_receiving"])
		var/obj/machinery/trade_beacon/receiving/B = LAZYACCESS(SStrade.beacons_receiving, text2num(href_list["PRG_receiving"]))
		receiving = B
		return 1

	if(href_list["PRG_sending"])
		var/obj/machinery/trade_beacon/sending/B = LAZYACCESS(SStrade.beacons_sending, text2num(href_list["PRG_sending"]))
		sending = B
		return 1

	if(href_list["PRG_cart_reset"])
		shoppinglist.Cut()
		return 1

	if(href_list["PRG_cart_add"])
		var/list/json_packet = splittext(href_list["PRG_cart_add"], "/")
		if(!islist(json_packet))
			return
		var/list/category = station.assortiment[station.assortiment[text2num(json_packet[1])]]
		if(!islist(category))
			return
		var/path = LAZYACCESS(category, text2num(text2num(json_packet[2])))
		if(!path)
			return
		shoppinglist[path] = 1 + shoppinglist[path]
		return 1

	if(href_list["PRG_cart_remove"])
		var/list/json_packet = splittext(href_list["PRG_cart_remove"], "/")
		if(!islist(json_packet))
			return
		var/list/category = station.assortiment[station.assortiment[text2num(json_packet[1])]]
		if(!islist(category))
			return
		var/path = LAZYACCESS(category, text2num(text2num(json_packet[2])))
		if(!path || !shoppinglist[path])
			return
		--shoppinglist[path]
		if(shoppinglist[path] <= 0)
			shoppinglist.Remove(path)
		return 1

	if(href_list["PRG_offer_fulfill"])
		var/datum/trade_station/S = LAZYACCESS(SStrade.discovered_stations, text2num(href_list["PRG_offer_fulfill"]))
		if(!S)
			return
		SStrade.fulfill_offer(sending, account, station)
		return 1

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

	.["receiving_index"] =  SStrade.beacons_receiving.Find(PRG.receiving)
	.["sending_index"] = SStrade.beacons_sending.Find(PRG.sending)

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
		.["receiving_list"] += list(list("id" = B.get_id(), "index" = SStrade.beacons_receiving.Find(B)))

	.["sending_list"] = list()
	for(var/obj/machinery/trade_beacon/sending/B in SStrade.beacons_sending)
		.["sending_list"] += list(list("id" = B.get_id(), "index" = SStrade.beacons_sending.Find(B)))


	if(PRG.station)
		.["goods"] = list()
		.["total"] = 0
		for(var/category in PRG.station.assortiment)
			var/list/ctegory = list()
			for(var/path in PRG.station.assortiment[category])
				if(ispath(path, /atom/movable))
					var/atom/movable/AM = path
					var/price = SStrade.get_import_cost(path)
					var/count = PRG.shoppinglist[path]
					var/list/cat = PRG.station.assortiment[category]
					ctegory += list(list(
						"name" = initial(AM.name),
						"price" = price,
						"count" = count,
						"index" = cat.Find(path)
					))
					.["total"] += price * count

			if(!length(ctegory))
				continue
			.["goods"] += list(list("name" = category, "goods" = ctegory, "index" = PRG.station.assortiment.Find(category)))
		if(!recursiveLen(.["goods"]))
			.["goods"] = null
	.["offers"] = list()
	for(var/datum/trade_station/S in SStrade.discovered_stations)
		var/atom/movable/offer_type = S.offer_type
		var/list/offer = list("station" = S.name, "name" = initial(offer_type.name), "amount" = S.offer_amount, "price" = S.offer_price, "index" = SStrade.discovered_stations.Find(S))
		if(PRG.sending)
			offer["available"] = length(SStrade.assess_offer(PRG.sending, S))
		.["offers"] += list(offer)
	if(!recursiveLen(.["offers"]))
		.["offers"] = null
	

#undef GOODS_SCREEN
#undef OFFER_SCREEN
