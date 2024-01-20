/obj/item/electronics/circuitboard/crafting_station
	name = T_BOARD("crafting station")
	build_path = /obj/machinery/autolathe/crafting_station
	board_type = "machine"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1
	)
