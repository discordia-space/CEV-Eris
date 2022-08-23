#define TRADE_SYSTEM_IC_NAME "Asters Automated Trading System"
GLOBAL_LIST_EMPTY(price_cache)
SUBSYSTEM_DEF(trade)
	name = "Trade"
	priority = SS_PRIORITY_SUPPLY
	flags = SS_NO_FIRE

	var/trade_stations_budget = 7 // Currently unused. This is the budget for stations with spawn_always = FALSE

	var/list/obj/machinery/trade_beacon/sending/beacons_sending = list()
	var/list/obj/machinery/trade_beacon/receiving/beacons_receiving = list()

	var/list/datum/trade_station/all_stations = list()
	var/list/datum/trade_station/discovered_stations = list()

	// For exports
	var/list/offer_types = list()						// List of offer datums
	var/list/hockable_tags = list(SPAWN_EXCELSIOR)		// List of spawn tags of hockable items
	var/list/junk_tags = list(SPAWN_JUNK)				// List of spawn tags of junk items

	// For tracking/logging
	var/shipping_invoice_number = 0
	var/export_invoice_number = 0
	var/offer_invoice_number = 0
	var/order_number = 0

	var/list/shipping_log = list()
	var/list/export_log = list()
	var/list/offer_log = list()
	var/list/order_log = list()

	// For ordering
	var/handling_fee = 0.2
	var/order_queue_id = 0
	var/list/order_queue = list()
	// Order format
	// list(
	//		"requesting_acct" = acct name,
	//		"reason" = reasons,
	//		"cost" = cart price,
	//		"fee" = handling fee,
	//		"contents" = shoppinglist,
	//		"viewable_contents" = parsed shopping list
	// )

// === TRADE STATIONS ===

/datum/controller/subsystem/trade/proc/DiscoverAllTradeStations()
	discovered_stations = all_stations.Copy()

/datum/controller/subsystem/trade/Initialize()
	InitStations()
	. = ..()

/datum/controller/subsystem/trade/proc/ReInitStations()
	DeInitStations()
	InitStations()

/datum/controller/subsystem/trade/Destroy()
	DeInitStations()
	. = ..()

/datum/controller/subsystem/trade/proc/DeInitStations()
	for(var/datum/trade_station/s in all_stations)
		s.regain_trade_stations_budget()
		qdel(s)
		discovered_stations -= s
		all_stations -= s

/datum/controller/subsystem/trade/proc/InitStations()
	var/list/weightstationlist = collect_trade_stations()
	var/list/stations2init = collect_spawn_always()

	while(trade_stations_budget && length(weightstationlist))
		var/datum/trade_station/station_instance = pickweight(weightstationlist)
		if(istype(station_instance))
			stations2init += station_instance
			station_instance.cost_trade_stations_budget()
		weightstationlist.Remove(station_instance)
	init_stations_by_list(stations2init)

// Add a random trading station after the start of the round among pool of stations not already spawned
/datum/controller/subsystem/trade/proc/AddStation(var/turf/station_loc)
	var/list/availablestationlist = collect_available_trade_stations()

	if(length(availablestationlist))
		var/datum/trade_station/station_instance = pickweight(availablestationlist)
		if(istype(station_instance))
			station_instance.init_src(station_loc, TRUE)  // Spawn at custom location with discovered status

/datum/controller/subsystem/trade/proc/collect_trade_stations()
	. = list()
	for(var/path in subtypesof(/datum/trade_station))
		var/datum/trade_station/s = new path()
		if(!s.spawn_always && s.spawn_probability)
			.[s] = s.spawn_probability
		else
			qdel(s)

/datum/controller/subsystem/trade/proc/collect_spawn_always()
	. = list()
	for(var/path in subtypesof(/datum/trade_station))
		var/datum/trade_station/s = new path()
		if(s.spawn_always)
			. += s
		else
			qdel(s)

// Get a weighted list of all stations that have not already been spawned
/datum/controller/subsystem/trade/proc/collect_available_trade_stations()
	. = list()
	for(var/path in subtypesof(/datum/trade_station))
		var/is_available = TRUE
		for(var/datum/trade_station/S in SStrade.all_stations)
			if(istype(S, path))
				is_available = FALSE
		if(is_available)
			var/datum/trade_station/s = new path()
			if(s.spawn_probability)
				. += s
			else
				qdel(s)

