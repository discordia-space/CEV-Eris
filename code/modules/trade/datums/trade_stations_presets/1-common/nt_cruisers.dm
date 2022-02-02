/datum/trade_station/nt_cruisers
	name_pool = list(
		"NTV 'Faith'" = "NeoTheology Vessel 'Faith': \"The most holy purveyors of ecclesiarchic goods!\"",
	)
	icon_states = "nt_cruiser"
	uid = "nt_basic"
	start_discovered = TRUE
	spawn_always = TRUE
	markup = COMMON_GOODS
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("nt_uncommon")
	assortiment = list(
		"Biomatter Products" = list(
			/obj/item/reagent_containers/food/snacks/meat,
			/obj/item/reagent_containers/food/drinks/milk,
			/obj/item/soap/nanotrasen,
			/obj/item/storage/pouch/medical_supply,
			/obj/item/storage/pouch/engineering_tools,
			/obj/item/storage/pouch/engineering_supply,
			/obj/item/storage/pouch/engineering_material,
			/obj/item/storage/pouch/tubular,
			/obj/item/storage/pouch/tubular/vial,
			/obj/item/storage/pouch/ammo,
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip
		),
		"Agro Supply" = list(
			/obj/machinery/vending/hydroseeds,
			/obj/structure/largecrate/animal/corgi,
			/obj/structure/largecrate/animal/cow,
			/obj/structure/largecrate/animal/goat,
			/obj/structure/largecrate/animal/cat,
			/obj/structure/largecrate/animal/chick
		),
		"Custodial Supply" = list(
			/obj/item/reagent_containers/glass/bucket,
			/obj/item/mop,
			/obj/item/caution,
			/obj/item/storage/bag/trash,
			/obj/item/device/lightreplacer,
			/obj/item/reagent_containers/spray/cleaner,
			/obj/item/reagent_containers/glass/rag,
			/obj/item/grenade/chem_grenade/cleaner/nt_cleaner,
			/obj/item/grenade/chem_grenade/antiweed/nt_antiweed,
			/obj/structure/mopbucket,		
			/obj/structure/janitorialcart
		)
	)
	secret_inventory = list(
		"Curious Seeds" = list(
			/obj/item/seeds/greengrapeseed = good_data("green grape seeds", list(1,3)),
			/obj/item/seeds/icepepperseed = good_data("ice-pepper seeds", list(1,3)),
			/obj/item/seeds/glowberryseed = good_data("glowberry seeds", list(1,3)),
			/obj/item/seeds/poisonberryseed = good_data("poison berry seeds", list(1,3)),
			/obj/item/seeds/deathberryseed = good_data("death berry seeds", list(1,3)),
			/obj/item/seeds/deathnettleseed = good_data("death nettle seeds", list(1,3)),
			/obj/item/seeds/bloodtomatoseed = good_data("blood tomato seeds", list(1,3)),
			/obj/item/seeds/killertomatoseed = good_data("killer tomato seeds", list(1,3)),
			/obj/item/seeds/bluetomatoseed = good_data("blue tomato seeds", list(1,3)),
			/obj/item/seeds/bluespacetomatoseed = good_data("blusepace tomato seeds", list(1,3)),
			/obj/item/seeds/poisonedappleseed = good_data("poison apple seeds", list(1,3)),
			/obj/item/seeds/goldappleseed = good_data("golden apple seeds", list(1,3)),
			/obj/item/seeds/ambrosiadeusseed = good_data("ambrosia deus seeds", list(1,3)),
			/obj/item/seeds/walkingmushroommycelium = good_data("walking mushroom spores", list(1,3)),
			/obj/item/seeds/angelmycelium = good_data("destroying angel spores", list(1,3))
		)
	)
	offer_types = list(
		/obj/item/implant/core_implant/cruciform = offer_data("cruciform", 2500, 3),
		/obj/item/book/ritual/cruciform = offer_data("Neotheology ritual book", 600, 5),		// base price: 300
		/obj/item/oddity/common/towel = offer_data("trustworthy towel", 800, 1)
	)
