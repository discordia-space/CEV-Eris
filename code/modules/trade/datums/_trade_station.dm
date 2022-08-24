#define good_data(nam, randList, price) list("name" = nam, "amount_range" = randList, "price" = price)
#define custom_good_name(nam) good_data(nam, null, null)
#define custom_good_amount_range(randList) good_data(null, randList, null)
#define custom_good_price(price) good_data(null, null, price)

#define offer_data(name, price, amount) list("name" = name, "price" = price, "amount" = amount)

#define category_data(nam, listOfTags) list("name" = nam, "tags" = listOfTags)

#define WHOLESALE_GOODS 1.2
#define COMMON_GOODS 1.5
#define UNCOMMON_GOODS 1.8
#define RARE_GOODS 2.0

/datum/trade_station
	var/name
	var/desc
	var/list/icon_states = list("htu_station", "station")
	var/initialized = FALSE
	var/uid 						// Needed for unlocking via recommendations since names are selected from a pool

	var/tree_x = 0.1				// Position on the trade tree map, 0 - left, 1 - right                 
	var/tree_y = 0.1				// 0 - down, 1 - top

	var/update_time = 0				// For displaying the time remaining on the UI
	var/update_timer_start = 0		//

	var/spawn_always = FALSE
	var/spawn_probability = 60		// This is actually treated as a weight variable. The number isn't the actual probability that the station will spawn.
	var/spawn_cost = 1
	var/start_discovered = FALSE

	var/list/forced_overmap_zone 	// list(list(minx, maxx), list(miny, maxy))
	var/overmap_opacity = 0

	var/list/name_pool = list()

	var/markup = WHOLESALE_GOODS

	var/list/inventory = list()
	var/list/offer_types = list()	// Defines offers
	var/list/offer_limit = 10		// For limiting offer quantity. 0 is no cap. Offer data packet can set a good specific cap that overrides this.

	var/list/amounts_of_goods = list()
	var/unique_good_count = 0
	var/list/special_offers = list()	// The offer created using the data in offer_types()

	var/base_income = 1600				// Lets stations restock without player interaction.
	var/wealth = 0						// The abstract value of the goods sold to the station via offers + base income. Represents the station's ability to produce or purchase goods.

	var/favor = 0							// For keeping track of how much wealth a station has handled with the players. Triggers events when certain thresholds are reached.
	var/hidden_inv_threshold = 2000			// Amount of favor required to unlock secret inventory
	var/hidden_inv_unlocked = FALSE
	var/list/hidden_inventory = list()
	var/recommendation_threshold = 4000		// Amount of favor required to unlock recommendation
	var/recommendation_unlocked = FALSE
	var/list/stations_recommended = list()	// Stations recommended by this station
	var/list/recommendations_needed = 0		// Station recommendations needed to unlock this station

	var/obj/effect/overmap_event/overmap_object
	var/turf/overmap_location

/datum/trade_station/New(init_on_new)
	. = ..()
	if(init_on_new)
		init_src()

/datum/trade_station/proc/init_src(var/turf/station_loc = null, var/force_discovered = FALSE)
	if(name)
		CRASH("Some retard gived trade station a name before init_src, overriding name_pool. ([type])")
	for(var/datum/trade_station/S in SStrade.all_stations)
		name_pool.Remove(S.name)
		if(!length(name_pool))
			warning("Trade station name pool exhausted: [type]")
			name_pool = S.name_pool
			break
	name = pick(name_pool)
	desc = name_pool[name]

	AssembleInventory()
	init_goods()

	update_tick()

	if(force_discovered)  // Force trading station to be already discovered when spawned
		start_discovered = TRUE

	var/x = 1
	var/y = 1
	if(station_loc)  // Spawn trading station at custom location
		x = station_loc.x
		y = station_loc.y
	else if(recursiveLen(forced_overmap_zone) == 6)
		x = rand(forced_overmap_zone[1][1], forced_overmap_zone[1][2])
		y = rand(forced_overmap_zone[2][1], forced_overmap_zone[2][2])
	else
		x = rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size)
		y = rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size)
	place_overmap(min(x, GLOB.maps_data.overmap_size - OVERMAP_EDGE), min(y, GLOB.maps_data.overmap_size - OVERMAP_EDGE))

	SStrade.all_stations += src
	if(start_discovered)
		SStrade.discovered_stations += src

