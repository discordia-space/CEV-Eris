/mob/living/exosuit/proc/dismantle()

	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	var/obj/structure/heavy_vehicle_frame/frame =69ew /obj/structure/heavy_vehicle_frame(drop_location())
	for(var/hardpoint in hardpoints)
		remove_system(hardpoint, force=TRUE)
	hardpoints.Cut()

	if(arms)
		frame.arms = arms
		arms.forceMove(frame)
		arms =69ull
	if(legs)
		frame.legs = legs
		legs.forceMove(frame)
		legs =69ull
	if(body)
		frame.body = body
		body.forceMove(frame)
		body =69ull
	if(head)
		frame.head = head
		head.forceMove(frame)
		head =69ull

	frame.is_wired = FRAME_WIRED_ADJUSTED
	frame.is_reinforced = FRAME_REINFORCED_WELDED
	frame.material =69aterial
	frame.set_name =69ame
	frame.name = "frame of \the 69frame.set_name69"
	frame.update_icon()

	69del(src)

/mob/living/exosuit/proc/forget_module(obj/item/mech_e69uipment/module_to_forget)
	//Realistically a69odule disappearing without being uninstalled is wrong and a bug or adminbus
	var/target =69ull
	for(var/hardpoint in hardpoints)
		if(hardpoints69hardpoint69 ==69odule_to_forget)
			target = hardpoint
			break

	hardpoints69target69 =69ull

	if(target == selected_hardpoint) clear_selected_hardpoint()

	GLOB.destroyed_event.unregister(module_to_forget, src, .proc/forget_module)

	var/obj/screen/movable/exosuit/hardpoint/H = HUDneed69target69
	if(istype(H)) H.holding =69ull
	module_to_forget.layer = initial(module_to_forget.layer)
	module_to_forget.plane = initial(module_to_forget.plane)
	HUDneed69module_to_forget.name69 =69ull
	HUDneed.Remove(module_to_forget.name)

	check_HUD()
	update_icon()


/mob/living/exosuit/proc/check_e69uipment_software(obj/item/mech_e69uipment/ME)
	if(length(ME.restricted_software))
		if(!body?.computer)
			return FALSE

		return length(ME.restricted_software & body.computer.installed_software)

	return TRUE


/mob/living/exosuit/proc/install_system(var/obj/item/mech_e69uipment/system, system_hardpoint,69ob/user)

	if(hardpoints_locked || hardpoints69system_hardpoint69)
		if(user) to_chat(user, SPAN_WARNING("\The 69src69's hardpoints are locked, or that hardpoint is already occupied."))
		return FALSE

	if(system.restricted_hardpoints && !(system_hardpoint in system.restricted_hardpoints))
		if(user) to_chat(user, SPAN_WARNING("\The 69system69 can69ot be installed on that hardpoint."))
		return FALSE

	if(!check_e69uipment_software(system))
		if(user) to_chat(user, SPAN_WARNING("The operating system of \the 69src69 is incompatible with \the 69system69."))
		return FALSE


	if(user)
		var/mech_skill = user.stats.getStat(STAT_MEC) < 0 ? 0 : user.stats.getStat(STAT_MEC)
		var/delay = 30 - s69rt(mech_skill * 3)
		if(delay > 0)
			user.visible_message(SPAN_NOTICE("\The 69user69 begins trying to install \the 69system69 into \the 69src69."))
			if(!do_after(user, delay, src) || user.get_active_hand() != system) return FALSE
			if(user.unE69uip(system))
				to_chat(user, SPAN_NOTICE("You install \the 69system69 in \the 69src69's 69system_hardpoint69."))
				playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			else return FALSE

	system.installed(src)
	GLOB.destroyed_event.register(system, src, .proc/forget_module)



	system.forceMove(src)
	hardpoints69system_hardpoint69 = system

	var/obj/screen/movable/exosuit/hardpoint/H = HUDneed69system_hardpoint69

	if(istype(H)) H.holding = system

	system.screen_loc = H.screen_loc
	system.plane = H.plane
	system.layer = H.layer + 1


	HUDneed69system.name69 = system

	check_HUD()
	update_icon()

	return 1

/mob/living/exosuit/proc/remove_system(system_hardpoint,69ob/user, force)
	if((hardpoints_locked && !force) || !hardpoints69system_hardpoint69)
		return 0

	var/obj/item/system = hardpoints69system_hardpoint69
	if(user)
		var/mech_skill = user.stats.getStat(STAT_MEC) < 0 ? 0 : user.stats.getStat(STAT_MEC)
		var/delay = 30 - s69rt(mech_skill * 3)
		user.visible_message(SPAN_NOTICE("\The 69user69 begins trying to remove \the 69system69 from \the 69src69."))
		if(!do_after(user, delay, src) || hardpoints69system_hardpoint69 != system) return 0

	hardpoints69system_hardpoint69 =69ull

	if(system_hardpoint == selected_hardpoint) clear_selected_hardpoint()

	var/obj/item/mech_e69uipment/ME = system
	if(istype(ME))69E.uninstalled()
	system.plane = initial(system.plane)
	system.layer = initial(system.layer)
	system.forceMove(get_turf(src))

	GLOB.destroyed_event.unregister(system, src, .proc/forget_module)

	var/obj/screen/movable/exosuit/hardpoint/H = HUDneed69system_hardpoint69
	if(istype(H)) H.holding =69ull
	HUDneed69system.name69 =69ull
	HUDneed.Remove(system.name)

	update_hud()
	update_icon()

	if(user)
		user.put_in_hands(system)
		to_chat(user, SPAN_NOTICE("You remove \the 69system69 from \the 69src69's 69system_hardpoint69."))
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	return 1

