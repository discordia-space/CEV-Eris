#define good_data(nam, randList) list("name" = nam, "amount_range" = randList)
#define custom_good_name(nam) good_data(nam, null)
#define custom_good_amount_range(randList) good_data(null, randList)

#define offer_data(name, price, amount) list("name" = name, "price" = price, "amount" = amount)

#define category_data(nam, listOfTags) list("name" = nam, "tags" = listOfTags)

#define COMMON_GOODS 1.2
#define UNCOMMON_GOODS 2.4
#define RARE_GOODS 3.6
#define UNIQUE_GOODS 4.8

/datum/trade_station
	var/name
	var/desc
	var/list/icon_states = "htu_station"
	var/initialized = FALSE
	var/uid 						// Needed for unlocking via recommendations since names are selected from a pool

	var/update_time = 0				// For displaying the time remaining on the UI
	var/update_timer_start = 0		//

	var/spawn_always = FALSE
	var/spawn_probability = 60		// This is actually treated as a weight variable. The number isn't the actual probability that the station will spawn.
	var/spawn_cost = 1
	var/start_discovered = FALSE
	var/commision = 200 			// Cost of trading more than one thing or cost for crate

	var/list/forced_overmap_zone 	// list(list(minx, maxx), list(miny, maxy))
	var/overmap_opacity = 0

	var/list/name_pool = list()

	var/markup = COMMON_GOODS
	var/markdown = 0.6				// Default markdown is 60%
	var/list/assortiment = list()
	var/list/offer_types = list()	// Defines special offers
	var/list/offer_limit = 20		// For limiting sell offer quantity. 0 is no cap. Offer_data has its own cap, but this may still be useful.

	var/list/amounts_of_goods = list()
	var/unique_good_count = 0
	var/list/special_offers = list()	// The special offer created using the data in offer_types()

	var/base_income = 1600				// Lets stations restock without player interaction.
	var/wealth = 0						// The abstract value of the goods sold to the station via offers + base income. Represents the station's ability to produce or purchase goods.

	var/favor = 0							// For keeping track of how much wealth a station has handled. Triggers events when certain thresholds are reached.
	var/secret_inv_threshold = 2000			// Favor required to unlock secret inventory
	var/secret_inv_unlocked = FALSE
	var/list/secret_inventory = list()
	var/recommendation_threshold = 4000	// Favor required to unlock recommendation
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
		crash_with("Some retard gived trade station a name before init_src, overriding name_pool. ([type])")
	for(var/datum/trade_station/S in SStrade.all_stations)
		name_pool.Remove(S.name)
		if(!length(name_pool))
			warning("Trade station name pool exhausted: [type]")
			name_pool = S.name_pool
			break
	name = pick(name_pool)
	desc = name_pool[name]

	AssembleAssortiment()
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

/datum/trade_station/proc/AssembleAssortiment()
	for(var/list/category_name in assortiment)
		if(category_name?.len >= 2) // ?. len and not checking islist() cuz only lists have var/len and ?. check it's isnull
			var/new_category_name
			if(category_name.Find("name"))
				new_category_name = category_name["name"]
			else
				continue
			var/list/content
			var/list/category_content_tag = (category_name.Find("tags") ? category_name["tags"] : null)
			if(islist(assortiment[category_name]))
				content = assortiment[category_name]
			else
				content = list()
			content.Add(SSspawn_data.valid_candidates(category_content_tag,,TRUE))

			if(istext(new_category_name) && islist(content))
				var/category_name_index = assortiment.Find(category_name)
				assortiment.Cut(category_name_index, category_name_index + 1)
				assortiment.Insert(category_name_index, new_category_name)
				assortiment[new_category_name] = content

/datum/trade_station/proc/update_tick()
	offer_tick()
	if(initialized)		// So the station doesn't get paid or restock at roundstart
		goods_tick()
	else
		initialized = TRUE
	update_time = rand(15,25) MINUTES
	addtimer(CALLBACK(src, .proc/update_tick), update_time, TIMER_STOPPABLE)
	update_timer_start = world.time