/datum/trade_station/proc/AssembleInventory()
	for(var/list/category_name in inventory)
		if(category_name?.len >= 2) // ?. len and not checking islist() cuz only lists have var/len and ?. check it's isnull
			var/new_category_name
			if(category_name.Find("name"))
				new_category_name = category_name["name"]
			else
				continue
			var/list/content
			var/list/category_content_tag = (category_name.Find("tags") ? category_name["tags"] : null)
			if(islist(inventory[category_name]))
				content = inventory[category_name]
			else
				content = list()
			content.Add(SSspawn_data.valid_candidates(category_content_tag,,TRUE))

			if(istext(new_category_name) && islist(content))
				var/category_name_index = inventory.Find(category_name)
				inventory.Cut(category_name_index, category_name_index + 1)
				inventory.Insert(category_name_index, new_category_name)
				inventory[new_category_name] = content

/datum/trade_station/proc/init_goods()
	for(var/category_name in inventory)
		var/list/category = inventory[category_name]
		if(islist(category))
			for(var/good_path in category)
				var/cost = SStrade.get_import_cost(good_path, src)
				var/list/rand_args = list(1, 30 / max(cost/200, 1))
				var/list/good_packet = category[good_path]
				if(islist(good_packet))
					if(islist(good_packet["amount_range"]))
						rand_args = good_packet["amount_range"]
				if(!islist(amounts_of_goods[category_name]))
					amounts_of_goods[category_name] = list()
				var/content = amounts_of_goods[category_name]
				var/good_index = "[category.Find(good_path)]"
				var/good_quantity = max(0, rand(rand_args[1], rand_args[2]))
				content[good_index] = good_quantity
				unique_good_count += 1

	for(var/offer_path in offer_types)
		var/list/offer_content = offer_types[offer_path]
		if(ispath(offer_path) && islist(offer_content))
			var/offer_index = offer_types.Find(offer_path)
			special_offers.Insert(offer_index, offer_path)
			special_offers[offer_path] = offer_content
			SStrade.offer_types |= offer_path				// For blacklisting offer goods from exports

/datum/trade_station/proc/update_tick()
	offer_tick()
	if(initialized)		// So the station doesn't get paid or restock at roundstart
		goods_tick()
	else
		initialized = TRUE
	update_time = rand(8,12) MINUTES
	addtimer(CALLBACK(src, .proc/update_tick), update_time, TIMER_STOPPABLE)
	update_timer_start = world.time

// The station will restock based on base_income + wealth, then check unlockables.
/datum/trade_station/proc/goods_tick()
	// Add base income
	wealth += base_income		// Base income doesn't contribute to favor

	// Restock
	var/starting_balance = wealth								// For calculating production budget
	var/budget = round(starting_balance / unique_good_count)	// Don't wanna blow the whole balance on one item
	var/list/restock_candidates = list()

	for(var/category_name in inventory)
		var/list/category = inventory[category_name]
		for(var/good_path in category)
			var/good_index = category.Find(good_path)
			var/current_amount = get_good_amount(category_name, good_index)
			var/chance_to_restock = (current_amount < 5) ? 100 : (current_amount > 20) ? 0 : 15		// Always restock low quantity goods, never restock well-stocked goods
			var/roll = rand(1,100)
			if(roll <= chance_to_restock)
				var/cost = max(1, round(SStrade.get_import_cost(good_path, src) / 2))			// Cost of production is lower than sale price. Otherwise, it wouldn't make sense for the station to operate.
				var/amount_to_add = rand(1, round(budget / cost))
				var/list/content = list(
					"cat" = category_name,
					"index" = good_index,
					"cost" = cost,
					"to add" = amount_to_add,
					"current amt" = current_amount)
				var/restock_index = restock_candidates.len + 1
				restock_candidates.Insert(restock_index, restock_index)
				restock_candidates[restock_index] = content

	for(var/count in 1 to 20)
		if(!restock_candidates.len || !wealth)
			break

		var/list/good_packet = pick(restock_candidates)
		var/candidate_index = restock_candidates.Find(good_packet)
		var/total_cost = good_packet["cost"] * good_packet["to add"]
		restock_candidates.Cut(candidate_index, candidate_index + 1)

		if(total_cost < wealth)
			set_good_amount(good_packet["cat"], good_packet["index"], good_packet["to add"] + good_packet["current amt"])
			subtract_from_wealth(total_cost)

	// Compare total favor and unlock thresholds
	if(!hidden_inv_unlocked)
		try_unlock_hidden_inv()

	if(!recommendation_unlocked)
		try_recommendation()
	
