/datum/trade_station/rigvider
	name_pool = list(
		"ATB \'Boris\'" = "Aster\'s Trade Beacon \'Boris\': \"Hello there, we are hardsuit salvagers. We will be around the system for some time and we have leftover stock. We can sell some off if you want them."
	)
	icon_states = list("htu_station", "station")
	uid = "rigs"
	tree_x = 0.66
	tree_y = 0.7
	start_discovered = FALSE
	spawn_always = TRUE
	markup = COMMON_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("illegal1")
	recommendations_needed = 1
	inventory = list(
		"RIGs" =  list(
			/obj/item/rig/medical = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/hazmat = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/hazard = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/industrial = custom_good_amount_range(list(1, 5))
		),
		"RIG Specialized Modules" = list(
			/obj/item/rig_module/storage = good_data("Internal Storage compartment", list(1, 10), null),
			/obj/item/rig_module/maneuvering_jets = good_data("Mounted Jetpack", list(1, 10), null),
			/obj/item/rig_module/device/flash = good_data("Mounted Flash", list(1, 10), null),
			/obj/item/rig_module/mounted/egun = good_data("Mounted Energy Gun", list(1, 10), null),
			/obj/item/rig_module/mounted/taser = good_data("Mounted Taser", list(1, 10), null),
			/obj/item/rig_module/device/drill = good_data("Mounted Drill", list(1, 10), null),
			/obj/item/rig_module/device/orescanner = good_data("Mounted Ore Scanner", list(1, 10), null),
			/obj/item/rig_module/device/anomaly_scanner = good_data("Mounted Anomaly Scanner", list(1,10), null),
			/obj/item/rig_module/device/rcd = good_data("Mounted RCD", list(1, 10), null),
			/obj/item/rig_module/device/healthscanner = good_data("Mounted Health Scanner", list(1, 10), null),
			/obj/item/rig_module/modular_injector,
			/obj/item/rig_module/ai_container,
			/obj/item/rig_module/power_sink,
			/obj/item/rig_module/vision/meson,
			/obj/item/rig_module/vision/nvg,
			/obj/item/rig_module/vision/sechud,
			/obj/item/rig_module/vision/medhud
		)
	)
	hidden_inventory = list(
		"RIGs II" =  list(
			/obj/item/rig/light = custom_good_amount_range(list(1, 5)),
			/obj/item/rig_module/held/shield,
			/obj/item/rig_module/datajack,
			/obj/item/rig_module/electrowarfare_suite,
			/obj/item/rig_module/modular_injector/combat,
			/obj/item/rig_module/modular_injector/medical,
			/obj/item/rig_module/cape
		)
	)
	offer_types = list(
		/obj/item/rig/merc = offer_data("crimson hardsuit control module", 10000, 1),						// base price: 6282 (incl. components)
		/obj/item/stock_parts/capacitor/one_star = offer_data("one star capacitor", 1000, 3),
		/obj/item/stock_parts/scanning_module/one_star = offer_data("one star scanning module", 1000, 3),
		/obj/item/stock_parts/manipulator/one_star = offer_data("one star manipulator", 1000, 3),
		/obj/item/stock_parts/micro_laser/one_star = offer_data("one star micro-laser", 1000, 3),
		/obj/item/stock_parts/matter_bin/one_star = offer_data("one star matter bin", 1000, 3)
	)
