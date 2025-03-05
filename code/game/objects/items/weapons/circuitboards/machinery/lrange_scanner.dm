#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/electronics/circuitboard/long_range_scanner
	name = T_BOARD("long range scanner")
	board_type = "machine"
	build_path = /obj/machinery/power/shipside/long_range_scanner
	matter = list(MATERIAL_GLASS = 3, MATERIAL_GOLD = 3)
	origin_tech = list(TECH_BLUESPACE = 5, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 2,
							/obj/item/bluespace_crystal = 1,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/console_screen = 1)


/obj/item/electronics/circuitboard/scanner_conduit
	name = T_BOARD("scanner conduit")
	board_type = "machine"
	build_path = /obj/machinery/power/conduit/scanner_conduit
	matter = list(MATERIAL_GLASS = 3, MATERIAL_GOLD = 3)
	origin_tech = list(TECH_BLUESPACE = 3, TECH_POWER = 4)
	req_components = list(
							/obj/item/stock_parts/subspace/crystal = 1,
							/obj/item/stock_parts/subspace/amplifier = 1,
							/obj/item/stock_parts/smes_coil = 1,
							/obj/item/stock_parts/capacitor = 2)