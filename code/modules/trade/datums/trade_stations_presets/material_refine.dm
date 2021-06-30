/datum/trade_station/collector
	start_discovered = TRUE
	markup = 0.6 // 1,08
	spawn_probability = 66
	name_pool = list("CRS 'Recollekt'" = "Civilian Refinery Ship 'Recollekt'. They're sending a message. \"Heey! We are a small refinery looking for customers. We accept all types of ores and we sell refined materials at cheap prices aswell!\"")
	assortiment = list(
		"Unrefined Materials"  = list(
			/obj/item/weapon/ore,
			/obj/item/weapon/ore/uranium = custom_good_amount_range(list(1, 5)),
			/obj/item/weapon/ore/iron,
			/obj/item/weapon/ore/coal,
			/obj/item/weapon/ore/glass,
			/obj/item/weapon/ore/plasma = custom_good_amount_range(list(1, 5)),
			/obj/item/weapon/ore/silver,
			/obj/item/weapon/ore/gold,
			/obj/item/weapon/ore/diamond = custom_good_amount_range(list(1, 5)),
			/obj/item/weapon/ore/osmium = custom_good_amount_range(list(1, 5)),
			/obj/item/weapon/ore/hydrogen = custom_good_amount_range(list(1, 5)),
		),
		"Refined Materials" = list(
			/obj/item/stack/material/iron,
			/obj/item/stack/material/steel,
			/obj/item/stack/material/plasteel,
			/obj/item/stack/material/wood,
			/obj/item/stack/material/glass,
			/obj/item/stack/material/plastic,
			/obj/item/stack/material/diamond = custom_good_amount_range(list(0, 2)),
			/obj/item/stack/material/silver = custom_good_amount_range(list(0,15)),
			/obj/item/stack/material/uranium = custom_good_amount_range(list(0,2)),
		),
	)
	offer_types = list(
	)
