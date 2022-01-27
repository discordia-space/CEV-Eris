/datum/trade_station/asterstradecapital
	name_pool = list(
		"FTS 'Solnishko'" = "Free Trade Station 'Solnishko':\n\"Zdravstvuite, this is the trade station 'Solaris'. We have the best products in Hanza space! You couldn't find better prices!.\"",
	)
	forced_overmap_zone = list(
		list(24, 26),
		list(30, 30)
	)
	start_discovered = TRUE
	spawn_always = TRUE
	markup = COMMON_69OODS
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 16000
	assortiment = list(
		"Disk Desi69ns" = list(
			/obj/item/computer_hardware/hard_drive/portable/desi69n/tools = 69ood_data("Asters Basic Tool Pack", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/desi69n/misc = 69ood_data("Asters69iscellaneous Pack", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/desi69n/robustcells = 69ood_data("Asters Robustcells", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/desi69n/devices = 69ood_data("Asters Devices and Instruments", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/desi69n/nonlethal_ammo = 69ood_data("Frozen Star69onlethal69a69azines Pack", list(1, 10)),
			/obj/item/computer_hardware/hard_drive/portable/desi69n/lethal_ammo = 69ood_data("Frozen Star Lethal69a69azines Pack", list(1, 10)),
//			/obj/item/stora69e/deferred/disks	// Can be bou69ht, emptied, and resold to discount the price.69ow that direct sellin69 replenishes stock, this69ay be a problem.
		),
		"Tools and E69uipment" = list(
			/obj/item/clothin69/suit/stora69e/hazardvest,
			/obj/item/stora69e/pouch/small_69eneric,
			/obj/item/stora69e/pouch/ammo,
			/obj/item/stora69e/pouch/69un_part,
			/obj/item/stora69e/belt/utility,
			/obj/item/device/li69htin69/to6969leable/flashli69ht,
			/obj/item/device/li69htin69/to6969leable/flashli69ht/heavy,
			/obj/item/tool/omnitool = 69ood_data("Asters \"Munchkin 5000\"", list(1, 3)),
			/obj/item/tool/crowbar,
			/obj/item/tool/screwdriver,
			/obj/item/tool/shovel,
			/obj/item/tool/wirecutters,
			/obj/item/tool/wrench,
			/obj/item/tool/weldin69tool,
			/obj/item/tool/tape_roll
		),
		"Aster's Cells" = list(
			/obj/item/cell/small,
			/obj/item/cell/small/hi69h,
			/obj/item/cell/small/super,
			/obj/item/cell/medium,
			/obj/item/cell/medium/hi69h,
			/obj/item/cell/medium/super,
			/obj/item/cell/lar69e,
			/obj/item/cell/lar69e/hi69h,
			/obj/item/cell/lar69e/super
		),
		"Toys" = list(
			/obj/item/toy/balloon = 69ood_data("Water Balloon", list(1, 50)),
			/obj/item/toy/blink,
			/obj/item/toy/crossbow,
			/obj/item/toy/ammo/crossbow,
			/obj/item/toy/sword,
			/obj/item/toy/katana,
			/obj/item/toy/snappop,
			/obj/item/toy/bosunwhistle,
			/obj/item/toy/fi69ure/va69abond,
			/obj/item/toy/fi69ure/roach,
//			/obj/item/ammo_casin69/cap
		),
		"Frozen Star Accessories & Ammunition" = list(
			/obj/item/clothin69/accessory/holster,
			/obj/item/clothin69/accessory/holster/armpit,
			/obj/item/clothin69/accessory/holster/waist,
			/obj/item/clothin69/accessory/holster/hip,
			/obj/item/ammo_ma69azine/slpistol,
			/obj/item/ammo_ma69azine/slpistol/rubber,
			/obj/item/ammo_ma69azine/pistol,
			/obj/item/ammo_ma69azine/pistol/rubber,
			/obj/item/ammo_ma69azine/hpistol = custom_69ood_amount_ran69e(list(-1, 3)),
			/obj/item/ammo_ma69azine/hpistol/rubber = custom_69ood_amount_ran69e(list(-1, 5)),
			/obj/item/ammo_ma69azine/ammobox/pistol,
			/obj/item/ammo_ma69azine/ammobox/pistol/rubber
		),
		"Miscellanous" = list(
			/obj/item/device/camera,
			/obj/item/device/camera_film,
			/obj/item/device/toner,
			/obj/item/stora69e/photo_album,
			/obj/item/wrappin69_paper,
			/obj/item/packa69eWrap,
			/obj/item/rea69ent_containers/69lass/paint/red = 69ood_data("Red Paint", list(1, 10)),
			/obj/item/rea69ent_containers/69lass/paint/69reen = 69ood_data("69reen Paint", list(1, 10)),
			/obj/item/rea69ent_containers/69lass/paint/blue = 69ood_data("Blue Paint", list(1, 10)),
			/obj/item/rea69ent_containers/69lass/paint/yellow = 69ood_data("Yellow Paint", list(1, 10)),
			/obj/item/rea69ent_containers/69lass/paint/purple = 69ood_data("Purple Paint", list(1, 10)),
			/obj/item/rea69ent_containers/69lass/paint/black = 69ood_data("Black Paint", list(1, 10)),
			/obj/item/rea69ent_containers/69lass/paint/white = 69ood_data("White Paint", list(1, 10)),
			/obj/item/stora69e/lunchbox = 69ood_data("Lunchbox", list(1, 10)),
			/obj/item/stora69e/lunchbox/rainbow = 69ood_data("Rainbow Lunchbox", list(1, 10)),
			/obj/item/stora69e/lunchbox/cat = 69ood_data("Cat Lunchbox", list(1, 10)),
			/obj/item/mop,
			/obj/item/caution,
			/obj/item/stora69e/ba69/trash,
			/obj/item/rea69ent_containers/spray/cleaner,
			/obj/item/rea69ent_containers/69lass/ra69,
			/obj/item/or69an_module/active/simple/armshield
		),
	)
	offer_types = list(
		/obj/item/mech_component/ = offer_data("mech component", 125, 10),															// base price: 150
		/obj/item/mech_e69uipment/ = offer_data("mech e69uipment", 175, 10),															// base price: 200
		/obj/item/robot_parts/robot_component/armour/exosuit/plain = offer_data("exosuit armor platin69", 250, 8),					// base price: 300, sold at common
		/obj/item/robot_parts/robot_component/armour/exosuit/radproof = offer_data("rad-proof exosuit armor platin69", 415, 8),		// base price: 500, sold at common
		/obj/item/robot_parts/robot_component/armour/exosuit/ablative = offer_data("ablative exosuit armor platin69", 465, 8),		// base price: 550, sold at common
		/obj/item/robot_parts/robot_component/armour/exosuit/combat = offer_data("combat exosuit armor platin69", 830, 8),			// base price: 1000, sold at common
	)
