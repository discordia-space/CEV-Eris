/datum/trade_station/suit_up
	name_pool = list(
		"ATB \'Suit Up!\'" = "Aster\'s Trade Beacon \'Suit Up!\': \"Suits, voidsuits, and more for you, traveler!\""
	)
	icon_states = list("htu_station", "station")
	uid = "suit_up"
	tree_x = 0.66
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 20
	base_income = 3200
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("rigs", "style")
	inventory = list(
		"Basic Space Gear" = list(
			/obj/item/clothing/suit/space/void = custom_good_price(200),
			/obj/item/clothing/suit/space/void/atmos = custom_good_price(2100),
			/obj/item/rig/eva = custom_good_price(600),
			/obj/item/tank/jetpack/oxygen = custom_good_price(100),
			/obj/item/tank/jetpack/carbondioxide = custom_good_price(100),
			/obj/item/device/suit_cooling_unit
		),
		"Cosmetic Accesories" = list(
			/obj/item/clothing/ears/earmuffs,
			/obj/item/clothing/glasses/eyepatch,
			/obj/item/clothing/glasses/regular,
			/obj/item/clothing/glasses/regular/hipster = custom_good_name("Hipster Prescription Glasses"),
			/obj/item/clothing/glasses/regular/scanners,
			/obj/item/clothing/glasses/sunglasses,
			/obj/item/clothing/glasses/monocle
		),
		"Hats" = list(
			/obj/item/clothing/head/bearpelt,
			/obj/item/clothing/head/beret,
			/obj/item/clothing/head/bowler,
			/obj/item/clothing/head/chaplain_hood,
			/obj/item/clothing/head/chefhat,
			/obj/item/clothing/head/chicken,
			/obj/item/clothing/head/fez,
			/obj/item/clothing/head/gladiator,
			/obj/item/clothing/head/hgpiratecap,
			/obj/item/clothing/head/nun_hood,
			/obj/item/clothing/head/pirate,
			/obj/item/clothing/head/plaguedoctorhat,
			/obj/item/clothing/head/richard,
			/obj/item/clothing/head/that,
			/obj/item/clothing/head/ushanka,
			/obj/item/clothing/head/witchwig,
			/obj/item/clothing/head/xenos
		),
		"Masks" = list(
			/obj/item/clothing/mask/fakemoustache,
			/obj/item/clothing/mask/gas,
			/obj/item/clothing/mask/gas/monkeymask,
			/obj/item/clothing/mask/gas/owl_mask,
			/obj/item/clothing/mask/gas/plaguedoctor
		),
		"Shoes" = list(
			/obj/item/clothing/shoes/jackboots,
			/obj/item/clothing/shoes/leather,
			/obj/item/clothing/shoes/magboots,
			/obj/item/clothing/shoes/sandal,
			/obj/item/clothing/shoes/workboots
		),
		"Jumpsuits" = list(
			/obj/item/clothing/under/blackskirt,
			/obj/item/clothing/under/blazer,
			/obj/item/clothing/under/brown,
			/obj/item/clothing/under/cyber,
			/obj/item/clothing/under/dress/gray,
			/obj/item/clothing/under/dress/blue,
			/obj/item/clothing/under/dress/red,
			/obj/item/clothing/under/genericb,
			/obj/item/clothing/under/genericw,
			/obj/item/clothing/under/genericr,
			/obj/item/clothing/under/jersey,
			/obj/item/clothing/under/kilt,
			/obj/item/clothing/under/leisure,
			/obj/item/clothing/under/leisure/white,
			/obj/item/clothing/under/leisure/pullover,
			/obj/item/clothing/under/librarian,
			/obj/item/clothing/under/overalls,
			/obj/item/clothing/under/serviceoveralls,
			/obj/item/clothing/under/owl,
			/obj/item/clothing/under/waiter,
			/obj/item/clothing/under/pirate,
			/obj/item/clothing/under/gladiator,
			/obj/item/clothing/under/soviet,
			/obj/item/clothing/under/schoolgirl,
			/obj/item/clothing/under/serbiansuit,
			/obj/item/clothing/under/serbiansuit/brown,
			/obj/item/clothing/under/serbiansuit/black,
			/obj/item/clothing/under/suit_jacket,
			/obj/item/clothing/under/suit_jacket/red,
			/obj/item/clothing/under/bride_white,
			/obj/item/clothing/under/tuxedo,
			/obj/item/clothing/under/rank/fo_suit,
			/obj/item/clothing/under/rank/janitor,
			/obj/item/clothing/under/rank/hydroponics
		),
		"Suits" = list(
			/obj/item/clothing/suit/apron,
			/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
			/obj/item/clothing/suit/chef,
			/obj/item/clothing/suit/chickensuit,
			/obj/item/clothing/suit/judgerobe,
			/obj/item/clothing/suit/monkeysuit,
			/obj/item/clothing/suit/nun,
			/obj/item/clothing/suit/pirate,
			/obj/item/clothing/suit/poncho,
			/obj/item/clothing/suit/poncho/tactical,
			/obj/item/clothing/suit/punkvest,
			/obj/item/clothing/suit/punkvest/cyber,
			/obj/item/clothing/suit/storage/bladerunner,
			/obj/item/clothing/suit/storage/bomj,
			/obj/item/clothing/suit/wcoat,
			/obj/item/clothing/suit/xenos
		),
		"Utility" = list(
			/obj/item/clothing/suit/storage/greatcoat,
			/obj/item/clothing/suit/storage/vest,
			/obj/item/clothing/head/bio_hood,
			/obj/item/clothing/suit/bio_suit,
			/obj/item/clothing/suit/fire,
			/obj/item/clothing/head/radiation,
			/obj/item/clothing/suit/radiation
		)
	)
	hidden_inventory = list(
		"Voidsuits" = list(
			/obj/item/clothing/suit/space/void/mining = custom_good_price(312),
			/obj/item/clothing/suit/space/void/engineering = custom_good_price(312),
			/obj/item/clothing/suit/space/void/medical,
			/obj/item/clothing/suit/space/void/security = custom_good_price(520),
			/obj/item/clothing/suit/space/void/hazardsuit = custom_good_price(312)
		),
		"Oberth Attire" = list(
			/obj/item/clothing/gloves/german,
			/obj/item/clothing/head/beret/german,
			/obj/item/clothing/mask/gas/german,
			/obj/item/clothing/shoes/jackboots/german,
			/obj/item/clothing/suit/storage/greatcoat/german_overcoat,
			/obj/item/clothing/under/germansuit
		)
	)
	offer_types = list(
		/obj/item/rig_module = offer_data("rig module", 500, 6),							// base price: 500
		/obj/item/rig/eva = offer_data("EVA suit control module", 300, 2),					// base price: 1090 (incl. components)
		/obj/item/rig/medical = offer_data("rescue suit control module", 800, 2),			// base price: 1090 (incl. components)
		/obj/item/rig/hazard = offer_data("hazard hardsuit control module", 800, 2),		// base price: 1090 (incl. components)
		/obj/item/rig/industrial = offer_data("industrial suit control module", 1000, 2),	// base price: 1290 (incl. components)
		/obj/item/rig/hazmat = offer_data("AMI control module", 1000, 2),					// base price: 1290 (incl. components)
		/obj/item/rig/combat = offer_data("combat hardsuit control module", 1500, 2)		// base price: 1590 (incl. components)
	)
