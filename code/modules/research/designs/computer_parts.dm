// Modular computer components

// Data disks
/datum/design/research/item/modularcomponent/portabledrive
	build_type = AUTOLATHE | PROTOLATHE

/datum/design/research/item/modularcomponent/portabledrive/basic
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable
	sort_string = "VBAAJ"

/datum/design/research/item/modularcomponent/portabledrive/advanced
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/advanced
	sort_string = "VBAAK"

/datum/design/research/item/modularcomponent/portabledrive/super
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/super
	sort_string = "VBAAL"


// Hard drives
/datum/design/research/item/modularcomponent/disk
	build_type = AUTOLATHE | PROTOLATHE

/datum/design/research/item/modularcomponent/disk/normal
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/computer_hardware/hard_drive
	sort_string = "VBAAA"

/datum/design/research/item/modularcomponent/disk/advanced
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/advanced
	sort_string = "VBAAB"

/datum/design/research/item/modularcomponent/disk/super
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/super
	sort_string = "VBAAC"

/datum/design/research/item/modularcomponent/disk/cluster
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/cluster
	sort_string = "VBAAD"

/datum/design/research/item/modularcomponent/disk/small
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/small
	sort_string = "VBAAE"

/datum/design/research/item/modularcomponent/disk/micro
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/micro
	sort_string = "VBAAF"


// Network cards
/datum/design/research/item/modularcomponent/netcard
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)

/datum/design/research/item/modularcomponent/netcard/basic
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/computer_hardware/network_card
	sort_string = "VBAAG"

/datum/design/research/item/modularcomponent/netcard/advanced
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/computer_hardware/network_card/advanced
	sort_string = "VBAAH"

/datum/design/research/item/modularcomponent/netcard/wired
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/computer_hardware/network_card/wired
	sort_string = "VBAAI"


// Card slot
/datum/design/research/item/modularcomponent/cardslot
	req_tech = list(TECH_DATA = 2)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/card_slot
	sort_string = "VBAAM"


// Nano printer
/datum/design/research/item/modularcomponent/nanoprinter
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/nano_printer
	sort_string = "VBAAO"


// Tesla link
/datum/design/research/item/modularcomponent/teslalink
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/tesla_link
	sort_string = "VBAAP"


// Processor
/datum/design/research/item/modularcomponent/cpu
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)

/datum/design/research/item/modularcomponent/cpu
	name = "computer processor unit"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/computer_hardware/processor_unit
	sort_string = "VBAAW"

/datum/design/research/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/small
	sort_string = "VBAAX"

/datum/design/research/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	chemicals = list("sacid" = 40)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic
	sort_string = "VBAAY"

/datum/design/research/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic/small
	sort_string = "VBAAZ"
