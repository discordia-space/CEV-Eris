/datum/trade_station/bluespace_technical
	name_pool = list("B-42-Alpha" = "Unknown signature, bluespace traces interfere with sensors. Unable to triangulate object.")
	uid = "bluespace"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = UNIQUE_GOODS
	recommendations_needed = 1
	assortiment = list(
		"#$285@$532#$@" = list(
			/obj/item/electronics/circuitboard/teleporter,
			/obj/item/tool/knife/dagger/bluespace,
			/obj/item/reagent_containers/glass/beaker/bluespace,
			/obj/item/electronics/circuitboard/bssilk_hub
		)
	)
	offer_types = list(
		/obj/item/bluespace_crystal = offer_data("bluespace crystal", 1000, 10),
		/obj/item/device/mmi/digital/posibrain = offer_data("positronic brain", 2500, 3)
	)	
