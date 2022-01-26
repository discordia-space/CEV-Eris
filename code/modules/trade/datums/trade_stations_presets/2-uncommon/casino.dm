/datum/trade_station/gamba
	name_pool = list(
		"FTB 'Solntsey'" = "Free Trade Beacon 'Solntsey':\n\"TBD\"",
	)
	uid = "casino"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = 10				// High markup, low base price to prevent export abuse
	base_income = 0
	wealth = 0
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("illegal1", "serbian")
	recommendations_needed = 1
	assortiment = list(
		"Assorted Goods" = list(
			/obj/item/storage/deferred/disks = custom_good_amount_range(list(1, 5)),
			/obj/item/storage/deferred/gun_parts = custom_good_amount_range(list(1, 5)),
			/obj/item/storage/deferred/powercells = custom_good_amount_range(list(1, 5)),
			/obj/item/storage/deferred/electronics = custom_good_amount_range(list(1, 5)),
		)
	)
	secret_inventory = list(
		// loot box inside the box
	)
	offer_types = list(
		// coins, old money
	)
