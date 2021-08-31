//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting stuff manually
//as they handle all relevant stuff like adding it to the player's screen and such

//Returns the thing in our active hand (whatever is in our active module-slot, in this case)
/mob/living/silicon/robot/get_active_hand()
	return module_active

/*-------TODOOOOOOOOOO--------*/

//Verbs used by hotkeys.
/mob/living/silicon/robot/verb/cmd_unequip_module()
	set name = "unequip-module"
	set hidden = 1
	uneq_active()

/mob/living/silicon/robot/verb/cmd_toggle_module(module as num)
	set name = "toggle-module"
	set hidden = 1
	toggle_module(module)

/mob/living/silicon/robot/proc/uneq_active()
	if(isnull(module_active))
		return
	if(module_state_1 == module_active)
		if(istype(module_state_1,/obj/item/borg/sight))
			sight_mode &= ~module_state_1:sight_mode
		if (client)
			client.screen -= module_state_1
		contents -= module_state_1
		module_active = null
		module_state_1:loc = module //So it can be used again later
		module_state_1 = null
		//inv1.icon_state = "inv1"
	else if(module_state_2 == module_active)
		if(istype(module_state_2,/obj/item/borg/sight))
			sight_mode &= ~module_state_2:sight_mode
		if (client)
			client.screen -= module_state_2
		contents -= module_state_2
		module_active = null
		module_state_2:loc = module
		module_state_2 = null
		//inv2.icon_state = "inv2"
	else if(module_state_3 == module_active)
		if(istype(module_state_3,/obj/item/borg/sight))
			sight_mode &= ~module_state_3:sight_mode
		if (client)
			client.screen -= module_state_3
		contents -= module_state_3
		module_active = null
		module_state_3:loc = module
		module_state_3 = null
		//inv3.icon_state = "inv3"
	update_robot_modules_display()
	updateicon()

/mob/living/silicon/robot/proc/uneq_all()
	module_active = null

	if(module_state_1)
		if(istype(module_state_1,/obj/item/borg/sight))
			sight_mode &= ~module_state_1:sight_mode
		if (client)
			client.screen -= module_state_1
		contents -= module_state_1
		module_state_1:loc = module
		module_state_1 = null
		//inv1.icon_state = "inv1"
	if(module_state_2)
		if(istype(module_state_2,/obj/item/borg/sight))
			sight_mode &= ~module_state_2:sight_mode
		if (client)
			client.screen -= module_state_2
		contents -= module_state_2
		module_state_2:loc = module
		module_state_2 = null
		//inv2.icon_state = "inv2"
	if(module_state_3)
		if(istype(module_state_3,/obj/item/borg/sight))
			sight_mode &= ~module_state_3:sight_mode
		if (client)
			client.screen -= module_state_3
		contents -= module_state_3
		module_state_3:loc = module
		module_state_3 = null
		//inv3.icon_state = "inv3"
	for (var/obj/screen/HUDelement in HUDinventory)
		HUDelement.underlays.Cut()
	updateicon()

/mob/living/silicon/robot/proc/activated(obj/item/O)
	if(module_state_1 == O || module_state_2 == O || module_state_3 == O)
		updateicon()
		return 1
	else
		return 0
	

//Helper procs for cyborg modules on the UI.
//These are hackish but they help clean up code elsewhere.

//module_selected(module) - Checks whether the module slot specified by "module" is currently selected.
/mob/living/silicon/robot/proc/module_selected(var/module) //Module is 1-3
	return module == get_selected_module()

//module_active(module) - Checks whether there is a module active in the slot specified by "module".
/mob/living/silicon/robot/proc/module_active(var/module) //Module is 1-3
	if(module < 1 || module > 3) return 0

	switch(module)
		if(1)
			if(module_state_1)
				return 1
		if(2)
			if(module_state_2)
				return 1
		if(3)
			if(module_state_3)
				return 1
	return 0

//get_selected_module() - Returns the slot number of the currently selected module.  Returns 0 if no modules are selected.
/mob/living/silicon/robot/proc/get_selected_module()
	if(module_state_1 && module_active == module_state_1)
		return 1
	else if(module_state_2 && module_active == module_state_2)
		return 2
	else if(module_state_3 && module_active == module_state_3)
		return 3

	return 0

//select_module(module) - Selects the module slot specified by "module"
/mob/living/silicon/robot/proc/select_module(var/module) //Module is 1-3
	if(module < 1 || module > 3) return

	if(!module_active(module)) return

	switch(module)
		if(1)
			if(module_active != module_state_1)
				//inv1.icon_state = "inv1 +a"
				//inv2.icon_state = "inv2"
				//inv3.icon_state = "inv3"
				module_active = module_state_1
				return
		if(2)
			if(module_active != module_state_2)
				/*inv1.icon_state = "inv1"
				inv2.icon_state = "inv2 +a"
				inv3.icon_state = "inv3"*/
				module_active = module_state_2
				return
		if(3)
			if(module_active != module_state_3)
				/*inv1.icon_state = "inv1"
				inv2.icon_state = "inv2"
				inv3.icon_state = "inv3 +a"*/
				module_active = module_state_3
				return

	return

