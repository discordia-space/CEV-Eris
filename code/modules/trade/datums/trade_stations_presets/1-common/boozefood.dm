/datum/trade_station/boozefood
	name_pool = list(
		"ATB 'Vermouth'" = "Aster's Trade Beacon 'Vermouth':\nBest Drinks! Best Beverages! Ingredients for your cooks! Anything that is needed for your private bars and more!"
	)
	uid = "commissary"
	start_discovered = TRUE
	spawn_always = TRUE
	markup = COMMON_GOODS
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("mcronalds", "serbian")
	assortiment = list(
		"Basic Ingredients" = list(
			/obj/item/reagent_containers/food/condiment/flour,
			/obj/item/reagent_containers/food/drinks/milk,
			/obj/item/storage/fancy/egg_box,
			/obj/item/reagent_containers/food/snacks/tofu,
			/obj/item/reagent_containers/food/snacks/meat,
			/obj/item/reagent_containers/food/condiment/enzyme
		),
		"Drinks" = list(
			/obj/item/reagent_containers/food/drinks/bottle/gin,
			/obj/item/reagent_containers/food/drinks/bottle/whiskey,
			/obj/item/reagent_containers/food/drinks/bottle/tequilla,
			/obj/item/reagent_containers/food/drinks/bottle/vodka,
			/obj/item/reagent_containers/food/drinks/bottle/vermouth,
			/obj/item/reagent_containers/food/drinks/bottle/rum,
			/obj/item/reagent_containers/food/drinks/bottle/wine,
			/obj/item/reagent_containers/food/drinks/bottle/cognac,
			/obj/item/reagent_containers/food/drinks/bottle/kahlua,
			/obj/item/reagent_containers/food/drinks/bottle/small/beer,
			/obj/item/reagent_containers/food/drinks/bottle/small/ale,
			/obj/item/reagent_containers/food/drinks/bottle/orangejuice,
			/obj/item/reagent_containers/food/drinks/bottle/tomatojuice,
			/obj/item/reagent_containers/food/drinks/bottle/limejuice,
			/obj/item/reagent_containers/food/drinks/bottle/cream,
			/obj/item/reagent_containers/food/drinks/bottle/cola,
			/obj/item/reagent_containers/food/drinks/bottle/space_up,
			/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind,
			/obj/item/reagent_containers/food/drinks/bottle/bluecuracao,
			/obj/item/reagent_containers/food/drinks/bottle/grenadine,
			/obj/item/reagent_containers/food/drinks/bottle/melonliquor,
			/obj/item/reagent_containers/food/drinks/bottle/absinthe,
			/obj/item/reagent_containers/food/drinks/cans/dr_gibb,
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
			/obj/item/storage/deferred/kitchen
		)
	)
	secret_inventory = list(
		"Drinks II" = list(
			/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
			/obj/item/reagent_containers/food/drinks/bottle/pwine,
			/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
		)
	)
	offer_types = list(
		/obj/item/reagent_containers/food/snacks/kampferburger = offer_data("kampfer burger", 400, 3),
		/obj/item/reagent_containers/food/snacks/panzerburger = offer_data("panzer burger", 500, 2),
		/obj/item/reagent_containers/food/snacks/jagerburger = offer_data("jager burger", 500, 2),
		/obj/item/reagent_containers/food/snacks/seucheburger = offer_data("seuche burger", 500, 2),
	)
