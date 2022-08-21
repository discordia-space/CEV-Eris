/datum/trade_station/fs_experimental_factory
	name_pool = list(
		"FSTB \'Suoh\'" = "Frozen Star Trade Beacon \'Suoh\': \"Hello there! We are looking for beta testers of our experimental weapons and upgrades. Sign up now!\""
	)
	icon_states = list("htu_station", "station")
	uid = "fs_experimental"
	tree_x = 0.74
	tree_y = 0.6
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS
	offer_limit = 20
	base_income = 0
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	recommendations_needed = 1
	inventory = list(
		"Gunmods" = list(
			/obj/item/gun_upgrade/trigger/dangerzone,
			/obj/item/gun_upgrade/trigger/cop_block,
			/obj/item/gun_upgrade/mechanism/weintraub,
			/obj/item/gun_upgrade/scope/watchman
		),
		"Grenades" = list(
			/obj/item/grenade/anti_photon,
			/obj/item/grenade/empgrenade,
			/obj/item/grenade/chem_grenade/incendiary
		),
		"Experimental Ammunition" = list(
			/obj/item/ammo_magazine/ammobox/srifle_small/hv = custom_good_amount_range(list(-3, 2)),
			/obj/item/ammo_magazine/ammobox/clrifle_small/hv = custom_good_amount_range(list(-3, 2)),
			/obj/item/ammo_magazine/ammobox/lrifle_small/hv = custom_good_amount_range(list(-3, 2)),
			/obj/item/ammo_magazine/ammobox/pistol/hv = custom_good_amount_range(list(-1, 2)),
			/obj/item/ammo_magazine/ammobox/magnum/hv = custom_good_amount_range(list(-1, 2)),
			/obj/item/ammo_magazine/ammobox/shotgun/incendiaryshells = custom_good_name("ammunition box (.50 incendiary)")
		)
	)
