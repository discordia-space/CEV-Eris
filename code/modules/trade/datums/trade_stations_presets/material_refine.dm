/datum/trade_station/collector
	start_discovered = TRUE
	spawn_always = TRUE
	name_pool = list("CRS 'Reoll'" = "Civilian Refinery Ship 'Recoll'. They're sending a message. \"Heey! We are a small refinery looking for customers. We accept all types of ores and we sell refined materials at cheap prices aswell!\"")
	assortiment = list(
		"Unrefined Materials"  = list(
			/obj/item/weapon/ore,
			/obj/item/weapon/ore/iron,
			/obj/item/weapon/ore/coal,
			/obj/item/weapon/ore/glass,
			/obj/item/weapon/ore/plasma = custom_good_amount_range(list(0, 2)),
			/obj/item/weapon/ore/silver = custom_good_amount_range(list(0, 2)),
			/obj/item/weapon/ore/gold = custom_good_amount_range(list(0, 2)),
			/obj/item/weapon/ore/diamond = custom_good_amount_range(list(0, 2)),
			/obj/item/weapon/ore/osmium = custom_good_amount_range(list(0, 2)),
			/obj/item/weapon/ore/hydrogen = custom_good_amount_range(list(0, 2)),
			/obj/item/weapon/ore/uranium = custom_good_amount_range(list(0, 2))
		),

		"Refined Materials" = list(
			/obj/item/stack/material/plastic/full = good_data("plastic sheets (x120)", list(1, 10)),
			/obj/item/stack/material/cardboard/full = good_data("cardboard sheets (x120)", list(1, 10)),
			/obj/item/stack/material/steel/full = good_data("steel sheets (x120)", list(1, 10)),
			/obj/item/stack/material/plasteel/full = good_data("plasteel sheets (x120)", list(-3, 10)),
			/obj/item/stack/material/wood/full = good_data("wood planks (x120)", list(-3, 10)),
			/obj/item/stack/material/glass/full = good_data("glass sheets (x120)", list(-3, 10)),
			/obj/item/stack/material/platinum = good_data("platinum sheet (x1)", list(0, 3)),
			/obj/item/stack/material/mhydrogen = good_data("metallic hydrogen sheet (x1)", list(0, 1)),
			/obj/item/stack/material/uranium = good_data("uranium sheet (x1)", list(0, 3)),
			/obj/item/stack/material/diamond = good_data("diamond sheet (x1)", list(0, 3)),
			/obj/item/stack/material/iron = good_data("iron ingot (x1)", list(0, 5)),
			/obj/item/stack/material/gold = good_data("gold ingot (x1)", list(0, 2)),
			/obj/item/stack/material/silver = good_data("silver ingot (x1)", list(0, 2)),
			/obj/item/stack/material/tritium = good_data("tritium ingot (x1)", list(0, 2)),
			/obj/item/stack/material/osmium = good_data("osmium ingot (x1)", list(0, 2))
		),
	)
