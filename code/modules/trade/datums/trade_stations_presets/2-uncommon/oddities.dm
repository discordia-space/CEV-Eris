/datum/trade_station/oddities
	name_pool = list(
		"JNK \'Garbaj\'" = "Junker \'Garbaj\': \"You wanna buy what?\"",
	)
	uid = "oddities"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = 1
	base_income = 3200
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("bluespace")
	recommendations_needed = 1
	inventory = list(
		"Old Junk" = list(
			/obj/item/oddity/common/coin = custom_good_price(500),
			/obj/item/oddity/common/photo_landscape = custom_good_price(500),
			/obj/item/oddity/common/photo_coridor = custom_good_price(500),
			/obj/item/oddity/common/book_bible = custom_good_price(500),
			/obj/item/oddity/common/old_money = custom_good_price(500),
			/obj/item/oddity/common/mirror = custom_good_price(500),
			/obj/item/oddity/common/lighter = custom_good_price(500)
		)
	)
	hidden_inventory = list(
		"Older Junk" = list(
			/obj/item/oddity/common/blueprint = custom_good_price(500),
			/obj/item/oddity/common/photo_eyes = custom_good_price(500),
			/obj/item/oddity/common/photo_crime = custom_good_price(500),
			/obj/item/oddity/common/old_newspaper = custom_good_price(500),
			/obj/item/oddity/common/paper_crumpled = custom_good_price(500),
			/obj/item/oddity/common/paper_omega = custom_good_price(500),
			/obj/item/oddity/common/book_eyes = custom_good_price(500),
			/obj/item/oddity/common/book_omega = custom_good_price(500),
			/obj/item/oddity/common/book_unholy = custom_good_price(500),
			/obj/item/oddity/common/healthscanner = custom_good_price(500),
			/obj/item/oddity/common/old_pda = custom_good_price(500),
			/obj/item/oddity/common/towel = custom_good_price(500),
			/obj/item/oddity/common/teddy = custom_good_price(500),
			/obj/item/oddity/common/old_knife = custom_good_price(500),
			/obj/item/oddity/common/old_id = custom_good_price(500),
			/obj/item/oddity/common/disk = custom_good_price(500),
			/obj/item/oddity/common/device = custom_good_price(500),
			/obj/item/oddity/common/old_radio = custom_good_price(500),
			/obj/item/oddity/common/paper_bundle = custom_good_price(500)
		)
	)
	offer_types = list(
		/datum/reagent/alcohol/roachbeer = offer_data("Kakerlakenbier", 2500, 1),
		/datum/reagent/alcohol/kaiserbeer = offer_data("Monarchenblut", 25000, 1)
	)
