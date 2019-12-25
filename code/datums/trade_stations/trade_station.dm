/datum/trade_station
	var/name
	var/desc
	var/offer_type
	var/offer_price
	var/offer_amount

	var/turf/overmap_location

	var/start_discovered = FALSE
	var/max_missing_assortiment = 0

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

	..()

	var/removed = rand(0, max_missing_assortiment)
	while(removed-- && length(assortiment))
		assortiment -= pick(assortiment)

	offer_tick()
	place_overmap(rand(OVERMAP_EDGE, maps_data.overmap_size - OVERMAP_EDGE),
	              rand(OVERMAP_EDGE, maps_data.overmap_size - OVERMAP_EDGE))

	SStrade.all_stations += src
	if(start_discovered)
		SStrade.discovered_stations += src

/datum/trade_station/Destroy()
	SStrade.all_stations -= src
	return ..()

/datum/trade_station/proc/place_overmap(x, y, z = maps_data.overmap_z)
	overmap_location = locate(x, y, z)

	var/obj/effect/overmap_event/event = new(overmap_location)
	event.name = name
	event.icon_state = "event" //placeholder
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
	addtimer(CALLBACK(src, .proc/offer_tick), rand(15,25) MINUTES)
