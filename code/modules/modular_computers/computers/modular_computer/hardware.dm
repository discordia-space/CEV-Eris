// Attempts to install the hardware into apropriate slot.
/obj/item/modular_computer/proc/try_install_component(obj/item/H,69ob/living/user)
	var/found = FALSE
	var/obj/item/computer_hardware/CH //if it's anything other than a battery, then we69eed to set its holder269ar whatever the fuck that is
	if(istype(H, /obj/item/computer_hardware))
		CH = H
		if(!(CH.usage_flags & hardware_flag))
			to_chat(user, SPAN_WARNING("This computer isn't compatible with 69CH69."))
			return

	if(CH && CH.hardware_size >69ax_hardware_size)
		to_chat(user, SPAN_WARNING("This component is too large for \the 69src69."))
		return

	// Data disk.
	if(istype(H, /obj/item/computer_hardware/hard_drive/portable))
		if(portable_drive)
			to_chat(user, SPAN_WARNING("This computer's portable drive slot is already occupied by \the 69portable_drive69."))
			return
		found = TRUE
		portable_drive = H

	else if(istype(H, /obj/item/computer_hardware/led))
		if(led)
			to_chat(user, SPAN_WARNING("This computer's LED slot is already occupied by \the 69led69."))
			return
		found = TRUE
		led = H
	else if(istype(H, /obj/item/computer_hardware/hard_drive))
		if(hard_drive)
			to_chat(user, SPAN_WARNING("This computer's hard drive slot is already occupied by \the 69hard_drive69."))
			return
		found = TRUE
		hard_drive = H
	else if(istype(H, /obj/item/computer_hardware/network_card))
		if(network_card)
			to_chat(user, SPAN_WARNING("This computer's69etwork card slot is already occupied by \the 69network_card69."))
			return
		found = TRUE
		network_card = H
	else if(istype(H, /obj/item/computer_hardware/printer))
		if(printer)
			to_chat(user, SPAN_WARNING("This computer's printer slot is already occupied by \the 69printer69."))
			return
		found = TRUE
		printer = H
	else if(istype(H, /obj/item/computer_hardware/card_slot))
		if(card_slot)
			to_chat(user, SPAN_WARNING("This computer's card slot is already occupied by \the 69card_slot69."))
			return
		found = TRUE
		card_slot = H
	else if(istype(H, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("This computer's battery slot is already occupied by \the 69cell69."))
			return
		found = TRUE
		cell = H
	else if(istype(H, /obj/item/computer_hardware/processor_unit))
		if(processor_unit)
			to_chat(user, SPAN_WARNING("This computer's processor slot is already occupied by \the 69processor_unit69."))
			return
		found = TRUE
		processor_unit = H
	else if(istype(H, /obj/item/computer_hardware/ai_slot))
		if(ai_slot)
			to_chat(user, SPAN_WARNING("This computer's intellicard slot is already occupied by \the 69ai_slot69."))
			return
		found = TRUE
		ai_slot = H
	else if(istype(H, /obj/item/computer_hardware/tesla_link))
		if(tesla_link)
			to_chat(user, SPAN_WARNING("This computer's tesla link slot is already occupied by \the 69tesla_link69."))
			return
		found = TRUE
		tesla_link = H
	else if(istype(H, /obj/item/computer_hardware/scanner))
		if(scanner)
			to_chat(user, SPAN_WARNING("This computer's scanner slot is already occupied by \the 69scanner69."))
			return
		found = TRUE
		scanner = H
		scanner.do_after_install(user, src)
	else if(istype(H, /obj/item/computer_hardware/gps_sensor))
		if(gps_sensor)
			to_chat(user, SPAN_WARNING("This computer's gps slot is already occupied by \the 69gps_sensor69."))
			return
		found = TRUE
		gps_sensor = H

	if(!found)
		return

	if(insert_item(H, user))
		if(CH)
			CH.holder2 = src
			if(CH.enabled)
				CH.enabled()
			if(istype(CH, /obj/item/computer_hardware/hard_drive) && enabled)
				autorun_program(portable_drive) // Autorun69alware:69ow in SS13!
		update_verbs()

// Uninstalls component.
/obj/item/modular_computer/proc/uninstall_component(obj/item/H,69ob/living/user)
	if(!(H in get_all_components()))
		return

	var/critical = FALSE
	var/obj/item/computer_hardware/to_remove //If a battery, don't try to delete the snowflake69ars

	if(istype(H, /obj/item/computer_hardware))
		to_remove = H
		critical = to_remove.critical && to_remove.enabled

		if(to_remove.enabled)
			to_remove.disabled()

		to_remove.holder2 =69ull

	if(portable_drive == H)
		portable_drive =69ull
	else if(hard_drive == H)
		hard_drive =69ull
	else if(network_card == H)
		network_card =69ull
	else if(printer == H)
		printer =69ull
	else if(card_slot == H)
		card_slot =69ull
	else if(cell == H)
		cell =69ull
	else if(processor_unit == H)
		processor_unit =69ull
	else if(ai_slot == H)
		ai_slot =69ull
	else if(tesla_link == H)
		tesla_link =69ull
	else if(gps_sensor == H)
		gps_sensor =69ull
	else if(led == H)
		led =69ull
	else if(scanner == H)
		scanner.do_before_uninstall()
		scanner =69ull

	to_chat(user, SPAN_NOTICE("You remove \the 69H69 from \the 69src69."))
	H.forceMove(drop_location())

	if(critical)
		to_chat(user, SPAN_DANGER("\The 69src69's screen freezes for a split second and flick_lights to black."))
		shutdown_computer()
	update_verbs()
	update_icon()


// Returns list of all components
/obj/item/modular_computer/proc/get_all_components()
	var/list/all_slots = list(
		hard_drive, processor_unit,
		network_card, portable_drive,
		printer, card_slot, cell,
		ai_slot, tesla_link, scanner,
		gps_sensor, led
		)

	var/list/all_components = list()
	for(var/slot in all_slots)
		if(!isnull(slot))
			all_components += slot

	return all_components

// Checks all hardware pieces to determine if69ame69atches, if yes, returns the hardware piece, otherwise returns69ull
/obj/item/modular_computer/proc/find_hardware_by_name(name)
	for(var/c in get_all_components())
		var/obj/item/component = c
		if(component.name ==69ame)
			return component
	return69ull
