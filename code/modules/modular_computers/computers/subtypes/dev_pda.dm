/obj/item/modular_computer/pda
	name = "PDA"
	desc = "A very compact computer, designed to keep its user always connected."
	icon = 'icons/obj/modular_pda.dmi'
	icon_state = "pda"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_GLASS = 1)
	hardware_flag = PROGRAM_PDA
	max_hardware_size = 1
	w_class = ITEM_SIZE_SMALL
	screen_light_strength = 1.1
	screen_light_range = 2
	slot_flags = SLOT_ID | SLOT_BELT
	stores_pen = TRUE
	stored_pen = /obj/item/weapon/pen
	battery_type = /obj/item/weapon/cell/small //We take small battery
	price_tag = 50

/obj/item/modular_computer/pda/Initialize()
	. = ..()
	enable_computer()

/obj/item/modular_computer/pda/AltClick(var/mob/user)
	if(!CanPhysicallyInteract(user))
		return
	if(card_slot && istype(card_slot.stored_card))
		eject_id()
	else
		..()

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

// PDA types
/obj/item/modular_computer/pda/medical
	icon_state = "pda-m"

/obj/item/modular_computer/pda/chemistry
	icon_state = "pda-m"

/obj/item/modular_computer/pda/engineering
	icon_state = "pda-e"

/obj/item/modular_computer/pda/security
	icon_state = "pda-s"

/obj/item/modular_computer/pda/forensics
	icon_state = "pda-s"

/obj/item/modular_computer/pda/science
	icon_state = "pda-nt"

/obj/item/modular_computer/pda/heads
	name = "command PDA"
	icon_state = "pda-h"

/obj/item/modular_computer/pda/heads/paperpusher
//	stored_pen = /obj/item/weapon/pen/fancy

/obj/item/modular_computer/pda/heads/hop
	icon_state = "pda-hop"

/obj/item/modular_computer/pda/heads/hos
	icon_state = "pda-hos"

/obj/item/modular_computer/pda/heads/ce
	icon_state = "pda-ce"

/obj/item/modular_computer/pda/heads/cmo
	icon_state = "pda-cmo"

/obj/item/modular_computer/pda/heads/rd
	icon_state = "pda-rd"

/obj/item/modular_computer/pda/captain
	icon_state = "pda-c"

/obj/item/modular_computer/pda/ert
	icon_state = "pda-h"

/obj/item/modular_computer/pda/cargo
	icon_state = "pda-sup"

/obj/item/modular_computer/pda/syndicate
	icon_state = "pda-syn"

/obj/item/modular_computer/pda/roboticist
	icon_state = "pda-robot"

/obj/item/modular_computer/pda/Created()
	qdel(processor_unit)
	qdel(battery_module)
	qdel(tesla_link)
	qdel(hard_drive)
	qdel(network_card)
	qdel(scanner)
	qdel(card_slot)
	qdel(gps_sensor)
	qdel(led)