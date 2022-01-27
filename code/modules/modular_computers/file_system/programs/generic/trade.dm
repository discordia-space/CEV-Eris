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
	choosed_category =69alue

/datum/computer_file/program/trade/proc/reset_shoplist()
	RecursiveCut(shoppinglist)
	if(station)
		for(var/i in station.assortiment)
			shoppinglist69i69 = list()

/datum/computer_file/program/trade/proc/get_price_of_cart()
	. = 0
	for(var/i in shoppinglist)
		var/list/l = shoppinglist69i69
		if(islist(l))
			for(var/b in l)
				. += l69b69 * SStrade.get_import_cost(b, station)

/datum/computer_file/program/trade/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list69"PRG_goods_category"69)
		if(!choosed_category || !(choosed_category in station.assortiment))
			set_choosed_category()
		set_choosed_category((text2num(href_list69"PRG_goods_category"69) <= length(station.assortiment)) ? station.assortiment69text2num(href_list69"PRG_goods_category"69)69 : "")
		return 1

	if(href_list69"PRG_trade_screen"69)
		trade_screen = !trade_screen
		return 1

	if(href_list69"PRG_account"69)
		var/acc_num = input("Enter account69umber", "Account linking", computer?.card_slot?.stored_card?.associated_account_number) as69um|null
		if(!acc_num)
			return

		var/acc_pin = input("Enter PIN", "Account linking") as69um|null
		if(!acc_pin)
			return

		var/card_check = computer?.card_slot?.stored_card?.associated_account_number == acc_num
		var/datum/money_account/A = attempt_account_access(acc_num, acc_pin, card_check ? 2 : 1, TRUE)
		if(!A)
			to_chat(usr, SPAN_WARNING("Unable to link account: access denied."))
			return

		account = A
		return 1

	if(href_list69"PRG_station"69)
		var/datum/trade_station/S = LAZYACCESS(SStrade.discovered_stations, text2num(href_list69"PRG_station"69))
		set_choosed_category()
		station = S
		reset_shoplist()
		return 1

	if(href_list69"PRG_receiving"69)
		var/obj/machinery/trade_beacon/receiving/B = LAZYACCESS(SStrade.beacons_receiving, text2num(href_list69"PRG_receiving"69))
		receiving = B
		return 1

	if(href_list69"PRG_sending"69)
		var/obj/machinery/trade_beacon/sending/B = LAZYACCESS(SStrade.beacons_sending, text2num(href_list69"PRG_sending"69))
		sending = B
		return 1

	if(href_list69"PRG_cart_reset"69)
		reset_shoplist()
		return 1

	if(href_list69"PRG_cart_add"69 || href_list69"PRG_cart_add_input"69)
		var/ind
		var/count2buy = 1
		if(href_list69"PRG_cart_add_input"69)
			count2buy = input(usr, "Input how69any you want to add", "Trade", 2) as69um
			ind = text2num(href_list69"PRG_cart_add_input"69)
		else
			ind = text2num(href_list69"PRG_cart_add"69)
		var/list/category = station.assortiment69choosed_category69
		if(!islist(category))
			return
		var/path = LAZYACCESS(category, ind)
		if(!path)
			return
		var/good_amount = station.get_good_amount(choosed_category, ind)
		if(!good_amount)
			return

		set_2d_matrix_cell(shoppinglist, choosed_category, path, clamp(get_2d_matrix_cell(shoppinglist, choosed_category, path) + count2buy, 0, good_amount))
		return 1

	if(href_list69"PRG_cart_remove"69)
		var/list/category = station.assortiment69choosed_category69
		if(!islist(category))
			return
		var/path = LAZYACCESS(category, text2num(href_list69"PRG_cart_remove"69))
		if(!path)
			return
		var/good_amount = station.get_good_amount(choosed_category, text2num(href_list69"PRG_cart_remove"69))

		set_2d_matrix_cell(shoppinglist, choosed_category, path, clamp(get_2d_matrix_cell(shoppinglist, choosed_category, path) - 1, 0, good_amount))
		return 1

	if(account)
		if(href_list69"PRG_receive"69)
			SStrade.buy(receiving, account, shoppinglist, station)
			reset_shoplist()
			return 1
		if(href_list69"PRG_account_unlink"69)
			account =69ull
			return 1

		if(href_list69"PRG_offer_fulfill"69)
			var/datum/trade_station/S = LAZYACCESS(SStrade.discovered_stations, text2num(href_list69"PRG_offer_fulfill"69))
			if(!S)
				return
			var/atom/movable/path = text2path(href_list69"PRG_offer_fulfill_path"69)
			SStrade.fulfill_offer(sending, account, station, path)
			return 1

		var/t2n = text2num(href_list69"PRG_sell"69)
		if(isnum(t2n) && station)
			var/path = get_2d_matrix_cell(station.assortiment, choosed_category, t2n)
			SStrade.sell_thing(sending, account, locate(path) in SStrade.assess_offer(sending, station, path), station)
			return 1

