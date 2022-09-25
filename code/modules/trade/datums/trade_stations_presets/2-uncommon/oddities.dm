/datum/trade_station/oddities
	name_pool = list(
		"JNK \'Garbaj\'" = "Junker \'Garbaj\': \"You wanna buy what?\"",
	)
	icon_states = list("htu_station", "station")
	uid = "oddities"
	tree_x = 0.26
	tree_y = 0.7
	start_discovered = FALSE
	spawn_always = TRUE
	markup = 1
	base_income = 0					// Needs player interaction to replenish stock
	wealth = -16000					//
	hidden_inv_threshold = 4000
	recommendation_threshold = 0
	stations_recommended = list()
	recommendations_needed = 1
	inventory = list(
		"Old Junk" = list(
			/obj/item/oddity/common/old_money = custom_good_price(660),
			/obj/item/oddity/common/mirror = custom_good_price(660),
			/obj/item/oddity/common/old_id = custom_good_price(680),
			/obj/item/oddity/common/disk = custom_good_price(680),
			/obj/item/oddity/common/lighter = custom_good_price(680),
			/obj/item/oddity/common/coin = custom_good_price(700),
			/obj/item/oddity/common/photo_landscape = custom_good_price(700),
			/obj/item/oddity/common/photo_coridor = custom_good_price(700),
			/obj/item/oddity/common/book_bible = custom_good_price(700)
		)
	)
	hidden_inventory = list(
		"Older Junk" = list(
			/obj/item/oddity/common/old_newspaper = custom_good_price(740),
			/obj/item/oddity/common/old_pda = custom_good_price(740),
			/obj/item/oddity/common/towel = custom_good_price(740),
			/obj/item/oddity/common/blueprint = custom_good_price(780),
			/obj/item/oddity/common/book_unholy = custom_good_price(780),
			/obj/item/oddity/common/photo_crime = custom_good_price(780),
			/obj/item/oddity/common/old_knife = custom_good_price(800),
			/obj/item/oddity/common/device = custom_good_price(820),
			/obj/item/oddity/common/healthscanner = custom_good_price(820),
			/obj/item/oddity/common/paper_bundle = custom_good_price(860),
			/obj/item/oddity/common/old_radio = custom_good_price(860),
			/obj/item/oddity/common/book_omega = custom_good_price(860),
			/obj/item/oddity/common/photo_eyes = custom_good_price(860),
			/obj/item/oddity/common/paper_crumpled = custom_good_price(860),
			/obj/item/oddity/common/teddy = custom_good_price(920),
			/obj/item/oddity/common/paper_omega = custom_good_price(980),
			/obj/item/oddity/common/book_eyes = custom_good_price(1040)	
		)
	)
	offer_types = list(
		/datum/reagent/alcohol/roachbeer = offer_data("Kakerlakenbier", 2500, 2),
		/datum/reagent/alcohol/kaiserbeer = offer_data("Monarchenblut", 25000, 1)
	)
