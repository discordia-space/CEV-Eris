/datum/trade_station/nt_cruisers
	icon_states = "nt_cruiser"
	markup = 1.2
	name_pool = list(
		"NTV 'Faith'" = "They are sending message, \"The most holy purveyors of ecclesiarchic goods!\"",
		"NTV 'Hope'" = "They are sending message, \"Reliable, blessed and sanctified goods for the correct price.\""
	)
	assortiment = list(
		"Biomatter products" = list(
			/obj/item/weapon/reagent_containers/food/snacks/meat,
			/obj/item/weapon/reagent_containers/food/drinks/milk,
			/obj/item/weapon/soap/nanotrasen,
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
		"Energy Weapons" = list(
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
			/obj/item/weapon/gun/projectile/mk58/wood,
			/obj/item/weapon/gun/projectile/shotgun/pump/regulator,
			/obj/item/weapon/gun/launcher/grenade
		),
	)
