/obj/item/electronics/circuitboard/miningturret
	name = T_BOARD("mining turret")
	build_path = /obj/machinery/porta_turret/mining
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/cell/large = 1
	)
