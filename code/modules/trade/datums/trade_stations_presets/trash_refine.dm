/datum/trade_station/lancer
	name_pool = list("IRS 'Lancer'" = "IRS Trash Railgun 'Lancer'. They're sending a message. \"Hoho, you want some Trash?\"")
	start_discovered = FALSE
	spawn_always = TRUE
	offer_limit = 20
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 16000
	assortiment = list(
		"Trash" = list(
			/obj/spawner/scrap/dense = custom_good_amount_range(list(15, 60))
		)
	)
	secret_inventory = list(
		"Premium Trash" = list(
			/obj/structure/scrap_spawner = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/medical = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/medical/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/vehicle = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/vehicle/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/food = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/food/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/guns = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/guns/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/science = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/science/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/cloth = custom_good_amount_range(list(2,5)),			// Could be a concern with the armor part offer, but it's locked behind discovery and a secret inventory. Something to watch for.
			/obj/structure/scrap_spawner/cloth/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/poor = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/poor/large = custom_good_amount_range(list(2,5)),
		)
	)
	// TODO: offers

