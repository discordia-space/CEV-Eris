/obj/item/weapon/circuitboard/neotheology/cloner
	name = T_BOARD("christian cloner")
	build_path = /obj/machinery/neotheology/cloner
	board_type = "machine"
	frame_type = FRAME_VERTICAL
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/scanning_module = 1,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/manipulator = 3,
		/obj/item/weapon/implant/core_implant/cruciform = 1
	)

/obj/item/weapon/circuitboard/neotheology/reader
	name = T_BOARD("cruciform reader")
	build_path = /obj/machinery/neotheology/reader
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/scanning_module = 2,
		/obj/item/weapon/implant/core_implant/cruciform = 1
	)

/obj/item/weapon/circuitboard/neotheology/biocan
	name = T_BOARD("biomass container")
	build_path = /obj/machinery/neotheology/biomass_container
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/matter_bin = 3,
		/obj/item/weapon/implant/core_implant/cruciform = 1
	)
