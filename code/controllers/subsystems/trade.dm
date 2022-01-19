#define TRADE_SYSTEM_IC_NAME "Asters Automated Trading System"
GLOBAL_LIST_EMPTY(price_cache)
SUBSYSTEM_DEF(trade)
	name = "Trade"
	priority = SS_PRIORITY_SUPPLY
	flags = SS_NO_FIRE

	var/trade_stations_budget = 7

	var/list/obj/machinery/trade_beacon/sending/beacons_sending = list()
	var/list/obj/machinery/trade_beacon/receiving/beacons_receiving = list()

	var/list/datum/trade_station/all_stations = list()
	var/list/datum/trade_station/discovered_stations = list()

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
					discovered_stations += station

//Returns cost of an existing object including contents
/datum/controller/subsystem/trade/proc/get_cost(atom/movable/target)
	. = 0
	for(var/atom/movable/A in target.GetAllContents(includeSelf = TRUE))
		. += A.get_item_cost(TRUE)

//Returns cost of a newly created object including contents
/datum/controller/subsystem/trade/proc/get_new_cost(path)
	if(!ispath(path))
		var/atom/movable/A = path
		if(istype(A))
			path = A.type
		else
			crash_with("Unacceptable get_new_cost() by path ([path]) and type ([A?.type]).")
			return 0

	if(!GLOB.price_cache[path])
		var/atom/movable/AM = new path
		GLOB.price_cache[path] = get_cost(AM)
		qdel(AM)
	return GLOB.price_cache[path]

/datum/controller/subsystem/trade/proc/get_export_cost(atom/movable/target)
	. = round(get_cost(target) * 0.6)

/datum/controller/subsystem/trade/proc/get_sell_price(path, datum/trade_station/station)
	. = round(get_new_cost(path) * station.markdown)

/datum/controller/subsystem/trade/proc/get_import_cost(path, datum/trade_station/station)
	. = get_new_cost(path)
	var/markup = 1.2
	if(istype(station))
		markup = station.markup
	. *= markup

// Checks item stacks amd item containers to see if they match their base states (no more selling empty first-aid kits or split item stacks as if they were full)
// Checks reagent containers to see if they match their base state or if they match the special offer from a station
/datum/controller/subsystem/trade/proc/check_contents(item_path, offer_path, assessing_special_offer = FALSE)
	if(!ispath(offer_path, /datum/reagent))
		if(istype(item_path, /obj/item/stack))					// Check if item is an item stack
			var/obj/item/stack/item_stack = item_path
			if(item_stack.amount == item_stack.max_amount)
				return TRUE										// You can only sell items when they are at max stacks
			return FALSE

		if(istype(item_path, /obj/item/storage))			// Storage items are too resource intensive to check (populate_contents() means we have to create new instances of every object within the initial object)
			return FALSE									// Also, directly selling storage items after emptying them is abusable

	if(istype(item_path, /obj/item/reagent_containers))						// Check if item is a reagent container

		var/obj/item/reagent_containers/current_container = item_path
		var/datum/reagent/target_reagent = offer_path
		var/target_volume = 0

		if(!ispath(offer_path, /datum/reagent))
			if(istype(item_path, /obj/item/reagent_containers/food))			// Food check (needed because contents are populated using something other than preloaded_reagents)
				return TRUE

			if(istype(item_path, /obj/item/reagent_containers/blood))			// Blood pack check (needed because contents are populated using something other than preloaded_reagents)
				if(current_container.reagents?.reagent_list[1]?.id == "blood" && current_container.reagents?.reagent_list[1]?.volume >= 200)
					return TRUE

			if(current_container.preloaded_reagents?.len < 1)		// If a new instance of the container does not start with reagents and the offer is not a reagent, pass
				return TRUE

		if(!current_container.reagents)		// If the previous check fails, we are looking for a container with reagents or a specific reagent
			return FALSE					// If the container is empty, fail

		var/reagent_found = 0
		for(var/datum/reagent/current_reagent in current_container.reagents?.reagent_list)
			var/current_reagent_id = current_reagent.id
			var/current_volume = current_reagent.volume

			if(assessing_special_offer)
				target_volume = 60																	// Each good requested in a reagent offer is a 60u container (container type is irrelevant)
				if(current_volume >= target_volume && istype(current_reagent, target_reagent))		// Check volume and reagent type
					return TRUE
			else																					// If there is no offer to check against, compare to preloaded reagents
				for(var/target_reagent_id in current_container.preloaded_reagents)
					target_volume = current_container.preloaded_reagents[target_reagent_id]
					if(current_volume >= target_volume && current_reagent_id == target_reagent_id)	// Check volume and reagent id
						reagent_found += 1
				if(reagent_found == current_container.preloaded_reagents.len)						// If all preloaded reagents are in the container, pass
					return TRUE

		return FALSE

	if(ispath(offer_path, /datum/reagent))		// If item is not of the types checked and the offer is for a reagent, fail
		return FALSE

	return TRUE
		