/datum/trade_station/proc/try_unlock_hidden_inv()
	if(favor >= hidden_inv_threshold)
		hidden_inv_unlocked = TRUE
		for(var/category_name in hidden_inventory)
			var/list/category = hidden_inventory[category_name]
			if(istext(category_name) && islist(category))
				var/category_name_index = hidden_inventory.Find(category_name)
				hidden_inventory.Cut(category_name_index, category_name_index + 1)
				inventory.Add(category_name)
				inventory[category_name] = category
				for(var/good_path in category)
					var/cost = SStrade.get_import_cost(good_path, src)
					var/list/rand_args = list(1, 30 / max(cost/200, 1))
					var/list/good_packet = category[good_path]
					if(islist(good_packet))
						if(islist(good_packet["amount_range"]))
							rand_args = good_packet["amount_range"]
					if(!islist(amounts_of_goods[category_name]))
						amounts_of_goods[category_name] = list()
					var/content = amounts_of_goods[category_name]
					var/good_index = "[category.Find(good_path)]"
					var/good_quantity = max(0, rand(rand_args[1], rand_args[2]))
					content[good_index] = good_quantity
					unique_good_count += 1

/datum/trade_station/proc/try_recommendation()
	if(favor >= recommendation_threshold)
		recommendation_unlocked = TRUE
		SStrade.discover_by_uid(stations_recommended)

/datum/trade_station/proc/get_good_amount(cat, index)
	. = 0
	if(isnum(cat))
		cat = inventory[cat]
	if(istext(cat) && text2num(index))
		if(islist(amounts_of_goods))
			var/list/L = amounts_of_goods[cat]
			if(islist(L))
				. = L[L[index]]

/datum/trade_station/proc/set_good_amount(cat, index, value)
	if(isnum(cat))
		cat = inventory[cat]
	if(istext(cat) && text2num(index))
		if(islist(amounts_of_goods))
			var/list/L = amounts_of_goods[cat]
			if(islist(L))
				L[L[index]] = value

/datum/trade_station/proc/get_good_price(item_path)
	. = 0
	if(ispath(item_path))
		for(var/category_name in inventory)
			var/list/category = inventory[category_name]
			var/list/item_path_check = list(item_path)
			var/list/good_path = category & item_path_check
			if(good_path.len)
				if(islist(category[item_path]))
					var/list/good_packet = category[item_path]
					. += good_packet["price"]

/datum/trade_station/proc/add_to_wealth(var/income, is_offer = FALSE)
	if(!isnum(income))
		return
	wealth += income
	favor += income * (is_offer ? 1 : 0.25)

	// Unlocks without needing to wait for update tick
	if(!hidden_inv_unlocked)
		try_unlock_hidden_inv()

	if(!recommendation_unlocked)
		try_recommendation()

/datum/trade_station/proc/subtract_from_wealth(var/cost)
	if(!isnum(cost))
		return
	wealth -= cost

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
	overmap_object.opacity = overmap_opacity
	overmap_object.dir = pick(rand(1,2), 4, 8)

	overmap_object.name_stages = list(name, "unknown station", "unknown spatial phenomenon")
	overmap_object.icon_stages = list(icon_states[1], icon_states[2], "poi")

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
	for(var/offer_type in offer_types)
		var/list/offer_content = offer_types[offer_type]
		var/name = "ERROR: no name found"	// Shouldn't see these anyway
		var/base_price = 1					//
		var/amount_cap = 0					//
		if(offer_content?.len >= 3)
			name = offer_content["name"]
			base_price = text2num(offer_content["price"])
			amount_cap = text2num(offer_content["amount"])
		else
			continue

		var/min_amt = round(SPECIAL_OFFER_MIN_PRICE / max(1, base_price))
		var/max_amt = round(SPECIAL_OFFER_MAX_PRICE / (max(1, base_price)))

		if(min_amt < 1)
			min_amt = 1

		if(amount_cap > 0)
			if(max_amt > amount_cap)
				max_amt = amount_cap
		else if(offer_limit > 0)
			if(max_amt > offer_limit)
				max_amt = offer_limit

		var/new_amt = rand(min_amt, max_amt)

		var/min_price = clamp(new_amt * max(1, base_price), SPECIAL_OFFER_MIN_PRICE, SPECIAL_OFFER_MAX_PRICE)
		var/max_price = clamp(new_amt * max(1, base_price), min_price, SPECIAL_OFFER_MAX_PRICE)
		var/new_price = rand(min_price, max_price)

		offer_content = offer_data(name, new_price, new_amt)
		special_offers[offer_type] = offer_content

/datum/trade_station/proc/offer_tick()
	generate_offer()
