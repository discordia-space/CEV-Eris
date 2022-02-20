/datum/trade_station/lancer
	name_pool = list(
		"ITR 'Lancer'" = "IRS Trash Railgun 'Lancer': \"Hoho, you want some Trash?\""
	)
	uid = "trash"
	start_discovered = TRUE//FALSE
	spawn_always = TRUE
	markup = UNCOMMON_GOODS
	offer_limit = 20
	base_income = 0
	wealth = 0
	secret_inv_threshold = 0//2000
	recommendation_threshold = 4000
	stations_recommended = list("oddities")
	recommendations_needed = 1
	assortiment = list(
		"Trash" = list(
			/obj/spawner/scrap/sparse = custom_good_amount_range(list(15, 60))
		)
	)
	secret_inventory = list(
		"Premium Trash" = list(
			/obj/structure/scrap_spawner = custom_good_amount_range(list(2,5)),
	//		/obj/structure/scrap_spawner/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/medical = custom_good_amount_range(list(2,5)),
	//		/obj/structure/scrap_spawner/medical/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/vehicle = custom_good_amount_range(list(2,5)),
	//		/obj/structure/scrap_spawner/vehicle/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/food = custom_good_amount_range(list(2,5)),
	//		/obj/structure/scrap_spawner/food/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/guns = custom_good_amount_range(list(2,5)),
	//		/obj/structure/scrap_spawner/guns/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/science = custom_good_amount_range(list(2,5)),
	//		/obj/structure/scrap_spawner/science/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/cloth = custom_good_amount_range(list(2,5)),			// Could be a concern with the armor part offer, but it requires multiple unlocks and 30-50 minutes minimum. Something to watch for.
	//		/obj/structure/scrap_spawner/cloth/large = custom_good_amount_range(list(2,5)),
			/obj/structure/scrap_spawner/poor = custom_good_amount_range(list(2,5)),
	//		/obj/structure/scrap_spawner/poor/large = custom_good_amount_range(list(2,5))
		)
	)
	offer_types = list(
		/datum/reagent/alcohol/changelingsting = offer_data("Changeling Sting bottle (60u)", 1500, 1),
		/datum/reagent/alcohol/longislandicedtea = offer_data("Long Island Iced Tea bottle (60u)", 1500, 1),
		/datum/reagent/alcohol/neurotoxin = offer_data("Neurotoxin bottle (60u)", 2500, 1),
		/datum/reagent/alcohol/hippies_delight = offer_data("Hippie's Delight bottle (60u)", 2500, 1),
		/datum/reagent/alcohol/silencer = offer_data("Silencer bottle (60u)", 2500, 1)
	)
