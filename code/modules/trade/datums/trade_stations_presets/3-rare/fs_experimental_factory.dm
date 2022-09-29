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
	stations_recommended = list("illegal2")
	recommendations_needed = 1
	inventory = list(
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
