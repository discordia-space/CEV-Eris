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

/mob/proc/get_inventory_slot(obj/item/I)
	var/slot = slot_none
	if (I.get_holding_mob() == src)
		slot = I.get_equip_slot()
	return slot

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