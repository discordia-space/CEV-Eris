/obj/item/electronics/circuitboard/miningdrill
	name = T_BOARD("mining drill head")
	build_path = /obj/machinery/mining/deep_drill
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/cell/large = 1
	)