/datum/controller/subsystem/trade/proc/init_station(stype)
	var/datum/trade_station/station
	if(istype(stype, /datum/trade_station))
		station = stype
		if(!station.name)
			station.init_src()
	else if(ispath(stype, /datum/trade_station))
		station = new stype(TRUE)
	. = station

/datum/controller/subsystem/trade/proc/init_stations_by_list(list/L)
	. = list()
	for(var/i in try_json_decode(L))
		var/a = init_station(i)
		if(a)
			. += a

/datum/controller/subsystem/trade/proc/discover_by_uid(list/uid_list)
	for(var/target_uid in uid_list)
		for(var/datum/trade_station/station in all_stations)
			if(station.uid == target_uid)
				station.recommendations_needed -= 1
				if(!station.recommendations_needed)
					discovered_stations |= station
					GLOB.entered_event.unregister(station.overmap_location, station, /datum/trade_station/proc/discovered)

/datum/controller/subsystem/trade/proc/get_station_by_uid(target_uid)
	for(var/datum/trade_station/station in all_stations)
		if(station.uid == target_uid)
			return station
	return FALSE

/datum/controller/subsystem/trade/proc/get_discovered_station_by_uid(target_uid)
	for(var/datum/trade_station/station in discovered_stations)
		if(station.uid == target_uid)
			return station
	return FALSE

// === PRICING ===

//Returns cost of an existing object including contents
/datum/controller/subsystem/trade/proc/get_cost(atom/movable/target, is_export = FALSE)
	. = 0
	for(var/atom/movable/A in target.GetAllContents(includeSelf = TRUE))
		. += A.get_item_cost(is_export)

//Returns cost of a newly created object including contents
/datum/controller/subsystem/trade/proc/get_new_cost(path)
	if(!ispath(path))
		var/atom/movable/A = path
		if(istype(A))
			path = A.type
		else
			. = 0
			CRASH("Unacceptable get_new_cost() by path ([path]) and type ([A?.type]).")

	if(!GLOB.price_cache[path])
		var/atom/movable/AM = new path
		GLOB.price_cache[path] = get_cost(AM)
		qdel(AM)
	return GLOB.price_cache[path]

/datum/controller/subsystem/trade/proc/get_price(atom/movable/target, is_export = FALSE)
	. = round(get_cost(target, is_export))

/datum/controller/subsystem/trade/proc/get_import_cost(path, datum/trade_station/station)
	. = station?.get_good_price(path)								// get_good_price() gets the custom price of the item, if it exists
	if(!.)
		. = get_new_cost(path) ? get_new_cost(path) : 100			// Should solve the issue of items without price tags
		if(istype(station))
			. *= station.markup

// === IMPORT/EXPORT ===

