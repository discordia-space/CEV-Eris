// All docs for procs in that file located in code/modules/mob/inventory/_docs.dm
/obj/item
	var/slot_flags = 0		//This is used to determine on which slots an item can fit
	var/canremove  = TRUE	//Will not allow the item to be removed
	var/item_flags = 0		//Miscellaneous flags pertaining to equippable objects.

	var/equip_slot = 0		//The slot that this item was most recently equipped to.
		//Note that this is, by design, not zeroed out when the item is removed from a mob
		//In that case, it holds the number of the slot it was last in, which is potentially useful info
		//For an accurate reading of the current slot,
		//  use item/get_equip_slot() which will return zero if not currently on a mob


/obj/item/proc/update_wear_icon(redraw_mob = TRUE)
	if(!ishuman(loc))
		return

	var/slot = get_equip_slot()
	if(!slot)
		return

	SSinventory.update_mob(loc, slot, redraw_mob)

/obj/item/proc/pre_equip(var/mob/user, var/slot)
	//Some inventory sounds.
	//occurs when you equip something
	if(item_flags & LOUDLY_EQUIPEMENT)
		var/picked_sound = pick(w_class > ITEM_SIZE_NORMAL ? long_equipement_sound : short_equipement_sound)
		playsound(src, picked_sound, 100, 1, 1)

/obj/item/proc/equipped(var/mob/user, var/slot)
	if(!istype(user))
		equip_slot = slot_none
		return

	equip_slot = slot
	layer = 20
	if(user.client)
		user.client.screen |= src
	if(user.pulling == src)
		user.stop_pulling()



/obj/item/proc/dropped(mob/user)
	..()
	if(zoom) //binoculars, scope, etc
		zoom()


/obj/item/proc/can_be_equipped(mob/Mob, slot, disable_warning = FALSE)
	return TRUE


/obj/item/proc/mob_can_unequip(mob/M, slot, disable_warning = 0)
	if(!slot) return 0
	if(!M) return 0

	if(!canremove)
		return 0
	if(!M.slot_is_accessible(slot, src, disable_warning? null : M))
		return 0
	return 1


/obj/item/proc/is_equipped()
	if (ismob(loc))
		return (equip_slot != slot_none)


/obj/item/proc/is_worn()
	if (ismob(loc))
		return !(equip_slot in list(slot_none, slot_l_hand, slot_r_hand))


/obj/item/proc/is_held()
	if (ismob(loc))
		return equip_slot in list(slot_l_hand, slot_r_hand)


/obj/item/proc/get_equip_slot()
	if (ismob(loc))
		return equip_slot
	else
		return slot_none


/obj/item/MouseDrop(obj/over_object)
	if(item_flags & DRAG_AND_DROP_UNEQUIP && isliving(usr))
		if(try_uneqip(over_object, usr))
			return
	return ..()


/obj/item/proc/try_uneqip(target, mob/living/user)
	if(loc == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if (!istype(target, /obj/screen/inventory/hand))
			return

		//makes sure that the storage is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if(src.loc != H || H.incapacitated())
			return

		if (!H.unEquip(src))
			return

		var/obj/screen/inventory/hand/Hand = target
		switch(Hand.slot_id)
			if(slot_r_hand)
				H.put_in_r_hand(src)
			if(slot_l_hand)
				H.put_in_l_hand(src)
		src.add_fingerprint(usr)
		return TRUE

