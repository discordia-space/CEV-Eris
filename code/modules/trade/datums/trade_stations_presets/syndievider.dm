/datum/trade_station/syndievider
	name_pool = list("SRS 'Up Link'" = "Syndney Research Station 'Up Link'. The Trade Beacon is sending an automatized message. \"Hey, Buddie. We are interested, we offer better products than NorthTrasen")
	spawn_probability = 10
	spawn_cost = 2
	commision = 600
	markup = 3
	assortiment = list(
		"Items" = list(
			/obj/item/weapon/implantcase/adrenalin,
			/obj/item/weapon/reagent_containers/hypospray/autoinjector/hyperzine,
			/obj/item/clothing/glasses/powered/night,
		),
		"Ballistics" = list(
			/obj/item/weapon/gun/projectile/selfload,
			/obj/item/weapon/gun/projectile/automatic/c20r = custom_good_amount_range(list(1,-5)),
			/obj/item/weapon/gun/energy/crossbow = custom_good_amount_range(list(1,-5))
		),
		"Voidsuit & RIGs" = list(
			/obj/item/clothing/suit/space/void/merc = custom_good_amount_range(list(1,-5)),
			/obj/item/weapon/rig/merc/empty = custom_good_amount_range(list(1,-5))
		),
	)
	offer_types = list(
	)