// Checks item stacks and item containers to see if they match their base states (no more selling empty first-aid kits or split item stacks as if they were full)
// Checks reagent containers to see if they match their base state or if they match the special offer from a station
/datum/controller/subsystem/trade/proc/check_offer_contents(item, offer_path)
	if(istype(item, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/current_container = item
		var/datum/reagent/target_reagent = offer_path
		var/target_volume = 60										// Each good requested in a reagent offer is a 60u container (container type is irrelevant)

		if(!ispath(offer_path, /datum/reagent))
			if(istype(item, /obj/item/reagent_containers/food))		// Food check (needed because contents are populated using something other than preloaded_reagents)
				return TRUE

			if(istype(item, /obj/item/reagent_containers/blood))	// Blood pack check (needed because contents are populated using something other than preloaded_reagents)
				if(current_container.reagents?.reagent_list[1]?.id == "blood" && current_container.reagents?.reagent_list[1]?.volume >= 200)
					return TRUE

			if(current_container.preloaded_reagents?.len < 1)		// If a new instance of the container does not start with reagents and the offer is not a reagent, pass
				return TRUE

		if(!current_container.reagents)								// If the previous check fails, we are looking for a container with reagents or a specific reagent
			return FALSE											// If the container is empty, fail

		for(var/datum/reagent/current_reagent in current_container.reagents?.reagent_list)											
			if(current_reagent.volume >= target_volume && istype(current_reagent, target_reagent))		// Check volume and reagent type
				return TRUE

		return FALSE

	if(ispath(offer_path, /datum/reagent))		// If item is not of the types checked and the offer is for a reagent, fail
		return FALSE

	return TRUE

/datum/controller/subsystem/trade/proc/assess_offer(obj/machinery/trade_beacon/sending/beacon, offer_path)
	if(QDELETED(beacon))
		return

	. = list()

	for(var/atom/movable/AM in beacon.get_objects())
		if(AM.anchored || !(istype(AM, offer_path) || ispath(offer_path, /datum/reagent)))
			continue
		if(!check_offer_contents(AM, offer_path))		// Check contents after we know it's the same type
			continue
		. += AM

/datum/controller/subsystem/trade/proc/assess_all_offers(obj/machinery/trade_beacon/sending/beacon)
	if(QDELETED(beacon))
		return

	var/list/all_offers = offer_types.Copy()

	for(var/atom/movable/AM in beacon.get_objects())
		for(var/offer_path in offer_types)
			if(AM.anchored || !(istype(AM, offer_path) || ispath(offer_path, /datum/reagent)))
				continue
			if(!check_offer_contents(AM, offer_path))		// Check contents after we know it's the same type
				continue
			if(!islist(all_offers[offer_path]))
				all_offers[offer_path] = list()
			all_offers[offer_path] += AM
			continue

	for(var/offer in all_offers)
		if(!islist(all_offers[offer]))		// If it's not a list, no items were found
			all_offers -= offer

	return all_offers

/datum/controller/subsystem/trade/proc/fulfill_offer(obj/machinery/trade_beacon/sending/beacon, datum/money_account/account, datum/trade_station/station, offer_path, is_slaved = FALSE)
	var/list/exported = assess_offer(beacon, offer_path)

	var/list/offer_content = station.special_offers[offer_path]
	var/offer_amount = text2num(offer_content["amount"])
	var/offer_price = text2num(offer_content["price"])
	if(!exported || length(exported) < offer_amount || !offer_amount)
		return

	exported.Cut(offer_amount + 1)

	if(account)
		var/invoice_contents_info

		for(var/atom/movable/AM in exported)
			SEND_SIGNAL(src, COMSIG_TRADE_BEACON, AM)
			invoice_contents_info += "<li>[AM.name]</li>"
			qdel(AM)

		create_log_entry("Special Offer", account.get_name(), invoice_contents_info, offer_price, FALSE, get_turf(beacon))

		beacon.activate()

		if(is_slaved)
			var/datum/money_account/master_account = department_accounts[DEPARTMENT_GUILD]
			var/datum/transaction/master_T = new(offer_price * 0.2, master_account.get_name(), "Trade Offer", station.name)
			var/datum/transaction/slave_T = new(offer_price * 0.8, account.get_name(), "Trade Offer", station.name)
			master_T.apply_to(master_account)
			slave_T.apply_to(account)
		else
			var/datum/transaction/T = new(offer_price, account.get_name(), "Trade Offer", station.name)
			T.apply_to(account)

		station.add_to_wealth(offer_price, TRUE)
		offer_content["amount"] = 0
		offer_content["price"] = 0
		station.special_offers[offer_path] = offer_content

/datum/controller/subsystem/trade/proc/fulfill_all_offers(obj/machinery/trade_beacon/sending/beacon, datum/money_account/account, is_slaved = FALSE)
	var/list/exported = assess_all_offers(beacon)

	for(var/station in discovered_stations)
		var/datum/trade_station/TS = station

		for(var/offer_path in TS.offer_types)
			var/list/offer_content = TS.special_offers[offer_path]
			var/offer_amount = text2num(offer_content["amount"])
			var/offer_price = text2num(offer_content["price"])
			var/list/item_list = exported[offer_path]

			if(!item_list || item_list.len < offer_amount || !offer_amount)
				continue

			if(account)
				var/invoice_contents_info

				for(var/i in 1 to offer_amount)
					var/atom/movable/AM = item_list[i]
					SEND_SIGNAL(src, COMSIG_TRADE_BEACON, AM)
					invoice_contents_info += "<li>[AM.name]</li>"
					qdel(AM)

				create_log_entry("Special Offer", account.get_name(), invoice_contents_info, offer_price, FALSE, get_turf(beacon))

				if(is_slaved)
					var/datum/money_account/master_account = department_accounts[DEPARTMENT_GUILD]
					var/datum/transaction/master_T = new(offer_price * 0.2, master_account.get_name(), "Trade Offer", TS.name)
					var/datum/transaction/slave_T = new(offer_price * 0.8, account.get_name(), "Trade Offer", TS.name)
					master_T.apply_to(account)
					slave_T.apply_to(account)
				else
					var/datum/transaction/T = new(offer_price, account.get_name(), "Trade Offer", TS.name)
					T.apply_to(account)

				TS.add_to_wealth(offer_price, TRUE)
				offer_content["amount"] = 0
				offer_content["price"] = 0
				TS.special_offers[offer_path] = offer_content

	beacon.start_export()

/datum/controller/subsystem/trade/proc/collect_counts_from(list/shopList)
	. = 0
	for(var/station in shopList)
		var/list/shoplist_station = shopList[station]
		for(var/category_name in shoplist_station)
			var/list/category = shoplist_station[category_name]
			if(length(category))
				for(var/path in category)
					. += category[path]

/datum/controller/subsystem/trade/proc/collect_price_for_list(list/shopList)
	. = 0
	for(var/station in shopList)
		var/list/shoplist_station = shopList[station]
		for(var/category_name in shoplist_station)
			var/category = shoplist_station[category_name]
			if(length(category))
				for(var/path in category)
					. += get_import_cost(path, station) * category[path]

/datum/controller/subsystem/trade/proc/collect_price_for_category(list/category, datum/trade_station/station)
	. = 0
	if(!length(category))
		return

	for(var/path in category)
		. += get_import_cost(path, station) * category[path]

/datum/controller/subsystem/trade/proc/buy(obj/machinery/trade_beacon/receiving/senderBeacon, datum/money_account/account, list/shopList)
	if(QDELETED(senderBeacon) || !istype(senderBeacon) || !account || !recursiveLen(shopList))
		return

	var/obj/structure/closet/crate/C
	var/count_of_all = collect_counts_from(shopList)
	var/price_for_all = collect_price_for_list(shopList)
	if(isnum(count_of_all) && count_of_all > 1)
		C = senderBeacon.drop(/obj/structure/closet/crate)
	if(price_for_all && get_account_credits(account) < price_for_all)
		return

	var/order_contents_info
	var/invoice_location

	for(var/datum/trade_station/station in shopList)
		var/list/shoplist_station = shopList[station]
		var/to_station_wealth = 0
		for(var/category_name in shoplist_station)
			var/list/shoplist_category = shoplist_station[category_name]
			var/list/inventory_category = station.inventory[category_name]
			to_station_wealth += collect_price_for_category(shoplist_category, station)
			if(length(shoplist_category) && length(inventory_category))
				for(var/good_path in shoplist_category)
					var/count_of_good = shoplist_category[good_path] //in shoplist
					var/index_of_good = inventory_category.Find(good_path) //in inventory
					for(var/i in 1 to count_of_good)
						if(istype(C))
							new good_path(C)
						else
							var/atom/movable/new_item = senderBeacon.drop(good_path)
							invoice_location = new_item.loc
					if(isnum(index_of_good))
						station.set_good_amount(category_name, index_of_good, max(0, station.get_good_amount(category_name, index_of_good) - count_of_good))

					// invoice gen stuff
					var/atom/movable/AM = good_path
					var/list/good_packet = inventory_category[good_path]
					var/item_name = initial(AM.name)
					if(islist(good_packet))
						item_name = good_packet["name"] ? good_packet["name"] : item_name
					order_contents_info += "<li>[count_of_good]x [item_name]</li>"
		station.add_to_wealth(to_station_wealth)

	if(count_of_all > 1)
		invoice_location = C

	create_log_entry("Shipping", account.get_name(), order_contents_info, price_for_all, FALSE, invoice_location)
	charge_to_account(account.account_number, account.get_name(), "Purchase", "Trade Network", price_for_all)

/datum/controller/subsystem/trade/proc/export(obj/machinery/trade_beacon/sending/senderBeacon)
	if(QDELETED(senderBeacon) || !istype(senderBeacon))
		return

	var/invoice_contents_info
	var/cost = 0

	for(var/atom/movable/AM in senderBeacon.get_objects())
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			H.apply_damage(5, BURN)
			continue

		var/list/contents_incl_self = AM.GetAllContents(5, TRUE)

		// We go backwards, so it'll be innermost objects sold first
		for(var/atom/movable/item in reverseRange(contents_incl_self))
			var/item_price = get_price(item, TRUE)
			var/export_multiplier = get_export_price_multiplier(item)
			var/export_value = item_price * export_multiplier

			if(export_multiplier)
				invoice_contents_info += "<li>[item.name]</li>"
				cost += export_value
				SEND_SIGNAL(src, COMSIG_TRADE_BEACON, item)
				qdel(item)
			else
				item.forceMove(get_turf(AM))		// Should be the same tile
	
	senderBeacon.start_export()
	var/datum/money_account/guild_account = department_accounts[DEPARTMENT_GUILD]
	var/datum/transaction/T = new(cost, guild_account.get_name(), "Export", TRADE_SYSTEM_IC_NAME)
	T.apply_to(guild_account)

	if(invoice_contents_info)	// If no info, then nothing was exported
		create_log_entry("Export", guild_account.get_name(), invoice_contents_info, cost, FALSE, get_turf(senderBeacon))

/datum/controller/subsystem/trade/proc/get_export_price_multiplier(atom/movable/target)
	if(!target || target.anchored)
		return NONEXPORTABLE

	. = EXPORTABLE

	var/list/target_spawn_tags = params2list(target?.spawn_tags)
	var/list/target_junk_tags = target_spawn_tags & junk_tags
	var/list/target_hockable_tags = target_spawn_tags & hockable_tags

	// Junk tags override hockable tags and offer types override both
	if(target_hockable_tags.len)
		. = HOCKABLE				
	if(target_junk_tags.len)
		. = JUNK
	for(var/offer_type in offer_types)
		if(istype(target, offer_type))
			return NONEXPORTABLE

// === ORDERING ===

/datum/controller/subsystem/trade/proc/build_order(requesting_account, reason, list/shopping_list)
	if(!requesting_account || !shopping_list || !shopping_list.len)
		return

	var/cost = collect_price_for_list(shopping_list)
	var/order_contents_info
	var/list/goods = list()
	var/datum/money_account/requesting_acct = requesting_account
	var/datum/money_account/master_acct = department_accounts[DEPARTMENT_GUILD]
	var/is_requestor_master = (requesting_acct == master_acct) ? TRUE : FALSE

	for(var/station in shopping_list)
		var/list/shoplist_categories = shopping_list[station]
		for(var/category in shoplist_categories)
			var/list/shoplist_goods = shoplist_categories[category]
			for(var/good in shoplist_goods)
				goods |= good

				var/amount_to_add = shoplist_goods[good]

				goods[good] += amount_to_add

				var/atom/movable/AM = good
				order_contents_info += "<li>[amount_to_add]x [initial(AM.name)]</li>"

	var/list/new_order = list(
		"requesting_acct" = requesting_account,
		"reason" = reason,
		"cost" = cost,
		"fee" = (is_requestor_master ? 0 : cost * handling_fee),
		"contents" = shopping_list,
		"viewable_contents" = order_contents_info
	)

	var/order_queue_slot = "order_[++order_queue_id]"
	order_queue |= order_queue_slot
	order_queue[order_queue_slot] = new_order

	return order_queue_slot

/datum/controller/subsystem/trade/proc/purchase_order(obj/machinery/trade_beacon/receiving/beacon, order_id)
	if(QDELETED(beacon) || !beacon || !order_id)
		return

	if(order_queue.Find(order_id))
		var/list/order = order_queue[order_id]

		var/datum/money_account/master_account = department_accounts[DEPARTMENT_GUILD]
		var/datum/money_account/requesting_account = order["requesting_acct"]
		var/list/shopping_list = order["contents"]
		var/list/viewable_contents = order["viewable_contents"]
		var/total_cost = order["cost"] + order["fee"]
		var/is_requestor_master = (requesting_account == master_account) ? TRUE : FALSE

		buy(beacon, master_account, shopping_list)
		if(!is_requestor_master)
			transfer_funds(requesting_account, master_account, "Order Request", null, total_cost)
		create_log_entry("Order", requesting_account.get_name(), viewable_contents, total_cost)

// === LOGGING ===

/datum/controller/subsystem/trade/proc/create_log_entry(type, ordering_account, contents, total_paid, create_invoice = FALSE, invoice_location = null)
	var/log_id

	switch(type)
		if("Shipping")
			log_id = "[++shipping_invoice_number]-S"
			shipping_log.Add(list(list("id" = log_id, "ordering_acct" = ordering_account, "contents" = contents, "total_paid" = total_paid, "time" = time2text(world.time, "hh:mm"))))
		if("Export")
			log_id = "[++export_invoice_number]-E"
			export_log.Add(list(list("id" = log_id, "ordering_acct" = ordering_account, "contents" = contents, "total_paid" = total_paid, "time" = time2text(world.time, "hh:mm"))))
		if("Special Offer")
			log_id = "[++offer_invoice_number]-SO"
			offer_log.Add(list(list("id" = log_id, "ordering_acct" = ordering_account, "contents" = contents, "total_paid" = total_paid, "time" = time2text(world.time, "hh:mm"))))
		if("Order")
			log_id = "[++order_number]-O"
			order_log.Add(list(list("id" = log_id, "ordering_acct" = ordering_account, "contents" = contents, "total_paid" = total_paid, "time" = time2text(world.time, "hh:mm"))))
		else
			return

	if(create_invoice && invoice_location && log_id)
		print_invoice(type, log_id, ordering_account, contents, total_paid, FALSE, invoice_location)
		if(type == "Shipping")
			print_invoice(type, log_id, ordering_account, contents, total_paid, TRUE, invoice_location)

/datum/controller/subsystem/trade/proc/print_invoice(type, log_id, ordering_account, contents, total_paid, is_internal = FALSE, location)
	if(!location)
		return

	var/title
	title = "[lowertext(type)] invoice - #[log_id]"
	title += is_internal ? " (internal)" : null

	var/text
	text += "<h3>[type] Invoice - #[log_id]</h3>"
	text += "<hr><font size = \"2\">"
	text += is_internal ? "FOR INTERNAL USE ONLY<br><br>" : null
	text += type != "Shipping" && type ? "Recipient: [ordering_account]<br>" : "Recipient: \[field\]<br>"
	text += type == "Shipping" ? "Package Name: \[field\]<br>" : null
	text += "Contents:<br>"
	text += "<ul>"
	text += contents
	text += "</ul>"
	text += is_internal ? "Order Cost: [total_paid]<br>" : null
	text += type == "Shipping" ? "Total Credits Paid: \[field\]<br>" : "Total Credits Paid: [total_paid]<br>"
	text += "</font>"
	text += type == "Shipping" ? "<hr><h5>Stamp below to confirm receipt of goods:</h5>" : null

	new/obj/item/paper(location, text, title)

/datum/controller/subsystem/trade/proc/get_log_data_by_id(log_id)
	var/id_data = splittext(log_id, "-")
	var/log_num = text2num(id_data[1])
	var/log_type = id_data[2]
	switch(log_type)
		if("S")
			return shipping_log[log_num]
		if("E")
			return export_log[log_num]
		if("SO")
			return offer_log[log_num]
		if("O")
			return order_log[log_num]
		else
			return

// === ECONOMY ===

// The proc that is called when the price is being asked for. Use this to refer to another object if necessary.
/atom/movable/proc/get_item_cost(export)
	. = price_tag
