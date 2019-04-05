// These are basically USB data sticks and may be used to transfer files between devices
/obj/item/weapon/computer_hardware/hard_drive/portable
	name = "basic data crystal"
	desc = "Small crystal with imprinted photonic circuits that can be used to store data. Its capacity is 16 GQ."
	power_usage = 10
	icon_state = "flashdrive_basic"
	hardware_size = 1
	max_capacity = 16
	origin_tech = list(TECH_DATA = 1)

/obj/item/weapon/computer_hardware/hard_drive/portable/advanced
	name = "advanced data crystal"
	desc = "Small crystal with imprinted high-density photonic circuits that can be used to store data. Its capacity is 64 GQ."
	power_usage = 20
	icon_state = "flashdrive_advanced"
	hardware_size = 1
	max_capacity = 64
	origin_tech = list(TECH_DATA = 2)
	price_tag = 15

/obj/item/weapon/computer_hardware/hard_drive/portable/super
	name = "super data crystal"
	desc = "Small crystal with imprinted ultra-density photonic circuits that can be used to store data. Its capacity is 256 GQ."
	power_usage = 40
	icon_state = "flashdrive_super"
	hardware_size = 1
	max_capacity = 256
	origin_tech = list(TECH_DATA = 4)
	price_tag = 20

/obj/item/weapon/computer_hardware/hard_drive/portable/New()
	..()
	stored_files = list()
	recalculate_size()

/obj/item/weapon/computer_hardware/hard_drive/portable/Destroy()
	if(holder2 && (holder2.portable_drive == src))
		holder2.portable_drive = null
	return ..()

/obj/item/weapon/computer_hardware/hard_drive/portable/attackby(obj/item/I, mob/user, params)

	if(istype(I, /obj/item/weapon/pen))
		var/new_name = input(user, "What would you like to label the flash drive?", "Tape labeling") as null|text
		if(isnull(new_name)) return
		new_name = sanitizeSafe(new_name)
		if(new_name)
			SetName("[initial(name)] - '[new_name]'")
			user << SPAN_NOTICE("You label the flash drive '[new_name]'.")
		else
			SetName("[initial(name)]")
			user << SPAN_NOTICE("You scratch off the label.")
		return

	..()