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


/obj/item/proc/can_be_equipped(mob/user, slot, disable_warning = 0)
	var/obj/item/equipped = user.get_equipped_item(slot)
	if(equipped && equipped.overslot)
		if (!disable_warning)
			to_chat(user, "You are unable to wear \the [src] as [equipped] in the way.")
		return FALSE
	return TRUE

/obj/item/pre_attack(atom/a, mob/user, var/params)
	if(overslot)
		var/obj/item/clothing/i = a
		if (istype(i))
			if(i.is_worn() && i.slot_flags == slot_flags)
				user.equip_to_appropriate_slot(src)
				return TRUE


/obj/item/proc/pre_equip(mob/user, slot)
	//Some inventory sounds.
	//occurs when you equip something
	if(item_flags & EQUIP_SOUNDS)
		var/picked_sound = pick(volumeClass > ITEM_SIZE_NORMAL ? long_equipement_sound : short_equipement_sound)
		playsound(src, picked_sound, 100, 1, 1)
	if(overslot)
		var/obj/item/equipped = user.get_equipped_item(slot)
		if(equipped)
			src.overslot_contents = equipped
			user.drop_from_inventory(equipped)
			equipped.forceMove(src)
	return FALSE

/obj/item/proc/equipped(mob/user, slot)
	equip_slot = slot
	for(var/obj/item/grab/g in user)
		if(g.affecting == src)
			QDEL_NULL(g)
	if(overslot && !is_worn())
		remove_overslot_contents(user)
	if(user.l_hand)
		user.l_hand.update_twohanding()
	if(user.r_hand)
		user.r_hand.update_twohanding()
	if(wielded)
		unwield(user)
	GLOB.mob_equipped_event.raise_event(user, src, slot)
	GLOB.item_equipped_event.raise_event(src, user, slot)
	SEND_SIGNAL_OLD(user, COMSIG_CLOTH_EQUIPPED, src) // Theres instances in which its usefull to keep track of it both on the user and individually
	SEND_SIGNAL_OLD(src, COMSIG_CLOTH_EQUIPPED, user)
	update_light()

/obj/item/proc/dropped(mob/user)
	GLOB.mob_unequipped_event.raise_event(user, src)
	GLOB.item_unequipped_event.raise_event(src, user)
	SEND_SIGNAL_OLD(src, COMSIG_ITEM_DROPPED, src)
	update_light()
	if(zoom) //binoculars, scope, etc
		zoom()
	remove_hud_actions(user)
	if(overslot && is_held())
		remove_overslot_contents(user)

/obj/item/proc/remove_overslot_contents(mob/user)
	if(overslot_contents)
		if(!user.equip_to_appropriate_slot(overslot_contents))
			overslot_contents.forceMove(get_turf(src))
		overslot_contents = null



/obj/item/proc/mob_can_unequip(mob/M, slot, disable_warning = FALSE)
	if(!slot) return FALSE
	if(!M) return FALSE

	if(!canremove)
		return FALSE
	var/mob/living/carbon/human/attached_to = M
	if (istype(attached_to) && attached_to.is_item_attached(src))
		return FALSE
	if(!M.slot_is_accessible(slot, src, disable_warning? null : M))
		return FALSE
	return TRUE


/obj/item/proc/is_equipped()
	if (ismob(loc))
		return (equip_slot != slot_none)


/obj/item/proc/is_worn()
	//If equip_slot is zero then it has never been equipped
	if (equip_slot == slot_none)
		return FALSE

	if (ismob(loc))
		return !(equip_slot in unworn_slots)


/obj/item/proc/is_held()
	//If equip_slot is zero then it has never been equipped
	if (equip_slot == slot_none)
		return FALSE

	if (ismob(loc))
		return equip_slot in list(slot_l_hand, slot_r_hand,slot_robot_equip_1,slot_robot_equip_2,slot_robot_equip_3)


/obj/item/proc/get_equip_slot()
	if (ismob(loc))
		return equip_slot
	else
		return slot_none


/obj/item/MouseDrop(obj/over_object)
	if(item_flags & DRAG_AND_DROP_UNEQUIP && isliving(usr))
		if(try_transfer(over_object, usr))
			return
	return ..()


/obj/item/proc/try_transfer(target, mob/living/user)
	if(loc == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(target, /obj/screen/inventory))
			var/obj/screen/inventory/screen_thing = target
			target = screen_thing.slot_id
		//makes sure that the storage is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if(src.loc != H || H.incapacitated())
			return FALSE

		if(!H.canUnEquip(src))
			return FALSE
		if(!H.can_equip(src, target, FALSE, FALSE, FALSE))
			return FALSE
		H.remove_from_mob(src, FALSE)
		/*
			Copied from human equip_to_slot
			Separate since its needed to prevent double-signals being sent
			on atom containerization

		*/
		H.equip_to_slot(src, target, TRUE, FALSE)
		if(H.client)
			H.client.screen |= src
		if(action_button_name)
			H.update_action_buttons()
		if(H.get_holding_hand(src))
			add_hud_actions(H)
		return TRUE


