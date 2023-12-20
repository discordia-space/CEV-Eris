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
/mob/proc/put_in_hands(obj/item/W)
	if(istype(W))
		W.forceMove(get_turf(src))
		W.layer = initial(W.layer)
		W.set_plane(initial(W.plane))
		W.dropped(usr)

// Removes an item from inventory and places it in the target atom.
// If canremove or other conditions need to be checked then use unEquip instead.
/mob/proc/drop_from_inventory(var/obj/item/W, var/atom/Target = null, drop_flag = null)
	if(W)
		if(W.wielded)
			W.unwield(src)
		if(!Target)
			Target = loc

		remove_from_mob(W)
		if(!(W && W.loc))
			return TRUE // self destroying objects (tk, grabs)

		if(W.loc != Target)
			W.do_putdown_animation(Target, src)
			W.forceMove(Target, drop_flag)
		update_icons()
		return TRUE
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

/mob/proc/drop_offhand(var/atom/Target)
	var/obj/item/I = get_inactive_hand()
	unEquip(I, Target, MOVED_DROP)

/*
	Removes the object from any slots the mob might have, calling the appropriate icon update proc.
	Does nothing else.

	DO NOT CALL THIS PROC DIRECTLY. It is meant to be called only by other inventory procs.
	It's probably okay to use it if you are transferring the item between slots on the same mob,
	but chances are you're safer calling remove_from_mob() or drop_from_inventory() anyways.

	As far as I can tell the proc exists so that mobs with different inventory slots can override
	the search through all the slots, without having to duplicate the rest of the item dropping.
*/
/mob/proc/u_equip(obj/W as obj)
	if (W == r_hand)
		r_hand = null
		update_inv_r_hand(0)
	else if (W == l_hand)
		l_hand = null
		update_inv_l_hand(0)
	else if (W == back)
		back = null
		update_inv_back(0)
	else if (W == wear_mask)
		wear_mask = null
		update_inv_wear_mask(0)
	return

/mob/proc/isEquipped(obj/item/I)
	if(!I)
		return FALSE
	return get_inventory_slot(I) != 0

/mob/proc/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return TRUE
	var/slot = get_inventory_slot(I)
	return slot && I.mob_can_unequip(src, slot)

/mob/proc/get_inventory_slot(obj/item/I)
	var/slot = slot_none
	if (I.get_holding_mob() == src)
		slot = I.get_equip_slot()
	return slot

//This differs from remove_from_mob() in that it checks if the item can be unequipped first.
/mob/proc/unEquip(obj/item/I, var/atom/Target = null, force = 0) //Force overrides NODROP for things like wizarditis and admin undress.
	if(!canUnEquip(I))
		return
	SEND_SIGNAL_OLD(src, COMSIG_CLOTH_DROPPED, I)
	if(I)
		SEND_SIGNAL_OLD(I, COMSIG_CLOTH_DROPPED, src)
	return drop_from_inventory(I,Target)

//Attemps to remove an object on a mob.
/mob/proc/remove_from_mob(obj/O, drop = TRUE)
	u_equip(O)
	if (client)
		client.screen -= O
	O.layer = initial(O.layer)
	O.set_plane(initial(O.plane))
	O.screen_loc = null
	if(istype(O, /obj/item))
		var/obj/item/I = O
		if(drop && !QDELING(O))
			I.forceMove(get_turf(src), MOVED_DROP)
		I.dropped(src)
	return TRUE


//This function is an unsafe proc used to prepare an item for being moved to a slot, or from a mob to a container
//It should be equipped to a new slot or forcemoved somewhere immediately after this is called
/mob/proc/prepare_for_slotmove(obj/item/I)
	u_equip(I)
	if (client)
		client.screen -= I
	I.layer = initial(I.layer)
	I.set_plane(initial(I.plane))
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

/mob/proc/get_max_volumeClass()
	return 0 //zero

/mob/proc/get_total_style()
	return 0 //zero

//Returns the inventory slot for the current hand
/mob/proc/get_active_hand_slot()
	if (hand)
		return slot_l_hand
	return slot_r_hand

/mob/proc/delete_inventory(var/include_carried = FALSE)
	for(var/entry in get_equipped_items(include_carried))
		drop_from_inventory(entry)
		qdel(entry)

/mob/proc/equip_to_slot_or_store_or_drop(obj/item/W as obj, slot)
	var/store = equip_to_slot_if_possible(W, slot, 0, 1, 0)
	if(!store)
		return equip_to_storage_or_drop(W)
	return store

/mob/proc/equip_to_storage_or_drop(obj/item/newitem)
	var/stored = equip_to_storage(newitem)
	if(!stored && newitem)
		newitem.forceMove(loc)
	return stored

// Returns all items which covers any given body part
/mob/proc/get_covering_equipped_items(var/body_parts)
	. = list()
	for(var/entry in get_equipped_items())
		var/obj/item/I = entry
		if(I.body_parts_covered & body_parts)
			. += I
