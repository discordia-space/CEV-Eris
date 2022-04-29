#define GOODS_SCREEN TRUE
#define OFFER_SCREEN FALSE
/datum/computer_file/program/trade_catalog
	filename = "trade_catalog"
	filedesc = "Aster\'s Trade Catalog"
	extended_desc = "Electronic handbook containing inventory information about discovered trade beacons."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 2
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/program/trade_catalog
	usage_flags = PROGRAM_ALL

	var/trade_screen = GOODS_SCREEN
	var/chosen_category
	var/datum/trade_station/station

/datum/computer_file/program/trade_catalog/proc/set_chosen_category(value)
	chosen_category = value

/datum/computer_file/program/trade_catalog/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["PRG_goods_category"])
		if(!chosen_category || !(chosen_category in station.inventory))
			set_chosen_category()
		set_chosen_category((text2num(href_list["PRG_goods_category"]) <= length(station.inventory)) ? station.inventory[text2num(href_list["PRG_goods_category"])] : "")
		return TRUE

	if(href_list["PRG_trade_screen"])
		trade_screen = !trade_screen
		return TRUE

	if(href_list["PRG_station"])
		var/datum/trade_station/S = input("Select trade station", "Trade Station", null) as null|anything in SStrade.discovered_stations
		set_chosen_category()
		station = S
		return TRUE

	if(station)
		if(href_list["PRG_station_unlink"])
			station = null
			return TRUE

/datum/nano_module/program/trade_catalog
	name = "Trade Catalog"

/datum/nano_module/program/trade_catalog/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "trade_catalog.tmpl", name, 640, 700, state = state)
		ui.set_auto_update(TRUE)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/trade_catalog/ui_data()
	. = ..()
	var/datum/computer_file/program/trade_catalog/PRG = program
	if(!istype(PRG))
		return

	.["tradescreen"] = PRG.trade_screen

	.["station_name"] = PRG.station?.name
	.["station_desc"] = PRG.station?.desc
	.["station_index"] = SStrade.discovered_stations.Find(PRG.station)

	.["offer_time"] = time2text( (PRG.station?.update_time - (world.time - PRG.station?.update_timer_start)) , "mm:ss")

	.["station_list"] = list()
	for(var/datum/trade_station/S in SStrade.discovered_stations)
		.["station_list"] += list(list("name" = S.name, "desc" = S.desc, "index" = SStrade.discovered_stations.Find(S)))

	if(PRG.station)
		if(!PRG.chosen_category || !(PRG.chosen_category in PRG.station.inventory))
			PRG.set_chosen_category()
		.["current_category"] = PRG.chosen_category ? PRG.station.inventory.Find(PRG.chosen_category) : null
		.["goods"] = list()
		.["categories"] = list()
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

					.["goods"] += list(list(
						"name" = pathname,
						"amount_available" = amount,
						"index" = index
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
				"index" = SStrade.discovered_stations.Find(PRG.station),
				"path" = path,
			)
			.["offers"] += list(offer)

		if(!recursiveLen(.["offers"]))
			.["offers"] = null

#undef GOODS_SCREEN
#undef OFFER_SCREEN
