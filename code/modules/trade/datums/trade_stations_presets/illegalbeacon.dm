/datum/trade_station/illegaltrader
	name_pool = list("NSTB 'Arau'" = "Null-Space Trade Beacon 'Arau'. The Trade Beacon is sending an automatized message. \"Hey, Buddie. Interested in our legal goods?")
	spawn_probability = 5
	spawn_cost = 2
	markup = 2
	assortiment = list(
		"Ballistics" = list(
			/obj/item/gun/projectile/selfload,
			/obj/item/gun/projectile/automatic/c20r = custom_good_amount_range(list(-3, 1)),
			/obj/item/gun/energy/crossbow = custom_good_amount_range(list(-3, 1))
		),
		"Useful stuff" = list(
			/obj/item/reagent_containers/hypospray/autoinjector/hyperzine,
			/obj/item/clothing/glasses/powered/night,
			/obj/item/clothing/suit/space/void/merc = custom_good_amount_range(list(-3, 1)),
			/obj/item/rig/merc/empty = custom_good_amount_range(list(-3, 1))
		),
	)
