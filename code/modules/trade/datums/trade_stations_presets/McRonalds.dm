/datum/trade_station/McRonalds
	name_pool = list(
		"CTB 'Dionis'" = "Corporate Trade Beacon of food chain 'McRonalds'. You hope they still have Happy Meals with toy."
	)
	markup = UNCOMMON_GOODS
	offer_limit = 10
	assortiment = list(
		"Burgers" = list(
			/obj/item/reagent_containers/food/snacks/bigbiteburger = custom_good_name("Big RBurger"),
			/obj/item/reagent_containers/food/snacks/jellyburger/cherry = custom_good_name("JellyCherry RBurger"),
			/obj/item/reagent_containers/food/snacks/tofuburger = custom_good_name("Tofu RBurger")
		),
		"Pizza" = list(
			/obj/item/pizzabox/meat = custom_good_name("Supreme Meatlover: Pizza Alliance"),
			/obj/item/pizzabox/mushroom = custom_good_name("Mushrooms' Impact 3rd"),
			/obj/item/pizzabox/vegetable = custom_good_name("Pizza Fantasy 7: Vegeterian Deluxe Edition"),
			/obj/item/pizzabox/margherita = custom_good_name("PizzeR: autoTomato")
		),
		"Cakes" = list(
			/obj/item/reagent_containers/food/snacks/sliceable/plaincake = custom_good_name("Vanilla"),
			/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake = custom_good_name("Chocola"),
			
			/obj/item/reagent_containers/food/snacks/sliceable/carrotcake,
			/obj/item/reagent_containers/food/snacks/sliceable/cheesecake,
			/obj/item/reagent_containers/food/snacks/sliceable/orangecake,
			/obj/item/reagent_containers/food/snacks/sliceable/limecake,
			/obj/item/reagent_containers/food/snacks/sliceable/lemoncake,
		),
		"Misc" = list(
			/obj/item/reagent_containers/food/snacks/fishandchips = custom_good_name("Fishps"),
			/obj/item/storage/box/happy_meal,
		),
	)
	secret_inventory = list(
		"Secret Menu" = list(
			/obj/item/storage/box/monkeycubes = good_data("Chicken Nuggets", list(1, 5))
			// Needs funny and useful things
		)
	)
	offer_types = list(
//		/obj/item/reagent_containers/food/snacks/meat = offer_data("meat", 100, 10),
		/obj/item/reagent_containers/food/snacks/meat/corgi = offer_data("corgi meat", 400, 4),
		/obj/item/reagent_containers/food/snacks/meat/roachmeat = offer_data("roach meat", 300, 10),
//		/obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche,
//		/obj/item/reagent_containers/food/snacks/meat/roachmeat/kraftwerk,
//		/obj/item/reagent_containers/food/snacks/meat/roachmeat/jager,
	)
