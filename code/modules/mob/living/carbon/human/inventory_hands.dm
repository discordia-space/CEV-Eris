//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting l_hand = ...etc
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

//// GET ////
//Returns the thing in our active/inactive hand
/mob/living/carbon/human/get_active_hand()
	if(hand)	return l_hand
	else		return r_hand

/mob/living/carbon/human/get_inactive_hand()
	if(hand)	return r_hand
	else		return l_hand

//Returns our active hand organ
/mob/living/carbon/human/proc/get_active_hand_organ()
	if(hand)
		return get_organ(BP_L_ARM)
	else
		return get_organ(BP_R_ARM)


/mob/living/carbon/human/proc/get_holding_hand(var/obj/item/W)
	switch(get_inventory_slot(W))
		if(slot_l_hand)
			return BP_L_ARM
		if(slot_r_hand)
			return BP_R_ARM


//// PUT IN ////
//Puts the item into our l_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/living/carbon/human/proc/put_in_l_hand(var/obj/item/W)
	. = equip_to_slot_if_possible(W, slot_l_hand, 0, 1)
	if(.)
		W.add_fingerprint(src)


//Puts the item into our r_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/living/carbon/human/proc/put_in_r_hand(var/obj/item/W)
	. = equip_to_slot_if_possible(W, slot_r_hand, 0, 1)
	if(.)
		W.add_fingerprint(src)


//Puts the item into our active/inactive hand if possible. returns 1 on success.
/mob/living/carbon/human/put_in_active_hand(var/obj/item/W)
	if(hand)	return put_in_l_hand(W)
	else		return put_in_r_hand(W)

/mob/living/carbon/human/put_in_inactive_hand(var/obj/item/W)
	if(hand)	return put_in_r_hand(W)
	else		return put_in_l_hand(W)

/mob/living/carbon/human/put_in_hands(var/obj/item/W)
	if(!W)
		return FALSE
	if(put_in_active_hand(W) || put_in_inactive_hand(W))
		return TRUE
	else
		return ..()


//// DROP ITEM ////
//Drops the item in our left hand
/mob/living/carbon/human/proc/drop_l_hand(var/atom/Target)
	return unEquip(l_hand, Target)

//Drops the item in our right hand
/mob/living/carbon/human/proc/drop_r_hand(var/atom/Target)
	return unEquip(r_hand, Target)


//Drops the item from our active/inactive hand
/mob/living/carbon/human/drop_active_hand(var/atom/Target)
	if(hand)	return drop_l_hand(Target)
	else		return drop_r_hand(Target)

/mob/living/carbon/human/drop_all_hands(pick_one = FALSE)
	if(pick_one)
		if(prob(50))
			return drop_r_hand()
		else
			return drop_l_hand()
	else
		drop_r_hand() 
		drop_l_hand()


