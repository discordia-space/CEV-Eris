/datum/trade_station/fs_experimental_factory
	name_pool = list("FSTB 'Suoh'" = "Frozen Star Trade Beacon 'Suoh'. This is the experimental weaponry seller, requires a better description because I suck at this, please someone on the PR send help.")
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
			/obj/item/ammo_magazine/ammobox/srifle_small/hv,
			/obj/item/ammo_magazine/ammobox/clrifle_small/hv,
			/obj/item/ammo_magazine/ammobox/lrifle_small/hv,
			/obj/item/ammo_magazine/ammobox/pistol/hv,
			/obj/item/ammo_magazine/ammobox/magnum/hv,
			/obj/item/weapon/storage/box/shotgunammo/incendiaryshells
		),
	)
