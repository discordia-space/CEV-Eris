/datum/trade_station/boozefood
	name_pool = list(
		"ATB \'Vermouth\'" = "Aster's Trade Beacon \'Vermouth\': \"Best beverages, ingredients for your cooks, and anything that is needed for your private bars and more!\""
	)
	icon_states = list("htu_station", "station")
	uid = "commissary"
	tree_x = 0.5
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("mcronalds", "serbian", "trapper")
	inventory = list(
		"Basic Ingredients" = list(
			/obj/item/reagent_containers/food/condiment/flour = custom_good_price(50),
			/obj/item/reagent_containers/food/drinks/milk = custom_good_price(50),
			/obj/item/storage/fancy/egg_box = custom_good_price(100),
			/obj/item/reagent_containers/food/snacks/tofu = custom_good_price(50),
			/obj/item/reagent_containers/food/snacks/meat = custom_good_price(100),
			/obj/item/reagent_containers/food/condiment/enzyme = custom_good_price(80)
		),
		"Drinks" = list(
			/obj/item/reagent_containers/food/drinks/bottle/gin = custom_good_price(100), 
			/obj/item/reagent_containers/food/drinks/bottle/whiskey = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/tequilla = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/vodka = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/vermouth = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/rum = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/wine = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/cognac = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/kahlua = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/small/beer = custom_good_price(50),
			/obj/item/reagent_containers/food/drinks/bottle/small/ale = custom_good_price(50),
			/obj/item/reagent_containers/food/drinks/bottle/orangejuice,
			/obj/item/reagent_containers/food/drinks/bottle/tomatojuice,
			/obj/item/reagent_containers/food/drinks/bottle/limejuice,
			/obj/item/reagent_containers/food/drinks/bottle/cream,
			/obj/item/reagent_containers/food/drinks/bottle/cola,
			/obj/item/reagent_containers/food/drinks/bottle/space_up,
			/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind,
			/obj/item/reagent_containers/food/drinks/bottle/bluecuracao = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/grenadine,
			/obj/item/reagent_containers/food/drinks/bottle/melonliquor = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/absinthe = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/cans/dr_gibb = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/cans/sodawater,
			/obj/item/reagent_containers/food/drinks/cans/tonic
		),
		"Commissary Supplies" = list(
			/obj/item/reagent_containers/food/drinks/drinkingglass,
			/obj/item/reagent_containers/food/drinks/teapot,
			/obj/item/reagent_containers/food/drinks/pitcher,
			/obj/item/reagent_containers/food/drinks/carafe,
			/obj/item/reagent_containers/food/drinks/flask/barflask,
			/obj/item/reagent_containers/food/drinks/flask/vacuumflask,
			/obj/item/storage/deferred/kitchen = custom_good_price(50)
		)
	)
	hidden_inventory = list(
		"Drinks II" = list(
			/obj/item/reagent_containers/food/drinks/bottle/goldschlager = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/pwine = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing = custom_good_price(100)
		)
	)
	offer_types = list(
		/obj/item/reagent_containers/food/snacks/kampferburger = offer_data("kampfer burger", 500, 3),
		/obj/item/reagent_containers/food/snacks/panzerburger = offer_data("panzer burger", 700, 2),
		/obj/item/reagent_containers/food/snacks/jagerburger = offer_data("jager burger", 700, 2),
		/obj/item/reagent_containers/food/snacks/seucheburger = offer_data("seuche burger", 700, 2),
		/obj/item/reagent_containers/food/snacks/bigroachburger = offer_data("big roach burger", 2000, 2),
		/obj/item/reagent_containers/food/snacks/fuhrerburger = offer_data("fuhrer burger", 2000, 2),
		/datum/reagent/alcohol/changelingsting = offer_data("Changeling Sting bottle (60u)", 1500, 1),
		/datum/reagent/alcohol/longislandicedtea = offer_data("Long Island Iced Tea bottle (60u)", 1500, 1)		// Lemon juice bottle may need to be added to the game
	)
