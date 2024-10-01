/mob/living/proc/handle_recoil(var/obj/item/gun/G, var/recoil_buildup)
	deltimer(recoil_reduction_timer)

	add_recoil(recoil_buildup)

/mob/living/proc/external_recoil(var/recoil_buildup) // Used in human_attackhand.dm
	deltimer(recoil_reduction_timer)
	add_recoil(recoil_buildup)

/mob/living/proc/add_recoil(var/recoil_buildup)
	if(recoil_buildup)
		recoil += recoil_buildup
		update_recoil()

/mob/living/proc/calc_recoil()

	var/base = 0.4
	var/scale = 0.9

	if(recoil <= base)
		recoil = 0
	else
		recoil -= base
		recoil *= scale
	update_recoil()

/mob/living/proc/calculate_offset(var/offset = 0)
	if(recoil)
		offset += recoil
	offset = round(offset)
	offset = CLAMP(offset, 0, MAX_ACCURACY_OFFSET)

	return offset

//Called after setting recoil
/mob/living/proc/update_recoil()
	var/obj/item/gun/G = get_active_hand()
	if(istype(G) && G)
		G.check_safety_cursor(src)

	if(recoil != 0)
		recoil_reduction_timer = addtimer(CALLBACK(src, PROC_REF(calc_recoil)), 0.1 SECONDS, TIMER_STOPPABLE)
	else
		deltimer(recoil_reduction_timer)

//This doesn't really belong here, but it doesn't belong anywhere else either
/mob/proc/update_cursor()
	return

/mob/living/update_cursor()
	var/obj/item/gun/G = get_active_hand()
	if(get_preference_value(/datum/client_preference/gun_cursor) != GLOB.PREF_YES || (!istype(G, /obj/item/gun) || G.safety))
		remove_cursor()
		return
	if(client)
		client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
		var/offset = round(calculate_offset(G.init_offset_with_brace(src)) * 0.8)
		var/icon/base = find_cursor_icon('icons/obj/gun_cursors/standard/standard.dmi', offset)
		ASSERT(isicon(base))
		client.mouse_pointer_icon = base

/mob/living/proc/remove_cursor()
	if(client)
		client.mouse_pointer_icon = initial(client.mouse_pointer_icon)

/proc/find_cursor_icon(var/icon_file, var/offset)
	var/list/L = GLOB.cursor_icons[icon_file]
	if(L)
		return L["[offset]"]

/proc/add_cursor_icon(var/icon/icon, var/icon_file, var/offset)
	var/list/L = GLOB.cursor_icons[icon_file]
	if(!L)
		GLOB.cursor_icons[icon_file] = list()
		L = GLOB.cursor_icons[icon_file]
	L["[offset]"] = icon

/proc/make_cursor_icon(var/icon_file, var/offset)
	var/icon/base = icon('icons/effects/96x96.dmi')
	var/icon/scaled = icon('icons/obj/gun_cursors/standard/standard.dmi') //Default cursor, cut into pieces according to their direction
	base.Blend(scaled, ICON_OVERLAY, x = 32, y = 32)

	for(var/dir in list(NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST))
		var/icon/overlay = icon('icons/obj/gun_cursors/standard/standard.dmi', "[dir]")
		var/pixel_y
		var/pixel_x
		if(dir & NORTH)
			pixel_y = CLAMP(offset, -MAX_ACCURACY_OFFSET, MAX_ACCURACY_OFFSET)
		if(dir & SOUTH)
			pixel_y = CLAMP(-offset, -MAX_ACCURACY_OFFSET, MAX_ACCURACY_OFFSET)
		if(dir & EAST)
			pixel_x = CLAMP(offset, -MAX_ACCURACY_OFFSET, MAX_ACCURACY_OFFSET)
		if(dir & WEST)
			pixel_x = CLAMP(-offset, -MAX_ACCURACY_OFFSET, MAX_ACCURACY_OFFSET)
		base.Blend(overlay, ICON_OVERLAY, x=32+pixel_x, y=32+pixel_y)
	add_cursor_icon(base, 'icons/obj/gun_cursors/standard/standard.dmi', offset)
	return base

/proc/send_all_cursor_icons(var/client/C)
	var/list/cursor_icons = GLOB.cursor_icons
	for(var/icon_file in cursor_icons)
		var/list/icons = cursor_icons[icon_file]
		for(var/offset in icons)
			var/icon/I = icons[offset]
			C << I
