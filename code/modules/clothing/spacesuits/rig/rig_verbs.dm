// Interface for humans.
/obj/item/rig/verb/hardsuit_interface()

	set name = "Open Hardsuit Interface"
	set desc = "Open the hardsuit system interface."
	set category = "Hardsuit"
	set src = usr.contents

	if(wearer && wearer.back == src)
		ui_interact(usr)

/obj/item/rig/verb/toggle_vision()

	set name = "Toggle69isor"
	set desc = "Turns your rig69isor off or on."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	if(!check_power_cost(usr))
		return

	if(canremove)
		to_chat(usr, SPAN_WARNING("The suit is not active."))
		return

	if(!check_suit_access(usr))
		return

	if(!visor)
		to_chat(usr, SPAN_WARNING("The hardsuit does not have a configurable69isor."))
		return

	if(!visor.active)
		visor.activate()
	else
		visor.deactivate()

/obj/item/rig/proc/toggle_helmet()

	set name = "Toggle Helmet"
	set desc = "Deploys or retracts your helmet."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	if(!check_suit_access(usr))
		return

	toggle_piece("helmet",wearer)

/obj/item/rig/proc/toggle_chest()

	set name = "Toggle Chestpiece"
	set desc = "Deploys or retracts your chestpiece."
	set category = "Hardsuit"
	set src = usr.contents

	if(!check_suit_access(usr))
		return

	toggle_piece("chest",wearer)

/obj/item/rig/proc/toggle_gauntlets()

	set name = "Toggle Gauntlets"
	set desc = "Deploys or retracts your gauntlets."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	if(!check_suit_access(usr))
		return

	toggle_piece("gauntlets",wearer)

/obj/item/rig/proc/toggle_boots()

	set name = "Toggle Boots"
	set desc = "Deploys or retracts your boots."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	if(!check_suit_access(usr))
		return

	toggle_piece("boots",wearer)

/obj/item/rig/verb/deploy_suit()

	set name = "Deploy Hardsuit"
	set desc = "Deploys helmet, gloves and boots."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	if(!check_suit_access(usr))
		return

	if(!check_power_cost(usr))
		return

	deploy(wearer)

/obj/item/rig/verb/toggle_seals_verb()

	set name = "Toggle Hardsuit"
	set desc = "Activates or deactivates your rig."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	if(!check_suit_access(usr))
		return

	toggle_seals(wearer)

/obj/item/rig/verb/switch_vision_mode()

	set name = "Switch69ision69ode"
	set desc = "Switches between available69ision69odes."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	if(canremove)
		to_chat(usr, SPAN_WARNING("The suit is not active."))
		return

	if(!visor)
		to_chat(usr, SPAN_WARNING("The hardsuit does not have a configurable69isor."))
		return

	if(!visor.active)
		visor.activate()

	if(!visor.active)
		to_chat(usr, SPAN_WARNING("The69isor is suffering a hardware fault and cannot be configured."))
		return

	visor.engage()

/obj/item/rig/verb/alter_voice()

	set name = "Configure69oice Synthesiser"
	set desc = "Toggles or configures your69oice synthesizer."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(canremove)
		to_chat(usr, SPAN_WARNING("The suit is not active."))
		return

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	if(!speech)
		to_chat(usr, SPAN_WARNING("The hardsuit does not have a speech synthesiser."))
		return

	speech.engage()

/obj/item/rig/verb/select_module()

	set name = "Select69odule"
	set desc = "Selects a69odule as your primary system."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	if(canremove)
		to_chat(usr, SPAN_WARNING("The suit is not active."))
		return

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	var/list/selectable = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.selectable)
			selectable |=69odule

	var/obj/item/rig_module/module = input("Which69odule do you wish to select?") as null|anything in selectable

	if(!istype(module))
		selected_module = null
		to_chat(usr, "<font color='blue'><b>Primary system is now: deselected.</b></font>")
		return

	selected_module =69odule
	to_chat(usr, "<font color='blue'><b>Primary system is now: 69selected_module.interface_name69.</b></font>")

/obj/item/rig/verb/toggle_module()

	set name = "Toggle69odule"
	set desc = "Toggle a system69odule."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	if(canremove)
		to_chat(usr, SPAN_WARNING("The suit is not active."))
		return

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	var/list/selectable = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.toggleable)
			selectable |=69odule

	var/obj/item/rig_module/module = input("Which69odule do you wish to toggle?") as null|anything in selectable

	if(!istype(module))
		return

	if(module.active)
		to_chat(usr, "<font color='blue'><b>You attempt to deactivate \the 69module.interface_name69.</b></font>")
		module.deactivate()
	else
		to_chat(usr, "<font color='blue'><b>You attempt to activate \the 69module.interface_name69.</b></font>")
		module.activate()

/obj/item/rig/verb/engage_module()

	set name = "Engage69odule"
	set desc = "Engages a system69odule."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(canremove)
		to_chat(usr, SPAN_WARNING("The suit is not active."))
		return

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, SPAN_WARNING("The hardsuit is not being worn."))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	var/list/selectable = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.usable)
			selectable |=69odule

	var/obj/item/rig_module/module = input("Which69odule do you wish to engage?") as null|anything in selectable

	if(!istype(module))
		return

	to_chat(usr, "<font color='blue'><b>You attempt to engage the 69module.interface_name69.</b></font>")
	module.engage()