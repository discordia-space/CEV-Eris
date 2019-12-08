#define BASE_ACCURACY_REGEN 0.75 //Recoil reduction per ds with 0 VIG
#define VIG_ACCURACY_REGEN  0.015 //Recoil reduction per ds per VIG
#define MIN_ACCURACY_REGEN  0.4 //How low can we get with negative VIG
#define MAX_ACCURACY_OFFSET  75 //It's both how big gun recoil can build up, and how hard you can miss

/mob/living/proc/handle_recoil(var/obj/item/weapon/gun/G)
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
	var/bottom = 0
	switch(recoil)
		if(0 to 10)
			;
		if(10 to 20)
			bottom = 10
		if(20 to 30)
			bottom = 20
		if(30 to 50)
			bottom = 30
		if(50 to MAX_ACCURACY_OFFSET)
			bottom = 50
		if(MAX_ACCURACY_OFFSET to INFINITY)
			bottom = MAX_ACCURACY_OFFSET
	if(bottom)
		var/reduction = calc_reduction()
		if(reduction > 0)
			recoil_timer = addtimer(CALLBACK(src, .proc/update_recoil_cursor), 1 + (recoil - bottom) / reduction)

GLOBAL_LIST_INIT(cursor_icons, list()) //list of icon files, which point to lists of offsets, which point to icons

/mob/living/proc/update_cursor()
	if(get_preference_value(/datum/client_preference/gun_cursor) != GLOB.PREF_YES)
		remove_cursor()
		return
	if(client)
		client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
		var/offset = round(calc_recoil())
		var/icon/base = find_cursor_icon('icons/obj/gun_cursors/standard/standard.dmi', offset)
		if(!isicon(base))
			base = icon('icons/effects/96x96.dmi')
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
				to_chat(world, "overlay [dir] [overlay] [pixel_x] [pixel_y]")
				base.Blend(overlay, ICON_OVERLAY, x=32+pixel_x, y=32+pixel_y)
			add_cursor_icon(base, 'icons/obj/gun_cursors/standard/standard.dmi', offset)
		if(base)
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
	L.Add("[offset]")
	L["[offset]"] = icon