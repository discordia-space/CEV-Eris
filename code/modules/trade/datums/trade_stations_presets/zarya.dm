/datum/trade_station/station_zarya
	name_pool = list(
	"FTB 'Zarya'" = "Free Trade Beacon 'Zarya', they sending message \"Privet, this is the trade beacon 'Zarya'. We selling electronics, construction and anything related to engineering! If you are looking for a more general shop, you should contact our main station: FTS 'Solnishko'")
	start_discovered = TRUE
	spawn_always = TRUE
	assortiment = list(
		"BO3DYX" = list(
			/obj/item/weapon/tank/air,
			/obj/item/weapon/tank/plasma,
			/obj/machinery/portable_atmospherics/canister/sleeping_agent,
			/obj/machinery/portable_atmospherics/canister/nitrogen,
			/obj/machinery/portable_atmospherics/canister/oxygen,
			/obj/machinery/portable_atmospherics/canister/air
		),
		"CHAPR*EHNE" = list(
			/obj/item/clothing/mask/gas,
			/obj/item/clothing/suit/storage/hazardvest,
			/obj/item/clothing/gloves/insulated,
			/obj/item/weapon/storage/toolbox/emergency,
			/obj/item/clothing/head/welding,
			/obj/item/weapon/storage/belt/utility,
			/obj/item/weapon/storage/pouch/engineering_supply,
			/obj/item/weapon/storage/pouch/engineering_tools,
			/obj/item/weapon/storage/briefcase/inflatable/empty,
			/obj/item/inflatable/door,
			/obj/item/inflatable/wall
		),
		"E/\\EKTPOHNKA" = list(
			/obj/item/weapon/electronics/circuitboard/shield_diffuser,
			/obj/item/weapon/electronics/circuitboard/shield_generator,
			/obj/item/weapon/electronics/circuitboard/long_range_scanner,
			/obj/item/weapon/electronics/circuitboard/solar_control,
			/obj/item/weapon/electronics/circuitboard/smes,
			/obj/item/weapon/electronics/circuitboard/breakerbox,
			/obj/item/weapon/electronics/circuitboard/recharger
		),
		"EHEPLNR" = list(
			/obj/item/weapon/electronics/tracker,
			/obj/machinery/power/emitter,
			/obj/machinery/power/rad_collector,
			/obj/machinery/power/supermatter,
			/obj/machinery/power/generator,
			/obj/machinery/atmospherics/binary/circulator,
			/obj/item/solar_assembly,
//			/obj/item/weapon/tracker_electronics, // broken for now? This is even used for something?
			/obj/machinery/field_generator
		),
		"BCRKAR BCR4NHA" = list(
			/obj/machinery/pipedispenser/orderable,
			/obj/machinery/pipedispenser/disposal/orderable,
			/obj/machinery/pipelayer, // is this unused for some reason? its broken????
			/obj/item/weapon/cell/large,
			/obj/item/weapon/cell/large/high,
			/obj/structure/reagent_dispensers/watertank,
			/obj/structure/reagent_dispensers/fueltank,
			/obj/machinery/floodlight
		),
	)
