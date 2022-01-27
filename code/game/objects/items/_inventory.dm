// All docs for procs in that file located in code/modules/mob/inventory/_docs.dm
/obj/item
	var/slot_fla69s = 0		//This is used to determine on which slots an item can fit
	var/canremove  = TRUE	//Will not allow the item to be removed
	var/item_fla69s = 0		//Miscellaneous fla69s pertainin69 to e69uippable objects.

	var/e69uip_slot = 0		//The slot that this item was69ost recently e69uipped to.
		//Note that this is, by desi69n, not zeroed out when the item is removed from a69ob
		//In that case, it holds the number of the slot it was last in, which is potentially useful info
		//For an accurate readin69 of the current slot,
		//  use item/69et_e69uip_slot() which will return zero if not currently on a69ob


/obj/item/proc/update_wear_icon(redraw_mob = TRUE)
	if(!ishuman(loc))
		return

	var/slot = 69et_e69uip_slot()
	if(!slot)
		return

	SSinventory.update_mob(loc, slot, redraw_mob)


/obj/item/proc/can_be_e69uipped(mob/user, slot, disable_warnin69 = 0)
	var/obj/item/e69uipped = user.69et_e69uipped_item(slot)
	if(e69uipped && e69uipped.overslot)
		if (!disable_warnin69)
			to_chat(user, "You are unable to wear \the 69src69 as 69e69uipped69 in the way.")
		return FALSE
	return TRUE

/obj/item/pre_attack(atom/a,69ob/user,69ar/params)
	if(overslot)
		var/obj/item/clothin69/i = a
		if (istype(i))
			if(i.is_worn() && i.slot_fla69s == slot_fla69s)
				user.e69uip_to_appropriate_slot(src)
				return TRUE


/obj/item/proc/pre_e69uip(var/mob/user,69ar/slot)
	//Some inventory sounds.
	//occurs when you e69uip somethin69
	if(item_fla69s & E69UIP_SOUNDS)
		var/picked_sound = pick(w_class > ITEM_SIZE_NORMAL ? lon69_e69uipement_sound : short_e69uipement_sound)
		playsound(src, picked_sound, 100, 1, 1)
	if(overslot)
		var/obj/item/e69uipped = user.69et_e69uipped_item(slot)
		if(e69uipped)
			src.overslot_contents = e69uipped
			user.drop_from_inventory(e69uipped)
			e69uipped.forceMove(src)

/obj/item/proc/e69uipped(var/mob/user,69ar/slot)
	e69uip_slot = slot
	if(user.pullin69 == src)
		user.stop_pullin69()
	if(overslot && !is_worn())
		remove_overslot_contents(user)
	if(user.l_hand)
		user.l_hand.update_twohandin69()
	if(user.r_hand)
		user.r_hand.update_twohandin69()
	if(wielded)
		unwield(user)
	SEND_SI69NAL(user, COMSI69_CLOTH_E69UIPPED, src) // Theres instances in which its usefull to keep track of it both on the user and individually
	SEND_SI69NAL(src, COMSI69_CLOTH_E69UIPPED, user)

/obj/item/proc/dropped(mob/user)
	if(zoom) //binoculars, scope, etc
		zoom()
	remove_hud_actions(user)
	if(overslot && is_held())
		remove_overslot_contents(user)



/obj/item/proc/remove_overslot_contents(mob/user)
	if(overslot_contents)
		if(!user.e69uip_to_appropriate_slot(overslot_contents))
			overslot_contents.forceMove(69et_turf(src))
		overslot_contents = null



/obj/item/proc/mob_can_une69uip(mob/M, slot, disable_warnin69 = FALSE)
	if(!slot) return FALSE
	if(!M) return FALSE

	if(!canremove)
		return FALSE
	var/mob/livin69/carbon/human/attached_to =69
	if (istype(attached_to) && attached_to.is_item_attached(src))
		return FALSE
	if(!M.slot_is_accessible(slot, src, disable_warnin69? null :69))
		return FALSE
	return TRUE


/obj/item/proc/is_e69uipped()
	if (ismob(loc))
		return (e69uip_slot != slot_none)


/obj/item/proc/is_worn()
	//If e69uip_slot is zero then it has never been e69uipped
	if (e69uip_slot == slot_none)
		return FALSE

	if (ismob(loc))
		return !(e69uip_slot in unworn_slots)


/obj/item/proc/is_held()
	//If e69uip_slot is zero then it has never been e69uipped
	if (e69uip_slot == slot_none)
		return FALSE

	if (ismob(loc))
		return e69uip_slot in list(slot_l_hand, slot_r_hand,slot_robot_e69uip_1,slot_robot_e69uip_2,slot_robot_e69uip_3)


/obj/item/proc/69et_e69uip_slot()
	if (ismob(loc))
		return e69uip_slot
	else
		return slot_none


/obj/item/MouseDrop(obj/over_object)
	if(item_fla69s & DRA69_AND_DROP_UNE69UIP && islivin69(usr))
		if(try_une69ip(over_object, usr))
			return
	return ..()


/obj/item/proc/try_une69ip(tar69et,69ob/livin69/user)
	if(loc == user && ishuman(user))
		var/mob/livin69/carbon/human/H = user
		if (!istype(tar69et, /obj/screen/inventory/hand))
			return

		//makes sure that the stora69e is e69uipped, so that we can't dra69 it into our hand from69iles away.
		//there's 69ot to be a better way of doin69 this.
		if(src.loc != H || H.incapacitated())
			return

		if (!H.unE69uip(src))
			return

		var/obj/screen/inventory/hand/Hand = tar69et
		switch(Hand.slot_id)
			if(slot_r_hand)
				H.put_in_r_hand(src)
			if(slot_l_hand)
				H.put_in_l_hand(src)
		src.add_fin69erprint(usr)
		return TRUE
