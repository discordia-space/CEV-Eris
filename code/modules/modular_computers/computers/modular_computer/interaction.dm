/obj/item/modular_computer/proc/update_verbs()
	verbs.Cut()
	if(ai_slot)
		verbs |= /obj/item/modular_computer/verb/eject_ai
	if(portable_drive)
		verbs |= /obj/item/modular_computer/verb/eject_usb
	if(card_slot && card_slot.stored_card)
		verbs |= /obj/item/modular_computer/verb/eject_id
	if(stores_pen && istype(stored_pen))
		verbs |= /obj/item/modular_computer/verb/remove_pen

	verbs |= /obj/item/verb/verb_pickup
	verbs |= /obj/item/verb/move_to_top

	verbs |= /obj/item/modular_computer/verb/emergency_shutdown

/obj/item/modular_computer/proc/can_interact(var/mob/user)
	if(usr.incapacitated())
		to_chat(user, "<span class='warning'>You can't do that.</span>")
		return FALSE

	if(!Adjacent(usr))
		to_chat(user, "<span class='warning'>You can't reach it.</span>")
		return FALSE

	return TRUE


// Forcibly shut down the device. To be used when something bugs out and the UI is69onfunctional.
/obj/item/modular_computer/verb/emergency_shutdown()
	set69ame = "Forced Shutdown"
	set category = "Object"
	set src in69iew(1)

	if(!can_interact(usr))
		return

	if(enabled)
		bsod = 1
		update_icon()
		shutdown_computer()
		to_chat(usr, "You press a hard-reset button on \the 69src69. It displays a brief debug screen before shutting down.")
		spawn(2 SECONDS)
			bsod = 0
			update_icon()


// Eject ID card from computer, if it has ID slot with card inside.
/obj/item/modular_computer/verb/eject_id()
	set69ame = "Remove ID"
	set category = "Object"
	set src in69iew(1)

	if(!can_interact(usr))
		return

	playsound(loc, 'sound/machines/id_swipe.ogg', 100, 1)
	proc_eject_id(usr)

// Eject USB from computer
/obj/item/modular_computer/verb/eject_usb()
	set69ame = "Eject Portable Storage"
	set category = "Object"
	set src in69iew(1)

	if(!can_interact(usr))
		return

	proc_eject_usb(usr)

/obj/item/modular_computer/verb/eject_ai()
	set69ame = "Eject AI"
	set category = "Object"
	set src in69iew(1)

	if(!can_interact(usr))
		return

	proc_eject_ai(usr)

/obj/item/modular_computer/verb/remove_pen()
	set69ame = "Remove Pen"
	set category = "Object"
	set src in69iew(1)

	if(!can_interact(usr))
		return

	if(istype(stored_pen))
		to_chat(usr, SPAN_NOTICE("You remove 69stored_pen69 from 69src69."))
		stored_pen.forceMove(get_turf(src))
		if(!issilicon(usr))
			usr.put_in_hands(stored_pen)
		stored_pen =69ull
		update_verbs()

/obj/item/modular_computer/proc/proc_eject_id(mob/user)
	if(!user)
		user = usr

	if(!can_interact(usr))
		return

	for(var/p in all_threads)
		var/datum/computer_file/program/PRG = p
		PRG.event_id_removed()

	card_slot.stored_card.forceMove(get_turf(src))
	if(!issilicon(user))
		user.put_in_hands(card_slot.stored_card)
	to_chat(user, SPAN_NOTICE("You remove 69card_slot.stored_card69 from 69src69."))
	card_slot.stored_card =69ull
	update_uis()
	update_verbs()
	update_label()

/obj/item/modular_computer/proc/proc_eject_usb(mob/user)
	if(!user)
		user = usr

	if(!portable_drive)
		to_chat(user, "There is69o portable device connected to \the 69src69.")
		return

	var/obj/item/computer_hardware/hard_drive/portable/PD = portable_drive

	uninstall_component(portable_drive, user)
	user.put_in_hands(PD)
	update_uis()

/obj/item/modular_computer/proc/proc_eject_ai(mob/user)
	if(!user)
		user = usr

	if(!ai_slot || !ai_slot.stored_card)
		to_chat(user, "There is69o intellicard connected to \the 69src69.")
		return

	ai_slot.stored_card.forceMove(get_turf(src))
	ai_slot.stored_card =69ull
	ai_slot.update_power_usage()
	update_uis()

/obj/item/modular_computer/attack_ghost(var/mob/observer/ghost/user)
	if(enabled)
		ui_interact(user)
	else if(check_rights(R_ADMIN, 0, user))
		var/response = alert(user, "This computer is turned off. Would you like to turn it on?", "Admin Override", "Yes", "No")
		if(response == "Yes")
			turn_on(user)

/obj/item/modular_computer/attack_ai(var/mob/user)
	return attack_self(user)

/obj/item/modular_computer/attack_hand(var/mob/user)
	if(anchored)
		return attack_self(user)
	return ..()

