/datum/trade_station/serbfrigate
	icon_states = "serb_frigate"
	spawn_cost = 2
	spawn_probability = 10
	commision = 500
	markup = 5
	name_pool = list(
		"STF 'Kovac'" = "Serbia Trade Frigate 'Kovac', *generic description for generic serbians alpha ape males that ain't killing you instantly*",
		"SV 'Zoric'" = "Serbia Vessel 'Zoric' Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
	)

//Types of items sold by the station
	assortiment = list(
		"Suit Stock" = list(
			/obj/item/weapon/storage/backpack/satchel/military = custom_good_amount_range(list(-8,2)),
			/obj/item/weapon/storage/backpack/military = custom_good_amount_range(list(-8,2)),
			/obj/item/weapon/tank/jetpack = custom_good_amount_range(list(-5,2)),
		),
		"First Aids" = list(
			/obj/item/weapon/storage/firstaid/adv,
			/obj/item/weapon/storage/firstaid/combat = custom_good_amount_range(list(-5,2))
		),
		"Ballistics" = list(
			/obj/item/weapon/gun/projectile/boltgun/serbian = custom_good_amount_range(list(1, 10)),
			/obj/item/weapon/gun/projectile/shotgun/bojevic = custom_good_amount_range(list(-5,2)),
			/obj/item/weapon/gun/projectile/automatic/ak47/sa = custom_good_amount_range(list(-5,2)),
			/obj/item/weapon/gun/projectile/kovacs = custom_good_amount_range(list(-5,2)),
			/obj/item/weapon/gun/projectile/automatic/lmg/pk = custom_good_amount_range(list(-8,1)),

			/obj/item/ammo_magazine/sllrifle,
			/obj/item/ammo_magazine/lrifle,
			/obj/item/ammo_magazine/lrifle/pk = custom_good_amount_range(list(-4,1)),

			/obj/item/ammo_magazine/m12/empty,

			/obj/item/weapon/storage/box/shotgunammo/slug,
			/obj/item/weapon/storage/box/shotgunammo/buckshot,
			/obj/item/weapon/storage/box/shotgunammo/incendiaryshells
		),
	)
	offer_types = list(
	)

