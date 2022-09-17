// Attempts to install the hardware into apropriate slot.
/obj/item/modular_computer/proc/tryInstallComponent(obj/item/H, mob/living/user)
	var/obj/item/computer_hardware/comp_to_install = H
	if(!istype(comp_to_install))
		return FALSE
	if(getUsedSpace() + comp_to_install.hardware_size > component_space)
		return FALSE
	user.drop_from_inventory(comp_to_install)
	installComponent(H)

// This will always install the object into the computer
/obj/item/modular_computer/proc/installComponent(/obj/item/computer_hardware/to_install)
	comp_to_install.forceMove(src)
	for(var/thing in comp_to_install.component_flags)
		addToCategory(thing, comp_to_install)
	comp_to_install.install(src)
	update_verbs()

// Uninstalls component.
/obj/item/modular_computer/proc/uninstallComponent(obj/item/H, mob/living/user)
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
	comp_to_uninstall.uninstall(user)
	checkCriticalHardware()
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

/obj/item/modular_computer/proc/checkCriticalHardware()
	var/list/to_check_for = getCriticalHardware()
	for(var/thing in to_check_for)
		if(!attached_components[thing])
			shutdown_computer()
			return FALSE
		var/list/ref_list = attached_components[thing]
		var/found_functioning = FALSE
		for(var/obj/item/computer_hardware/hardware_piece in ref_list)
			if(hardware_piece.health < MODCOMP_BROKEN_THRESHOLD)
				continue
			found_functioning = TRUE
		if(!found_functioning)
			shutdown_computer()
			return FALSE
	return TRUE

// returns what this computer really needs to function , override if you want other requirements
/obj/item/modular_computer/proc/getCriticalHardware()
	return list(MODCOMP_PROCESSOR, MODCOMP_HARDDRIVE)

// Returns list of all components
/obj/item/modular_computer/proc/getAllComponents()
	var/list/comps = list()
	for(var/category in attached_components)
		var/list/list_ref = attached_components[category]
		if(list_ref)
			comps.Add(list_ref)
	return comps

// returns a list of all the components in this category
/obj/item/modular_computer/proc/getAllFromCategory(var/category)
	if(!attached_components[category])
		return FALSE
	return attached_components[category]

// Returns all NTnet's that we are connected to currently
/obj/item/modular_computer/proc/getAllConnectedNetworks()
	var/list/net_ids = list()
	for(var/obj/item/computer_hardware/network_card/net_card in getAllFromCategory(MODCOMP_NETCARD))
		if(net_card.health < MODCOMP_BROKEN_THRESHOLD) // broken
			continue
		if(!net_card.enabled) // disabled
			continue
		net_ids |= net_card.network_id
	return net_ids
