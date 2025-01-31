#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif
// New shields
/obj/item/electronics/circuitboard/shield_generator
	name = T_BOARD("hull shield generator")
	board_type = "machine"
	build_path = /obj/machinery/power/shipside/shield_generator
	matter = list(MATERIAL_GLASS = 2, MATERIAL_GOLD = 1)
	origin_tech = list(TECH_ENGINEERING = 4, TECH_BLUESPACE = 4)
	req_components = list(
							/obj/item/stock_parts/micro_laser = 1,
							/obj/item/stock_parts/subspace/crystal = 1,  //might be changed to the Catalyst in furure Techno updates
							/obj/item/stock_parts/subspace/transmitter = 1,
							/obj/item/stock_parts/console_screen = 1)


/obj/item/electronics/circuitboard/shield_conduit
	name = T_BOARD("shield conduit")
	board_type = "machine"
	build_path = /obj/machinery/power/conduit/shield_conduit
	matter = list(MATERIAL_GLASS = 2, MATERIAL_GOLD = 1)
	origin_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	req_components = list(
							/obj/item/stock_parts/capacitor = 4,
							/obj/item/stock_parts/smes_coil = 1,
							/obj/item/stack/cable_coil = 10)


/obj/item/electronics/circuitboard/shield_diffuser
	name = T_BOARD("shield diffuser")
	board_type = "machine"
	build_path = /obj/machinery/shield_diffuser
	origin_tech = list(TECH_MAGNET = 4, TECH_POWER = 2)
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/micro_laser = 1)


/obj/item/electronics/circuitboard/shieldwallgen
	name = T_BOARD("shield wall generator")
	board_type = "machine"
	matter = list(MATERIAL_GLASS = 2, MATERIAL_GOLD = 1)
	build_path = /obj/machinery/shieldwallgen
	origin_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	req_components = list(
		/obj/item/stock_parts/subspace/transmitter = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/subspace/amplifier = 1,
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stack/cable_coil = 30
	)