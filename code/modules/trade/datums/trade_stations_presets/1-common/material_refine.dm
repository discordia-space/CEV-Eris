/datum/trade_station/mat_refinery
	name_pool = list(
		"RS \'Recoll\'" = "Refinery Ship \'Recoll\': \"We accept precious or exotic ores and we sell refined materials in bulk, as well!\""
	)
	icon_states = list("htu_frigate", "ship")
	uid = "materials"
	tree_x = 0.18
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 30
	base_income = 0		// Needs ore to refine
	wealth = 0
	hidden_inv_threshold = 3000
	recommendation_threshold = 0
	stations_recommended = list()
	inventory = list(
		"Refined Materials" = list(
			/obj/item/stack/material/plastic/full = good_data("plastic sheets (x120)", list(3, 5), null),
			/obj/item/stack/material/cardboard/full = good_data("cardboard sheets (x120)", list(3, 5), null),
			/obj/item/stack/material/steel/full = good_data("steel sheets (x120)", list(3, 5), null),
			/obj/item/stack/material/plasteel/full = good_data("plasteel sheets (x120)", list(3, 5), null),
			/obj/item/stack/material/wood/full = good_data("wood planks (x120)", list(3, 5), null),
			/obj/item/stack/material/glass/full = good_data("glass sheets (x120)", list(3, 5), null),
			/obj/item/stack/material/plasma/full = good_data("plasma sheets (x120)", list(3, 5), null)
		)
	)
	hidden_inventory = list(
		"Refined Materials II" = list(
			/obj/item/stack/material/iron/full = good_data("iron ingots (x120)", list(1, 2), null),
			/obj/item/stack/material/silver/full = good_data("silver ingots (x120)", list(1, 2), null),
			/obj/item/stack/material/gold/full = good_data("gold ingots (x120)", list(1, 2), null),
			/obj/item/stack/material/diamond/full = good_data("diamond sheets (x120)", list(1, 2), null),
			/obj/item/stack/material/platinum/full = good_data("platinum sheets (x120)", list(1, 2), null),
			/obj/item/stack/material/osmium/full = good_data("osmium ingots (x120)", list(1, 2), null),
			/obj/item/stack/material/mhydrogen/full = good_data("metallic hydrogen sheets (x120)", list(1, 2), null),
			/obj/item/stack/material/tritium/full = good_data("tritium ingots (x120)", list(1, 2), null),
			/obj/item/stack/material/uranium/full = good_data("uranium sheets (x120)", list(1, 2), null)
		)
	)
	offer_types = list(
		/obj/item/tool/pickaxe = offer_data_mods("modified pickaxe (3 upgrades)", 1400, 2, OFFER_MODDED_TOOL, 3),
		/obj/item/tool/shovel = offer_data_mods("modified shovel (3 upgrades)", 1400, 2, OFFER_MODDED_TOOL, 3),
		/obj/item/tool/pickaxe/onestar = offer_data("one star pickaxe", 5000, 2),
		/obj/item/tool/pickaxe/drill/onestar = offer_data("one star mining drill", 5000, 2),
		/obj/item/tool/pickaxe/jackhammer/onestar = offer_data("one star jackhammer", 5000, 2),
		/obj/item/ore/silver = offer_data("native silver ore", 250, 0),
		/obj/item/ore/gold = offer_data("native gold ore", 320, 0),
		/obj/item/ore/diamond = offer_data("diamonds", 550, 0),
		/obj/item/ore/osmium = offer_data("raw platinum", 330, 0),
		/obj/item/ore/hydrogen = offer_data("raw hydrogen", 250, 0),
	)
