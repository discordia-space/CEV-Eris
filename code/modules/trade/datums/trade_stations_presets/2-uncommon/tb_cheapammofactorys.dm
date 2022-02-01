/datum/trade_station/tb_cheapammofactory
	name_pool = list(
		"ATB 'Zeus'" = "Ammunition Trade Beacon 'Zeus'\nCheap ammunition! Almost free! If we don't have it, that means it doesn't exists or it is illegal enough!",
		"AFTB 'Hispa'" = "Ammunition Factory Trade Beacon 'Hispa'\nAll ammunition in existence is here! Buy all calibers, all types! We don't sell anything illegal and everything comes from us! Cheap as breathing!",
	)
	uid = "fs_ammo"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = COMMON_GOODS / 2
	markdown = 0
	offer_limit = 20
	base_income = 0
	wealth = 0
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("fs_experimental")
	recommendations_needed = 1
	assortiment = list(
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
			/obj/item/ammo_magazine/ammobox/clrifle_small,	// object def needs name and icon
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
			/obj/item/ammo_magazine/ammobox/shotgun,
			/obj/item/ammo_magazine/ammobox/shotgun/buckshot = custom_good_name("ammunition box (.50 pellet)"),
			/obj/item/ammo_magazine/ammobox/shotgun/beanbags = custom_good_name("ammunition box (.50 beanbag)"),
			/obj/item/ammo_magazine/ammobox/shotgun/blanks = custom_good_name("ammunition box (.50 blank)"),
			/obj/item/ammo_magazine/ammobox/shotgun/flashshells = custom_good_name("ammunition box (.50 flash)"),
			/obj/item/ammo_magazine/ammobox/shotgun/incendiaryshells = custom_good_name("ammunition box (.50 incendiary)")
		),
	)
	offer_types = list(
		/obj/item/gun_upgrade/ = offer_data("gun mod", 100, 10),
	)
