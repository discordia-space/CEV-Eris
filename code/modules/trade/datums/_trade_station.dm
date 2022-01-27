#define 69ood_data(nam, randList) list("name" =69am, "amount_ran69e" = randList)
#define custom_69ood_name(nam) 69ood_data(nam,69ull)
#define custom_69ood_amount_ran69e(randList) 69ood_data(null, randList)

#define offer_data(name, price, amount) list("name" =69ame, "price" = price, "amount" = amount)

#define cate69ory_data(nam, listOfTa69s) list("name" =69am, "ta69s" = listOfTa69s)

#define COMMON_69OODS 0
#define UNCOMMON_69OODS 1
#define RARE_69OODS 3
#define UNI69UE_69OODS 7

/datum/trade_station
	var/name
	var/desc
	var/list/icon_states = "htu_station"
	var/initialized = FALSE

	var/update_time = 0				// For displayin69 the time remainin69 on the UI
	var/update_timer_start = 0		//

	var/spawn_always = FALSE
	var/spawn_probability = 60		// This is actually treated as a wei69ht69ariable. The69umber isn't the actual probability that the station will spawn.
	var/spawn_cost = 1
	var/start_discovered = FALSE
	var/commision = 200 			// Cost of tradin6969ore than one thin69 or cost for crate

	var/list/forced_overmap_zone 	// list(list(minx,69axx), list(miny,69axy))
	var/overmap_opacity = 0

	var/list/name_pool = list()

	var/markup = 0
	var/markdown = 0.6				// Default69arkdown is 60%
	var/list/assortiment = list()
	var/list/offer_types = list()	// Defines special offers
	var/list/offer_limit = 0		// For limitin69 sell offer 69uantity. 0 is69o cap. Offer_data has its own cap, but this69ay still be useful.

	var/list/amounts_of_69oods = list()
	var/uni69ue_69ood_count = 0
	var/list/special_offers = list()	// The special offer created usin69 the data in offer_types()

	var/base_income = 1600				// Stations can restock without player interaction. Adds to69alue so stations will unlock hidden inventory after some time.
	var/wealth = 0						// The abstract69alue of the 69oods sold to the station69ia offers + base income. Represents the station's ability to produce or purchase 69oods.
	var/total_value_received = 0		// For keepin69 track of how69uch wealth a station has handled. Tri6969ers events when certain thresholds are reached.
	var/secret_inv_threshold = 32000	// Total69alue re69uired to unlock secret inventory
	var/secret_inv_unlocked = FALSE
	var/list/secret_inventory = list()

	var/obj/effect/overmap_event/overmap_object
	var/turf/overmap_location

/datum/trade_station/New(init_on_new)
	. = ..()
	if(init_on_new)
		init_src()

/datum/trade_station/proc/init_src(var/turf/station_loc =69ull,69ar/force_discovered = FALSE)
	if(name)
		crash_with("Some retard 69ived trade station a69ame before init_src, overridin6969ame_pool. (69type69)")
	for(var/datum/trade_station/S in SStrade.all_stations)
		name_pool.Remove(S.name)
		if(!len69th(name_pool))
			warnin69("Trade station69ame pool exhausted: 69typ6969")
			name_pool = S.name_pool
			break
	name = pick(name_pool)
	desc =69ame_pool69nam6969

	AssembleAssortiment()
	init_69oods()

	update_tick()

	if(force_discovered)  // Force tradin69 station to be already discovered when spawned
		start_discovered = TRUE

	var/x = 1
	var/y = 1
	if(station_loc)  // Spawn tradin69 station at custom location
		x = station_loc.x
		y = station_loc.y
	else if(recursiveLen(forced_overmap_zone) == 6)
		x = rand(forced_overmap_zone696969669169, forced_overmap_zone69916969269)
		y = rand(forced_overmap_zone696969669169, forced_overmap_zone69926969269)
	else
		x = rand(OVERMAP_ED69E, 69LOB.maps_data.overmap_size)
		y = rand(OVERMAP_ED69E, 69LOB.maps_data.overmap_size)
	place_overmap(min(x, 69LOB.maps_data.overmap_size - OVERMAP_ED69E),69in(y, 69LOB.maps_data.overmap_size - OVERMAP_ED69E))

	SStrade.all_stations += src
	if(start_discovered)
		SStrade.discovered_stations += src

