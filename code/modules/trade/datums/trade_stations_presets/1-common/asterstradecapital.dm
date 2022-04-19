/datum/trade_station/asterstradecapital
	name_pool = list(
		"FTS \'Solnishko\'" = "Free Trade Station \'Solnishko\': \"Zdravstvuite, this is the trade station \'Solnishko\'. We have the best products in Hanza space! You couldn't find better prices!.\"",
	)
	forced_overmap_zone = list(
		list(24, 26),
		list(30, 30)
	)
	uid = "asterstradecapital"
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
			/obj/item/computer_hardware/hard_drive/portable/design/devices = good_data("Aster\'s Devices and Instruments", list(1, 10), 200)
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
		"Aster's Cells" = list(
			/obj/item/cell/small = custom_good_price(50),
			/obj/item/cell/small/high = custom_good_price(100),
			/obj/item/cell/small/super = custom_good_price(150),
			/obj/item/cell/medium = custom_good_price(100),
			/obj/item/cell/medium/high = custom_good_price(150),
			/obj/item/cell/medium/super = custom_good_price(200),
			/obj/item/cell/large = custom_good_price(200),
			/obj/item/cell/large/high = custom_good_price(400),
			/obj/item/cell/large/super = custom_good_price(800)
		),
		"Mining Gear" = list(
			/obj/machinery/mining/deep_drill,
			/obj/item/tool/pickaxe,
			/obj/item/tool/pickaxe/excavation,
			/obj/item/tool/pickaxe/jackhammer
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
			/obj/item/toy/figure/roach
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
			/obj/item/reagent_containers/glass/paint/red = good_data("Red Paint", list(1, 10), null),
			/obj/item/reagent_containers/glass/paint/green = good_data("Green Paint", list(1, 10), null),
			/obj/item/reagent_containers/glass/paint/blue = good_data("Blue Paint", list(1, 10), null),
			/obj/item/reagent_containers/glass/paint/yellow = good_data("Yellow Paint", list(1, 10), null),
			/obj/item/reagent_containers/glass/paint/purple = good_data("Purple Paint", list(1, 10), null),
			/obj/item/reagent_containers/glass/paint/black = good_data("Black Paint", list(1, 10), null),
			/obj/item/reagent_containers/glass/paint/white = good_data("White Paint", list(1, 10), null),
			/obj/item/storage/lunchbox = good_data("Lunchbox", list(1, 10), null),
			/obj/item/storage/lunchbox/rainbow = good_data("Rainbow Lunchbox", list(1, 10), null),
			/obj/item/storage/lunchbox/cat = good_data("Cat Lunchbox", list(1, 10), null),
			/obj/item/contraband/poster
		)
	)
	hidden_inventory = list(
		"Exosuits" = list(
			/mob/living/exosuit/premade/powerloader/firefighter,
			/mob/living/exosuit/premade/powerloader/flames_blue,
			/mob/living/exosuit/premade/powerloader/flames_red,
			/mob/living/exosuit/premade/light,
			/mob/living/exosuit/premade/heavy,
			/mob/living/exosuit/premade/combat/slayer
		),
		"Mech Armor" = list(
			/obj/item/robot_parts/robot_component/armour/exosuit/plain,
			/obj/item/robot_parts/robot_component/armour/exosuit/ablative,
			/obj/item/robot_parts/robot_component/armour/exosuit/combat
		),
		"Parts" = list(
			/obj/item/mech_component/chassis,
			/obj/item/mech_component/manipulators,
			/obj/item/mech_component/sensors,
			/obj/item/mech_component/propulsion
		),
		"Soft" = list(
			/obj/item/electronics/circuitboard/exosystem/engineering,
			/obj/item/electronics/circuitboard/exosystem/utility,
			/obj/item/electronics/circuitboard/exosystem/medical,
			/obj/item/electronics/circuitboard/exosystem/weapons
		),
		"Equipment" = list(
			/obj/item/mech_equipment/mounted_system/taser,
			/obj/item/mech_equipment/mounted_system/taser/ion,
			/obj/item/mech_equipment/mounted_system/taser/plasma,
			/obj/item/mech_equipment/mounted_system/rcd,
			/obj/item/mech_equipment/clamp,
			/obj/item/mech_equipment/light,
			/obj/item/mech_equipment/drill,
			/obj/item/mech_equipment/mounted_system/extinguisher,
			/obj/item/mech_equipment/sleeper
		)
	)
	offer_types = list(
		/obj/item/mech_component = offer_data("mech component", 120, 4),															// base price: 150
		/obj/item/mech_equipment = offer_data("mech equipment", 160, 4),															// base price: 200
		/obj/item/robot_parts/robot_component/armour/exosuit/plain = offer_data("exosuit armor plating", 240, 4),					// base price: 300
		/obj/item/robot_parts/robot_component/armour/exosuit/ablative = offer_data("ablative exosuit armor plating", 440, 4),		// base price: 550
		/obj/item/robot_parts/robot_component/armour/exosuit/combat = offer_data("combat exosuit armor plating", 800, 4)			// base price: 1000
	)
