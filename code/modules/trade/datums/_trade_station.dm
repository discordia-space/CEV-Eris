/datum/trade_station
	var/name
	var/desc
	var/list/icon_states = "station"
	var/offer_type
	var/offer_price
	var/offer_amount

	var/turf/overmap_location

	var/start_discovered = FALSE
	var/max_missing_assortiment = 0
	var/spawning_with //trade 'station' that must spawn with //todo

	var/list/forced_overmap_zone //list(list(minx, maxx), list(miny, maxy))

	var/list/name_pool = list()

	var/list/assortiment = list()
	var/list/offer_types = list()

/datum/trade_station/New()
	for(var/datum/trade_station/S in SStrade.all_stations)
		name_pool.Remove(S.name)
		if(!length(name_pool))
			warning("Trade station name pool exhausted: [type]")
			name_pool = S.name_pool
			break
	name = pick(name_pool)
	desc = name_pool[name]

	. = ..()

	var/removed = rand(0, max_missing_assortiment)
	while(removed-- && recursiveLen(assortiment))
		var/list/cur2remove = assortiment[pick(assortiment)]
		if(islist(cur2remove))
			cur2remove -= pick(cur2remove)

	offer_tick()
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

/datum/trade_station/Destroy()
	SStrade.all_stations -= src
	return ..()

/datum/trade_station/proc/place_overmap(x, y, z = GLOB.maps_data.overmap_z)
	overmap_location = locate(x, y, z)

	var/obj/effect/overmap_event/event = new(overmap_location)
	event.name = name
	event.icon_state = pick(icon_states) //placeholder
	event.opacity = 0

	if(!start_discovered)
		GLOB.entered_event.register(overmap_location, src, .proc/discovered)

/datum/trade_station/proc/discovered(_, obj/effect/overmap/ship/ship)
	if(!istype(ship) || !ship.base)
		return

	SStrade.discovered_stations |= src
	GLOB.entered_event.unregister(overmap_location, src, .proc/discovered)

#define SPECIAL_OFFER_MIN_PRICE 7000
#define SPECIAL_OFFER_MAX_PRICE 20000
#define SPECIAL_OFFER_MIN_MOD 3
#define SPECIAL_OFFER_MAX_MOD 4

/datum/trade_station/proc/generate_offer()
	if(!length(offer_types))
		return
	offer_type = pick(offer_types)
	var/atom/movable/AM = offer_type

	var/min_amt = round(SPECIAL_OFFER_MIN_PRICE / (initial(AM.price_tag) * SPECIAL_OFFER_MAX_MOD) + 1)
	var/max_amt = round(SPECIAL_OFFER_MAX_PRICE / (initial(AM.price_tag) * SPECIAL_OFFER_MIN_MOD))
	offer_amount = rand(min_amt, max_amt)

	var/min_price = max(SPECIAL_OFFER_MIN_PRICE, offer_amount * initial(AM.price_tag) * SPECIAL_OFFER_MIN_MOD)
	var/max_price = min(SPECIAL_OFFER_MAX_PRICE, offer_amount * initial(AM.price_tag) * SPECIAL_OFFER_MAX_MOD)
	offer_price = rand(min_price, max_price)

/datum/trade_station/proc/offer_tick()
	generate_offer()
	addtimer(CALLBACK(src, .proc/offer_tick), rand(15, 25) MINUTES)
