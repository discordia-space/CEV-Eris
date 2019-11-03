// Modular computer components
/datum/design/research/item/modularcomponent
	category = CAT_MODCOMP
// Data disks
/datum/design/research/item/modularcomponent/portabledrive
	build_type = AUTOLATHE | PROTOLATHE

/datum/design/research/item/modularcomponent/portabledrive/basic
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/basic
	sort_string = "GAAAA"

/datum/design/research/item/modularcomponent/portabledrive/normal
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable
	sort_string = "GAAAB"

/datum/design/research/item/modularcomponent/portabledrive/advanced
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/advanced
	sort_string = "GAAAC"


// Hard drives
/datum/design/research/item/modularcomponent/disk
	build_type = AUTOLATHE | PROTOLATHE

/datum/design/research/item/modularcomponent/disk/normal
	build_path = /obj/item/weapon/computer_hardware/hard_drive
	sort_string = "VBAAA"

/datum/design/research/item/modularcomponent/disk/advanced
	build_path = /obj/item/weapon/computer_hardware/hard_drive/advanced
	sort_string = "VBAAB"

/datum/design/research/item/modularcomponent/disk/super
	build_path = /obj/item/weapon/computer_hardware/hard_drive/super
	sort_string = "VBAAC"

/datum/design/research/item/modularcomponent/disk/cluster
	build_path = /obj/item/weapon/computer_hardware/hard_drive/cluster
	sort_string = "VBAAD"

/datum/design/research/item/modularcomponent/disk/small
	build_path = /obj/item/weapon/computer_hardware/hard_drive/small
	sort_string = "VBAAE"

/datum/design/research/item/modularcomponent/disk/micro
	build_path = /obj/item/weapon/computer_hardware/hard_drive/micro
	sort_string = "VBAAF"


// Network cards
/datum/design/research/item/modularcomponent/netcard
	build_type = IMPRINTER
	chemicals = list("silicon" = 20)

/datum/design/research/item/modularcomponent/netcard/basic
	build_path = /obj/item/weapon/computer_hardware/network_card
	sort_string = "VBAAG"

/datum/design/research/item/modularcomponent/netcard/advanced
	build_path = /obj/item/weapon/computer_hardware/network_card/advanced
	sort_string = "VBAAH"

/datum/design/research/item/modularcomponent/netcard/wired
	build_path = /obj/item/weapon/computer_hardware/network_card/wired
	sort_string = "VBAAI"


// Card slot
/datum/design/research/item/modularcomponent/cardslot
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/card_slot
	sort_string = "VBAAM"


// Nano printer
/datum/design/research/item/modularcomponent/nanoprinter
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/nano_printer
	sort_string = "VBAAO"


// Tesla link
/datum/design/research/item/modularcomponent/teslalink
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/tesla_link
	sort_string = "VBAAP"


// Processor
/datum/design/research/item/modularcomponent/cpu
	build_type = IMPRINTER
	chemicals = list("silicon" = 20)
	name = "computer processor unit"
	build_path = /obj/item/weapon/computer_hardware/processor_unit
	sort_string = "VBAAW"

/datum/design/research/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	build_path = /obj/item/weapon/computer_hardware/processor_unit/small
	sort_string = "VBAAX"

/datum/design/research/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	chemicals = list("silicon" = 40)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic
	sort_string = "VBAAY"

/datum/design/research/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic/small
	sort_string = "VBAAZ"