// Old goods_tick(). Now, good amounts are randomly chosen once at round start.
/datum/trade_station/proc/init_goods()
	for(var/category_name in assortiment)
		var/list/category = assortiment[category_name]
		if(islist(category))
			for(var/good_path in category)
				var/cost = SStrade.get_import_cost(good_path, src)
				var/list/rand_args = list(0, 50 / max(cost/200, 1))
				var/list/good_packet = category[good_path]
				if(islist(good_packet))
					if(islist(good_packet["amount_range"]))
						rand_args = good_packet["amount_range"]
				if(!islist(amounts_of_goods))
					amounts_of_goods = list()
				if(!islist(amounts_of_goods[category_name]))
					amounts_of_goods[category_name] = list()
				var/good_amount = amounts_of_goods[category_name]
				good_amount["[category.Find(good_path)]"] = max(0, rand(rand_args[1], rand_args[2]))
				unique_good_count += 1
	for(var/offer_path in offer_types)
		var/list/offer_content = offer_types[offer_path]
		if(ispath(offer_path) && islist(offer_content))
			var/offer_index = offer_types.Find(offer_path)
			special_offers.Insert(offer_index, offer_path)
			special_offers[offer_path] = offer_content

// The station will restock based on base_income + wealth, then check to see if the secret inventory is unlocked.
/datum/trade_station/proc/goods_tick()
	// Get base income
	wealth += base_income		// Shouldn't contribute towards unlocks

	// Restock
	// TODO: Make this actually random.
	// 		 Currently, items that are closer to the end of the list have a lower chance to restock because they can't restock if wealth goes to zero as a result of earlier items restocking.
	var/starting_balance = wealth								// For calculating production budget
	var/budget = round(starting_balance / unique_good_count)	// Don't wanna blow the whole balance on one item
	for(var/category_name in assortiment)
		var/list/category = assortiment[category_name]
		if(islist(category))
			for(var/good_path in category)
				var/good_index = category.Find(good_path)
				var/good_amount = get_good_amount(category_name, good_index)
				var/chance_to_restock = (good_amount < 5) ? 100 : (good_amount > 20) ? 0 : 15		// Always restock low quantity goods, never restock well-stocked goods
				var/roll = rand(1,100)
				if(roll <= chance_to_restock)
					var/cost = max(1, round(SStrade.get_import_cost(good_path, src) / 2))			// Cost of production is lower than sale price. Otherwise, it wouldn't make sense for the station to operate.
					var/amount_to_add = rand(1, round(budget / cost))
					if(cost * amount_to_add < wealth)												// This means the cost of the items can go over budget, but that might be alright for now.
						set_good_amount(category_name, good_index, good_amount + amount_to_add)
						subtract_from_wealth(amount_to_add * cost)

	// Compare total score and unlock thresholds
	if(!secret_inv_unlocked)
		try_unlock_secret_inv()

	if(!recommendation_unlocked)
		try_recommendation()
	
/datum/trade_station/proc/try_unlock_secret_inv()
	if(favor >= secret_inv_threshold)
		secret_inv_unlocked = TRUE
		for(var/category_name in secret_inventory)
			var/list/category = secret_inventory[category_name]
			if(istext(category_name) && islist(category))
				var/category_name_index = secret_inventory.Find(category_name)
				secret_inventory.Cut(category_name_index, category_name_index + 1)
				assortiment.Add(category_name)
				assortiment[category_name] = category
				for(var/good_path in category)
					var/cost = SStrade.get_import_cost(good_path, src)
					var/list/rand_args = list(0, 50 / max(cost/200, 1))
					var/list/good_packet = category[good_path]
					if(islist(good_packet))
						if(islist(good_packet["amount_range"]))
							rand_args = good_packet["amount_range"]
					if(!islist(amounts_of_goods))
						amounts_of_goods = list()
					if(!islist(amounts_of_goods[category_name]))
						amounts_of_goods[category_name] = list()
					var/good_amount = amounts_of_goods[category_name]
					good_amount["[category.Find(good_path)]"] = max(0, rand(rand_args[1], rand_args[2]))

/datum/trade_station/proc/try_recommendation()
	if(favor >= recommendation_threshold)
		recommendation_unlocked = TRUE
		SStrade.discover_by_uid(stations_recommended)

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

/datum/trade_station/proc/add_to_wealth(var/income, is_offer = FALSE)
	if(!isnum(income))
		return
	wealth += income
	favor += income * (is_offer ? 1 : 0.5)

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
	overmap_object.icon_stages = list(pick(icon_states), "station", "poi")

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
