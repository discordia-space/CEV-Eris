//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_hand()
	var/obj/item/E = get_equipped_item(slot)
	if (istype(E))
		if(istype(W))
			W.resolve_attackby(E, src)
		else
			E.attack_hand(src)
	else
		equip_to_slot_if_possible(W, slot)

//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting l_hand = ...etc
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

//Returns the thing in our active hand
/mob/proc/get_active_hand()
	if(hand)	return l_hand
	else		return r_hand

//Returns the thing in our inactive hand
/mob/proc/get_inactive_hand()
	if(hand)	return r_hand
	else		return l_hand

//Declarations. Overrided in human/robots subtypes
//Puts the Item into your l_hand/r_hand if possible and calls all necessary triggers/updates. returns TRUE on success.
/mob/proc/put_in_l_hand(var/obj/item/Item)
/mob/proc/put_in_r_hand(var/obj/item/Item)

//Puts the item into our active hand if possible. returns 1 on success.
/mob/proc/put_in_active_hand(var/obj/item/W)
	return FALSE // Moved to human procs because only they need to use hands.

//Puts the item into our inactive hand if possible. returns 1 on success.
/mob/proc/put_in_inactive_hand(var/obj/item/W)
	return FALSE // As above.

//Puts the item our active hand if possible. Failing that it tries our inactive hand. Returns 1 on success.
//If both fail it drops it on the floor and returns 0.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(var/obj/item/W)
	if(!W)
		return FALSE
	W.forceMove(get_turf(src))
	W.layer = initial(W.layer)
	W.plane = initial(W.plane)
	W.dropped()
	return FALSE

//Drops the item in our left hand
/mob/proc/drop_l_hand(var/atom/Target)
	return unEquip(l_hand, Target)

//Drops the item in our right hand
/mob/proc/drop_r_hand(var/atom/Target)
	return unEquip(r_hand, Target)

//Drops the item in our active hand. TODO: rename this to drop_active_hand or something
/mob/proc/drop_item(var/atom/Target)
	var/obj/item/I = get_active_hand()
	unEquip(I, Target, MOVED_DROP)

/mob/proc/isEquipped(obj/item/I)
	if(!I)
		return FALSE
	return get_inventory_slot(I) != 0

//This function is an unsafe proc used to prepare an item for being moved to a slot, or from a mob to a container
//It should be equipped to a new slot or forcemoved somewhere immediately after this is called
/mob/proc/prepare_for_slotmove(obj/item/I)
	src.u_equip(I)
	if (src.client)
		src.client.screen -= I
	I.layer = initial(I.layer)
	I.plane = initial(I.plane)
	I.screen_loc = null
	I.on_slotmove(src)
	return 1


//Returns the item equipped to the specified slot, if any.
/mob/proc/get_equipped_item(var/slot)
	switch(slot)
		if(slot_l_hand) return l_hand
		if(slot_r_hand) return r_hand
		if(slot_back) return back
		if(slot_wear_mask) return wear_mask
	return null

//Outdated but still in use apparently. This should at least be a human proc.
/mob/proc/get_equipped_items()
	return list()


//Returns the inventory slot for the current hand
/mob/proc/get_active_hand_slot()
	if (hand)
		return slot_l_hand
	return slot_r_hand