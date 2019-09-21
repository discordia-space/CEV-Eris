/obj/item/modular_computer/pda/install_default_hardware()
	..()

	network_card = new /obj/item/weapon/computer_hardware/network_card/(src)
	hard_drive = new /obj/item/weapon/computer_hardware/hard_drive/small(src)
	processor_unit = new /obj/item/weapon/computer_hardware/processor_unit/small(src)
	card_slot = new /obj/item/weapon/computer_hardware/card_slot(src)
	cell = new /obj/item/weapon/cell/small/moebius/pda(src)
	gps_sensor	= new /obj/item/weapon/computer_hardware/gps_sensor(src)
	led = new /obj/item/weapon/computer_hardware/led(src)
	if(scanner_type)
		scanner = new scanner_type(src)


/obj/item/modular_computer/pda/install_default_programs()
	..()

	hard_drive.store_file(new /datum/computer_file/program/chatclient())
	hard_drive.store_file(new /datum/computer_file/program/email_client())
	hard_drive.store_file(new /datum/computer_file/program/crew_manifest())
	hard_drive.store_file(new /datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new /datum/computer_file/program/records())
	hard_drive.store_file(new /datum/computer_file/program/bounty_board_app())
	if(prob(50)) //harmless tax software
		hard_drive.store_file(new /datum/computer_file/program/uplink())

// PDA types
/obj/item/modular_computer/pda/medical
	icon_state = "pda-m"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/medical

/obj/item/modular_computer/pda/chemistry
	icon_state = "pda-m"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/reagent

/obj/item/modular_computer/pda/engineering
	icon_state = "pda-e"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/atmos

/obj/item/modular_computer/pda/security
	icon_state = "pda-s"

/obj/item/modular_computer/pda/forensics
	icon_state = "pda-s"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/reagent

/obj/item/modular_computer/pda/science
	icon_state = "pda-nt"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/reagent

/obj/item/modular_computer/pda/church
	icon_state = "pda-neo"

/obj/item/modular_computer/pda/heads
	name = "command PDA"
	icon_state = "pda-h"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/paper

/obj/item/modular_computer/pda/heads/paperpusher
//	stored_pen = /obj/item/weapon/pen/fancy

/obj/item/modular_computer/pda/heads/hop
	icon_state = "pda-hop"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/paper

/obj/item/modular_computer/pda/heads/hos
	icon_state = "pda-hos"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/paper

/obj/item/modular_computer/pda/heads/ce
	icon_state = "pda-ce"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/atmos

/obj/item/modular_computer/pda/heads/cmo
	icon_state = "pda-cmo"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/medical

/obj/item/modular_computer/pda/heads/rd
	icon_state = "pda-rd"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/reagent

/obj/item/modular_computer/pda/captain
	icon_state = "pda-c"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/paper

/obj/item/modular_computer/pda/ert
	icon_state = "pda-h"

/obj/item/modular_computer/pda/cargo
	icon_state = "pda-sup"
	scanner_type = /obj/item/weapon/computer_hardware/scanner/paper

/obj/item/modular_computer/pda/syndicate
	icon_state = "pda-syn"

/obj/item/modular_computer/pda/roboticist
	icon_state = "pda-robot"

// PDA box
/obj/item/weapon/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdabox"

/obj/item/weapon/storage/box/PDAs/Initialize()
	. = ..()

	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
