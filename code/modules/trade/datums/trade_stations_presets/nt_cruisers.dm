/datum/trade_station/nt_cruisers
	icon_states = "nt_cruiser"
	markup = 1.2
	name_pool = list(
		"NTV 'Faith'" = "They are sending message, \"The most holy purveyors of ecclesiarchic goods!\"",
		"NTV 'Hope'" = "They are sending message, \"Reliable, blessed and sanctified goods for the correct price.\""
	)
	assortiment = list(
		"Biomatter products" = list(
			/obj/item/reagent_containers/food/snacks/meat,
			/obj/item/reagent_containers/food/drinks/milk,
			/obj/item/soap/nanotrasen,
			/obj/item/storage/pouch/small_generic,
			/obj/item/storage/pouch/medium_generic,
			/obj/item/storage/pouch/large_generic,
			/obj/item/storage/pouch/medical_supply,
			/obj/item/storage/pouch/engineering_tools,
			/obj/item/storage/pouch/engineering_supply,
			/obj/item/storage/pouch/engineering_material,
			/obj/item/storage/pouch/tubular,
			/obj/item/storage/pouch/tubular/vial,
			/obj/item/storage/pouch/ammo,
			/obj/item/storage/pouch/medical_supply,
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip
		),
		"Energy Weapons" = list(
			/obj/item/gun/energy/taser,
			/obj/item/gun/energy/nt_svalinn,
			/obj/item/gun/energy/laser = custom_good_amount_range(list(1, 5)),
			/obj/item/gun/energy/ionrifle = custom_good_amount_range(list(1, 4)),
			/obj/item/gun/energy/plasma = custom_good_amount_range(list(-3, 2)),
			/obj/item/gun/energy/plasma/destroyer = custom_good_amount_range(list(-3, 2)),
			/obj/item/gun/energy/sniperrifle = custom_good_amount_range(list(-8, 1)),
			/obj/item/gun/energy/crossbow/largecrossbow = custom_good_amount_range(list(-8, 1))
		),
		"Ballistic weapons" = list(
			/obj/item/gun/projectile/mk58,
			/obj/item/gun/projectile/mk58/wood,
			/obj/item/gun/projectile/shotgun/pump/regulator,
			/obj/item/gun/projectile/shotgun/pump/grenade
		),
	)
