// Attempts to install the hardware into apropriate slot.
/obj/item/modular_computer/proc/try_install_component(obj/item/H, mob/living/user)
	var/obj/item/computer_hardware/comp_to_install = H
	if(!istype(comp_to_install))
		return FALSE
	if(getUsedSpace() + comp_to_install.hardware_size > component_space)
		return FALSE
	user.drop_from_inventory(comp_to_install)
	comp_to_install.forceMove(src)
	for(var/thing in comp_to_install.component_flags)
		addToCategory(thing, comp_to_install)
	comp_to_install.install(src)
	update_verbs()

// Uninstalls component.
/obj/item/modular_computer/proc/uninstall_component(obj/item/H, mob/living/user)
	var/found = FALSE
	for(var/thing in contents)
		if(thing == H)
			found = TRUE
			break
	if(!found)
		return FALSE
	var/obj/item/computer_hardware/comp_to_uninstall = H
	for(var/thing in comp_to_uninstall.component_flags)
		removeFromCategory(thing, comp_to_uninstall)
	comp_to_uninstall.uninstall()



	to_chat(user, SPAN_NOTICE("You remove \the [H] from \the [src]."))
	H.forceMove(drop_location())

	if(critical)
		to_chat(user, SPAN_DANGER("\The [src]'s screen freezes for a split second and flickers to black."))
		shutdown_computer()
	update_verbs()
	update_icon()

/obj/item/modular_computers/proc/getUsedSpace()
	for(var/thing in MODCOMP_ALL_COMPONENTS)
		var/list/referenced_list = attached_components[thing]
		if(referenced_list)
			for(var/obj/item/computer_hardware/hard_piece in referenced_list)
				. += hard_piece.hardware_size

/obj/item/modular_computer/proc/addToCategory(var/category, var/reference)
	if(!category || !reference)
		return FALSE
	if(!attached_components[category])
		attached_components[category] = list(reference)
	else
		var/list/list_ref = attached_components[category]
		list_ref.Add(reference)
	return TRUE

/obj/item/modular_computer/proc/removeFromCategory(var/category, var/reference)
	if(!category || !reference)
		return FALSE
	// didn't exist in the first place
	if(!attached_components[category])
		return TRUE
	var/list/list_ref = attached_components[category]
	list_ref.Remove(reference)
	if(!list_ref.len)
		attached_components[category] = null
	return TRUE

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

// Checks all hardware pieces to determine if name matches, if yes, returns the hardware piece, otherwise returns null
/obj/item/modular_computer/proc/find_hardware_by_name(name)
	for(var/c in get_all_components())
		var/obj/item/component = c
		if(component.name == name)
			return component
	return null
