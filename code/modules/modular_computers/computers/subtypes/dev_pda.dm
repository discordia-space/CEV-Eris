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
	price_tag = 50
	suitable_cell = /obj/item/weapon/cell/small //We take small battery
	var/scanner_type = null

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
