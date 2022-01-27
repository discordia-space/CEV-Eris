/*
 * Rigsuit upgrades/abilities.
 */

/datum/rig_charge
	var/short_name = "undef"
	var/display_name = "undefined"
	var/product_type = "undefined"
	var/charges = 0

/obj/item/rig_module
	name = "hardsuit upgrade"
	desc = "It looks pretty sciency."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "module"
	matter = list(MATERIAL_STEEL = 15,69ATERIAL_PLASTIC = 20,69ATERIAL_GLASS = 5)
	spawn_tags = SPAWN_TAG_RIG_MODULE
	rarity_value = 5
	bad_type = /obj/item/rig_module

	var/damage = 0
	var/obj/item/rig/holder

	var/module_cooldown = 10
	var/next_use = 0

	var/toggleable                      // Set to 1 for the device to show up as an active effect.
	var/usable                          // Set to 1 for the device to have an on-use effect.
	var/selectable                      // Set to 1 to be able to assign the device as primary system.
	var/redundant                       // Set to 1 to ignore duplicate69odule checking when installing.
	var/permanent                       // If set, the69odule can't be removed.
	var/disruptive = 1                  // Can disrupt by other effects.
	var/activates_on_touch              // If set, unarmed attacks will call engage() on the target.

	var/active                          // Basic69odule status
	var/disruptable                     // Will deactivate if some other powers are used.

	var/use_power_cost = 0              // Power used when single-use ability called.
	var/active_power_cost = 0           // Power used when turned on.
	var/passive_power_cost = 0        // Power used when turned off.

	var/list/charges                    // Associative list of charge types and remaining numbers.
	var/charge_selected                 // Currently selected option used for charge dispensing.

	// Icons.
	var/suit_overlay
	var/suit_overlay_active             // If set, drawn over icon and69ob when effect is active.
	var/suit_overlay_inactive           // As above, inactive.
	var/suit_overlay_used               // As above, when engaged.
	var/suit_overlay_mob_only           // Set to 1 for overlay to only display on69ob and not on icon

	//Display fluff
	var/interface_name = "hardsuit upgrade"
	var/interface_desc = "A generic hardsuit upgrade."
	var/engage_string = "Engage"
	var/activate_string = "Activate"
	var/deactivate_string = "Deactivate"

	var/list/stat_rig_module/stat_modules = new()

/obj/item/rig_module/get_cell()
	holder = get_rig()
	return holder?.get_cell()

/obj/item/rig_module/Destroy()
	if (holder)
		holder.uninstall(src)
		holder = null
	return ..()



/obj/item/rig_module/examine()
	..()
	switch(damage)
		if(0)
			to_chat(usr, "It is undamaged.")
		if(1)
			to_chat(usr, "It is badly damaged.")
		if(2)
			to_chat(usr, "It is almost completely destroyed.")

/obj/item/rig_module/attackby(obj/item/W,69ob/user)

	if(istype(W,/obj/item/stack/nanopaste))

		if(damage == 0)
			to_chat(user, "There is no damage to69end.")
			return

		to_chat(user, "You start69ending the damaged portions of \the 69src69...")

		if(!do_after(user,30,src) || !W || !src)
			return

		var/obj/item/stack/nanopaste/paste = W
		damage = 0
		to_chat(user, "You69end the damage to 69src69 with 69W69.")
		paste.use(1)
		return

	else if(istype(W,/obj/item/stack/cable_coil))

		switch(damage)
			if(0)
				to_chat(user, "There is no damage to69end.")
				return
			if(2)
				to_chat(user, "There is no damage that you are capable of69ending with such crude tools.")
				return

		var/obj/item/stack/cable_coil/cable = W
		if(!cable.amount >= 5)
			to_chat(user, "You need five units of cable to repair \the 69src69.")
			return

		to_chat(user, "You start69ending the damaged portions of \the 69src69...")
		if(!do_after(user,30,src) || !W || !src)
			return

		damage = 1
		to_chat(user, "You69end some of damage to 69src69 with 69W69, but you will need69ore advanced tools to fix it completely.")
		cable.use(5)
		return
	..()

