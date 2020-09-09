SUBSYSTEM_DEF(trade)
	name = "Trade"
	priority = SS_PRIORITY_SUPPLY
	flags = SS_NO_FIRE

	var/trade_stations_budget = 8 //how many trade stations should spawned

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
		var/datum/trade_station/s = pickweight(weightstationlist)
		if(istype(s))
			stations2init += s
		s.cost_trade_stations_budget()
		weightstationlist.Remove(s)
	init_stations_by_list(stations2init)

/datum/controller/subsystem/trade/proc
	collect_trade_stations()
		. = list()
		for(var/path in subtypesof(/datum/trade_station))
			var/datum/trade_station/s = new path()
			if(!s.spawn_always && s.spawn_probability)
				.[s] = s.spawn_probability
			else
				qdel(s)

	collect_spawn_always()
		. = list()
		for(var/path in subtypesof(/datum/trade_station))
			var/datum/trade_station/s = new path()
			if(s.spawn_always)
				. += s
			else
				qdel(s)

	init_station(stype)
		var/datum/trade_station/station
		if(istype(stype, /datum/trade_station))
			station = stype
			if(!station.name)
				station.init_src()
		else if(ispath(stype, /datum/trade_station))
			station = new stype(TRUE)
		if(station?.linked_with)
			init_stations_by_list(station.linked_with)
		. = station

	init_stations_by_list(list/L)
		. = list()
		for(var/i in try_json_decode(L))
			var/a = init_station(i)
			if(a)
				. += a

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
	var/static/list/price_cache = list()
	if(!price_cache[path])
		var/atom/movable/AM = new path
		price_cache[path] = get_cost(AM)
		qdel(AM)
	return price_cache[path]

/datum/controller/subsystem/trade/proc/get_export_cost(atom/movable/target)
	. = get_cost(target) * 0.6

/datum/controller/subsystem/trade/proc/get_import_cost(path, datum/trade_station/trade_station)
	. = get_new_cost(path)
	var/markup = 1.2
	if(istype(trade_station))
		markup += trade_station.markup
	. *= markup

/datum/controller/subsystem/trade/proc/sell(obj/machinery/trade_beacon/sending/beacon, datum/money_account/account)
	if(QDELETED(beacon))
		return

	var/points = 0

	for(var/atom/movable/AM in beacon.get_objects())
		if(AM.anchored)
			continue

		var/export_cost = get_export_cost(AM)
		if(!export_cost)
			continue

		points += export_cost
		qdel(AM)

	if(!points)
		return

	beacon.activate()

	if(account)
		var/datum/money_account/A = account
		var/datum/transaction/T = new(points, account.get_name(), "Exports", "Asters Automated Trading System")
		T.apply_to(A)


/datum/controller/subsystem/trade/proc/assess_offer(obj/machinery/trade_beacon/sending/beacon, datum/trade_station/station)
	if(QDELETED(beacon) || !station)
		return

	. = list()

	for(var/atom/movable/AM in beacon.get_objects())
		if(AM.anchored || !istype(AM, station.offer_type))
			continue
		. += AM

/datum/controller/subsystem/trade/proc/fulfill_offer(obj/machinery/trade_beacon/sending/beacon, datum/money_account/account, datum/trade_station/station)
	var/list/exported = assess_offer(beacon, station)

	if(!exported || length(exported) < station.offer_amount)
		return

	exported.Cut(station.offer_amount + 1)

	for(var/atom/movable/AM in exported)
		qdel(AM)

	beacon.activate()

	if(account)
		var/datum/money_account/A = account
		var/datum/transaction/T = new(station.offer_price, account.get_name(), "Special deal", station.name)
		T.apply_to(A)

	station.generate_offer()


/datum/controller/subsystem/trade/proc/buy(obj/machinery/trade_beacon/receiving/beacon, datum/money_account/account, list/shoppinglist, datum/trade_station/station)
	if(QDELETED(beacon) || !account || !length(shoppinglist))
		return

	var/cost = 0
	for(var/category_name in shoppinglist)
		var/list/category = shoppinglist[category_name]
		for(var/path in category)
			cost += get_import_cost(path, station) * category[path]

	if(get_account_credits(account) < cost)
		return

	if(length(shoppinglist) == 1 && shoppinglist[shoppinglist[1]] == 1)
		var/type = shoppinglist[1]
		if(!beacon.drop(type))
			return
	else
		var/obj/structure/closet/crate/C = beacon.drop(/obj/structure/closet/crate)
		if(!C)
			return
		for(var/category_name in shoppinglist)
			var/list/category = shoppinglist[category_name]
			var/list/assortiment_category = station.assortiment[category_name]
			for(var/t in category)
				var/tcount = category[t]
				for(var/i in 1 to tcount)
					new t(C)
				var/indix = assortiment_category.Find(t)
				station.set_good_amount(category_name, indix, max(0, station.get_good_amount(category_name, indix) - tcount))

	charge_to_account(account.account_number, account.get_name(), "Purchase", "Asters Automated Trading System", cost)

	RecursiveCut(shoppinglist)
