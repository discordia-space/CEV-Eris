#define good_data(nam, rand_list) list("name" = nam, "amount_range" = rand_list)
#define custom_good_name(nam) good_data(nam, null)
#define custom_good_amount_range(rand_list) good_data(null, rand_list)
/datum/trade_station
	var/name
	var/desc
	var/list/icon_states = "station"
	var/offer_type
	var/offer_price
	var/offer_amount

	var/spawn_always = FALSE
	var/spawn_probability = 30
	var/spawn_cost = 1
	var/start_discovered = FALSE
	var/list/linked_with //trade 'stations' or 'station' that must spawn with //list or path
	var/commision = 200 //Cost of trading more than one thing or cost for crate

	var/list/forced_overmap_zone //list(list(minx, maxx), list(miny, maxy))
	var/ovemap_opacity = 0

	var/list/name_pool = list()

	var/markup = 0
	var/list/assortiment = list()
	var/list/offer_types = list()
	
	var/list/amounts_of_goods = list()

	var/obj/effect/overmap_event/overmap_object
	var/turf/overmap_location

/datum/trade_station/New(init_on_new)
	. = ..()
	if(init_on_new)
		init_src()

/datum/trade_station/proc/init_src()
	if(name)
		crash_with("Some retard gived trade station a name before init_src, not thought name_pool. ([type])")
	for(var/datum/trade_station/S in SStrade.all_stations)
		name_pool.Remove(S.name)
		if(!length(name_pool))
			warning("Trade station name pool exhausted: [type]")
			name_pool = S.name_pool
			break
	name = pick(name_pool)
	desc = name_pool[name]

	update_tick()

	var/x = 1
	var/y = 1
	if(recursiveLen(forced_overmap_zone) == 6)
		x = rand(forced_overmap_zone[1][1], forced_overmap_zone[1][2])
		y = rand(forced_overmap_zone[2][1], forced_overmap_zone[2][2])
	else
		x = rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size)
		y = rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size)
	place_overmap(min(x, GLOB.maps_data.overmap_size - OVERMAP_EDGE), min(y, GLOB.maps_data.overmap_size - OVERMAP_EDGE))

	SStrade.all_stations += src
	if(start_discovered)
		SStrade.discovered_stations += src

/datum/trade_station/proc/update_tick()
	offer_tick()
	goods_tick()
	addtimer(CALLBACK(src, .proc/update_tick), rand(15,25) MINUTES)

/datum/trade_station/proc/goods_tick()
	for(var/i in assortiment)
		var/list/ass = assortiment[i]
		if(islist(ass))
			for(var/path in ass)
				var/cost = SStrade.get_import_cost(path, src)
				var/list/rand_args = list(0, 50 / max(cost/200, 1))
				var/list/good_packet = ass[path]
				if(islist(good_packet))
					if(islist(good_packet["amount_range"]))
						rand_args = good_packet["amount_range"]
				if(!islist(amounts_of_goods))
					amounts_of_goods = list()
				if(!islist(amounts_of_goods[i]))
					amounts_of_goods[i] = list()
				var/amount_cat = amounts_of_goods[i]
				amount_cat["[ass.Find(path)]"] = max(0, rand(rand_args[1], rand_args[2]))

/datum/trade_station/proc/get_good_amount(cat, index)
	. = 0
	if(isnum(cat))
		cat = assortiment[cat]
	if(istext(cat) && text2num(index))
		if(islist(amounts_of_goods))
			var/list/L = amounts_of_goods[cat]
			if(islist(L))
				. = L[L[index]]

/datum/trade_station/proc/set_good_amount(cat, index, value)
	if(isnum(cat))
		cat = assortiment[cat]
	if(istext(cat) && text2num(index))
		if(islist(amounts_of_goods))
			var/list/L = amounts_of_goods[cat]
			if(islist(L))
				L[L[index]] = value

/datum/trade_station/proc/cost_trade_stations_budget(budget = spawn_cost)
	if(!spawn_always)
		SStrade.trade_stations_budget -= budget

/datum/trade_station/proc/regain_trade_stations_budget(budget = spawn_cost)
	if(!spawn_always)
		SStrade.trade_stations_budget += budget
/datum/trade_station/Destroy()
	SStrade.all_stations -= src
	SStrade.discovered_stations -= src
	qdel(overmap_location)
	return ..()

/datum/trade_station/proc/place_overmap(x, y, z = GLOB.maps_data.overmap_z)
	overmap_location = locate(x, y, z)

	overmap_object = new(overmap_location)
	overmap_object.name = name
	overmap_object.icon_state = pick(icon_states)
	overmap_object.opacity = ovemap_opacity
	overmap_object.dir = pick(rand(1,2), 4, 8)

	if(!start_discovered)
		GLOB.entered_event.register(overmap_location, src, .proc/discovered)

/datum/trade_station/proc/discovered(_, obj/effect/overmap/ship/ship)
	if(!istype(ship) || !ship.base)
		return

	SStrade.discovered_stations |= src
	GLOB.entered_event.unregister(overmap_location, src, .proc/discovered)

/datum/trade_station/proc/generate_offer()
	if(!length(offer_types))
		return
	offer_type = pick(offer_types)
	var/atom/movable/AM = offer_type

	var/min_amt = round(SPECIAL_OFFER_MIN_PRICE / max(1, SStrade.get_new_cost(AM)))
	var/max_amt = round(SPECIAL_OFFER_MAX_PRICE / (max(1, SStrade.get_new_cost(AM))))
	offer_amount = rand(min_amt, max_amt)
#define spec_offer_price_custom_mod (isnum(offer_types[offer_type]) ? offer_types[offer_type] : 1)
	var/min_price = clamp(offer_amount * max(1, SStrade.get_new_cost(AM)) * spec_offer_price_custom_mod, SPECIAL_OFFER_MIN_PRICE, SPECIAL_OFFER_MAX_PRICE)
	var/max_price = clamp(offer_amount * max(1, SStrade.get_new_cost(AM)) * spec_offer_price_custom_mod, min_price, SPECIAL_OFFER_MAX_PRICE)
	offer_price = rand(min_price, max_price)
#undef spec_offer_price_custom_mod

/datum/trade_station/proc/offer_tick()
	generate_offer()