//deselect_module(module) - Deselects the module slot specified by "module"
/mob/living/silicon/robot/proc/deselect_module(var/module) //Module is 1-3
	if(module < 1 || module > 3) return

	switch(module)
		if(1)
			if(module_active == module_state_1)
				//inv1.icon_state = "inv1"
				module_active = null
				return
		if(2)
			if(module_active == module_state_2)
				//inv2.icon_state = "inv2"
				module_active = null
				return
		if(3)
			if(module_active == module_state_3)
				//inv3.icon_state = "inv3"
				module_active = null
				return
	return

//toggle_module(module) - Toggles the selection of the module slot specified by "module".
/mob/living/silicon/robot/proc/toggle_module(var/module) //Module is 1-3
	if(module < 1 || module > 3) return

	if(module_selected(module))
		deselect_module(module)
	else
		if(module_active(module))
			select_module(module)
		else
			deselect_module(get_selected_module()) //If we can't do select anything, at least deselect the current module.
	for (var/obj/screen/inv in src.HUDinventory)
		inv.update_icon()
	return

//cycle_modules() - Cycles through the list of selected modules.
/mob/living/silicon/robot/proc/cycle_modules()
	var/slot_start = get_selected_module()
	if(slot_start) deselect_module(slot_start) //Only deselect if we have a selected slot.

	var/slot_num
	if(slot_start == 0)
		slot_num = 1
		slot_start = 2
	else
		slot_num = slot_start + 1

	while(slot_start != slot_num) //If we wrap around without finding any free slots, just give up.
		if(module_active(slot_num))
			select_module(slot_num)
			return
		slot_num++
		if(slot_num > 3) slot_num = 1 //Wrap around.

	return

/mob/living/silicon/robot/proc/find_inv_position(var/invnum)
	if (!src.HUDinventory.len)
		return
	var/obj/screen/silicon/module/inv

	if(invnum in 1 to 3)
		inv = src.HUDinventory[invnum]
		return inv.screen_loc
	else
		log_admin("some error has been occure in /mob/living/silicon/robot/proc/find_inv_position, because invnum [invnum]")
		return "7,7"

/mob/living/silicon/robot/proc/activate_module(var/obj/item/O)
	if(!(locate(O) in src.module.modules) && O != src.module.emag)
		return
	if(activated(O))
		to_chat(src, SPAN_NOTICE("Already activated"))
		return
	if(!module_state_1)
		if (O.pre_equip(src, slot_robot_equip_1))
			return

		module_state_1 = O
		O.layer = ABOVE_HUD_LAYER
		O.set_plane(ABOVE_HUD_PLANE)
		O.screen_loc = find_inv_position(1)
		contents += O
		if(istype(module_state_1,/obj/item/borg/sight))
			sight_mode |= module_state_1:sight_mode
		O.equipped(src, slot_robot_equip_1)

	else if(!module_state_2)
		if (O.pre_equip(src, slot_robot_equip_2))
			return
		module_state_2 = O
		O.layer = ABOVE_HUD_LAYER
		O.set_plane(ABOVE_HUD_PLANE)
		O.screen_loc = find_inv_position(2)
		contents += O
		if(istype(module_state_2,/obj/item/borg/sight))
			sight_mode |= module_state_2:sight_mode
		O.equipped(src, slot_robot_equip_2)

	else if(!module_state_3)
		if (O.pre_equip(src, slot_robot_equip_3))
			return
		module_state_3 = O
		O.layer = ABOVE_HUD_LAYER
		O.set_plane(ABOVE_HUD_PLANE)
		O.screen_loc = find_inv_position(3)
		contents += O
		if(istype(module_state_3,/obj/item/borg/sight))
			sight_mode |= module_state_3:sight_mode
		O.equipped(src, slot_robot_equip_3)
	else
		to_chat(src, SPAN_NOTICE("You need to disable a module first!"))


//Attempt to grip the item in a gripper.
//Parent call will drop it on the floor if gripper can't hold it
/mob/living/silicon/robot/put_in_hands(var/obj/item/W)
	var/obj/item/gripper/G = locate() in list(module_state_1, module_state_2, module_state_3)
	if (G && G.grip_item(W, src, 1))
		return 1
	else
		return ..(W)


/mob/living/silicon/robot/canUnEquip(obj/item/I) //Force overrides NODROP for things like wizarditis and admin undress.
	if(!I || !I.loc)
		return TRUE
	if (istype(I.loc, /obj/item/gripper)) //Robots are allowed to drop the things in their gripper
		return TRUE
	return ..(I) //This will be false for things directly equipped