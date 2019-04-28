//Allows for a dynamic cursor, simulating accuracy. If you want to resprite this, go ahead.

/obj/item/weapon/gun/equipped(mob/living/H)
	. = ..()
	if(is_held())
		update_cursor(H)
	else
		remove_cursor(H)

/obj/item/weapon/gun/proc/cursor_check()
	if(ismob(loc))
		var/mob/living/carbon/H = loc
		var/obj/item/weapon/gun/thegun = H.get_active_hand()
		if(istype(thegun) && thegun == src)
			update_cursor(H)
		else
			remove_cursor(H)

/obj/item/weapon/gun/swapped_from()
	if(ismob(loc))
		cursor_check(loc)

/obj/item/weapon/gun/swapped_to()
	if(ismob(loc))
		cursor_check(loc)

/obj/item/weapon/gun/afterattack(obj/target, mob/user, flag)
	. = ..()
	if(!is_held())
		remove_cursor(user)

/obj/item/weapon/gun/proc/update_cursor(mob/living/H)
	if(!H || !istype(H))
		return
	if(H.get_preference_value(/datum/client_preference/gun_cursor) != GLOB.PREF_YES)
		remove_cursor(H)
		return
	if(safety)
		remove_cursor(H)
		return
	if(H.client)
		H.client.mouse_pointer_icon = initial(H.client.mouse_pointer_icon)
		var/icon/scaled = 'icons/obj/gun_cursors/standard/standard1.dmi' //Default cursor
		switch(recoil)
			if(0 to 0.5)
				scaled = 'icons/obj/gun_cursors/standard/standard1.dmi'
			if(0.5 to 0.9)
				scaled = 'icons/obj/gun_cursors/standard/standard2.dmi'
			if(1 to 1.5)
				scaled = 'icons/obj/gun_cursors/standard/standard3.dmi'
			if(1.6 to 1.9)
				scaled = 'icons/obj/gun_cursors/standard/standard4.dmi'
			if(2 to 3)
				scaled = 'icons/obj/gun_cursors/standard/standard5.dmi'
			if(3.1 to INFINITY)
				scaled = 'icons/obj/gun_cursors/standard/standard6.dmi' //Catch. If we're above these numbers of recoil
		if(scaled)
			H.client.mouse_pointer_icon = scaled

/obj/item/weapon/gun/try_uneqip(target, mob/living/user)
	. = ..()
	remove_cursor(user)

/obj/item/weapon/gun/dropped(var/mob/living/user)
	remove_cursor(user)
	. = ..()

/obj/item/weapon/gun/proc/remove_cursor(mob/living/user)
	if(user.client)
		user.client.mouse_pointer_icon = initial(user.client.mouse_pointer_icon)

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	update_cursor(user)
	. = ..()

/obj/item/weapon/gun/Destroy()
	if(ismob(loc))
		remove_cursor(loc)
	. = ..()