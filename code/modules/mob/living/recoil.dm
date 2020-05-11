/mob/living/proc/handle_recoil(var/obj/item/weapon/gun/G)
	if(G.one_hand_penalty)//If the gun has a two handed penalty and is not weilded.
		if(!G.wielded)
			recoil += G.one_hand_penalty //Then the one hand penalty wil lbe added to the recoil.
	if(G.recoil_buildup)
		recoil += G.recoil_buildup
		update_recoil(G)

/mob/living/proc/calc_reduction()
	return max(BASE_ACCURACY_REGEN + stats.getStat(STAT_VIG)*VIG_ACCURACY_REGEN, MIN_ACCURACY_REGEN)

//Called to get current recoil value
/mob/living/proc/calc_recoil()
	if(!recoil || !last_recoil_update)
		return 0
	var/time = world.time - last_recoil_update
	if(time)
		//About the following code. This code is a mess, and we SHOULD NOT USE WORLD TIME FOR RECOIL
		var/timed_reduction = min(time**2, 400)
		recoil -= timed_reduction * calc_reduction()
		if(recoil <= 0)
			recoil = 0
			last_recoil_update = 0
		else
			last_recoil_update = world.time
	return recoil

/mob/living/proc/calc_timer()
	if(recoil <= 0)
		return 0
	return round(1+((recoil/10)/calc_reduction()))

//Called after setting recoil
/mob/living/proc/update_recoil(var/obj/item/weapon/gun/G)
	if(recoil <= 0)
		recoil = 0
		last_recoil_update = 0
	else
		if(last_recoil_update)
			calc_recoil()
		else
			last_recoil_update = world.time
	deltimer(recoil_timer)
	recoil_timer = null
	update_recoil_cursor(G)

/mob/living/proc/update_recoil_cursor()
	update_cursor()
	var/timer = calc_timer()
	if(timer > 0)
		deltimer(recoil_timer)
		recoil_timer = addtimer(CALLBACK(src, .proc/update_recoil_cursor), timer, TIMER_STOPPABLE)

/mob/living/proc/update_cursor()
	if(get_preference_value(/datum/client_preference/gun_cursor) != GLOB.PREF_YES)
		remove_cursor()
		return
	if(client)
		client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
		var/offset = min(round(calc_recoil()), MAX_ACCURACY_OFFSET)
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