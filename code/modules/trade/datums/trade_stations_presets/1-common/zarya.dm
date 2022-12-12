/datum/trade_station/station_zarya
	name_pool = list(
		"TTB \'Zarya\'" = "Technomancer Trade Beacon \'Zarya\': \"Privet, this is the trade beacon \'Zarya\'. We sell electronics, construction, and anything related to engineering!"
	)
	icon_states = list("htu_station", "station")
	uid = "techno_basic"
	tree_x = 0.1
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 0
	recommendation_threshold = 0
	stations_recommended = list()
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
		"Supplies" = list(
			/obj/item/clothing/mask/gas,
			/obj/item/clothing/suit/storage/hazardvest,
			/obj/item/clothing/head/hardhat,
			/obj/item/clothing/gloves/insulated,
			/obj/item/clothing/head/welding,
			/obj/item/clothing/glasses/welding,
			/obj/item/storage/belt/utility,
			/obj/item/storage/pouch/engineering_supply,
			/obj/item/storage/pouch/engineering_material,
			/obj/item/storage/pouch/engineering_tools,
			/obj/item/storage/hcases/engi,
			/obj/item/storage/box/lights/mixed,
			/obj/item/storage/briefcase/inflatable
		),
		"Tools" = list(
			/obj/item/tool/crowbar,
			/obj/item/tool/screwdriver,
			/obj/item/tool/shovel,
			/obj/item/tool/wirecutters,
			/obj/item/tool/wirecutters/pliers,
			/obj/item/tool/wrench,
			/obj/item/tool/weldingtool,
			/obj/item/tool/tape_roll,
			/obj/item/storage/toolbox/emergency,
			/obj/item/storage/toolbox/mechanical,
			/obj/item/storage/toolbox/electrical
		),
		"Electronics" = list(
			/obj/item/electronics/airlock,
			/obj/item/electronics/airlock/secure,
			/obj/item/electronics/airalarm,
			/obj/item/electronics/firealarm,
			/obj/item/electronics/circuitboard/apc,
			/obj/item/electronics/circuitboard/recharger,
			/obj/item/electronics/circuitboard/autolathe,
			/obj/item/electronics/circuitboard/autolathe_disk_cloner,
			/obj/item/electronics/circuitboard/smelter,
			/obj/item/electronics/circuitboard/sorter,
			/obj/item/electronics/circuitboard/crafting_station
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
			/obj/machinery/floodlight,
			/obj/item/construct/conveyor = custom_good_price(50),
			/obj/item/construct/conveyor_switch = custom_good_price(50)
		)
	)
	offer_types = list(
		/obj/item/tool_upgrade/artwork_tool_mod = offer_data("artistic tool upgrade", 800, 1),
		/obj/item/tool_upgrade/augment/randomizer = offer_data("BSL \"Randomizer\" tool polish", 1600, 2),
		/obj/item/oddity/common/blueprint = offer_data("strange blueprint", 500, 1),
		/obj/item/oddity/common/old_radio = offer_data("old radio", 500, 1),
		/obj/item/organ/external/robotic = offer_data("any external prosthetic", 400, 8),
		/obj/item/tool/crowbar = offer_data_mods("modified crowbar (6 upgrades)", 2800, 2, OFFER_MODDED_TOOL, 6),
		/obj/item/tool/screwdriver = offer_data_mods("modified screwdriver (6 upgrades)", 2800, 2, OFFER_MODDED_TOOL, 6),
		/obj/item/tool/shovel = offer_data_mods("modified shovel (6 upgrades)", 2800, 2, OFFER_MODDED_TOOL, 6),
		/obj/item/tool/wirecutters = offer_data_mods("modified wirecutters (6 upgrades)", 2800, 2, OFFER_MODDED_TOOL, 6),
		/obj/item/tool/wrench = offer_data_mods("modified wrench (6 upgrades)", 2800, 2, OFFER_MODDED_TOOL, 6),
		/obj/item/tool/weldingtool = offer_data_mods("modified welding tool (6 upgrades)", 2800, 2, OFFER_MODDED_TOOL, 6),
		/obj/item/oddity/techno = offer_data("unknown technological part", 3200, 2)
	)
