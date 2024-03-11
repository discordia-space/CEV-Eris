/datum/trade_station/asterstradecapital
	name_pool = list(
		"FTS \'Solnishko\'" = "Free Trade Station \'Solnishko\': \"Zdravstvuite, this is the trade station \'Solnishko\'. We have the best products in Hanza space! You couldn't find better prices!.\"",
	)
	forced_overmap_zone = list(
		list(24, 26),
		list(30, 30)
	)
	icon_states = list("htu_capital", "station")
	uid = "asterstradecapital"
	tree_x = 0.58
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("casino")
	inventory = list(
		"Disk Designs" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/tools = good_data("Aster\'s Basic Tool Pack", list(1, 10), 200),
			/obj/item/computer_hardware/hard_drive/portable/design/misc = good_data("Aster\'s Miscellaneous Pack", list(1, 10), 200),
			/obj/item/computer_hardware/hard_drive/portable/design/robustcells = good_data("Aster\'s Robustcells", list(1, 10), 200),
			/obj/item/computer_hardware/hard_drive/portable/design/devices = good_data("Aster\'s Devices and Instruments", list(1, 10), 200),
			/obj/item/computer_hardware/hard_drive/portable/design/armor/asters = good_data("Aster\'s Enforcement Armor Pack", list(1, 10), 900)
		),
		"Tools and Equipment" = list(
			/obj/item/clothing/suit/storage/hazardvest,
			/obj/item/storage/pouch/small_generic,
			/obj/item/storage/pouch/ammo,
			/obj/item/storage/pouch/gun_part,
			/obj/item/storage/belt/utility,
			/obj/item/storage/hcases/parts,
			/obj/item/device/lighting/toggleable/flashlight,
			/obj/item/device/lighting/toggleable/flashlight/heavy,
			/obj/item/tool/omnitool = good_data("Aster\'s \"Munchkin 5000\"", list(1, 3), null)
		),
		"Electronics" = list(
			/obj/item/electronics/circuitboard/artist_bench,
			/obj/item/electronics/circuitboard/miningturret,
			/obj/item/electronics/circuitboard/vending
		),
		"Aster\'s Cells" = list(
			/obj/item/cell/small = custom_good_price(50),
			/obj/item/cell/small/high = custom_good_price(100),
			/obj/item/cell/medium = custom_good_price(100),
			/obj/item/cell/medium/high = custom_good_price(150),
			/obj/item/cell/large = custom_good_price(200),
			/obj/item/cell/large/high = custom_good_price(400),
		),
		"Mining Gear" = list(
			/obj/machinery/mining/deep_drill,
			/obj/item/tool/karl,
			/obj/item/tool/pickaxe,
			/obj/item/tool/pickaxe/excavation,
			/obj/item/storage/bag/ore,
			/obj/structure/ore_box
		),
		"Toys" = list(
			/obj/item/toy/balloon = good_data("Water Balloon", list(1, 50), null),
			/obj/item/toy/blink,
			/obj/item/toy/crossbow,
			/obj/item/toy/ammo/crossbow,
			/obj/item/toy/sword,
			/obj/item/toy/katana,
			/obj/item/toy/snappop,
			/obj/item/toy/bosunwhistle,
			/obj/item/toy/figure/vagabond,
			/obj/item/toy/figure/roach,
			/obj/item/toy/rubber_pig = custom_good_price(99)
		),
		"Bags" = list(
			/obj/item/storage/backpack/satchel,
			/obj/item/storage/backpack/satchel/white,
			/obj/item/storage/backpack/satchel/purple,
			/obj/item/storage/backpack/satchel/blue,
			/obj/item/storage/backpack/satchel/green,
			/obj/item/storage/backpack/satchel/orange,
			/obj/item/storage/backpack/satchel/leather,
			/obj/item/storage/backpack,
			/obj/item/storage/backpack/white,
			/obj/item/storage/backpack/purple,
			/obj/item/storage/backpack/blue,
			/obj/item/storage/backpack/green,
			/obj/item/storage/backpack/orange,
			/obj/item/storage/backpack/sport,
			/obj/item/storage/backpack/sport/white,
			/obj/item/storage/backpack/sport/purple,
			/obj/item/storage/backpack/sport/blue,
			/obj/item/storage/backpack/sport/green,
			/obj/item/storage/backpack/sport/orange,
			/obj/item/storage/backpack/duffelbag,
			/obj/item/storage/backpack/duffelbag/loot
		),
		"Miscellanous" = list(
			/obj/item/device/camera,
			/obj/item/device/camera_film,
			/obj/item/device/toner,
			/obj/item/storage/photo_album,
			/obj/item/wrapping_paper,
			/obj/item/packageWrap,
			/obj/item/storage/box = custom_good_price(5),
			/obj/item/hand_labeler = custom_good_price(10),
			/obj/item/storage/fancy/crayons = custom_good_price(6),
			/obj/item/storage/lunchbox = good_data("Lunchbox", list(1, 10), null),
			/obj/item/storage/lunchbox/rainbow = good_data("Rainbow Lunchbox", list(1, 10), null),
			/obj/item/storage/lunchbox/cat = good_data("Cat Lunchbox", list(1, 10), null),
			/obj/item/contraband/poster
		),
		"IKEA crates" = list(
		/obj/item/machinery_crate/crafting_station = custom_good_price(700),
		/obj/item/machinery_crate/autolathe = custom_good_price(600),
		/obj/item/machinery_crate/pacman = custom_good_price(700),
		/obj/item/machinery_crate/recharger = custom_good_price(700)
		)
	)
	hidden_inventory = list(
		"Exosuits" = list(
			/mob/living/exosuit/premade/powerloader/firefighter,
			/mob/living/exosuit/premade/powerloader/flames_blue,
			/mob/living/exosuit/premade/powerloader/flames_red
		),
		"Aster\'s Cells II" = list(
			/obj/item/cell/small/super = custom_good_price(150),
			/obj/item/cell/small/hyper = custom_good_price(600),
			/obj/item/cell/medium/super = custom_good_price(200),
			/obj/item/cell/medium/hyper = custom_good_price(800),
			/obj/item/cell/large/super = custom_good_price(800),
			/obj/item/cell/large/hyper = custom_good_price(1600)
		),
		"SN4-Z 2N3Z" = list(
			/obj/item/media/boombox = custom_good_price(1000)
		)
	)
	offer_types = list(
		/obj/item/oddity/common/old_id = offer_data("old id", 500, 1),
		/obj/item/tool_upgrade = offer_data("tool upgrade", 200, 8),
		/obj/item/mech_component = offer_data("mech component", 300, 4),															// base price: 150
		/obj/item/mech_equipment = offer_data("mech equipment", 400, 4),															// base price: 200
		/obj/item/robot_parts/robot_component/armour/exosuit/plain = offer_data("exosuit armor plating", 700, 4),					// base price: 400
		/obj/item/robot_parts/robot_component/armour/exosuit/ablative = offer_data("ablative exosuit armor plating", 700, 4),		// base price: 550
		/obj/item/robot_parts/robot_component/armour/exosuit/combat = offer_data("combat exosuit armor plating", 1750, 4),			// base price: 1000
		/obj/item/tool/crowbar/onestar = offer_data("one star crowbar", 5000, 3),
		/obj/item/tool/hammer/sledgehammer/onestar = offer_data("one star sledgehammer", 5000, 3),
		/obj/item/tool/screwdriver/combi_driver/onestar = offer_data("one star combi driver", 6500, 3),
		/obj/item/tool/weldingtool/onestar = offer_data("one star welding tool", 6500, 3),
		/obj/item/organ/external/robotic/one_star = offer_data("one star external prosthetic", 5000, 4)
	)
