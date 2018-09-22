//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
var/list/slot_equipment_priority = list(
	slot_back,
	slot_wear_id,
	slot_w_uniform,
	slot_wear_suit,
	slot_wear_mask,
	slot_head,
	slot_shoes,
	slot_gloves,
	slot_l_ear,
	slot_r_ear,
	slot_glasses,
	slot_belt,
	slot_s_store,
	slot_accessory_buffer,
	slot_l_store,
	slot_r_store
)


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

//This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on whether you can or can't eqip need to be done before!
//Use mob_can_equip() for that task.
//In most cases you will want to use equip_to_slot_if_possible()
/mob/proc/equip_to_slot(obj/item/W as obj, slot)
	return

//This is a SAFE proc. Use this instead of equip_to_slot()!
//set del_on_fail to have it delete W if it fails to equip
//set disable_warning to disable the 'you are unable to equip that' warning.
//unset redraw_mob to prevent the mob from being redrawn at the end.
/mob/proc/equip_to_slot_if_possible(obj/item/W as obj, slot, del_on_fail = 0, disable_warning = 0, redraw_mob = 1)

	if(!istype(W))
		return FALSE

	if(!W.mob_can_equip(src, slot))
		if(del_on_fail)
			qdel(W)
		else
			if(!disable_warning)
				src << "\red You are unable to equip that." //Only print if del_on_fail is false
		return FALSE

	//Pre-equip intercepts here to let the item know it's about to be equipped
	if (W.pre_equip(src, slot))
		return FALSE

	equip_to_slot(W, slot, redraw_mob) //This proc should not ever fail.


	if(!istype(W, /obj/item/clothing/suit/storage) || !istype(W, /obj/item/weapon/storage))
		if(W.w_class > ITEM_SIZE_NORMAL)
			play_long()
		else
			play_short()

	return TRUE

//This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to equip people when the rounds tarts and when events happen and such.
/mob/proc/equip_to_slot_or_del(obj/item/W as obj, slot)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/proc/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	return TRUE

//puts the item "W" into an appropriate slot in a human's inventory
//returns 0 if it cannot, 1 if successful
/mob/proc/equip_to_appropriate_slot(obj/item/W)
	if(!istype(W))
		return FALSE

	for(var/slot in slot_equipment_priority)
		if(equip_to_slot_if_possible(W, slot, del_on_fail=0, disable_warning=1, redraw_mob=1))
			return TRUE

	return FALSE

/mob/proc/equip_to_storage(obj/item/newitem)
	// Try put it in their backpack
	if(istype(src.back,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/backpack = src.back
		if(backpack.can_be_inserted(newitem, 1))
			newitem.forceMove(src.back)
			return backpack

	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/weapon/storage/S in src.contents)
		if(S.can_be_inserted(newitem, 1))
			newitem.forceMove(S)
			return S

//Returns the thing in our active/inactive hand
//Declarations. Overrided in human/robots subtypes
/mob/proc/get_active_hand()
/mob/proc/get_inactive_hand()

//Puts the item into our active/inactive hand if possible. returns 1 on success.
//Declarations. Overrided in human/robots subtypes
/mob/proc/put_in_active_hand(var/obj/item/W)
/mob/proc/put_in_inactive_hand(var/obj/item/W)

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

//Drops the item in our active hand or all hands
//Declarations. Overrided in human/robots subtypes
/mob/proc/drop_active_hand(var/atom/Target)
/mob/proc/drop_all_hands(var/pick_one = FALSE) // Pick_one - drop one random hand else drop all


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


//Attemps to remove an object on a mob.
/mob/proc/remove_from_mob(var/obj/item/O)
	src.u_equip(O)
	if (src.client)
		src.client.screen -= O
	O.layer = initial(O.layer)
	O.plane = initial(O.plane)
	O.screen_loc = null
	if(istype(O))
		O.forceMove(src.loc, MOVED_DROP)
		O.dropped(src)
	return TRUE

// Removes an item from inventory and places it in the target atom.
// If canremove or other conditions need to be checked then use unEquip instead.
/mob/proc/drop_from_inventory(var/obj/item/W, var/atom/Target = null, drop_flag = null)
	if(W)
		remove_from_mob(W)
		if(!(W && W.loc))
			return TRUE // self destroying objects (tk, grabs)

		if(W.loc != Target)
			W.forceMove(Target, drop_flag)
		return TRUE

/mob/proc/get_inventory_slot(obj/item/I)
	var/slot = slot_none
	if (I.get_holding_mob() == src)
		slot = I.get_equip_slot()
	return slot

/mob/proc/isEquipped(obj/item/I)
	if(!I)
		return FALSE
	return get_inventory_slot(I) != 0


/mob/proc/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return TRUE
	var/slot = get_inventory_slot(I)
	return slot && I.mob_can_unequip(src, slot)


//This differs from remove_from_mob() in that it checks if the item can be unequipped first.
/mob/proc/unEquip(obj/item/I, var/atom/Target = null)
	if(!canUnEquip(I))
		return
	return drop_from_inventory(I,Target)

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
	return null

//Outdated but still in use apparently. This should at least be a human proc.
/mob/proc/get_equipped_items()
	return list()


//Returns the inventory slot for the current hand
/mob/proc/get_active_hand_slot()
	if (hand)
		return slot_l_hand
	return slot_r_hand


/mob/proc/can_pickup(var/obj/item/I, var/feedback = TRUE)
	if(!canmove || stat || restrained() || !Adjacent(usr))
		return

	var/slot = get_active_hand_slot()
	if (!I || !I.mob_can_equip(src, slot, TRUE))
		//Picking up is going to fail, maybe we can tell the user why

		return

	return TRUE


//////
//Some inventory sounds.
//occurs when you click and put up or take off something from you (any UI slot acceptable)
/////
/mob/proc/play_short()
	var/list/sounds = list(
	'sound/misc/inventory/short_1.ogg',
	'sound/misc/inventory/short_2.ogg',
	'sound/misc/inventory/short_3.ogg'
	)

	var/picked_sound = pick(sounds)

	playsound(src, picked_sound, 100, 1, 1)

/mob/proc/play_long()
	var/list/sounds = list(
	'sound/misc/inventory/long_1.ogg',
	'sound/misc/inventory/long_2.ogg',
	'sound/misc/inventory/long_3.ogg'
	)

	var/picked_sound = pick(sounds)

	playsound(src, picked_sound, 100, 1, 1)