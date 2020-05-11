/obj/item/weapon/circuitboard/chemmaster
	name = T_BOARD("ChemMaster 3000")
	build_path = /obj/machinery/chem_master
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/weapon/stock_parts/scanning_module = 1,
		/obj/item/weapon/reagent_containers/glass/beaker = 2
	)

/obj/item/weapon/circuitboard/chem_heater
	name = T_BOARD("Chemical Heater")
	build_path = /obj/machinery/chem_heater
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/console_screen = 1
	)

/obj/item/weapon/circuitboard/chemical_dispenser
	name = T_BOARD("Chemical Dispenser")
	build_path = /obj/machinery/chemical_dispenser
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/matter_bin = 2,
		/obj/item/weapon/stock_parts/capacitor = 1,
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/weapon/cell/medium = 1
	)
/obj/item/weapon/circuitboard/electrolyzer
	name = T_BOARD("Electrolyzer")
	build_path = /obj/machinery/electrolyzer
	board_type = "machine"
	origin_tech = list(TECH_BIO = 3)
	req_components = list(
		/obj/item/weapon/stock_parts/capacitor = 1,
	)

	