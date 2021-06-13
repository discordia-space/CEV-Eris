/datum/trade_station/station_zarya
	name_pool = list("FTS 'Zarya'" = "Free Trade Station 'Zarya', they sending message \"Privet, this is free station 'Zarya'. We have everything for sale here, don't be afraid to come aboard and check our wares!\".")
	start_discovered = TRUE
	spawn_always = TRUE
	assortiment = list(
		"Vozduh" = list(
			/obj/machinery/portable_atmospherics/canister/sleeping_agent,
			/obj/machinery/portable_atmospherics/canister/nitrogen,
			/obj/machinery/portable_atmospherics/canister/oxygen,
			/obj/item/weapon/tank/plasma,
			/obj/machinery/pipedispenser/orderable,
			/obj/machinery/pipedispenser/disposal/orderable,
		),
		"Energiya" = list(
			/obj/item/weapon/electronics/circuitboard/shield_diffuser,
			/obj/item/weapon/electronics/circuitboard/shield_generator,
			/obj/item/weapon/electronics/circuitboard/long_range_scanner,
			/obj/item/weapon/cell/large,
			/obj/item/weapon/cell/large/high,
			/obj/item/solar_assembly,
			/obj/item/weapon/electronics/circuitboard/solar_control,
			/obj/item/weapon/tracker_electronics,
			/obj/machinery/power/emitter,
			/obj/machinery/power/rad_collector,
			/obj/machinery/power/supermatter,
			/obj/machinery/power/generator,
			/obj/machinery/atmospherics/binary/circulator,
			/obj/item/clothing/gloves/insulated,
		),
		"Vsyakoe" = list(
			/obj/item/organ_module/active/simple/armshield,
			/obj/structure/reagent_dispensers/watertank,
			/obj/item/weapon/storage/briefcase/inflatable/empty,
			/obj/item/inflatable/door,
			/obj/item/inflatable/wall,
			/obj/item/stack/material/steel/full,
			/obj/item/weapon/storage/belt/utility,
			/obj/item/clothing/head/welding,
			/obj/item/weapon/tool/omnitool,
			/obj/structure/reagent_dispensers/fueltank,
			/obj/machinery/floodlight,
			/obj/item/weapon/storage/deferred/disks
		)
	)

	offer_types = list()
