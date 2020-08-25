/mob/living/exosuit/proc/dismantle()

	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	var/obj/structure/heavy_vehicle_frame/frame = new /obj/structure/heavy_vehicle_frame(drop_location())
	for(var/hardpoint in hardpoints)
		remove_system(hardpoint, force=TRUE)
	hardpoints.Cut()

	if(arms)
		frame.arms = arms
		arms.forceMove(frame)
		arms = null
	if(legs)
		frame.legs = legs
		legs.forceMove(frame)
		legs = null
	if(body)
		frame.body = body
		body.forceMove(frame)
		body = null
	if(head)
		frame.head = head
		head.forceMove(frame)
		head = null

	frame.is_wired = FRAME_WIRED_ADJUSTED
	frame.is_reinforced = FRAME_REINFORCED_WELDED
	frame.material = material
	frame.set_name = name
	frame.name = "frame of \the [frame.set_name]"
	frame.update_icon()

	qdel(src)

/mob/living/exosuit/proc/forget_module(obj/item/mech_equipment/module_to_forget)
	//Realistically a module disappearing without being uninstalled is wrong and a bug or adminbus
	var/target = null
	for(var/hardpoint in hardpoints)
		if(hardpoints[hardpoint] == module_to_forget)
			target = hardpoint
			break

	hardpoints[target] = null

	if(target == selected_hardpoint) clear_selected_hardpoint()

	GLOB.destroyed_event.unregister(module_to_forget, src, .proc/forget_module)

	var/obj/screen/movable/exosuit/hardpoint/H = HUDneed[target]
	if(istype(H)) H.holding = null
	module_to_forget.layer = initial(module_to_forget.layer)
	module_to_forget.plane = initial(module_to_forget.plane)
	HUDneed[module_to_forget.name] = null
	HUDneed.Remove(module_to_forget.name)

	check_HUD()
	update_icon()


/mob/living/exosuit/proc/check_equipment_software(obj/item/mech_equipment/ME)
	if(length(ME.restricted_software))
		if(!body?.computer)
			return FALSE

		return length(ME.restricted_software & body.computer.installed_software)

	return TRUE


/mob/living/exosuit/proc/install_system(var/obj/item/mech_equipment/system, system_hardpoint, mob/user)

	if(hardpoints_locked || hardpoints[system_hardpoint])
		if(user) to_chat(user, SPAN_WARNING("\The [src]'s hardpoints are locked, or that hardpoint is already occupied."))
		return FALSE

	if(system.restricted_hardpoints && !(system_hardpoint in system.restricted_hardpoints))
		if(user) to_chat(user, SPAN_WARNING("\The [system] can not be installed on that hardpoint."))
		return FALSE

	if(!check_equipment_software(system))
		if(user) to_chat(user, SPAN_WARNING("The operating system of \the [src] is incompatible with \the [system]."))
		return FALSE


	if(user)
		var/mech_skill = user.stats.getStat(STAT_MEC) < 0 ? 0 : user.stats.getStat(STAT_MEC)
		var/delay = 30 - sqrt(mech_skill * 3)
		if(delay > 0)
			user.visible_message(SPAN_NOTICE("\The [user] begins trying to install \the [system] into \the [src]."))
			if(!do_after(user, delay, src) || user.get_active_hand() != system) return FALSE
			if(user.unEquip(system))
				to_chat(user, SPAN_NOTICE("You install \the [system] in \the [src]'s [system_hardpoint]."))
				playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			else return FALSE

	system.installed(src)
	GLOB.destroyed_event.register(system, src, .proc/forget_module)



	system.forceMove(src)
	hardpoints[system_hardpoint] = system

	var/obj/screen/movable/exosuit/hardpoint/H = HUDneed[system_hardpoint]

	if(istype(H)) H.holding = system

	system.screen_loc = H.screen_loc
	system.plane = H.plane
	system.layer = H.layer + 1


	HUDneed[system.name] = system

	check_HUD()
	update_icon()

	return 1

/mob/living/exosuit/proc/remove_system(system_hardpoint, mob/user, force)
	if((hardpoints_locked && !force) || !hardpoints[system_hardpoint])
		return 0

	var/obj/item/system = hardpoints[system_hardpoint]
	if(user)
		var/mech_skill = user.stats.getStat(STAT_MEC) < 0 ? 0 : user.stats.getStat(STAT_MEC)
		var/delay = 30 - sqrt(mech_skill * 3)
		user.visible_message(SPAN_NOTICE("\The [user] begins trying to remove \the [system] from \the [src]."))
		if(!do_after(user, delay, src) || hardpoints[system_hardpoint] != system) return 0

	hardpoints[system_hardpoint] = null

	if(system_hardpoint == selected_hardpoint) clear_selected_hardpoint()

	var/obj/item/mech_equipment/ME = system
	if(istype(ME)) ME.uninstalled()
	system.plane = initial(system.plane)
	system.layer = initial(system.layer)
	system.forceMove(get_turf(src))

	GLOB.destroyed_event.unregister(system, src, .proc/forget_module)

	var/obj/screen/movable/exosuit/hardpoint/H = HUDneed[system_hardpoint]
	if(istype(H)) H.holding = null
	HUDneed[system.name] = null
	HUDneed.Remove(system.name)

	update_hud()
	update_icon()

	if(user)
		user.put_in_hands(system)
		to_chat(user, SPAN_NOTICE("You remove \the [system] from \the [src]'s [system_hardpoint]."))
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	return 1

