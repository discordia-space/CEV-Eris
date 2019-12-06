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

/mob/living/proc/update_cursor()
	if(get_preference_value(/datum/client_preference/gun_cursor) != GLOB.PREF_YES)
		remove_cursor()
		return
	if(client)
		client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
		var/icon/scaled = 'icons/obj/gun_cursors/standard/standard1.dmi' //Default cursor
		switch(calc_recoil())
			if(0 to 10)
				scaled = 'icons/obj/gun_cursors/standard/standard1.dmi'
			if(10 to 20)
				scaled = 'icons/obj/gun_cursors/standard/standard2.dmi'
			if(20 to 30)
				scaled = 'icons/obj/gun_cursors/standard/standard3.dmi'
			if(30 to 50)
				scaled = 'icons/obj/gun_cursors/standard/standard4.dmi'
			if(50 to MAX_ACCURACY_OFFSET)
				scaled = 'icons/obj/gun_cursors/standard/standard5.dmi'
			if(MAX_ACCURACY_OFFSET to INFINITY)
				scaled = 'icons/obj/gun_cursors/standard/standard6.dmi' //Catch. If we're above these numbers of recoil
		/*
		var/image/scaled = image('icons/obj/gun_cursors/standard/standard.dmi') //Default cursor, cut into pieces according to their direction
		var/offset = calc_recoil()
		for(var/dir in list(NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST))
			var/image/overlay = image('icons/obj/gun_cursors/standard/standard.dmi', scaled, dir)
			if(dir & NORTH)
				overlay.pixel_y = CLAMP(offset, -MAX_ACCURACY_OFFSET, MAX_ACCURACY_OFFSET)
			if(dir & SOUTH)
				overlay.pixel_y = CLAMP(-offset, -MAX_ACCURACY_OFFSET, MAX_ACCURACY_OFFSET)
			if(dir & EAST)
				overlay.pixel_x = CLAMP(offset, -MAX_ACCURACY_OFFSET, MAX_ACCURACY_OFFSET)
			if(dir & WEST)
				overlay.pixel_x = CLAMP(-offset, -MAX_ACCURACY_OFFSET, MAX_ACCURACY_OFFSET)
			to_chat(world, "overlay [overlay] [overlay.pixel_x] [overlay.pixel_y]")
			scaled.overlays.Add(overlay)
			*/

		if(scaled)
			client.mouse_pointer_icon = scaled

/mob/living/proc/remove_cursor()
	if(client)
		client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