/obj/item/rig_module/New()
	..()
	if(suit_overlay_inactive)
		suit_overlay = suit_overlay_inactive

	if(charges && charges.len)
		var/list/processed_charges = list()
		for(var/list/charge in charges)
			var/datum/rig_charge/charge_dat = new

			charge_dat.short_name   = charge69169
			charge_dat.display_name = charge69269
			charge_dat.product_type = charge69369
			charge_dat.charges      = charge69469

			if(!charge_selected) charge_selected = charge_dat.short_name
			processed_charges69charge_dat.short_name69 = charge_dat

		charges = processed_charges

	stat_modules +=	new/stat_rig_module/activate(src)
	stat_modules +=	new/stat_rig_module/deactivate(src)
	stat_modules +=	new/stat_rig_module/engage(src)
	stat_modules +=	new/stat_rig_module/select(src)
	stat_modules +=	new/stat_rig_module/charge(src)


//Called before the69odule is installed in a suit
//Return FALSE to deny the installation
/obj/item/rig_module/proc/can_install(var/obj/item/rig/rig,69ar/mob/user,69ar/feedback = FALSE)
	return TRUE

//Called before the69odule is removed from a suit
//Return FALSE to deny the removal
/obj/item/rig_module/proc/can_uninstall(var/obj/item/rig/rig,69ar/mob/user,69ar/feedback = FALSE)
	return TRUE

// Called after the69odule is installed into a suit. The holder69ar is already set to the new suit
/obj/item/rig_module/proc/installed(var/mob/living/user)
	return

// Called after the69odule is removed from a suit.
//The holder69ar is already set null
//Former contains the suit we came from
/obj/item/rig_module/proc/uninstalled(var/obj/item/rig/former,69ar/mob/living/user)
	return




//Proc for one-use abilities like teleport.
/obj/item/rig_module/proc/engage()

	if(damage >= 2)
		to_chat(usr, SPAN_WARNING("The 69interface_name69 is damaged beyond use!"))
		return 0

	if(world.time < next_use)
		to_chat(usr, SPAN_WARNING("You cannot use the 69interface_name69 again so soon."))
		return 0

	if(!holder || holder.canremove)
		to_chat(usr, SPAN_WARNING("The suit is not initialized."))
		return 0

	if(holder.wearer.lying || holder.wearer.stat || holder.wearer.stunned || holder.wearer.paralysis || holder.wearer.weakened)
		to_chat(usr, SPAN_WARNING("You cannot use the suit in this state."))
		return 0

	if(holder.wearer && holder.wearer.lying)
		to_chat(usr, SPAN_WARNING("The suit cannot function while the wearer is prone."))
		return 0

	if(holder.security_check_enabled && !holder.check_suit_access(usr))
		to_chat(usr, SPAN_DANGER("Access denied."))
		return 0

	if(!holder.check_power_cost(usr, use_power_cost, 0, src, (istype(usr,/mob/living/silicon ? 1 : 0) ) ) )
		return 0

	next_use = world.time +69odule_cooldown

	return 1

// Proc for toggling on active abilities.
/obj/item/rig_module/proc/activate()

	if(active || !engage())
		return 0

	active = 1

	spawn(1)
		if(suit_overlay_active)
			suit_overlay = suit_overlay_active
		else
			suit_overlay = null
		holder.update_icon()

	return 1

// Proc for toggling off active abilities.
/obj/item/rig_module/proc/deactivate()

	if(!active)
		return 0

	active = 0

	spawn(1)
		if(suit_overlay_inactive)
			suit_overlay = suit_overlay_inactive
		else
			suit_overlay = null
		if(holder)
			holder.update_icon()

	return 1


