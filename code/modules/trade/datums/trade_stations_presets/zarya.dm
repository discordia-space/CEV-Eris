/datum/trade_station/station_zarya
	name_pool = list(
	"FTS 'Zarya'" = "Free Trade Station 'Zarya', they sending message \"Privet, this is the trade station 'Zarya'. We focus on selling electronics, construction and anything related to energy! If you are looking for a more general shop, you should contact our main station: The 'Solaris'")
	start_discovered = TRUE
	spawn_always = TRUE
	assortiment = list(
/*
TODO: ADD MORE SHIT? LOOK THAT NOTHING FROM PACK.DM IS MISSING
*/
		"Atmospherics" = list(
			/obj/item/weapon/tank/air,
			/obj/item/weapon/tank/plasma,
			/obj/machinery/portable_atmospherics/canister/sleeping_agent,
			/obj/machinery/portable_atmospherics/canister/nitrogen,
			/obj/machinery/portable_atmospherics/canister/oxygen,
			/obj/machinery/portable_atmospherics/canister/air
		),
		"Equipment" = list(
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
		"Circuit boards" = list(
			/obj/item/weapon/electronics/circuitboard/shield_diffuser,
			/obj/item/weapon/electronics/circuitboard/shield_generator,
			/obj/item/weapon/electronics/circuitboard/long_range_scanner,
			/obj/item/weapon/electronics/circuitboard/solar_control,
			/obj/item/weapon/electronics/circuitboard/smes,
			/obj/item/weapon/electronics/circuitboard/breakerbox,
			/obj/item/weapon/electronics/circuitboard/recharger
		),
		"Power Generators" = list(
			/obj/item/weapon/electronics/tracker,
			/obj/machinery/power/emitter,
			/obj/machinery/power/rad_collector,
			/obj/machinery/power/supermatter,
			/obj/machinery/power/generator,
			/obj/machinery/atmospherics/binary/circulator,
			/obj/item/solar_assembly,
//			/obj/item/weapon/tracker_electronics,
			/obj/machinery/field_generator
		),
		"Unsorted Stock" = list(
			/obj/machinery/pipedispenser/orderable,
			/obj/machinery/pipedispenser/disposal/orderable,
			/obj/machinery/pipelayer, // is this unused for some reason? its broken????
			/obj/item/weapon/cell/large,
			/obj/item/weapon/cell/large/high,
			/obj/structure/reagent_dispensers/watertank,
			/obj/structure/reagent_dispensers/fueltank,
			/obj/item/weapon/storage/box/lights,
			/obj/item/weapon/storage/box/lights/tubes,
			/obj/machinery/floodlight
		),
	)

	offer_types = list(
	)
