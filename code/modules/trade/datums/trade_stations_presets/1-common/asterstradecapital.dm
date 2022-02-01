/datum/trade_station/asterstradecapital
	name_pool = list(
		"FTS 'Solnishko'" = "Free Trade Station 'Solnishko': \"Zdravstvuite, this is the trade station 'Solaris'. We have the best products in Hanza space! You couldn't find better prices!.\"",
	)
	forced_overmap_zone = list(
		list(24, 26),
		list(30, 30)
	)
	uid = "asterstradecapital"
	start_discovered = TRUE
	spawn_always = TRUE
	markup = COMMON_GOODS
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("casino")
	assortiment = list(
		"Disk Designs" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/tools = good_data("Asters Basic Tool Pack", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/design/misc = good_data("Asters Miscellaneous Pack", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/design/robustcells = good_data("Asters Robustcells", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/design/devices = good_data("Asters Devices and Instruments", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/design/nonlethal_ammo = good_data("Frozen Star Nonlethal Magazines Pack", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/design/lethal_ammo = good_data("Frozen Star Lethal Magazines Pack", list(1, 10))
		),
		"Tools and Equipment" = list(
			/obj/item/clothing/suit/storage/hazardvest,
			/obj/item/storage/pouch/small_generic,
			/obj/item/storage/pouch/ammo,
			/obj/item/storage/pouch/gun_part,
			/obj/item/storage/belt/utility,
			/obj/item/device/lighting/toggleable/flashlight,
			/obj/item/device/lighting/toggleable/flashlight/heavy,
			/obj/item/tool/omnitool = good_data("Asters \"Munchkin 5000\"", list(1, 3)),
			/obj/item/tool/crowbar,
			/obj/item/tool/screwdriver,
			/obj/item/tool/shovel,
			/obj/item/tool/wirecutters,
			/obj/item/tool/wrench,
			/obj/item/tool/weldingtool,
			/obj/item/tool/tape_roll
		),
		"Aster's Cells" = list(
			/obj/item/cell/small,
			/obj/item/cell/small/high,
			/obj/item/cell/small/super,
			/obj/item/cell/medium,
			/obj/item/cell/medium/high,
			/obj/item/cell/medium/super,
			/obj/item/cell/large,
			/obj/item/cell/large/high,
			/obj/item/cell/large/super
		),
		"Toys" = list(
			/obj/item/toy/balloon = good_data("Water Balloon", list(1, 50)),
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
		"Frozen Star Accessories & Ammunition" = list(
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip,
			/obj/item/ammo_magazine/slpistol,
			/obj/item/ammo_magazine/slpistol/rubber,
			/obj/item/ammo_magazine/pistol,
			/obj/item/ammo_magazine/pistol/rubber,
			/obj/item/ammo_magazine/hpistol = custom_good_amount_range(list(-1, 3)),
			/obj/item/ammo_magazine/hpistol/rubber = custom_good_amount_range(list(-1, 5)),
			/obj/item/ammo_magazine/ammobox/pistol,
			/obj/item/ammo_magazine/ammobox/pistol/rubber
		),
		"Miscellanous" = list(
			/obj/item/device/camera,
			/obj/item/device/camera_film,
			/obj/item/device/toner,
			/obj/item/storage/photo_album,
			/obj/item/wrapping_paper,
			/obj/item/packageWrap,
			/obj/item/reagent_containers/glass/paint/red = good_data("Red Paint", list(1, 10)),
			/obj/item/reagent_containers/glass/paint/green = good_data("Green Paint", list(1, 10)),
			/obj/item/reagent_containers/glass/paint/blue = good_data("Blue Paint", list(1, 10)),
			/obj/item/reagent_containers/glass/paint/yellow = good_data("Yellow Paint", list(1, 10)),
			/obj/item/reagent_containers/glass/paint/purple = good_data("Purple Paint", list(1, 10)),
			/obj/item/reagent_containers/glass/paint/black = good_data("Black Paint", list(1, 10)),
			/obj/item/reagent_containers/glass/paint/white = good_data("White Paint", list(1, 10)),
			/obj/item/storage/lunchbox = good_data("Lunchbox", list(1, 10)),
			/obj/item/storage/lunchbox/rainbow = good_data("Rainbow Lunchbox", list(1, 10)),
			/obj/item/storage/lunchbox/cat = good_data("Cat Lunchbox", list(1, 10)),
			/obj/item/mop,
			/obj/item/caution,
			/obj/item/storage/bag/trash,
			/obj/item/reagent_containers/spray/cleaner,
			/obj/item/reagent_containers/glass/rag
		)
	)
	secret_inventory = list(
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
			/obj/item/robot_parts/robot_component/armour/exosuit/radproof,
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
		/obj/item/mech_component/ = offer_data("mech component", 150, 10),															// base price: 150
		/obj/item/mech_equipment/ = offer_data("mech equipment", 200, 10),															// base price: 200
		/obj/item/robot_parts/robot_component/armour/exosuit/plain = offer_data("exosuit armor plating", 300, 8),					// base price: 300
		/obj/item/robot_parts/robot_component/armour/exosuit/radproof = offer_data("rad-proof exosuit armor plating", 500, 8),		// base price: 500
		/obj/item/robot_parts/robot_component/armour/exosuit/ablative = offer_data("ablative exosuit armor plating", 550, 8),		// base price: 550
		/obj/item/robot_parts/robot_component/armour/exosuit/combat = offer_data("combat exosuit armor plating", 1000, 8)			// base price: 1000
	)