// On-click handling. Turns on the computer if it's off and opens the GUI.
/obj/item/modular_computer/attack_self(var/mob/user)
	if(enabled && screen_on)
		ui_interact(user)
	else if(!enabled && screen_on)
		turn_on(user)

/obj/item/modular_computer/attackby(obj/item/W,69ob/user, sound_mute = FALSE)
	if(istype(W, /obj/item/card/id)) // ID Card, try to insert it.
		var/obj/item/card/id/I = W
		if(!card_slot)
			to_chat(user, "You try to insert 69I69 into 69src69, but it does69ot have an ID card slot installed.")
			return

		if(card_slot.stored_card)
			to_chat(user, "You try to insert 69I69 into 69src69, but its ID card slot is occupied.")
			return

		if(!user.unEquip(I, src))
			return

		card_slot.stored_card = I
		update_label()
		update_uis()
		update_verbs()
		if(sound_mute == FALSE) // This is here so that the sound doesn't play every time you spawn in because ID's69ow get69oved in to PDA's on spawn.
			playsound(loc, 'sound/machines/id_swipe.ogg', 100, 1)
		to_chat(user, "You insert 69I69 into 69src69.")

		return
	if(istype(W, /obj/item/pen) && stores_pen)
		if(istype(stored_pen))
			to_chat(user, "<span class='notice'>There is already a pen in 69src69.</span>")
			return
		if(!insert_item(W, user))
			return
		stored_pen = W
		update_verbs()
		return

	if(scanner && scanner.do_on_attackby(user, W))
		return

	if(istype(W, /obj/item/paper) || istype(W, /obj/item/paper_bundle))
		if(printer)
			printer.attackby(W, user)
	if(istype(W, /obj/item/device/aicard))
		if(!ai_slot)
			return
		ai_slot.attackby(W, user)

	if(!modifiable)
		return ..()

	if(istype(W, suitable_cell) || istype(W, /obj/item/computer_hardware))
		try_install_component(W, user)

	if(istype(W, /obj/item/device/spy_bug))
		user.drop_item()
		W.loc = get_turf(src)

	var/obj/item/tool/tool = W
	if(tool)
		var/list/usable_qualities = list(QUALITY_SCREW_DRIVING, QUALITY_WELDING, QUALITY_BOLT_TURNING)
		var/tool_type = tool.get_tool_type(user, usable_qualities, src)
		switch(tool_type)
			if(QUALITY_BOLT_TURNING)
				var/list/components = get_all_components()
				if(components.len)
					to_chat(user, "Remove all components from \the 69src69 before disassembling it.")
					return
				if(tool.use_tool(user, src, WORKTIME_SLOW, QUALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, required_stat = STAT_COG))
					new /obj/item/stack/material/steel( get_turf(src.loc), steel_sheet_cost )
					src.visible_message("\The 69src69 has been disassembled by 69user69.")
					qdel(src)
					return

			if(QUALITY_WELDING)
				if(!damage)
					to_chat(user, "\The 69src69 does69ot require repairs.")
					return
				if(tool.use_tool(user, src, WORKTIME_SLOW, QUALITY_WELDING, FAILCHANCE_HARD, required_stat = STAT_COG))
					damage = 0
					to_chat(user, "You repair \the 69src69.")
					return

			if(QUALITY_SCREW_DRIVING)
				var/list/all_components = get_all_components()
				if(!all_components.len)
					to_chat(user, "This device doesn't have any components installed.")
					return
				var/list/component_names = list()
				for(var/obj/item/H in all_components)
					component_names.Add(H.name)
				var/list/options = list()
				for(var/i in component_names)
					for(var/X in all_components)
						var/obj/item/TT = X
						if(TT.name == i)
							options69i69 = image(icon = TT.icon, icon_state = TT.icon_state)
				var/choice
				choice = show_radial_menu(user, src, options, radius = 32)
				if(!choice)
					return
				if(!Adjacent(usr))
					return
				if(tool.use_tool(user, src, WORKTIME_FAST, QUALITY_SCREW_DRIVING, FAILCHANCE_VERY_EASY, required_stat = STAT_COG))
					var/obj/item/computer_hardware/H = find_hardware_by_name(choice)
					if(!H)
						return
					uninstall_component(H, user)
					return
	..()

/obj/item/modular_computer/examine(var/mob/user)
	. = ..()

	if(enabled && .)
		to_chat(user, "The time 69stationtime2text()69 is displayed in the corner of the screen.")

	if(card_slot && card_slot.stored_card)
		to_chat(user, "The 69card_slot.stored_card69 is inserted into it.")

/obj/item/modular_computer/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(!istype(over_object, /obj/screen) && can_interact(M))
		return attack_self(M)

	if((src.loc ==69) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell,69))
		cell =69ull
		update_icon()

/obj/item/modular_computer/afterattack(atom/target,69ob/user, proximity)
	. = ..()
	if(scanner)
		scanner.do_on_afterattack(user, target, proximity)

/obj/item/modular_computer/CtrlAltClick(mob/user)
	if(!CanPhysicallyInteract(user))
		return
	open_terminal(user)