/datum/trade_station/McRonalds
	name_pool = list("CTB 'Dionis'" = "Corporate Trade Beacon of food chain 'McRonalds'. You hope they still have Happy Meals with toy.")
	assortiment = list(
		"Burgers" = list(
			/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger = custom_good_name("Big RBurger"),
			/obj/item/weapon/reagent_containers/food/snacks/jellyburger/cherry = custom_good_name("JellyCherry RBurger"),
			/obj/item/weapon/reagent_containers/food/snacks/tofuburger = custom_good_name("Vegeterian RBurger")
		),
		"Pizza" = list(
			/obj/item/pizzabox/meat = custom_good_name("Supreme Meatlover: Pizza Alliance"),
			/obj/item/pizzabox/mushroom = custom_good_name("Mushrooms' Impact 3rd"),
			/obj/item/pizzabox/vegetable = custom_good_name("Pizza Fantasy 7: Vegeterian Deluxe Edition"),
			/obj/item/pizzabox/margherita = custom_good_name("PizzeR: autoTomato")
		),
		"Cakes" = list(
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake = custom_good_name("Vanilla"),
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake = custom_good_name("Chocola"),
			
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake,
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake,
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/orangecake,
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/limecake,
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/lemoncake,	
		),
		"Misc" = list(
			/obj/item/weapon/reagent_containers/food/snacks/fishandchips = custom_good_name("Fishps"),
			/obj/item/weapon/storage/box/happy_meal,
		),
	)
	offer_types = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat/corgi,
		/obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat,
		/obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat/seuche,
		/obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat/kraftwerk,
		/obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat/jager,
	)
