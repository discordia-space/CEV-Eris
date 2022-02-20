/datum/trade_station/McRonalds
	name_pool = list(
		"McTB 'Dionis'" = "'McRonalds' Trade Beacon 'Dionis'. You hope they still have Happy Meals with a toy."
	)
	uid = "mcronalds"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = COMMON_GOODS
	offer_limit = 10
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("trapper")
	recommendations_needed = 1
	inventory = list(
		"Burgers" = list(
			/obj/item/reagent_containers/food/snacks/bigbiteburger = custom_good_name("Big RBurger"),
			/obj/item/reagent_containers/food/snacks/jellyburger/cherry = custom_good_name("JellyCherry RBurger"),
			/obj/item/reagent_containers/food/snacks/tofuburger = custom_good_name("Tofu RBurger")
		),
		"Pizza" = list(
			/obj/item/pizzabox/meat = good_data("Supreme Meatlover: Pizza Alliance", list(1, 3)),
			/obj/item/pizzabox/mushroom = good_data("Mushrooms' Impact 3rd", list(1, 3)),
			/obj/item/pizzabox/vegetable = good_data("Pizza Fantasy 7: Vegeterian Deluxe Edition", list(1, 3)),
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
			/obj/item/storage/box/happy_meal
		)
	)
	hidden_inventory = list(
		"Secret Menu" = list(
			/obj/item/storage/box/monkeycubes = good_data("Chicken Nuggets", list(1, 5))
			// TODO: Needs funny and useful stuff
		)
	)
	offer_types = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat = offer_data("roach meat", 300, 0),
		/obj/item/reagent_containers/food/snacks/meat/spider = offer_data("spider meat", 300, 0)
	)
