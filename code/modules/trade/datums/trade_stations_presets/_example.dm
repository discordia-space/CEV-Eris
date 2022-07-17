/datum/trade_station/example
	name_pool = list(				// Names in the pool are selected randomly on initialization
		"Name" = "Description",
		"T3-ST" = "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
	)
	icon_states = "htu_station"		// Overmap icon
	forced_overmap_zone = list()	// For forcing the station into a specific zone. Format: list(list(minx, maxx), list(miny, maxy))

	spawn_always = FALSE			// Should this station always spawn? (does not affect whether the station is available at round start or not)
	spawn_probability = 60			// This is actually treated as a weight variable. The number isn't the actual probability that the station will spawn.
	spawn_cost = 1					// How many points this station takes up in the budget (spawn_always = TRUE means it won't use any budget)
	start_discovered = FALSE		// Should the station start discovered? (players are able to trade with discovered stations)

	commision = 200 				// Cost of trading more than one thing or cost for crate

	markup = COMMON_GOODS			// Multiplier for the price of goods sold by the station. See _trade_station.dm for standard markups.
	markdown = 0.6					// Multiplier for the price of goods bought by the station (does not affect special offers)

	base_income = 1600				// Stations can replenish some stock without player interaction. Adds to value so stations will unlock hidden inventory after some time.
	wealth = 5000					// The abstract value of the goods sold to the station via offers + base income. Represents the station's ability to produce or purchase goods.

	favor = 0									// For keeping track of how much favor we have with a given station. Triggers events when certain thresholds are reached. Should always start at 0.
	hidden_inv_threshold = 2000					// Favor required to unlock secret inventory
	recommendation_threshold = 4000				// Favor required to unlock next station(s) in the tree
	stations_recommended = list("station_uid")	// List of stations unlocked when the recommendation threshold is reached
	recommendations_needed = 1					// How many stations need to recommend this one before unlocking

	// Types of items sold by the station
	// Notes: Duplicate items in the same category will cause runtimes
	//		  Items without a price_tag variable are priced at 100 before markup/markdown
	//		  /obj/... is the only type supported
	inventory = list(
		"Category Name"  = list(
			/obj/item/cell/large = custom_good_name("Item name"),
			/obj/item/cell/medium = custom_good_amount_range(list(0,3)),
			/obj/item/cell/small = good_data("small cell", list(6, 20), null)
		),
		"Next category" = list(
			/obj/spawner/scrap/dense = good_data("random trash pile", list(5,10))
		)
	)

	// Hidden types of items sold by the station. Unlocked when the threshold is reached.
	// This follows the same rules as inventorys and gets appended to the inventory list when the secret inv threshold is reached
	hidden_inventory = list(
		"Category Name II" = list(
			/obj/item/organ/internal/kidney = good_data("kidney", list(1,3))
		)
	)

	// Types of items bought buy the station via special offers.
	/*
	At the time of writing (31 Jan 2022), offers must come with the offer_data(name, price, max amount) packet as shown below.

	/obj/... and /datum/reagent/... are the only types supported.
	
	Reagents are requested 60u per unit shown. The container type does not matter, but you cannot use a single container to fulfill an offer for two or more.
	For example, an offer for 3 inaprovaline bottles cannot be fulfilled with a mixing bowl containing 180u inaprovaline. It must be 3 separate containers.
	Any excess in those containers will be consumed with the 60u asked for and will not count.
	*/
	offer_types = list(
		/obj/item/computer_hardware/hard_drive/cluster = offer_data("name", 100, 5),
		/datum/reagent/medicine/inaprovaline = offer_data("inaprovaline bottle (60u)", 150, 3)
	)