// Called by the hardsuit each rig process tick.
/obj/item/rig_module/Process()
	if(active)
		return active_power_cost
	else
		return passive_power_cost

// Called by holder rigsuit attackby()
// Checks if an item is usable with this69odule and handles it if it is
/obj/item/rig_module/proc/accepts_item(var/obj/item/input_device)
	return 0

/mob/living/carbon/human/Stat()
	. = ..()

	if(. && istype(back,/obj/item/rig))
		var/obj/item/rig/R = back
		SetupStat(R)

/mob/proc/SetupStat(var/obj/item/rig/R)
	if(R && !R.canremove && R.installed_modules.len && statpanel("Hardsuit69odules"))
		var/cell_status = R.cell ? "69R.cell.charge69/69R.cell.maxcharge69" : "ERROR"
		stat("Suit charge", cell_status)
		for(var/obj/item/rig_module/module in R.installed_modules)
		{
			for(var/stat_rig_module/SRM in69odule.stat_modules)
				if(SRM.CanUse())
					stat(SRM.module.interface_name,SRM)
		}

/stat_rig_module
	parent_type = /atom/movable
	var/module_mode = ""
	var/obj/item/rig_module/module

/stat_rig_module/New(var/obj/item/rig_module/module)
	..()
	src.module =69odule

/stat_rig_module/Destroy()
	if(module)
		module.stat_modules -= src
		module = null
	return ..()

/stat_rig_module/proc/AddHref(var/list/href_list)
	return

/stat_rig_module/proc/CanUse()
	return 0

/stat_rig_module/Click()
	if(CanUse())
		var/list/href_list = list(
							"interact_module" =69odule.holder.installed_modules.Find(module),
							"module_mode" =69odule_mode
							)
		AddHref(href_list)
		module.holder.Topic(usr, href_list)
		return TRUE

/stat_rig_module/DblClick()
	return Click()

/stat_rig_module/activate/New(var/obj/item/rig_module/module)
	..()
	name =69odule.activate_string
	if(module.active_power_cost)
		name += " (69module.active_power_cost*1069A)"
	module_mode = "activate"

/stat_rig_module/activate/CanUse()
	return69odule.toggleable && !module.active

/stat_rig_module/deactivate/New(var/obj/item/rig_module/module)
	..()
	name =69odule.deactivate_string
	// Show cost despite being 0, if it69eans changing from an active cost.
	if(module.active_power_cost ||69odule.passive_power_cost)
		name += " (69module.passive_power_cost*1069P)"

	module_mode = "deactivate"

/stat_rig_module/deactivate/CanUse()
	return69odule.toggleable &&69odule.active

/stat_rig_module/engage/New(var/obj/item/rig_module/module)
	..()
	name =69odule.engage_string
	if(module.use_power_cost)
		name += " (69module.use_power_cost*1069E)"
	module_mode = "engage"

/stat_rig_module/engage/CanUse()
	return69odule.usable

/stat_rig_module/select/New()
	..()
	name = "Select"
	module_mode = "select"

/stat_rig_module/select/CanUse()
	if(module.selectable)
		name =69odule.holder.selected_module ==69odule ? "Selected" : "Select"
		return 1
	return 0

/stat_rig_module/charge/New()
	..()
	name = "Change Charge"
	module_mode = "select_charge_type"

/stat_rig_module/charge/AddHref(var/list/href_list)
	var/charge_index =69odule.charges.Find(module.charge_selected)
	if(!charge_index)
		charge_index = 0
	else
		charge_index = charge_index ==69odule.charges.len ? 1 : charge_index+1

	href_list69"charge_type"69 =69odule.charges69charge_index69

/stat_rig_module/charge/CanUse()
	if(module.charges &&69odule.charges.len)
		var/datum/rig_charge/charge =69odule.charges69module.charge_selected69
		name = "69charge.display_name69 (69charge.charges69C) - Change"
		return 1
	return 0
