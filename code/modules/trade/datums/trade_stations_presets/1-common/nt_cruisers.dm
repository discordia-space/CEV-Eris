/datum/trade_station/nt_cruisers
	name_pool = list(
		"NTV \'Faith\'" = "NeoTheology Vessel \'Faith\': \"The most holy purveyors of ecclesiarchic goods!\"",
	)
	icon_states = list("nt_frigate", "ship")
	uid = "nt_basic"
	tree_x = 0.82
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 4000
	recommendation_threshold = 0
	stations_recommended = list()
	inventory = list(
		"Biomatter Products" = list(
			/obj/item/reagent_containers/food/snacks/meat = custom_good_price(100),
			/obj/item/reagent_containers/food/drinks/milk = custom_good_price(50),
			/obj/item/soap/nanotrasen = custom_good_price(100),
			/obj/item/storage/pouch/medical_supply,
			/obj/item/storage/pouch/engineering_tools,
			/obj/item/storage/pouch/engineering_supply,
			/obj/item/storage/pouch/engineering_material,
			/obj/item/storage/pouch/tubular,
			/obj/item/storage/pouch/tubular/vial,
			/obj/item/storage/pouch/ammo,
			/obj/item/clothing/accessory/holster,
			/obj/item/storage/pouch/holster,
			/obj/item/storage/pouch/holster/baton,
			/obj/item/storage/pouch/holster/belt,
			/obj/item/storage/pouch/holster/belt/sheath
		),
		"Agro Supply" = list(
			/obj/machinery/vending/hydroseeds,
			/obj/structure/largecrate/animal/corgi = custom_good_price(500),
			/obj/structure/largecrate/animal/cow = custom_good_price(1000),
			/obj/structure/largecrate/animal/goat = custom_good_price(300),
			/obj/structure/largecrate/animal/cat = custom_good_price(500),
			/obj/structure/largecrate/animal/chick = custom_good_price(100),
			/obj/item/reagent_containers/spray/plantbgone,
			/obj/item/reagent_containers/glass/bottle/ammonia,
			/obj/item/tool/hatchet,
			/obj/item/tool/minihoe,
			/obj/item/device/scanner/plant,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/suit/apron
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
			/obj/structure/janitorialcart,
			/obj/item/holyvacuum
		)
	)
	hidden_inventory = list(
		"Energy Weapons" = list(
			/obj/item/gun/energy/taser,
			/obj/item/gun/energy/nt_svalinn
		),
		"Ballistic Weapons" = list(
			/obj/item/gun/projectile/mk58,
			/obj/item/gun/projectile/mk58/wood,
			/obj/item/gun/projectile/shotgun/pump/regulator
		),
		"Neotheology Cells" = list(
			/obj/item/cell/small/neotheology,
			/obj/item/cell/medium/neotheology,
			/obj/item/cell/large/neotheology
		),
		"Curious Seeds" = list(
			/obj/item/seeds/greengrapeseed = good_data("green grape seeds", list(1,3), null),
			/obj/item/seeds/icepepperseed = good_data("ice-pepper seeds", list(1,3), null),
			/obj/item/seeds/glowberryseed = good_data("glowberry seeds", list(1,3), null),
			/obj/item/seeds/poisonberryseed = good_data("poison berry seeds", list(1,3), null),
			/obj/item/seeds/deathberryseed = good_data("death berry seeds", list(1,3), null),
			/obj/item/seeds/deathnettleseed = good_data("death nettle seeds", list(1,3), null),
			/obj/item/seeds/bloodtomatoseed = good_data("blood tomato seeds", list(1,3), null),
			/obj/item/seeds/killertomatoseed = good_data("killer tomato seeds", list(1,3), null),
			/obj/item/seeds/bluetomatoseed = good_data("blue tomato seeds", list(1,3), null),
			/obj/item/seeds/bluespacetomatoseed = good_data("bluespace tomato seeds", list(1,3), null),
			/obj/item/seeds/poisonedappleseed = good_data("poison apple seeds", list(1,3), null),
			/obj/item/seeds/goldappleseed = good_data("golden apple seeds", list(1,3), null),
			/obj/item/seeds/ambrosiadeusseed = good_data("ambrosia deus seeds", list(1,3), null),
			/obj/item/seeds/walkingmushroommycelium = good_data("walking mushroom spores", list(1,3), null),
			/obj/item/seeds/angelmycelium = good_data("destroying angel spores", list(1,3), null)
		)
	)
	offer_types = list(
		/obj/item/tool_upgrade/augment/sanctifier = offer_data("NT 'Sanctifier' tool blessing", 200, 0),
		/obj/item/gun_upgrade/barrel/excruciator = offer_data("NT \"EXCRUCIATOR\" giga lens", 500, 0),
		/obj/item/oddity/common/towel = offer_data("trustworthy towel", 500, 1),
		/obj/item/cruciform_upgrade = offer_data("cruciform upgrade", 1600, 0),
		/obj/item/book/ritual/cruciform = offer_data("Neotheology ritual book", 1800, 1),
		/obj/item/implant/core_implant/cruciform = offer_data("cruciform", 2500, 3),
		/obj/item/computer_hardware/hard_drive/portable/design/nt/medicii = offer_data("NeoTheology Armory - \"Medicii Supplies\"", 2000, 1),
		/obj/item/computer_hardware/hard_drive/portable/design/nt/nt_lightfall = offer_data("NeoTheology Armory - Lightfall Laser Gun", 2500, 1),
		/obj/item/computer_hardware/hard_drive/portable/design/nt/grenades = offer_data("NeoTheology Armory - Grenades Pack", 2500, 1),
		/obj/item/computer_hardware/hard_drive/portable/design/nt/triarii = offer_data("NeoTheology Armory - \"Triarii Arms\"", 8000, 1)
	)
