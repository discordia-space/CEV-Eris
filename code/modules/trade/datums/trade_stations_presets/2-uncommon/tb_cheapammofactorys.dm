/datum/trade_station/tb_cheapammofactory
	name_pool = list(
		"FSTB \'Zeus\'" = "Frozen Star Trade Beacon \'Zeus\': \"Cheap ammunition! Almost free! If we don\'t have it, that means it doesn't exists or it isn\'t legal enough!\"",
		"FSTB \'Hispa\'" = "Frozen Star Trade Beacon \'Hispa\': \"All ammunition in existence is here! Buy all calibers, all types! Cheap as breathing!\""
	)
	icon_states = list("htu_station", "station")
	uid = "fs_ammo"
	tree_x = 0.74
	tree_y = 0.7
	start_discovered = FALSE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 20
	base_income = 0
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("fs_experimental")
	recommendations_needed = 1
	inventory = list(
		".35 Caliber"  = list(
			/obj/item/ammo_magazine/slpistol,
			/obj/item/ammo_magazine/slpistol/rubber = custom_good_name("speed loader (.35 Auto rubber)"),
			/obj/item/ammo_magazine/pistol,
			/obj/item/ammo_magazine/pistol/rubber = custom_good_name("standard magazine (.35 Auto rubber)"),
			/obj/item/ammo_magazine/hpistol,
			/obj/item/ammo_magazine/hpistol/rubber = custom_good_name("highcap magazine (.35 Auto rubber)"),

			/obj/item/ammo_magazine/smg,
			/obj/item/ammo_magazine/smg/rubber = custom_good_name("smg magazine (.35 Auto rubber)"),

			/obj/item/ammo_magazine/ammobox/pistol,
			/obj/item/ammo_magazine/ammobox/pistol/rubber = custom_good_name("ammunition packet (.35 Auto rubber)")
		),
		".40 Caliber" = list(
			/obj/item/ammo_magazine/slmagnum,
			/obj/item/ammo_magazine/slmagnum/rubber = custom_good_name("speed loader (.40 Magnum rubber)"),
			/obj/item/ammo_magazine/magnum,
			/obj/item/ammo_magazine/magnum/rubber = custom_good_name("magazine (.40 Magnum rubber)"),

			/obj/item/ammo_magazine/msmg,
			/obj/item/ammo_magazine/msmg/rubber = custom_good_name("smg magazine (.40 Magnum rubber)"),

			/obj/item/ammo_magazine/ammobox/magnum,
			/obj/item/ammo_magazine/ammobox/magnum/rubber = custom_good_name("ammunition packet (.40 Magnum rubber)")
		),
		".20 Caliber" = list(
			/obj/item/ammo_magazine/srifle,
			/obj/item/ammo_magazine/srifle/rubber = custom_good_name("magazine (.20 Rifle rubber)"),

			/obj/item/ammo_magazine/ammobox/srifle_small,
			/obj/item/ammo_magazine/ammobox/srifle_small/rubber = custom_good_name("smg magazine (.20 Rifle rubber)"),
			/obj/item/ammo_magazine/ammobox/srifle,
			/obj/item/ammo_magazine/ammobox/srifle/rubber = custom_good_name("ammunition box (.20 Rifle rubber)")
		),
		".25 Caliber" = list(
			/obj/item/ammo_magazine/ihclrifle,
			/obj/item/ammo_magazine/ihclrifle/rubber = custom_good_name("magazine (.25 Caseless Rifle rubber)"),

			/obj/item/ammo_magazine/cspistol,
			/obj/item/ammo_magazine/cspistol/rubber = custom_good_name("pistol magazine (.25 Caseless Rifle rubber)"),

			/obj/item/ammo_magazine/ammobox/clrifle,
			/obj/item/ammo_magazine/ammobox/clrifle/rubber = custom_good_name("ammunition box (.25 Caseless Rifle rubber)"),
			/obj/item/ammo_magazine/ammobox/clrifle_small,
			/obj/item/ammo_magazine/ammobox/clrifle_small/rubber = custom_good_name("ammunition packet (.25 Caseless Rifle rubber)")
		),
		".30 Caliber" = list(
			/obj/item/ammo_magazine/lrifle,
			/obj/item/ammo_magazine/lrifle/rubber = custom_good_name("long magazine (.30 Rifle rubber)"),

			/obj/item/ammo_magazine/sllrifle,

			/obj/item/ammo_magazine/ammobox/lrifle,
			/obj/item/ammo_magazine/ammobox/lrifle_small,
			/obj/item/ammo_magazine/ammobox/lrifle_small/rubber = custom_good_name("ammunition packet (.30 Rifle rubber)")
		),
		"Shotgun shells" = list(
			/obj/item/ammo_magazine/ammobox/shotgun = custom_good_name("ammunition box (.50 shells)"),
			/obj/item/ammo_magazine/ammobox/shotgun/buckshot = custom_good_name("ammunition box (.50 pellet)"),
			/obj/item/ammo_magazine/ammobox/shotgun/beanbags = custom_good_name("ammunition box (.50 beanbag)"),
			/obj/item/ammo_magazine/ammobox/shotgun/blanks = custom_good_name("ammunition box (.50 blank)"),
			/obj/item/ammo_magazine/ammobox/shotgun/flashshells = custom_good_name("ammunition box (.50 flash)"),
			/obj/item/ammo_magazine/ammobox/shotgun/incendiaryshells = custom_good_name("ammunition box (.50 incendiary)")
		)
	)
	offer_types = list(
		/obj/item/gun = offer_data_mods("modified gun (3 upgrades)", 3200, 2, OFFER_MODDED_GUN, 3),
		/obj/item/part/gun/frame/ak47 = offer_data("AK frame", 800, 1),
		/obj/item/part/gun/frame/boltgun  = offer_data("boltgun frame", 800, 1),
		/obj/item/part/gun/frame/sol = offer_data("Sol frame", 2000, 1),
		/obj/item/part/gun/frame/straylight = offer_data("Straylight frame", 2000, 1),
		/obj/item/part/gun/frame/wintermute = offer_data("Wintermute frame", 2000, 1),
		/obj/item/part/gun/frame/kadmin = offer_data("Kadmin frame", 2000, 1),
		/obj/item/part/gun/frame/bull = offer_data("Bull frame", 2000, 1),
		/obj/item/part/gun/frame/gladstone = offer_data("Gladstone frame", 2000, 1),
		/obj/item/part/gun/frame/tk = offer_data("Takeshi frame", 2000, 1),
		/obj/item/part/gun/frame/lamia = offer_data("Lamia frame", 2000, 1),
		/obj/item/part/gun/frame/molly = offer_data("Molly frame", 2000, 1),
		/obj/item/part/gun/frame/consul = offer_data("Consul frame", 2000, 1),
		/obj/item/part/gun/frame/deckard = offer_data("Deckard frame", 2000, 1),
		/obj/item/part/gun/frame/mateba = offer_data("Mateba frame", 2000, 1)
	)