/datum/trade_station/proc/AssembleAssortiment()
	for(var/list/cate69ory_name in assortiment)
		if(cate69ory_name?.len >= 2) // ?. len and69ot checkin69 islist() cuz only lists have69ar/len and ?. check it's isnull
			var/new_cate69ory_name
			if(cate69ory_name.Find("name"))
				new_cate69ory_name = cate69ory_name69"name6969
			else
				continue
			var/list/content
			var/list/cate69ory_content_ta69 = (cate69ory_name.Find("ta69s") ? cate69ory_name69"ta69s6969 :69ull)
			if(islist(assortiment69cate69ory_nam6969))
				content = assortiment69cate69ory_nam6969
			else
				content = list()
			content.Add(SSspawn_data.valid_candidates(cate69ory_content_ta69,,TRUE))

			if(istext(new_cate69ory_name) && islist(content))
				var/cate69ory_name_index = assortiment.Find(cate69ory_name)
				assortiment.Cut(cate69ory_name_index, cate69ory_name_index + 1)
				assortiment.Insert(cate69ory_name_index,69ew_cate69ory_name)
				assortiment69new_cate69ory_nam6969 = content

/datum/trade_station/proc/update_tick()
	offer_tick()
	if(initialized)		// So the station doesn't 69et paid or restock at roundstart
		69oods_tick()
	else
		initialized = TRUE
	update_time = rand(15,25)69INUTES
	addtimer(CALLBACK(src, .proc/update_tick), update_time, TIMER_STOPPABLE)
	update_timer_start = world.time

// Old 69oods_tick().69ow, 69ood amounts are randomly chosen once at round start.
/datum/trade_station/proc/init_69oods()
	for(var/cate69ory_name in assortiment)
		var/list/cate69ory = assortiment69cate69ory_nam6969
		if(islist(cate69ory))
			for(var/69ood_path in cate69ory)
				var/cost = SStrade.69et_import_cost(69ood_path, src)
				var/list/rand_ar69s = list(0, 50 /69ax(cost/200, 1))
				var/list/69ood_packet = cate69ory6969ood_pat6969
				if(islist(69ood_packet))
					if(islist(69ood_packet69"amount_ran69e6969))
						rand_ar69s = 69ood_packet69"amount_ran69e6969
				if(!islist(amounts_of_69oods))
					amounts_of_69oods = list()
				if(!islist(amounts_of_69oods69cate69ory_nam6969))
					amounts_of_69oods69cate69ory_nam6969 = list()
				var/69ood_amount = amounts_of_69oods69cate69ory_nam6969
				69ood_amount69"69cate69ory.Find(69ood_pat69)69"69 =69ax(0, rand(rand_ar69s699169, rand_ar696969269))
				uni69ue_69ood_count += 1
	for(var/offer_path in offer_types)
		var/list/offer_content = offer_types69offer_pat6969
		if(ispath(offer_path) && islist(offer_content))
			var/offer_index = offer_types.Find(offer_path)
			special_offers.Insert(offer_index, offer_path)
			special_offers69offer_pat6969 = offer_content


// The station will restock based on base_income + wealth, then check to see if the secret inventory is unlocked.
/datum/trade_station/proc/69oods_tick()
	// 69et base income
	add_to_wealth(base_income)

	// Restock
	// TODO:69ake this actually random.
	// 		 Currently, items that are closer to the end of the list have a lower chance to restock because they can't restock if wealth 69oes to zero as a result of earlier items restockin69.
	var/startin69_balance = wealth								// For calculatin69 production bud69et
	var/bud69et = round(startin69_balance / uni69ue_69ood_count)	// Don't wanna blow the whole balance on one item
	for(var/cate69ory_name in assortiment)
		var/list/cate69ory = assortiment69cate69ory_nam6969
		if(islist(cate69ory))
			for(var/69ood_path in cate69ory)
				var/69ood_index = cate69ory.Find(69ood_path)
				var/69ood_amount = 69et_69ood_amount(cate69ory_name, 69ood_index)
				var/chance_to_restock = (69ood_amount < 5) ? 100 : (69ood_amount > 20) ? 0 : 15		// Always restock low 69uantity 69oods,69ever restock well-stocked 69oods
				var/roll = rand(1,100)
				if(roll <= chance_to_restock)
					var/cost =69ax(1, round(SStrade.69et_import_cost(69ood_path, src) / 2))			// Cost of production is lower than sale price. Otherwise, it wouldn't69ake sense for the station to operate.
					var/amount_to_add = rand(1, round(bud69et / cost))
					if(cost * amount_to_add < wealth)												// This69eans the cost of the items can 69o over bud69et, but that69i69ht be alri69ht for69ow.
						set_69ood_amount(cate69ory_name, 69ood_index, 69ood_amount + amount_to_add)
						subtract_from_wealth(amount_to_add * cost)

	// Compare total score and unlock thresholds
	if(secret_inv_unlocked)
		return
	if(total_value_received >= secret_inv_threshold)
		secret_inv_unlocked = TRUE
		for(var/cate69ory_name in secret_inventory)
			var/list/cate69ory = secret_inventory69cate69ory_nam6969
			if(istext(cate69ory_name) && islist(cate69ory))
				var/cate69ory_name_index = secret_inventory.Find(cate69ory_name)
				secret_inventory.Cut(cate69ory_name_index, cate69ory_name_index + 1)
				assortiment.Add(cate69ory_name)
				assortiment69cate69ory_nam6969 = cate69ory
				for(var/69ood_path in cate69ory)
					var/cost = SStrade.69et_import_cost(69ood_path, src)
					var/list/rand_ar69s = list(0, 50 /69ax(cost/200, 1))
					var/list/69ood_packet = cate69ory6969ood_pat6969
					if(islist(69ood_packet))
						if(islist(69ood_packet69"amount_ran69e6969))
							rand_ar69s = 69ood_packet69"amount_ran69e6969
					if(!islist(amounts_of_69oods))
						amounts_of_69oods = list()
					if(!islist(amounts_of_69oods69cate69ory_nam6969))
						amounts_of_69oods69cate69ory_nam6969 = list()
					var/69ood_amount = amounts_of_69oods69cate69ory_nam6969
					69ood_amount69"69cate69ory.Find(69ood_pat69)69"69 =69ax(0, rand(rand_ar69s699169, rand_ar696969269))

/datum/trade_station/proc/69et_69ood_amount(cat, index)
	. = 0
	if(isnum(cat))
		cat = assortiment69ca6969
	if(istext(cat) && text2num(index))
		if(islist(amounts_of_69oods))
			var/list/L = amounts_of_69oods69ca6969
			if(islist(L))
				. = L69L69ind69696969

/datum/trade_station/proc/set_69ood_amount(cat, index,69alue)
	if(isnum(cat))
		cat = assortiment69ca6969
	if(istext(cat) && text2num(index))
		if(islist(amounts_of_69oods))
			var/list/L = amounts_of_69oods69ca6969
			if(islist(L))
				L69L69ind69696969 =69alue

/datum/trade_station/proc/add_to_wealth(var/income)
	if(!isnum(income))
		return
	wealth += income
	total_value_received += income

/datum/trade_station/proc/subtract_from_wealth(var/cost)
	if(!isnum(cost))
		return
	wealth -= cost

// Part of the69ew69ethod of directly restockin69 69oods. Does69ot add to total_value_received.
datum/trade_station/proc/add_to_stock(atom/movable/AM)
	var/path_found = FALSE
	for(var/cate69ory_name in assortiment)
		if(path_found)
			break
		var/list/cate69ory = assortiment69cate69ory_nam6969
		if(islist(cate69ory))
			for(var/69ood_path in cate69ory)
				if(ispath(69ood_path, AM.type))
					if(typesof(69ood_path).len == typesof(AM.type).len)
						var/amount_cat = amounts_of_69oods69cate69ory_nam6969
						amount_cat69"69cate69ory.Find(69ood_pat69)69"69 += 1
						path_found = TRUE
						break


/datum/trade_station/proc/cost_trade_stations_bud69et(bud69et = spawn_cost)
	if(!spawn_always)
		SStrade.trade_stations_bud69et -= bud69et

/datum/trade_station/proc/re69ain_trade_stations_bud69et(bud69et = spawn_cost)
	if(!spawn_always)
		SStrade.trade_stations_bud69et += bud69et

/datum/trade_station/Destroy()
	SStrade.all_stations -= src
	SStrade.discovered_stations -= src
	69del(overmap_location)
	return ..()

/datum/trade_station/proc/place_overmap(x, y, z = 69LOB.maps_data.overmap_z)
	overmap_location = locate(x, y, z)

	overmap_object =69ew(overmap_location)
	overmap_object.opacity = overmap_opacity
	overmap_object.dir = pick(rand(1,2), 4, 8)

	overmap_object.name_sta69es = list(name, "unknown station", "unknown spatial phenomenon")
	overmap_object.icon_sta69es = list(pick(icon_states), "station", "poi")

	if(!start_discovered)
		69LOB.entered_event.re69ister(overmap_location, src, .proc/discovered)

/datum/trade_station/proc/discovered(_, obj/effect/overmap/ship/ship)
	if(!istype(ship) || !ship.base)
		return

	SStrade.discovered_stations |= src
	69LOB.entered_event.unre69ister(overmap_location, src, .proc/discovered)

/datum/trade_station/proc/69enerate_offer()
	if(!len69th(offer_types))
		return
	for(var/offer_type in offer_types)
		var/list/offer_content = offer_types69offer_typ6969
		var/name = "ERROR:69o69ame found"	// Shouldn't see these anyway
		var/base_price = 1					//
		var/amount_cap = 0					//
		if(offer_content?.len >= 3)
			name = offer_content69"name6969
			base_price = text2num(offer_content69"price6969)
			amount_cap = text2num(offer_content69"amount6969)
		else
			continue

		var/min_amt = round(SPECIAL_OFFER_MIN_PRICE /69ax(1, base_price))
		var/max_amt = round(SPECIAL_OFFER_MAX_PRICE / (max(1, base_price)))

		if(min_amt < 1)
			min_amt = 1

		if(amount_cap > 0)
			if(max_amt > amount_cap)
				max_amt = amount_cap
		else if(offer_limit > 0)
			if(max_amt > offer_limit)
				max_amt = offer_limit

		var/new_amt = rand(min_amt,69ax_amt)

		var/min_price = clamp(new_amt *69ax(1, base_price), SPECIAL_OFFER_MIN_PRICE, SPECIAL_OFFER_MAX_PRICE)
		var/max_price = clamp(new_amt *69ax(1, base_price),69in_price, SPECIAL_OFFER_MAX_PRICE)
		var/new_price = rand(min_price,69ax_price)

		offer_content = offer_data(name,69ew_price,69ew_amt)
		special_offers69offer_typ6969 = offer_content

/datum/trade_station/proc/offer_tick()
	69enerate_offer()
