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
			/obj/item/ammo_magazine/slpistol/rubber,
			/obj/item/ammo_magazine/pistol,
			/obj/item/ammo_magazine/pistol/rubber,
			/obj/item/ammo_magazine/hpistol,
			/obj/item/ammo_magazine/hpistol/rubber,

			/obj/item/ammo_magazine/smg,
			/obj/item/ammo_magazine/smg/rubber,

			/obj/item/ammo_magazine/ammobox/pistol,
			/obj/item/ammo_magazine/ammobox/pistol/rubber
		),
		".40 Caliber" = list(
			/obj/item/ammo_magazine/slmagnum,
			/obj/item/ammo_magazine/slmagnum/rubber,
			/obj/item/ammo_magazine/magnum,
			/obj/item/ammo_magazine/magnum/rubber,

			/obj/item/ammo_magazine/msmg,
			/obj/item/ammo_magazine/msmg/rubber,

			/obj/item/ammo_magazine/ammobox/magnum,
			/obj/item/ammo_magazine/ammobox/magnum/rubber
		),
		".20 Caliber" = list(
			/obj/item/ammo_magazine/srifle,
			/obj/item/ammo_magazine/srifle/rubber,

			/obj/item/ammo_magazine/ammobox/srifle_small,
			/obj/item/ammo_magazine/ammobox/srifle_small/rubber,
			/obj/item/ammo_magazine/ammobox/srifle,
			/obj/item/ammo_magazine/ammobox/srifle/rubber
		),
		".25 Caliber" = list(
			/obj/item/ammo_magazine/ihclrifle,
			/obj/item/ammo_magazine/ihclrifle/rubber,

			/obj/item/ammo_magazine/cspistol,
			/obj/item/ammo_magazine/cspistol/rubber,

			/obj/item/ammo_magazine/ammobox/clrifle,
			/obj/item/ammo_magazine/ammobox/clrifle/rubber,
			/obj/item/ammo_magazine/ammobox/clrifle_small,
			/obj/item/ammo_magazine/ammobox/clrifle_small/rubber
		),
		".30 Caliber" = list(
			/obj/item/ammo_magazine/lrifle,
			/obj/item/ammo_magazine/lrifle/rubber,

			/obj/item/ammo_magazine/sllrifle,

			/obj/item/ammo_magazine/ammobox/lrifle,
			/obj/item/ammo_magazine/ammobox/lrifle_small,
			/obj/item/ammo_magazine/ammobox/lrifle_small/rubber
		),
		"Shotgun shells" = list(
			/obj/item/ammo_magazine/ammobox/shotgun,
			/obj/item/ammo_magazine/ammobox/shotgun/buckshot,
			/obj/item/ammo_magazine/ammobox/shotgun/beanbags,
			/obj/item/ammo_magazine/ammobox/shotgun/blanks,
			/obj/item/ammo_magazine/ammobox/shotgun/flashshells,
			/obj/item/ammo_magazine/ammobox/shotgun/incendiaryshells
		),
	)
	offer_types = list(
		/obj/item/part/gun/frame/ = offer_data("gun frame", 600, 3),
		/obj/item/part/gun/grip = offer_data("gun grip", 250, 3),				// base price: 100
		/obj/item/part/gun/mechanism = offer_data("gun mechanism", 250, 3),		// base price: 100
		/obj/item/part/gun/barrel = offer_data("gun barrel", 250, 3),			// base price: 200
	)
