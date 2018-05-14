/obj/item/weapon/circuitboard/excelsiorshieldwallgen
	name = T_BOARD("excelsior shield wall generator")
	board_type = "machine"
	build_path = /obj/machinery/shieldwallgen/excelsior
	origin_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3, TECH_ILLEGAL = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/subspace/transmitter = 1,
		/obj/item/weapon/stock_parts/subspace/crystal = 1,
		/obj/item/weapon/stock_parts/subspace/amplifier = 1,
		/obj/item/weapon/stock_parts/capacitor = 3,
		/obj/item/stack/cable_coil = 30
	)

/obj/item/weapon/circuitboard/excelsiorautolathe
	name = T_BOARD("excelsior autolathe")
	build_path = /obj/machinery/autolathe/excelsior
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_ILLEGAL = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/matter_bin = 3,
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/console_screen = 1
	)