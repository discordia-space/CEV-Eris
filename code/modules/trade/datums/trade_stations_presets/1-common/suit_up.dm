/datum/trade_station/suit_up
	name_pool = list(
		"ATB 'Suit Up!'" = "Aster's Trade Beacon 'Suit Up!': \"Suits, voidsuits and more for you, traveler!\""
	)
	uid = "suit_up"
	start_discovered = TRUE
	spawn_always = TRUE
	markup = COMMON_GOODS
	offer_limit = 20
	base_income = 3200
	wealth = 0
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("rigs")
	assortiment = list(
		"Spacesuits" = list(
			/obj/item/clothing/suit/space/void,
			/obj/item/clothing/suit/space/void/atmos,
			/obj/item/rig/eva
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
			/obj/item/clothing/head/feathertrilby,
			/obj/item/clothing/head/fedora,
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
		"Premium collectable Hats" = list(
			/obj/item/clothing/head/collectable/chef,
			/obj/item/clothing/head/collectable/paper,
			/obj/item/clothing/head/collectable/tophat,
			/obj/item/clothing/head/collectable/captain,
			/obj/item/clothing/head/collectable/beret,
			/obj/item/clothing/head/collectable/welding,
			/obj/item/clothing/head/collectable/flatcap,
			/obj/item/clothing/head/collectable/pirate,
			/obj/item/clothing/head/collectable/kitty,
			/obj/item/clothing/head/collectable/rabbitears,
			/obj/item/clothing/head/collectable/wizard,
			/obj/item/clothing/head/collectable/hardhat,
			/obj/item/clothing/head/collectable/thunderdome,
			/obj/item/clothing/head/collectable/swat,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/police,
			/obj/item/clothing/head/collectable/xenom,
			/obj/item/clothing/head/collectable/petehat,
			/obj/item/clothing/head/collectable/festive
		)
	)
	secret_inventory = list(
		"Voidsuits" = list(
			/obj/item/clothing/suit/space/void/mining = custom_good_amount_range(list(1, 5)),
			/obj/item/clothing/suit/space/void/engineering = custom_good_amount_range(list(1, 5)),
			/obj/item/clothing/suit/space/void/medical = custom_good_amount_range(list(1, 5)),
			/obj/item/clothing/suit/space/void/security = custom_good_amount_range(list(1, 5))
		),
		"RIGs" =  list(
			/obj/item/rig/medical = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/hazmat = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/hazard = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/industrial = custom_good_amount_range(list(1, 5))
		),
		"RIG Specialized Modules" = list(
			/obj/item/rig_module/storage = good_data("Internal Storage compartment", list(1, 10)),
			/obj/item/rig_module/maneuvering_jets = good_data("Mounted Jetpack", list(1, 10)),
			/obj/item/rig_module/device/flash = good_data("Mounted Flash", list(1, 10)),
			/obj/item/rig_module/mounted/egun = good_data("Mounted Energy Gun", list(1, 10)),
			/obj/item/rig_module/mounted/taser = good_data("Mounted Taser", list(1, 10)),
			/obj/item/rig_module/device/drill = good_data("Mounted Drill", list(1, 10)),
			/obj/item/rig_module/device/orescanner = good_data("Mounted Ore Scanner", list(1, 10)),
			/obj/item/rig_module/device/anomaly_scanner = good_data("Mounted Anomaly Scanner", list(1,10)),
			/obj/item/rig_module/device/rcd = good_data("Mounted RCD", list(1, 10)),
			/obj/item/rig_module/device/healthscanner = good_data("Mounted Health Scanner", list(1, 10)),
			/obj/item/rig_module/modular_injector/medical = good_data("Mounted Chemical Dispenser (medical version)", list(-3, 2)),
			/obj/item/rig_module/ai_container,
			/obj/item/rig_module/power_sink,
			/obj/item/rig_module/vision/meson,
			/obj/item/rig_module/vision/nvg,
			/obj/item/rig_module/vision/sechud,
			/obj/item/rig_module/vision/medhud
		)
	)
	offer_types = list(
		/obj/item/rig_module = offer_data("rig module", 500, 10),							// base price: 500
		/obj/item/rig/medical = offer_data("rescue suit control module", 700, 2),			// base price: 682 (incl. components)
		/obj/item/rig/eva = offer_data("EVA suit control module", 700, 2),					// base price: 682 (incl. components)
		/obj/item/rig/hazard = offer_data("hazard hardsuit control module", 700, 2),		// base price: 682 (incl. components)
		/obj/item/rig/industrial = offer_data("industrial suit control module", 950, 2),	// base price: 882 (incl. components)
		/obj/item/rig/hazmat = offer_data("AMI control module", 950, 2),					// base price: 882 (incl. components)
		/obj/item/rig/combat = offer_data("combat hardsuit control module", 1100, 2)		// base price: 1032 (incl. components)
	)
