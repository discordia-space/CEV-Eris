/datum/trade_station/gamba
	name_pool = list(
		"FTB \'Solntsey\'" = "Free Trade Beacon \'Solntsey\': \"Try your luck with our grab bag specials!\"",
	)
	icon_states = list("htu_station", "station")
	uid = "casino"
	tree_x = 0.58
	tree_y = 0.7
	start_discovered = FALSE
	spawn_always = TRUE
	markup = 1
	base_income = 10000
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("illegal1", "serbian")
	recommendations_needed = 1
	inventory = list(
		"Assorted Goods" = list(
			/obj/item/storage/deferred/disks = custom_good_price(5000),
			/obj/item/storage/deferred/gun_parts = custom_good_price(3000),
			/obj/item/storage/deferred/powercells = custom_good_price(2000),
			/obj/item/storage/deferred/electronics = custom_good_price(1000)
		)
	)
	hidden_inventory = list(
		// TODO: More stuff.
	)
	offer_types = list(
		/obj/item/coin = offer_data("metal coin", 4000, 1),						// From what I can tell, these are pretty rare
		/obj/item/oddity/common/coin = offer_data("strange coin", 500, 1),
		/obj/item/oddity/common/old_money = offer_data("old money", 500, 1),
		/obj/item/oddity/artwork = offer_data("artistic oddity", 1600, 1)
	)
