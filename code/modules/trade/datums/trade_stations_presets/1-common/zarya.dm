/datum/trade_station/station_zarya
	name_pool = list(
		"TTB \'Zarya\'" = "Technomancer Trade Beacon \'Zarya\': \"Privet, this is the trade beacon \'Zarya\'. We sell electronics, construction, and anything related to engineering!"
	)
	icon_states = list("htu_station", "station")
	uid = "techno_basic"
	tree_x = 0.26
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 0
	recommendation_threshold = 3000
	stations_recommended = list("techno_adv")
	inventory = list(
		"Design Disks" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/components = good_data("Technomancers ARK-034 Components", list(5, 10), 400),
			/obj/item/computer_hardware/hard_drive/portable/design/adv_tools = good_data("Technomancers IJIRO-451 Advanced Tools", list(5, 10), 1500),
			/obj/item/computer_hardware/hard_drive/portable/design/circuits = good_data("Technomancers ESPO-830 Circuits", list(5, 10), 400),
			/obj/item/computer_hardware/hard_drive/portable/design/conveyors = good_data("Technomancers LAT-018 Logistics", list(5, 10), 300)
		),
		"Atmospherics" = list(
			/obj/item/tank/air,
			/obj/item/tank/plasma,
			/obj/machinery/portable_atmospherics/canister/sleeping_agent = custom_good_price(800),
			/obj/machinery/portable_atmospherics/canister/nitrogen = custom_good_price(400),
			/obj/machinery/portable_atmospherics/canister/oxygen = custom_good_price(400),
			/obj/machinery/portable_atmospherics/canister/air = custom_good_price(400),
			/obj/machinery/portable_atmospherics/canister/carbon_dioxide = custom_good_price(400)
		),
		"Technomancer Supplies" = list(
			/obj/item/clothing/mask/gas,
			/obj/item/clothing/suit/storage/hazardvest,
			/obj/item/clothing/head/hardhat,
			/obj/item/clothing/gloves/insulated,
			/obj/item/storage/toolbox/emergency,
			/obj/item/storage/toolbox/mechanical,
			/obj/item/storage/toolbox/electrical,
			/obj/item/clothing/head/welding,
			/obj/item/clothing/glasses/welding,
			/obj/item/storage/belt/utility,
			/obj/item/storage/pouch/engineering_supply,
			/obj/item/storage/pouch/engineering_material,
			/obj/item/storage/pouch/engineering_tools,
			/obj/item/storage/hcases/engi,
			/obj/item/tool/crowbar,
			/obj/item/tool/screwdriver,
			/obj/item/tool/shovel,
			/obj/item/tool/wirecutters,
			/obj/item/tool/wrench,
			/obj/item/tool/weldingtool,
			/obj/item/tool/tape_roll,
			/obj/item/storage/briefcase/inflatable/empty,
			/obj/item/inflatable/door,
			/obj/item/inflatable/wall,
			/obj/item/storage/box/lights/mixed
		),
		"Electronics" = list(
			/obj/item/electronics/circuitboard/pacman,
			/obj/item/electronics/circuitboard/shield_diffuser,
			/obj/item/electronics/circuitboard/long_range_scanner,
			/obj/item/electronics/circuitboard/solar_control,
			/obj/item/electronics/circuitboard/smes,
			/obj/item/electronics/circuitboard/apc,
			/obj/item/electronics/circuitboard/breakerbox,
			/obj/item/electronics/circuitboard/recharger,
			/obj/item/electronics/circuitboard/batteryrack
		),
		"Power Generation" = list(
			/obj/item/electronics/tracker,
			/obj/machinery/power/emitter,
			/obj/machinery/power/rad_collector,
			/obj/machinery/power/supermatter = custom_good_amount_range(list(1,2)),
			/obj/machinery/power/generator,
			/obj/machinery/atmospherics/binary/circulator,
			/obj/item/solar_assembly
		),
		"Machinery" = list(
			/obj/machinery/pipedispenser/orderable,
			/obj/machinery/pipedispenser/disposal/orderable,
			/obj/structure/reagent_dispensers/watertank,
			/obj/structure/reagent_dispensers/fueltank,
			/obj/machinery/floodlight
		)
	)
	offer_types = list(
		/obj/item/tool_upgrade = offer_data("tool upgrade", 200, 8),									// base price: 200
		/obj/item/tool_upgrade/artwork_tool_mod = offer_data("artistic tool upgrade", 800, 1),
		/obj/item/oddity/common/blueprint = offer_data("strange blueprint", 500, 1),
		/obj/item/oddity/common/old_radio = offer_data("old radio", 500, 1),
		/obj/item/organ/external/robotic = offer_data("any external prosthetic", 400, 8)
	)
