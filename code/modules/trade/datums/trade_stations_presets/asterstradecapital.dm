/datum/trade_station/asterstradecapital
	name_pool = list("ATS 'Solaris'" = "Aster's Trade Station 'Solaris', they sending message \"Hello, this is the Trade Station 'Solaris'. We have all of the bests products on sale at Hansa! You couldn't get even better prices!.\ Everything for sale here, don't be afraid to come aboard and check our wares!\".")
	// This is, going to be the main trading station. Has a grand part of the not so big things, and a fuckload of dittos of the crates that were on the shuttle now without needing to buy a full crate of unnecesary/unwanted items.
	start_discovered = TRUE
	spawn_always = TRUE
	markup = 0.7 // actual markup: 1,33

	forced_overmap_zone = list(
		list(24, 26),
	list(24, 30)
	)
//TODO: FIX BROKEN NAMES HERE SO ITS "Crowbar" and not "crowbar", add other designs.
	assortiment = list(
		"Disk Designs" = list(
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/tools = good_data("Asters Basic Tool Pack", list(1, 10)),
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/misc = good_data("Asters Miscellaneous Pack", list(1, 10)),
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/robustcells = good_data("Asters Robustcells", list(1, 10)),
			/obj/item/weapon/computer_hardware/hard_drive/portable/design/devices = good_data("Asters Devices and Instruments", list(1, 10)),
//			/obj/item/weapon/computer_hardware/hard_drive/portable/design/nonlethal_ammo = good_data("Frozen Star Nonlethal Magazines Pack", list(1, 10)),
//			/obj/item/weapon/computer_hardware/hard_drive/portable/design/lethal_ammo = good_data("Frozen Star Lethal Magazines Pack", list(1,10))
		),
		"Tools and Equipment" = list(
			/obj/item/clothing/suit/storage/hazardvest,
			/obj/spawner/cloth/holster,
			/obj/item/weapon/storage/pouch/small_generic,
			/obj/item/weapon/storage/pouch/ammo,
			/obj/item/weapon/storage/pouch/gun_part,
			/obj/item/weapon/storage/belt/utility,
			/obj/item/device/lighting/toggleable/flashlight,
			/obj/item/device/lighting/toggleable/flashlight/heavy,
			/obj/item/weapon/tool/omnitool = good_data("Asters \"Munchkin 5000\"", list(1, 3)),
			/obj/item/weapon/tool/crowbar,
			/obj/item/weapon/tool/screwdriver,
			/obj/item/weapon/tool/wrench,
			/obj/item/weapon/tool/shovel,
			/obj/item/weapon/tool/weldingtool,
			/obj/item/weapon/tool/screwdriver,
			/obj/item/weapon/tool/tape_roll,
			/obj/item/weapon/tool/wirecutters
		),
		"Aster's Cells" = list(
			/obj/item/weapon/cell/small,
			/obj/item/weapon/cell/small/high,
			/obj/item/weapon/cell/small/super,
			/obj/item/weapon/cell/medium,
			/obj/item/weapon/cell/medium/high,
			/obj/item/weapon/cell/medium/super,
			/obj/item/weapon/cell/large/,
			/obj/item/weapon/cell/large/high,
			/obj/item/weapon/cell/large/super
		),
//Some of these could have better sprites, I guess.
		"Toys" = list(
			/obj/item/toy/balloon = good_data("Water Balloon", list(10,100)),
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
			/obj/item/weapon/gun/projectile/revolver/havelock,
			/obj/item/weapon/gun/projectile/olivaw,
			/obj/item/weapon/gun/projectile/giskard,
			/obj/item/weapon/gun/projectile/selfload,
			/obj/item/weapon/gun/energy/gun/martin,
			/obj/item/weapon/gun/energy/gun,
			/obj/item/ammo_magazine/slpistol,
			/obj/item/ammo_magazine/slpistol/rubber,
			/obj/item/ammo_magazine/pistol/rubber,
			/obj/item/ammo_magazine/pistol,
			/obj/item/ammo_magazine/hpistol/rubber,
			/obj/item/ammo_magazine/hpistol,
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
			/obj/item/weapon/reagent_containers/glass/paint/red = good_data("Red Paint", list(10,100)),
			/obj/item/weapon/reagent_containers/glass/paint/green = good_data("Green Paint", list(10,100)),
			/obj/item/weapon/reagent_containers/glass/paint/blue = good_data("Blue Paint", list(10,100)),
			/obj/item/weapon/reagent_containers/glass/paint/yellow = good_data("Yellow Paint", list(10,100)),
			/obj/item/weapon/reagent_containers/glass/paint/purple = good_data("Purple Paint", list(10,100)),
			/obj/item/weapon/reagent_containers/glass/paint/black = good_data("Black Paint", list(10,100)),
			/obj/item/weapon/reagent_containers/glass/paint/white = good_data("White Paint", list(10,100)),
			/obj/item/weapon/storage/lunchbox = good_data("Lunchbox", list(10,100)),
			/obj/item/weapon/storage/lunchbox/rainbow = good_data("Rainbow Lunchbox", list(10,100)),
			/obj/item/weapon/storage/lunchbox/cat = good_data("Cat Lunchbox", list(10,100))
		),
	)

	offer_types = list(
			/obj/item/stack/material/steel,
			/obj/item/stack/material/plasteel
	)
