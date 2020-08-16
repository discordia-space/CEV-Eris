#define TS_RELOAD_PERIOD 30 MINUTES
SUBSYSTEM_DEF(trade)
	name = "Trade"
	priority = SS_PRIORITY_SUPPLY
	flags = SS_NO_FIRE

	var/trade_stations_budget = 8 //how many trade stations should spawned

	var/list/obj/machinery/trade_beacon/sending/beacons_sending = list()
	var/list/obj/machinery/trade_beacon/receiving/beacons_receiving = list()

	var/list/datum/trade_station/all_stations = list()
	var/list/datum/trade_station/discovered_stations = list()
	var/ts_reload_period = TS_RELOAD_PERIOD
	var/tmp/reload_timer

/datum/controller/subsystem/trade/Initialize()
	InitStations()
	. = ..()

/datum/controller/subsystem/trade/proc/ReInitStations()
	DeInitStations()
	InitStations()

/datum/controller/subsystem/trade/Destroy()
	DeInitStations()
	. = ..()

/datum/controller/subsystem/trade/proc/InitLinked(linked_type, list/stations)
	stations = try_json_decode(stations)
	for(var/list/i in stations)
		RemoveByType(stations, linked_type, TRUE) //BYOND lists is an objects, if we send list here we will change this list, not it's copy
	return InitStation(linked_type)

/datum/controller/subsystem/trade/proc/init_and_cost_station(stationtype, stations)
	var/datum/trade_station/st = InitLinked(stationtype, stations)
	st.cost_trade_stations_budget()

/datum/controller/subsystem/trade/proc/initlinkedstations(list/linked, list/stations) //(list, null)
	linked = try_json_decode(linked)
	for(var/i in linked)
		init_and_cost_station(i, stations)

/datum/controller/subsystem/trade/proc/InitStation(stype, init_on_new = TRUE)
	var/datum/trade_station/s = new stype(init_on_new)
	return s

/datum/controller/subsystem/trade/proc/InitStations()
	var/list/stations2init = list()
	var/list/subtypes = subtypesof(/datum/trade_station)
	for(var/i in subtypesof(/datum/trade_station))
		var/datum/trade_station/s = new i()
		stations2init[s] = s.spawn_probability
		initlinkedstations(s.linked_with, list(stations2init, subtypes))

	while(trade_stations_budget && length(stations2init))
		var/i = pickweight(stations2init)
		if(ispath(i))
			init_and_cost_station(i, stations2init)

	clear_list(stations2init)

	if(length(all_stations))
		reload_timer = addtimer(CALLBACK(src, .proc/ReInitStations), ts_reload_period, TIMER_STOPPABLE)

/datum/controller/subsystem/trade/proc/DeInitStations()
	for(var/datum/trade_station/s in all_stations)
		s.regain_trade_stations_budget()
		qdel(s)
	all_stations.Cut()
	deltimer(reload_timer)
//Returns cost of an existing object including contents
/datum/controller/subsystem/trade/proc/get_cost(atom/movable/target)
	. = 0
	for(var/atom/movable/A in target.GetAllContents(includeSelf = TRUE))
		. += A.get_item_cost(TRUE)

//Returns cost of a newly created object including contents
/datum/controller/subsystem/trade/proc/get_new_cost(path)
	var/static/list/price_cache = list()
	if(!price_cache[path])
		var/atom/movable/AM = new path
		price_cache[path] = get_cost(AM)
		qdel(AM)
	return price_cache[path]

/datum/controller/subsystem/trade/proc/get_export_cost(atom/movable/target)
	return get_cost(target) * 0.6

/datum/controller/subsystem/trade/proc/get_import_cost(path)
	return get_new_cost(path) * 1.2


/datum/controller/subsystem/trade/proc/sell(obj/machinery/trade_beacon/sending/beacon, datum/money_account/account)
	if(QDELETED(beacon))
		return

	var/points = 0

	for(var/atom/movable/AM in beacon.get_objects())
		if(AM.anchored)
			continue

		var/export_cost = get_export_cost(AM)
		if(!export_cost)
			return

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


/datum/controller/subsystem/trade/proc/buy(obj/machinery/trade_beacon/receiving/beacon, datum/money_account/account, list/shoppinglist)
	if(QDELETED(beacon) || !account || !length(shoppinglist))
		return

	var/cost = 0
	for(var/path in shoppinglist)
		cost += get_import_cost(path) * shoppinglist[path]

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
		for(var/type in shoppinglist)
			for(var/i in 1 to shoppinglist[type])
				new type(C)

	charge_to_account(account.account_number, account.get_name(), "Purchase", "Asters Automated Trading System", cost)

	shoppinglist.Cut()
