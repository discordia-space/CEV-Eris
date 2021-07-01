/datum/trade_station/nt_cruisers
	icon_states = "nt_cruiser" // Because we lack NT noncombat ships.
	spawn_cost = 2
	spawn_probability = 15
	markup = 1
	name_pool = list(
		"NTV 'Faith'" = "'NeoTheology Vessel 'Faith' something, something, NeoTheology is good, buy us, convert, something something",
		"NTV 'Hope'" = "'NeoTheology Vessel 'Hope' something something, this PR is unfinished and I need feedback something, something."
	)

//Types of items sold by the station
	assortiment = list(
		"Holsters n' Pockets" = list(
			/obj/item/weapon/storage/pouch/small_generic,
			/obj/item/weapon/storage/pouch/medium_generic,
			/obj/item/weapon/storage/pouch/large_generic,
			/obj/item/weapon/storage/pouch/medical_supply,
			/obj/item/weapon/storage/pouch/engineering_tools,
			/obj/item/weapon/storage/pouch/engineering_supply,
			/obj/item/weapon/storage/pouch/tubular,
			/obj/item/weapon/storage/pouch/tubular/vial,
			/obj/item/weapon/storage/pouch/ammo,
			/obj/item/weapon/storage/pouch/medical_supply,
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip
		),
		"Energy Weapon" = list(
			/obj/item/weapon/gun/energy/taser,
			/obj/item/weapon/gun/energy/nt_svalinn,
			/obj/item/weapon/gun/energy/laser = custom_good_amount_range(list(1, 5)),
			/obj/item/weapon/gun/energy/ionrifle = custom_good_amount_range(list(1, 4)),
			/obj/item/weapon/gun/energy/plasma = custom_good_amount_range(list(-3, 2)),
			/obj/item/weapon/gun/energy/plasma/destroyer = custom_good_amount_range(list(-3, 2)),
			/obj/item/weapon/gun/energy/sniperrifle = custom_good_amount_range(list(-8, 1)),
			/obj/item/weapon/gun/energy/crossbow/largecrossbow = custom_good_amount_range(list(-8, 1))
		),
		"Ballistic weapons" = list(
			/obj/item/weapon/gun/projectile/mk58,
			/obj/item/weapon/gun/projectile/mk58/wood = custom_good_name("NT HG .35 \"Mk58\" Wood Version"),
			/obj/item/weapon/gun/projectile/shotgun/pump/regulator,
			/obj/item/weapon/gun/launcher/grenade
		),
	)
	offer_types = list(
	)
