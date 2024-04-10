/obj/item/electronics/circuitboard/cooking_with_jane/stove
	name = "Circuit board (Stovetop)"
	build_path = /obj/machinery/cooking_with_jane/stove
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/manipulator = 2, //Affects the food quality
	)

/obj/item/electronics/circuitboard/cooking_with_jane/oven
	name = "Circuit board (Convection Oven)"
	build_path = /obj/machinery/cooking_with_jane/oven
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2, //Affects the food quality
	)

/obj/item/electronics/circuitboard/cooking_with_jane/grill
	name = "Circuit board (Charcoal Grill)"
	build_path = /obj/machinery/cooking_with_jane/grill
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2, //Affects the food quality
		/obj/item/stock_parts/matter_bin = 2, //Affects wood hopper size
	)
