/datum/trade_station/fs_experimental_factory
	name_pool = list("FSTB 'Suoh'" = "Frozen Star Trade Beacon 'Suoh'. They're sending a message. \"Hello there! We are looking for beta testers of our experimental weapons and upgrades. Sign up now!\""))
	markup = 1
	spawn_probability = 10
	assortiment = list(
		"Gunmods" = list(
			/obj/item/weapon/gun_upgrade/trigger/dangerzone,
			/obj/item/weapon/gun_upgrade/trigger/cop_block,
			/obj/item/weapon/gun_upgrade/mechanism/weintraub,
			/obj/item/weapon/gun_upgrade/scope/watchman
		),
		"Grenades" = list(
			/obj/item/weapon/grenade/anti_photon,
			/obj/item/weapon/grenade/empgrenade,
			/obj/item/weapon/grenade/chem_grenade/incendiary
		),
		"Experimental Ammunition" = list(
			/obj/item/ammo_magazine/ammobox/srifle_small/hv = custom_good_amount_range(list(-3, 2)),
			/obj/item/ammo_magazine/ammobox/clrifle_small/hv = custom_good_amount_range(list(-3, 2)),
			/obj/item/ammo_magazine/ammobox/lrifle_small/hv = custom_good_amount_range(list(-3, 2)),
			/obj/item/ammo_magazine/ammobox/pistol/hv = custom_good_amount_range(list(-1, 2)),
			/obj/item/ammo_magazine/ammobox/magnum/hv = custom_good_amount_range(list(-1, 2)),
			/obj/item/weapon/storage/box/shotgunammo/incendiaryshells
		),
	)
