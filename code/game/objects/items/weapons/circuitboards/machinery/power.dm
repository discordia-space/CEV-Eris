/obj/item/weapon/circuitboard/smes
	name = T_BOARD("superconductive magnetic energy storage")
	build_path = /obj/machinery/power/smes/buildable
	board_type = "machine"
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)
	req_components = list(
		/obj/item/weapon/smes_coil = 1,
		/obj/item/stack/cable_coil = 30
	)

/obj/item/weapon/circuitboard/batteryrack
	name = T_BOARD("battery rack PSU")
	build_path = /obj/machinery/power/smes/batteryrack
	board_type = "machine"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/weapon/cell/large = 3
	)

/obj/item/weapon/circuitboard/apc
	name = "power control module"
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	desc = "Heavy-duty switching circuits for power control."
	flags = CONDUCT
	build_path = /obj/machinery/power/smes/batteryrack/makeshift
	board_type = "machine"
	req_components = list(
		/obj/item/weapon/cell/large = 3
	)
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 3)