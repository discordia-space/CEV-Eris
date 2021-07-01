/datum/trade_station/syndievider
	name_pool = list("NSTB 'Arau'" = "Null-Space Trade Beacon 'Arau'. The Trade Beacon is sending an automatized message. \"Hey, Buddie. Interested on something?")
	spawn_probability = 10
	spawn_cost = 2
	markup = 1
	assortiment = list(
		"Ballistics" = list(
			/obj/item/weapon/gun/projectile/selfload,
			/obj/item/weapon/gun/projectile/automatic/c20r = custom_good_amount_range(list(-3, 1)),
			/obj/item/weapon/gun/energy/crossbow = custom_good_amount_range(list(-3, 1))
		),
		"Useful stuff" = list(
			/obj/item/weapon/reagent_containers/hypospray/autoinjector/hyperzine,
			/obj/item/clothing/glasses/powered/night,
			/obj/item/clothing/suit/space/void/merc = custom_good_amount_range(list(-3, 1)),
			/obj/item/weapon/rig/merc/empty = custom_good_amount_range(list(-3, 1))
		),
	)
