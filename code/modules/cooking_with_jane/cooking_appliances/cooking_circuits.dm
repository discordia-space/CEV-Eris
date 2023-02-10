/obj/item/electronics/circuitboard/cooking_with_jane/stove
	name = "Circuit board (Blue-Ink Stovetop)"
	build_path = /obj/machinery/cooking_with_jane/stove
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/manipulator = 2, //Affects the food quality
		/obj/item/stock_parts/scanning_module = 4,
	)

/obj/item/electronics/circuitboard/cooking_with_jane/oven
	name = "Circuit board (Blue-Ink Convection Oven)"
	build_path = /obj/machinery/cooking_with_jane/oven
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2, //Affects the food quality
		/obj/item/stock_parts/scanning_module = 4,
	)

/obj/item/electronics/circuitboard/cooking_with_jane/grill
	name = "Circuit board (Blue-Ink Charcoal Grill)"
	build_path = /obj/machinery/cooking_with_jane/grill
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2, //Affects the food quality
		/obj/item/stock_parts/matter_bin = 2, //Affects wood hopper size
		/obj/item/stock_parts/scanning_module = 4,
	)
