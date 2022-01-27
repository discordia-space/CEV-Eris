/datum/trade_station/collector
	name_pool = list(
		"RS 'Recoll'" = "Refinery Ship 'Recoll':\n\"Hey! We are a small refinery looking for customers. We accept all types of ores and we sell refined69aterials at cheap prices aswell!\""
	)
	start_discovered = TRUE
	spawn_always = TRUE
	markup = COMMON_GOODS
	markdown = 0		//69eeds to be zero because it can be abused. When a item of type ...stack/material/mat_name/full is split, the69ew item retains the /full subtype and can be sold at the sell price shown.
	base_income = 0		//69eeds ore to refine
	wealth = 0
	offer_limit = 30
	secret_inv_threshold = 48000	// Has69any offers
	assortiment = list(
		"Refined69aterials" = list(
			// Commenting out single stacks of goods because it is possible someone will want to order a bunch at once. Having too69any items on the same tile is problematic.
			// If69iners are bringing back a bunch of ore, some of it is probably going to be smelted anyway.
			/obj/item/stack/material/plastic/full = good_data("plastic sheets (x120)", list(-4, 6)),
			/obj/item/stack/material/cardboard/full = good_data("cardboard sheets (x120)", list(-4, 6)),
			/obj/item/stack/material/steel/full = good_data("steel sheets (x120)", list(-3, 5)),
			/obj/item/stack/material/plasteel/full = good_data("plasteel sheets (x120)", list(-3, 5)),
			/obj/item/stack/material/wood/full = good_data("wood planks (x120)", list(-3, 5)),
			/obj/item/stack/material/glass/full = good_data("glass sheets (x120)", list(-3, 5)),
//			/obj/item/stack/material/iron = good_data("iron ingot (x1)", list(0, 5)),
//			/obj/item/stack/material/silver = good_data("silver ingot (x1)", list(0, 5)),
//			/obj/item/stack/material/gold = good_data("gold ingot (x1)", list(0, 5)),
//			/obj/item/stack/material/diamond = good_data("diamond sheet (x1)", list(0, 5)),
//			/obj/item/stack/material/platinum = good_data("platinum sheet (x1)", list(0, 5)),
//			/obj/item/stack/material/osmium = good_data("osmium ingot (x1)", list(0, 5)),
//			/obj/item/stack/material/mhydrogen = good_data("metallic hydrogen sheet (x1)", list(0, 5)),
//			/obj/item/stack/material/tritium = good_data("tritium ingot (x1)", list(0, 5)),
//			/obj/item/stack/material/uranium = good_data("uranium sheet (x1)", list(0, 5)),
		),
	)
	secret_inventory = list(
		"Refined69aterial Stacks" = list(
			/obj/item/stack/material/iron/full = good_data("iron ingots (x120)", list(1, 2)),
			/obj/item/stack/material/silver/full = good_data("silver ingots (x120)", list(1, 2)),
			/obj/item/stack/material/gold/full = good_data("gold ingots (x120)", list(1, 2)),
			/obj/item/stack/material/diamond/full = good_data("diamond sheets (x120)", list(1, 2)),
			/obj/item/stack/material/platinum/full = good_data("platinum sheets (x120)", list(1, 2)),
			/obj/item/stack/material/osmium/full = good_data("osmium ingots (x120)", list(1, 21)),
			/obj/item/stack/material/mhydrogen/full = good_data("metallic hydrogen sheets (x120)", list(1, 2)),
			/obj/item/stack/material/tritium/full = good_data("tritium ingots (x120)", list(1, 2)),
			/obj/item/stack/material/uranium/full = good_data("uranium sheets (x120)", list(1, 2)),
		)
	)
	offer_types = list(
		// Trash69ats are priced based on expected69alue of sheets. Ores are priced based on smelting results and are priced slightly better than if the processed sheets were being sold directly.
		/obj/item/trash/material/metal = offer_data("scrap69etal", 120, 0),
		/obj/item/trash/material/circuit = offer_data("burnt circuit", 90, 0),
		/obj/item/trash/material/device = offer_data("broken device", 205, 0),
		/obj/item/ore/iron = offer_data("hematite", 20, 0),
		/obj/item/ore/coal = offer_data("raw carbon", 20, 0),
		/obj/item/ore/glass = offer_data("sand", 5, 0),
//		/obj/item/ore/plasma = offer_data("plasma crystals", 80, 0),
		/obj/item/ore/silver = offer_data("native silver ore", 275, 0),
		/obj/item/ore/gold = offer_data("native gold ore", 325, 0),
		/obj/item/ore/diamond = offer_data("diamonds", 450, 0),
		/obj/item/ore/osmium = offer_data("raw platinum", 325, 0),
		/obj/item/ore/hydrogen = offer_data("raw hydrogen", 250, 0),
		/obj/item/ore/uranium = offer_data("pitchblende", 450, 0),
	)
