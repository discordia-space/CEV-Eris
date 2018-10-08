/obj/item/modular_computer/tablet
	name = "tablet computer"
	desc = "A small, portable microcomputer."
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet"
	icon_state_unpowered = "tablet"

	icon_state_menu = "menu"
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1
	w_class = ITEM_SIZE_SMALL
	light_strength = 5 // same as PDAs

/obj/item/modular_computer/tablet/lease
	desc = "A small, portable microcomputer. This one has a gold and blue stripe, and a serial number stamped into the case."
	icon_state = "tabletsol"
	icon_state_unpowered = "tabletsol"

/obj/item/modular_computer/tablet/Created()
	qdel(processor_unit)
	qdel(tesla_link)
	qdel(hard_drive)
	qdel(network_card)
	qdel(scanner)