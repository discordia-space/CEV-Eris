/datum/computer_file/program/trade
	filename = "trade"
	filedesc = "Trading Program"
	nanomodule_path = /datum/nano_module/program/trade
	program_icon_state = "supply"
	program_key_state = "rd_key"
	program_menu_icon = "cart"
	extended_desc = "A management tool that allows for ordering of various supplies through the facility's cargo system."
	size = 21
	available_on_ntnet = FALSE
	requires_ntnet = TRUE

	var/screen = 0

	var/list/shoppinglist = list()

	var/obj/machinery/trade_beacon/sending/sending
	var/obj/machinery/trade_beacon/receiving/receiving

	var/datum/trade_station/station

	var/datum/money_account/account

/datum/computer_file/program/trade/Topic(href, href_list)
	. = ..()
	if(.)
		return

	//Common
	if(href_list["PRG_screen"])
		var/new_screen = text2num(href_list["PRG_screen"])
		if(new_screen > 6 || new_screen < 0)
			return
		screen = new_screen
		return 1

	//Screen 0
	if(href_list["PRG_send"])
		SStrade.sell(sending, account)
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

	//Screen 1
	if(href_list["PRG_station"])
		var/datum/trade_station/S = LAZYACCESS(SStrade.discovered_stations, text2num(href_list["PRG_station"]) + 1)
		if(!S)
			return
		station = S
		shoppinglist.Cut()
		return 1

	//Screen 2
	if(href_list["PRG_receiving"])
		var/obj/machinery/trade_beacon/receiving/B = LAZYACCESS(SStrade.beacons_receiving, text2num(href_list["PRG_receiving"]) + 1)
		if(!B)
			return
		receiving = B
		return 1

	//Screen 3
	if(href_list["PRG_sending"])
		var/obj/machinery/trade_beacon/sending/B = LAZYACCESS(SStrade.beacons_sending, text2num(href_list["PRG_sending"]) + 1)
		if(!B)
			return
		sending = B
		return 1

	//Screen 4
	if(href_list["PRG_receive"])
		SStrade.buy(receiving, account, shoppinglist)
		return 1

	if(href_list["PRG_cart_reset"])
		shoppinglist.Cut()
		return 1

	if(href_list["PRG_cart_add"])
		var/path = LAZYACCESS(station.assortiment, text2num(href_list["PRG_cart_add"]) + 1)
		if(!path)
			return
		shoppinglist[path] = 1 + shoppinglist[path]
		return 1

	if(href_list["PRG_cart_remove"])
		var/path = LAZYACCESS(station.assortiment, text2num(href_list["PRG_cart_remove"]) + 1)
		if(!path || !shoppinglist[path])
			return
		--shoppinglist[path]
		if(shoppinglist[path] <= 0)
			shoppinglist.Remove(path)
		return 1

	//Screen 5
	if(href_list["PRG_offer_fulfill"])
		var/datum/trade_station/S = LAZYACCESS(SStrade.discovered_stations, text2num(href_list["PRG_offer_fulfill"]) + 1)
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
		ui = new(user, src, ui_key, "trade.tmpl", name, 450, 500, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/trade/ui_data()
	. = ..()
	var/datum/computer_file/program/trade/PRG = program
	if(!istype(PRG))
		return
	.["screen"] = PRG.screen
	switch(PRG.screen)
		if(0)
			.["station_name"] = PRG.station?.name
			.["station_desc"] = PRG.station?.desc

			if(PRG.account)
				.["account"] = "[PRG.account.get_name()] #[PRG.account.account_number]"

			if(!QDELETED(PRG.receiving))
				.["receiving"] = PRG.receiving.get_id()

			if(!QDELETED(PRG.sending))
				.["sending"] = PRG.sending.get_id()

		if(1)
			.["station_list"] = list()
			for(var/datum/trade_station/S in SStrade.discovered_stations)
				if(S == PRG.station)
					.["station_index"] = length(.["station_list"])
				.["station_list"] += list(list("name" = S.name, "desc" = S.desc))

		if(2)
			.["receiving_list"] = list()
			for(var/obj/machinery/trade_beacon/receiving/B in SStrade.beacons_receiving)
				if(B == PRG.receiving)
					.["receiving_index"] = length(.["receiving_list"])
				.["receiving_list"] += B.get_id()

		if(3)
			.["sending_list"] = list()
			for(var/obj/machinery/trade_beacon/sending/B in SStrade.beacons_sending)
				if(B == PRG.sending)
					.["sending_index"] = length(.["sending_list"])
				.["sending_list"] += B.get_id()

		if(4)
			.["goods"] = list()
			.["total"] = 0
			if(PRG.station)
				for(var/path in PRG.station.assortiment)
					if(!ispath(path, /atom/movable))
						continue
					var/atom/movable/AM = path
					var/price = SStrade.get_import_cost(path)
					var/count = PRG.shoppinglist[path]
					.["goods"] += list(list(
						"name" = initial(AM.name),
						"price" = price,
						"count" = count
					))
					.["total"] += price * count

		if(5)
			.["offers"] = list()
			for(var/datum/trade_station/S in SStrade.discovered_stations)
				var/atom/movable/offer_type = S.offer_type
				var/list/offer = list("station" = S.name, "name" = initial(offer_type.name), "amount" = S.offer_amount, "price" = S.offer_price)
				if(PRG.sending)
					offer["available"] = length(SStrade.assess_offer(PRG.sending, S))
				.["offers"] += list(offer)
