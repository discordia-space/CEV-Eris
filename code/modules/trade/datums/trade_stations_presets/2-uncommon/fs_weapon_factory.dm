/datum/trade_station/fs_factory
	name_pool = list(
		"FSTB 'Kaida'" = "Frozen Star Trade Beacon 'Kaida'. Maybe they have an extra batch of weapons?"
	)
	uid = "fs_guns"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS		// Dept-specific stuff should be more expensive for guild
	offer_limit = 20
	base_income = 0
	wealth = 0
//	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("fs_experimental", "illegal1")
	recommendations_needed = 1
	assortiment = list(
		"Ammunition" = list(
			/obj/item/ammo_magazine/ammobox/magnum = custom_good_amount_range(list(1, 10)),
			/obj/item/ammo_magazine/slmagnum = custom_good_amount_range(list(1, 10)),
			/obj/item/ammo_magazine/ammobox/magnum/rubber = custom_good_amount_range(list(1, 10)),
			/obj/item/ammo_magazine/slmagnum/rubber = custom_good_amount_range(list(1, 10)),

			/obj/item/ammo_magazine/m12,
			/obj/item/ammo_magazine/m12/beanbag,
			/obj/item/ammo_magazine/lrifle,
			/obj/item/ammo_magazine/smg,
			/obj/item/ammo_magazine/pistol,
			/obj/item/ammo_magazine/hpistol
		),
		category_data("Projectiles", list(SPAWN_FS_PROJECTILE)),
		category_data("Shotguns", list(SPAWN_FS_SHOTGUN)),
		category_data("Energy", list(SPAWN_FS_ENERGY)),
		"Grenades" = list(
			/obj/item/gun/projectile/shotgun/pump/grenade/lenar,
			/obj/item/grenade/chem_grenade/teargas,
			/obj/item/grenade/empgrenade/low_yield,
			/obj/item/grenade/flashbang,
			/obj/item/grenade/smokebomb
		),
	)
	offer_types = list(
		/obj/item/part/gun/frame/ak47 = offer_data("AK frame", 800, 1),
		/obj/item/part/gun/frame/sol = offer_data("Sol frame", 1000, 1),
		/obj/item/part/gun/frame/straylight = offer_data("Straylight frame", 1000, 1),
		/obj/item/part/gun/frame/atreides = offer_data("Atreides frame", 1000, 1),
		/obj/item/part/gun/frame/wintermute = offer_data("Wintermute frame", 1000, 1),
		/obj/item/part/gun/frame/tosshin = offer_data("Tosshin frame", 1000, 1),
		/obj/item/part/gun/frame/bull = offer_data("Bull frame", 1000, 1),
		/obj/item/part/gun/frame/gladstone = offer_data("Gladstone frame", 1000, 1),
		/obj/item/part/gun/frame/lamia = offer_data("Lamia frame", 1000, 1),
		/obj/item/part/gun/frame/molly = offer_data("Molly frame", 1000, 1),
	)
