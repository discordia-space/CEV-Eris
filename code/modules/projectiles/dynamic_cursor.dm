//Allows for a dynamic cursor, simulating accuracy. If you want to resprite this, go ahead.

/obj/item/weapon/gun/equipped(mob/living/H)
	. = ..()
	update_cursor(H)

/obj/item/weapon/gun/proc/cursor_check()
	if(ismob(loc))
		var/mob/living/carbon/H = loc
		var/obj/item/weapon/gun/thegun = H.get_active_hand()
		if(istype(thegun) && thegun == src)
			update_cursor(H)
		else
			remove_cursor(H)

/mob/living/carbon/human/swap_hand()
	var/obj/item/weapon/gun/thegun = get_active_hand()
	if(istype(thegun))
		thegun.cursor_check(src)
	. = ..()

/obj/item/weapon/gun/proc/update_cursor(mob/living/H)
	if(!H || !istype(H))
		return
	if(H.client)
		H.client.mouse_pointer_icon = initial(H.client.mouse_pointer_icon)
		var/icon/scaled
		scaled = 'icons/obj/gun_cursors/example/huge.dmi' //Default. If we're above these numbers of recoil
		switch(recoil)
			if(0)
				scaled = 'icons/obj/gun_cursors/example/standard.dmi'
			if(1)
				scaled = 'icons/obj/gun_cursors/example/medium.dmi'
			if(2 to 3)
				scaled = 'icons/obj/gun_cursors/example/large.dmi'
		if(scaled)
			H.client.mouse_pointer_icon = scaled

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