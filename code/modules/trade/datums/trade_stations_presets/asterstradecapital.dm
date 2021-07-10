/datum/trade_station/asterstradecapital
	name_pool = list("FTS 'Solnishko'" = "Free Trade Station 'Solnishko', they sending message \"Zdravstvuite, this is the Trade Station 'Solaris'. We have all of the bests products on sale at Hansa! You couldn't get even better prices!.\ Everything for sale here, don't be afraid to come aboard and check our wares!\".")
	start_discovered = TRUE
	spawn_always = TRUE
	forced_overmap_zone = list(
		list(24, 26),
		list(30, 30)
	)
	assortiment = list(
		"Disk Designs" = list(
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/tools = good_data("Asters Basic Tool Pack", list(1, 10)),
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/misc = good_data("Asters Miscellaneous Pack", list(1, 10)),
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/robustcells = good_data("Asters Robustcells", list(1, 10)),
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/devices = good_data("Asters Devices and Instruments", list(1, 10)),
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/nonlethal_ammo = good_data("Frozen Star Nonlethal Magazines Pack", list(1, 10)),
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/lethal_ammo = good_data("Frozen Star Lethal Magazines Pack", list(1, 10)),
			/obj/item/weapon/storage/deferred/disks
		),
		"Tools and Equipment" = list(
			/obj/item/clothing/suit/storage/hazardvest,
			/obj/item/weapon/storage/pouch/small_generic,
			/obj/item/weapon/storage/pouch/ammo,
			/obj/item/weapon/storage/pouch/gun_part,
			/obj/item/weapon/storage/belt/utility,
			/obj/item/device/lighting/toggleable/flashlight,
			/obj/item/device/lighting/toggleable/flashlight/heavy,
			/obj/item/weapon/tool/omnitool = good_data("Asters \"Munchkin 5000\"", list(1, 3)),
			/obj/item/weapon/tool/crowbar,
			/obj/item/weapon/tool/screwdriver,
			/obj/item/weapon/tool/shovel,
			/obj/item/weapon/tool/wirecutters,
			/obj/item/weapon/tool/wrench,
			/obj/item/weapon/tool/weldingtool,
			/obj/item/weapon/tool/tape_roll
		),
		"Aster's Cells" = list(
			/obj/item/weapon/cell/small,
			/obj/item/weapon/cell/small/high,
			/obj/item/weapon/cell/small/super,
			/obj/item/weapon/cell/medium,
			/obj/item/weapon/cell/medium/high,
			/obj/item/weapon/cell/medium/super,
			/obj/item/weapon/cell/large,
			/obj/item/weapon/cell/large/high,
			/obj/item/weapon/cell/large/super
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
			/obj/item/toy/figure/roach,
//			/obj/item/ammo_casing/cap
		),
		"Frozen Star Sidearms & Ammunitions" = list(
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip,
			/obj/item/weapon/gun/projectile/revolver/havelock,
			/obj/item/weapon/gun/projectile/olivaw,
			/obj/item/weapon/gun/projectile/giskard,
			/obj/item/weapon/gun/projectile/selfload,
			/obj/item/weapon/gun/energy/gun/martin,
			/obj/item/weapon/gun/energy/gun,
			/obj/item/ammo_magazine/slpistol,
			/obj/item/ammo_magazine/slpistol/rubber,
			/obj/item/ammo_magazine/pistol,
			/obj/item/ammo_magazine/pistol/rubber,
			/obj/item/ammo_magazine/hpistol = custom_good_amount_range(list(-1, 3)),
			/obj/item/ammo_magazine/hpistol/rubber = custom_good_amount_range(list(-1, 5)),
			/obj/item/ammo_magazine/ammobox/pistol,
			/obj/item/ammo_magazine/ammobox/pistol/rubber
		),
		"Utilities" = list(
			/obj/item/device/camera,
			/obj/item/device/camera_film,
			/obj/item/device/toner,
			/obj/item/weapon/storage/photo_album,
			/obj/item/weapon/wrapping_paper,
			/obj/item/weapon/packageWrap,
			/obj/item/weapon/reagent_containers/glass/paint/red = good_data("Red Paint", list(1, 10)),
			/obj/item/weapon/reagent_containers/glass/paint/green = good_data("Green Paint", list(1, 10)),
			/obj/item/weapon/reagent_containers/glass/paint/blue = good_data("Blue Paint", list(1, 10)),
			/obj/item/weapon/reagent_containers/glass/paint/yellow = good_data("Yellow Paint", list(1, 10)),
			/obj/item/weapon/reagent_containers/glass/paint/purple = good_data("Purple Paint", list(1, 10)),
			/obj/item/weapon/reagent_containers/glass/paint/black = good_data("Black Paint", list(1, 10)),
			/obj/item/weapon/reagent_containers/glass/paint/white = good_data("White Paint", list(1, 10)),
			/obj/item/weapon/storage/lunchbox = good_data("Lunchbox", list(1, 10)),
			/obj/item/weapon/storage/lunchbox/rainbow = good_data("Rainbow Lunchbox", list(1, 10)),
			/obj/item/weapon/storage/lunchbox/cat = good_data("Cat Lunchbox", list(1, 10)),
			/obj/item/weapon/mop,
			/obj/item/weapon/caution,
			/obj/item/weapon/storage/bag/trash,
			/obj/item/weapon/reagent_containers/spray/cleaner,
			/obj/item/weapon/reagent_containers/glass/rag
		),
	)
