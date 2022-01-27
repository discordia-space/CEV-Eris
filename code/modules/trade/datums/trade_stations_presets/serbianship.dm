/datum/trade_station/serbfrigate
	icon_states = "serb_frigate"
	spawn_cost = 2
	spawn_probability = 10
	markup = 3
	name_pool = list(
		"STF 'Kovac'" = "They are sending69essage, \"Come with69oney for69ery good stuff! You can pay with your life, even!\"",
		"SV 'Zoric'" = "They are sending69essage, \"For the correct price, we can sell you something... even jobs!\""
	)
//Types of items sold by the station
	assortiment = list(
		"Guns" = list(
			/obj/item/gun/projectile/boltgun/serbian = custom_good_amount_range(list(1, 10)),
			/obj/item/gun/projectile/shotgun/bojevic = custom_good_amount_range(list(-5, 2)),
			/obj/item/gun/projectile/automatic/ak47/sa = custom_good_amount_range(list(-5, 2)),
			/obj/item/gun/projectile/kovacs = custom_good_amount_range(list(-5, 2)),
			/obj/item/gun/projectile/automatic/lmg/pk = custom_good_amount_range(list(-8, 1)),
			/obj/item/ammo_magazine/sllrifle,
			/obj/item/ammo_magazine/lrifle,
			/obj/item/ammo_magazine/lrifle/pk = custom_good_amount_range(list(-4, 1)),
			/obj/item/ammo_magazine/m12/empty,
			/obj/item/ammo_magazine/ammobox/shotgun,
			/obj/item/ammo_magazine/ammobox/shotgun/buckshot,
			/obj/item/ammo_magazine/ammobox/shotgun/incendiaryshells
		),
	)
