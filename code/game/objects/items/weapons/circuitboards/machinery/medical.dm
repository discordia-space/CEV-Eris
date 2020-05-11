/*/obj/item/weapon/circuitboard/autodoc
	name = T_BOARD("autodoc")
	build_path = /obj/machinery/autodoc
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
		/obj/item/weapon/stock_parts/scanning_module = 2,
		/obj/item/weapon/stock_parts/manipulator = 4,
		/obj/item/weapon/stock_parts/console_screen = 2,
		/obj/item/weapon/stock_parts/micro_laser = 2
)*/
/obj/item/weapon/circuitboard/sleeper
	name = T_BOARD("sleeper")
	build_path = /obj/machinery/sleeper
	board_type = "machine"
	origin_tech = list(TECH_BIO = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/scanning_module = 2,
		/obj/item/weapon/stock_parts/manipulator = 2,
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/weapon/stock_parts/micro_laser = 2,
		/obj/item/weapon/reagent_containers/glass/beaker/large = 1
		)