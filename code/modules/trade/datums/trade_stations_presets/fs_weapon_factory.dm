/datum/trade_station/fs_factory
	name_pool = list("FSTB 'Kaida'" = "Frozen Star Trade Beacon 'Kaida'.69aybe they have an extra batch of weapons?")
	markup = 0.4
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
	)
