/datum/trade_station/McRonalds
	name_pool = list(
		"CTB 'Dionis'" = "Corporate Trade Beacon of food chain 'McRonalds'. You hope they still have Happy69eals with a toy."
	)
	spawn_always = TRUE
	markup = UNCOMMON_GOODS
	offer_limit = 30
	assortiment = list(
		"Burgers" = list(
			/obj/item/reagent_containers/food/snacks/bigbiteburger = custom_good_name("Big RBurger"),
			/obj/item/reagent_containers/food/snacks/jellyburger/cherry = custom_good_name("JellyCherry RBurger"),
			/obj/item/reagent_containers/food/snacks/tofuburger = custom_good_name("Tofu RBurger")
		),
		"Pizza" = list(
			/obj/item/pizzabox/meat = good_data("Supreme69eatlover: Pizza Alliance", list(1, 3)),
			/obj/item/pizzabox/mushroom = good_data("Mushrooms' Impact 3rd", list(1, 3)),
			/obj/item/pizzabox/vegetable = good_data("Pizza Fantasy 7:69egeterian Deluxe Edition", list(1, 3)),
			/obj/item/pizzabox/margherita = good_data("PizzeR: autoTomato", list(1, 3))
		),
		"Cakes" = list(
			/obj/item/reagent_containers/food/snacks/sliceable/plaincake = good_data("Vanilla", list(1, 3)),
			/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake = good_data("Chocola", list(1, 3)),
			/obj/item/reagent_containers/food/snacks/sliceable/carrotcake = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/food/snacks/sliceable/cheesecake = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/food/snacks/sliceable/orangecake = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/food/snacks/sliceable/limecake = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/food/snacks/sliceable/lemoncake = custom_good_amount_range(list(1, 3)),
		),
		"Misc" = list(
			/obj/item/reagent_containers/food/snacks/fishandchips = custom_good_name("Fishps"),
			/obj/item/storage/box/happy_meal,
		),
	)
	secret_inventory = list(
		"Secret69enu" = list(
			/obj/item/storage/box/monkeycubes = good_data("Chicken69uggets", list(1, 5))
			//69eeds funny and useful things
		)
	)
	offer_types = list(
//		/obj/item/reagent_containers/food/snacks/meat = offer_data("meat", 100, 10),
		/obj/item/reagent_containers/food/snacks/meat/corgi = offer_data("corgi69eat", 1000, 2),
		/obj/item/reagent_containers/food/snacks/meat/roachmeat = offer_data("roach69eat", 300, 0),
//		/obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche,
//		/obj/item/reagent_containers/food/snacks/meat/roachmeat/kraftwerk,
//		/obj/item/reagent_containers/food/snacks/meat/roachmeat/jager,
	)
