/obj/item/electronics/circuitboard/dna_console
	name = T_BOARD("chrysalis controller")
	build_path = /obj/machinery/dna/console
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	req_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/electronics/circuitboard/cryo_slab
	name = T_BOARD("chrysalis")
	build_path = /obj/machinery/cryo_slab
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 5)
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/scanning_module = 4)

/obj/item/electronics/circuitboard/moeballs_printer
	name = T_BOARD("regurgitator")
	build_path = /obj/machinery/dna/moeballs_printer
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 4)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/manipulator = 2)
