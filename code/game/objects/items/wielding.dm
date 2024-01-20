//THERE IS A LOT OF SHIT IN WIELDING! SO I'M PUTTING WIELDING INTO IT'S OWN FILE FOR ORGANIZATIONAL PURPOSES

/obj/item
	var/wielded = FALSE //Whether or not it's wielded.
	var/wieldsound = 'sound/weapons/thudswoosh.ogg' //Generic sound. Replace it with a special one if you have one.
	var/unwieldsound //If you want it to make a sound when you unwield, put one here.
	var/wielded_icon //The item state used when it's wielded. Guns are snowflakey and have their own shit for this. This is for non guns.
	/// Wielded multiplier moved in obj/item/ def


/mob/living/proc/do_wield()//The proc we actually care about.
	var/obj/item/I = get_active_hand()
	var/obj/item/O = get_inactive_hand()
	if(!I)
		if(!O)
			return
		swap_hand()
		O.attempt_wield(src)
	else
		I.attempt_wield(src)

/obj/item/proc/unwield(mob/living/user)
	if(!wielded || !user)
		return
	wielded = FALSE

	var/sf = findtext(name," (Wielded)")
	if(sf)
		name = copytext(name,1,sf)
	else //something went wrong
		name = "[initial(name)]"//Returns name from compile-time instead of name with changes that've happened since
	update_unwield_icon()
	update_icon()
	if(user)
		user.update_inv_r_hand()
		user.update_inv_l_hand()

	user.visible_message(SPAN_WARNING("[user] lets go of their other hand."))
	if(unwieldsound)
		playsound(loc, unwieldsound, 50, 1)
	var/obj/item/twohanded/offhand/O = user.get_inactive_hand()
	if(O && istype(O))
		user.drop_from_inventory(O)
	return

/obj/item/proc/wield(mob/living/user)
	if(wielded)
		return
	if(!is_held_twohanded(user))
		return
	var/obj/item/X = user.get_inactive_hand()
	if(X)
		if(!X.canremove)
			return
		user.drop_offhand()
		to_chat(user, SPAN_WARNING("You dropped \the [X]."))
	wielded = TRUE
	var/original_name = name //Else using [initial(name)] for the name of object returns compile-time name without any changes that've happened to the object's name
	name = "[name] (Wielded)"
	update_wield_icon()
	update_icon()//Legacy
	if(user)
		user.update_inv_r_hand()
		user.update_inv_l_hand()
	user.visible_message(SPAN_WARNING("[user] grabs \the [original_name] with both hands."))
	if(wieldsound)
		playsound(loc, wieldsound, 50, 1)
	var/obj/item/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
	O.name = "[name] - offhand"
	O.desc = "Your second grip on \the [name]"
	user.put_in_inactive_hand(O)
	return

/obj/item/proc/update_wield_icon()
	if(wielded && wielded_icon)
		item_state = wielded_icon

/obj/item/proc/update_unwield_icon()//That way it doesn't interupt any other special icon_states.
	if(!wielded && wielded_icon)
		item_state = "[initial(item_state)]"

//For general weapons.
/obj/item/proc/attempt_wield(mob/user)
	if(wielded) //Trying to unwield it
		unwield(user)
	else //Trying to wield it
		wield(user)

//Checks if the item is being held by a mob, and if so, updates the held icons
/obj/item/proc/update_twohanding()
	update_held_icon()

/obj/item/proc/update_held_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		if(M.l_hand == src)
			M.update_inv_l_hand()
		else if(M.r_hand == src)
			M.update_inv_r_hand()

/obj/item/proc/is_held_twohanded(mob/living/M)
	var/check_hand
	if(M.l_hand == src)//Eris removed hands long ago. This would normally check hands but it has to check if you have arms instead. Otherwise the below comments would be accurate.
		check_hand = BP_R_ARM //item in left hand, check right hand
	else if(M.r_hand == src)
		check_hand = BP_L_ARM //item in right hand, check left hand
	else
		return FALSE

	//would check is_broken() and is_malfunctioning() here too but is_malfunctioning()
	//is probabilistic so we can't do that and it would be unfair to just check one.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/hand = H.organs_by_name[check_hand]
		if(istype(hand) && hand.is_usable())
			return TRUE
	return FALSE


/obj/item/twohanded
	bad_type = /obj/item/twohanded
	spawn_tags = null

/obj/item/twohanded/offhand
	name = "offhand"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "offhand"
	volumeClass = ITEM_SIZE_COLOSSAL
	item_flags = ABSTRACT

/obj/item/twohanded/offhand/unwield()
	wielded = FALSE
	if(!QDELETED(src))
		qdel(src)

/obj/item/twohanded/offhand/wield()
	if(wielded)//Only delete if we're wielded
		wielded = FALSE
		if(!QDELETED(src))
			qdel(src)

/obj/item/twohanded/offhand/dropped(mob/living/user)
	..()
	var/obj/item/I = user.get_active_hand()
	var/obj/item/II = user.get_inactive_hand()
	if(I)
		I.unwield(user)
	if(II)
		II.unwield(user)
	if(!QDELETED(src))
		qdel(src)


/mob/living/verb/wield_hotkey()//For the hotkeys. Not sure where this should be put. But it pertains to two-handing so *shrug*.
	set name = ".wield"
	do_wield()
