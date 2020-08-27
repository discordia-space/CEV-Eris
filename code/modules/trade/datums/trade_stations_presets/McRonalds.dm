/datum/trade_station/McRonalds
	name_pool = list("CTS 'Dionis'" = "Corporate Trade Station of food chain 'McRonalds'. They're sending a message. \"Hey, dudes, we sell things for theta-7-oil manipulations fly in and check our wares!\"")
	assortiment = list(
		"Burgers" = list(
			/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger = custom_good_name("BigR RBurger"),
			/obj/item/weapon/reagent_containers/food/snacks/jellyburger/cherry = custom_good_name("JellyCherry RBurger"),
			/obj/item/weapon/reagent_containers/food/snacks/tofuburger = custom_good_name("Vegeterian RBurger")
		),
		"Misc" = list(
			/obj/item/weapon/reagent_containers/food/snacks/fishandchips = custom_good_name("Duchess Fish 'n' Lord Chips"),
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake = custom_good_name("Vanilla"),
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake = custom_good_name("Chocola")
		),
		"Pizza" = list(
			/obj/item/pizzabox/meat = custom_good_name("Supreme Meatlover: Pizza Alliance"),
			/obj/item/pizzabox/mushroom = custom_good_name("Mushrooms' Impact 3rd"),
			/obj/item/pizzabox/vegetable = custom_good_name("Pizza Fantasy 7: Vegeterian Deluxe Edition"),
			/obj/item/pizzabox/margherita = custom_good_name("PizzeR: autoTomato")
		)
	)
	offer_types = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat/corgi,
		/mob/living/carbon/superior_animal/roach,
		/mob/living/carbon/superior_animal/roach/hunter,
		/mob/living/carbon/superior_animal/roach/roachling
	)