/datum/nano_module/program/trade
	name = "Trading Program"

/datum/nano_module/program/trade/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "trade.tmpl",69ame, 750, 700, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/trade/ui_data()
	. = ..()
	var/datum/computer_file/program/trade/PRG = program
	if(!istype(PRG))
		return

	.69"tradescreen"69 = PRG.trade_screen

	.69"station_name"69 = PRG.station?.name
	.69"station_desc"69 = PRG.station?.desc
	.69"station_index"69 = SStrade.discovered_stations.Find(PRG.station)

	.69"receiving_index"69 =  SStrade.beacons_receiving.Find(PRG.receiving)
	.69"sending_index"69 = SStrade.beacons_sending.Find(PRG.sending)

	if(PRG.account)
		.69"account"69 = "69PRG.account.get_name()69 #69PRG.account.account_number69"

	if(!QDELETED(PRG.receiving))
		.69"receiving"69 = PRG.receiving.get_id()

	if(!QDELETED(PRG.sending))
		.69"sending"69 = PRG.sending.get_id()

	.69"station_list"69 = list()
	for(var/datum/trade_station/S in SStrade.discovered_stations)
		.69"station_list"69 += list(list("name" = S.name, "desc" = S.desc, "index" = SStrade.discovered_stations.Find(S)))

	.69"receiving_list"69 = list()
	for(var/obj/machinery/trade_beacon/receiving/B in SStrade.beacons_receiving)
		.69"receiving_list"69 += list(list("id" = B.get_id(), "index" = SStrade.beacons_receiving.Find(B)))

	.69"sending_list"69 = list()
	for(var/obj/machinery/trade_beacon/sending/B in SStrade.beacons_sending)
		.69"sending_list"69 += list(list("id" = B.get_id(), "index" = SStrade.beacons_sending.Find(B)))

	if(PRG.station)
		if(!PRG.choosed_category || !(PRG.choosed_category in PRG.station.assortiment))
			PRG.set_choosed_category()
		.69"commision"69 = PRG.station.commision
		.69"current_category"69 = PRG.choosed_category ? PRG.station.assortiment.Find(PRG.choosed_category) :69ull
		.69"goods"69 = list()
		.69"categories"69 = list()
		.69"total"69 = PRG.get_price_of_cart()
		for(var/i in PRG.station.assortiment)
			if(istext(i))
				.69"categories"69 += list(list("name" = i, "index" = PRG.station.assortiment.Find(i)))
		if(PRG.choosed_category)
			var/list/assort = PRG.station.assortiment69PRG.choosed_category69
			if(islist(assort))
				for(var/path in assort)
					if(!ispath(path, /atom/movable))
						continue
					var/atom/movable/AM = path

					var/index = assort.Find(path)

					var/amount = PRG.station.get_good_amount(PRG.choosed_category, index)

					var/amount2sell = 0
					if(PRG.station && PRG.sending)
						amount2sell = length(SStrade.assess_offer(PRG.sending, PRG.station, path))
					var/pathname = initial(AM.name)
					var/list/good_packet = assort69path69
					if(islist(good_packet))
						pathname = good_packet69"name"69 ? good_packet69"name"69 : pathname
					var/price = SStrade.get_import_cost(path, PRG.station)
					var/sell_price = SStrade.get_sell_price(path, PRG.station)

					var/count =69ax(0, get_2d_matrix_cell(PRG.shoppinglist, PRG.choosed_category, path))

					.69"goods"69 += list(list(
						"name" = pathname,
						"price" = price,
						"count" = count ? count : 0,
						"amount_available" = amount,
						"sell_price" = sell_price,
						"amount_available_around" = amount2sell,
						"index" = index
					))
		if(!recursiveLen(.69"goods"69))
			.69"goods"69 =69ull

		.69"offers"69 = list()
		for(var/offer_path in PRG.station.special_offers)
			var/atom/movable/path = offer_path
			var/list/offer_content = PRG.station.special_offers69offer_path69
			var/list/offer = list(
				"station" = PRG.station.name,
				"name" = offer_content69"name"69,
				"amount" = offer_content69"amount"69,
				"price" = offer_content69"price"69,
				"index" = SStrade.discovered_stations.Find(PRG.station),
				"path" = path,
			)
			if(PRG.sending)
				offer69"available"69 = length(SStrade.assess_offer(PRG.sending, PRG.station, offer_path))
			.69"offers"69 += list(offer)

		if(!recursiveLen(.69"offers"69))
			.69"offers"69 =69ull

		.69"time"69 = time2text( (PRG.station.update_time - (world.time - PRG.station.update_timer_start)) , "mm:ss")

#undef GOODS_SCREEN
#undef OFFER_SCREEN
