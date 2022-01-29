/datum/trade_station/station_zarya
	name_pool = list(
		"FTB 'Zarya'" = "Free Trade Beacon 'Zarya':\n\"Privet, this is the trade beacon 'Zarya'. We sell electronics, construction, and anything related to engineering! If you are looking for a more general shop, you should contact our main station: FTS 'Solnishko'"
	)
	start_discovered = TRUE
	spawn_always = TRUE
	markup = COMMON_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 16000
	assortiment = list(
		"BO3DYX" = list(
			/obj/item/tank/air,
			/obj/item/tank/plasma,
			/obj/machinery/portable_atmospherics/canister/sleeping_agent,
			/obj/machinery/portable_atmospherics/canister/nitrogen,
			/obj/machinery/portable_atmospherics/canister/oxygen,
			/obj/machinery/portable_atmospherics/canister/air,
			/obj/machinery/portable_atmospherics/canister/carbon_dioxide
		),
		"CHAPR*EHNE" = list(
			/obj/item/clothing/mask/gas,
			/obj/item/clothing/suit/storage/hazardvest,
			/obj/item/clothing/gloves/insulated,
			/obj/item/storage/toolbox/emergency,
			/obj/item/clothing/head/welding,
			/obj/item/storage/belt/utility,
			/obj/item/storage/pouch/engineering_supply,
			/obj/item/storage/pouch/engineering_material,
			/obj/item/storage/pouch/engineering_tools,
			/obj/item/storage/briefcase/inflatable/empty,
			/obj/item/inflatable/door,
			/obj/item/inflatable/wall
		),
		"E/\\EKTPOHNKA" = list(
			/obj/item/electronics/circuitboard/shield_diffuser,
			/obj/item/electronics/circuitboard/shield_generator,
			/obj/item/electronics/circuitboard/long_range_scanner,
			/obj/item/electronics/circuitboard/solar_control,
			/obj/item/electronics/circuitboard/smes,
			/obj/item/electronics/circuitboard/breakerbox,
			/obj/item/electronics/circuitboard/recharger
		),
		"EHEPLNR" = list(
			/obj/item/electronics/tracker,
			/obj/machinery/power/emitter,
			/obj/machinery/power/rad_collector,
			/obj/machinery/power/supermatter,
			/obj/machinery/power/generator,
			/obj/machinery/atmospherics/binary/circulator,
			/obj/item/solar_assembly,
//			/obj/item/tracker_electronics, // broken for now? This is even used for something?
			/obj/machinery/field_generator
		),
		"BCRKAR BCR4NHA" = list(
			/obj/machinery/pipedispenser/orderable,
			/obj/machinery/pipedispenser/disposal/orderable,
//			/obj/machinery/pipelayer, // is this unused for some reason? its broken????
			/obj/item/cell/large,
			/obj/item/cell/large/high,
			/obj/structure/reagent_dispensers/watertank,
			/obj/structure/reagent_dispensers/fueltank,
			/obj/machinery/floodlight
		)
	)
	offer_types = list(
		/obj/item/tool_upgrade = offer_data("tool upgrade", 200, 0),				// base price: 200
		/obj/item/tool/crowbar/onestar = offer_data("onestar crowbar", 1000, 3),
		/obj/item/tool/pickaxe/onestar = offer_data("onestar pickaxe", 1000, 3),
		/obj/item/tool/pickaxe/jackhammer/onestar = offer_data("onestar jackhammer", 1000, 3),
		/obj/item/tool/screwdriver/combi_driver/onestar = offer_data("onestar combi driver", 1000, 3),
		/obj/item/tool/weldingtool/onestar  = offer_data("onestar welding tool", 1000, 3),
		/obj/item/tool_upgrade/augment/repair_nano = offer_data("repair nano", 5000, 1)
	)
