/datum/trade_station/McRonalds
	name_pool = list(
		"McTB \'Dionis\'" = "\'McRonalds\' Trade Beacon \'Dionis\'. You hope they still have Happy Meals with a toy."
	)
	icon_states = list("htu_station", "station")
	uid = "mcronalds"
	tree_x = 0.46
	tree_y = 0.7
	start_discovered = FALSE
	spawn_always = TRUE
	markup = COMMON_GOODS
	offer_limit = 10
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list()
	recommendations_needed = 1
	inventory = list(
		"Burgers" = list(
			/obj/item/reagent_containers/food/snacks/bigbiteburger = good_data("Big RBurger", list(1, 3), 250),
			/obj/item/reagent_containers/food/snacks/jellyburger/cherry = good_data("JellyCherry RBurger", list(1, 3), 200),
			/obj/item/reagent_containers/food/snacks/tofuburger = good_data("Tofu RBurger", list(1, 3), 200)
		),
		"Pizza" = list(
			/obj/item/pizzabox/meat = good_data("Supreme Meatlover: Pizza Alliance", list(1, 3), 400),
			/obj/item/pizzabox/mushroom = good_data("Mushrooms' Impact 3rd", list(1, 3), 400),
			/obj/item/pizzabox/vegetable = good_data("Pizza Fantasy 7: Vegeterian Deluxe Edition", list(1, 3), 400),
			/obj/item/pizzabox/margherita = good_data("PizzeR: autoTomato", list(1, 3), 400)
		),
		"Cakes" = list(
			/obj/item/reagent_containers/food/snacks/sliceable/plaincake = good_data("Vanilla", list(1, 3), 300),
			/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake = good_data("Chocola", list(1, 3), 300),
			/obj/item/reagent_containers/food/snacks/sliceable/carrotcake = good_data("carrot cake", list(1, 3), 300),
			/obj/item/reagent_containers/food/snacks/sliceable/cheesecake = good_data("cheese cake", list(1, 3), 300),
			/obj/item/reagent_containers/food/snacks/sliceable/orangecake = good_data("orange cake", list(1, 3), 300),
			/obj/item/reagent_containers/food/snacks/sliceable/limecake = good_data("lime cake", list(1, 3), 300),
			/obj/item/reagent_containers/food/snacks/sliceable/lemoncake = good_data("lemon cake", list(1, 3), 300)
		),
		"Misc" = list(
			/obj/item/reagent_containers/food/snacks/fishandchips = custom_good_name("Fishps"),
			/obj/item/storage/box/happy_meal = good_data("McRonalds' Robust Meal", list(3, 5), 500)
		)
	)
	hidden_inventory = list(
	)
	offer_types = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat = offer_data("roach meat", 300, 0),
		/obj/item/reagent_containers/food/snacks/meat/spider = offer_data("spider meat", 300, 0)
	)
