/obj/machinery/autolathe/bioprinter
	name = "NeoTheology Bioprinter"
	desc = "NeoTheology machine for printing things using biomass."
	icon_state = "bioprinter"
	circuit = /obj/item/weapon/circuitboard/neotheology/bioprinter

	build_type = AUTOLATHE | BIOPRINTER
	unsuitable_materials = list()

/obj/machinery/autolathe/bioprinter/disk
	default_disk = /obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_bioprinter

/obj/machinery/autolathe/bioprinter/public
	default_disk = /obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_bioprinter_public
