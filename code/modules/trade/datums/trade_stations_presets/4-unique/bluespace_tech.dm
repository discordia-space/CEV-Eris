/datum/trade_station/bluespace_technical
	name_pool = list(
		"B-42-Alpha" = "Unknown signature, bluespace traces interfere with sensors. Unable to triangulate object."
	)
	icon_states = list("htu_station", "station")
	uid = "bluespace"
	tree_x = 0.26
	tree_y = 0.3
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS
	recommendations_needed = 1
	inventory = list(
		"#$285@$532#$@" = list(
			/obj/item/electronics/circuitboard/teleporter,
			/obj/item/tool/knife/dagger/bluespace,
			/obj/item/reagent_containers/glass/beaker/bluespace,
			/obj/item/electronics/circuitboard/bssilk_hub,
			/obj/item/electronics/circuitboard/bssilk_cons,
			/obj/item/bluespace_crystal = custom_good_price(1000)
		)
	)
	hidden_inventory = list(
		"@$@#" = list(
			/obj/item/oddity/broken_necklace = good_data("strange necklace", list(1,1), 2000)
		)
	)
	offer_types = list(
		/obj/item/bluespace_crystal = offer_data("bluespace crystal", 500, 10),
		/obj/item/device/mmi/digital/posibrain = offer_data("positronic brain", 5000, 2)
	)	