/datum/controller/subsystem/trade/proc/assess_offer(obj/machinery/trade_beacon/sending/beacon, datum/trade_station/station, offer_path, assessing_special_offer = FALSE)
	if(QDELETED(beacon) || !station)
		return

	. = list()

	for(var/atom/movable/AM in beacon.get_objects())
		if(AM.anchored || !(istype(AM, offer_path) || ispath(offer_path, /datum/reagent)))
			continue
		if(!check_contents(AM, offer_path, assessing_special_offer))		// Check contents after we know it's the same type
			continue
		. += AM

/datum/controller/subsystem/trade/proc/fulfill_offer(obj/machinery/trade_beacon/sending/beacon, datum/money_account/account, datum/trade_station/station, offer_path)
	var/list/exported = assess_offer(beacon, station, offer_path, TRUE)

	var/list/offer_content = station.special_offers[offer_path]
	var/offer_amount = text2num(offer_content["amount"])
	var/offer_price = text2num(offer_content["price"])
	if(!exported || length(exported) < offer_amount)
		return

	exported.Cut(offer_amount + 1)

	if(account)
		for(var/atom/movable/AM in exported)
			qdel(AM)

		beacon.activate()

		var/datum/money_account/A = account
		var/datum/transaction/T = new(offer_price, account.get_name(), "Special deal", station.name)
		T.apply_to(A)
		station.add_to_wealth(offer_price, TRUE)
		// clear offer, wait until next tick to generate a new one
		offer_content["amount"] = 0
		offer_content["price"] = 0
		station.special_offers[offer_path] = offer_content

/datum/controller/subsystem/trade/proc/collect_counts_from(list/shopList)
	. = 0
	for(var/categoryName in shopList)
		var/category = shopList[categoryName]
		if(length(category))
			for(var/path in category)
				. += category[path]

/datum/controller/subsystem/trade/proc/collect_price_for_list(list/shopList, datum/trade_station/tradeStation = null)
	. = 0
	for(var/categoryName in shopList)
		var/category = shopList[categoryName]
		if(length(category))
			for(var/path in category)
				. += get_import_cost(path, tradeStation) * category[path]

/datum/controller/subsystem/trade/proc/buy(obj/machinery/trade_beacon/receiving/senderBeacon, datum/money_account/account, list/shopList, datum/trade_station/station)
	if(QDELETED(senderBeacon) || !istype(senderBeacon) || !account || !recursiveLen(shopList) || !istype(station))
		return

	var/obj/structure/closet/crate/C
	var/count_of_all = collect_counts_from(shopList)
	var/price_for_all = collect_price_for_list(shopList, station)
	if(isnum(count_of_all) && count_of_all > 1)
		price_for_all += station.commision
		C = senderBeacon.drop(/obj/structure/closet/crate)
	if(price_for_all && get_account_credits(account) < price_for_all)
		return

	for(var/categoryName in shopList)
		var/list/shoplist_category = shopList[categoryName]
		var/list/assortiment_category = station.assortiment[categoryName]
		if(length(shoplist_category) && length(assortiment_category))
			for(var/pathOfGood in shoplist_category)
				var/count_of_good = shoplist_category[pathOfGood] //in shoplist
				var/index_of_good = assortiment_category.Find(pathOfGood) //in assortiment
				for(var/i in 1 to count_of_good)
					istype(C) ? new pathOfGood(C) : senderBeacon.drop(pathOfGood)
				if(isnum(index_of_good))
					station.set_good_amount(categoryName, index_of_good, max(0, station.get_good_amount(categoryName, index_of_good) - count_of_good))
	station.add_to_wealth(price_for_all)	// can only buy from one station at a time
	charge_to_account(account.account_number, account.get_name(), "Purchase", station.name, price_for_all)

/datum/controller/subsystem/trade/proc/sell_thing(obj/machinery/trade_beacon/sending/senderBeacon, datum/money_account/account, atom/movable/thing, datum/trade_station/station)
	if(QDELETED(senderBeacon) || !istype(senderBeacon) || !account || !istype(thing) || !istype(station))
		return

	var/cost = get_sell_price(thing, station)

	if(account)
		qdel(thing)
		senderBeacon.activate()
		var/datum/money_account/A = account
		var/datum/transaction/T = new(cost, account.get_name(), "Sold item", station.name)
		T.apply_to(A)
		station.add_to_wealth(cost)
