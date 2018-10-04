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


/obj/item/proc/pre_equip(var/mob/user, var/slot)
	return 0


/obj/item/proc/equipped(var/mob/user, var/slot)
	if(!istype(user))
		equip_slot = slot_none
		return

	equip_slot = slot
	layer = 20
	if(user.client)	user.client.screen |= src
	if(user.pulling == src) user.stop_pulling()
	if(user.l_hand)
		user.l_hand.update_held_icon()
	if(user.r_hand)
		user.r_hand.update_held_icon()


/obj/item/proc/dropped(mob/user as mob)
	..()
	if(zoom) zoom() //binoculars, scope, etc


//Defines which slots correspond to which slot flags
var/list/global/slot_flags_enumeration = list(
	"[slot_wear_mask]" = SLOT_MASK,
	"[slot_back]" = SLOT_BACK,
	"[slot_wear_suit]" = SLOT_OCLOTHING,
	"[slot_gloves]" = SLOT_GLOVES,
	"[slot_shoes]" = SLOT_FEET,
	"[slot_belt]" = SLOT_BELT,
	"[slot_glasses]" = SLOT_EYES,
	"[slot_head]" = SLOT_HEAD,
	"[slot_l_ear]" = SLOT_EARS|SLOT_TWOEARS,
	"[slot_r_ear]" = SLOT_EARS|SLOT_TWOEARS,
	"[slot_w_uniform]" = SLOT_ICLOTHING,
	"[slot_wear_id]" = SLOT_ID,
	"[slot_accessory_buffer]" = SLOT_ACCESSORY_BUFFER,
	)


//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to 1 if you wish it to not give you outputs.
//Should probably move the bulk of this into mob code some time, as most of it is related to the definition of slots and not item-specific
/obj/item/proc/mob_can_equip(M as mob, slot, disable_warning = 0)
	if(!slot) return 0
	if(!M) return 0

	if(!ishuman(M)) return 0

	var/mob/living/carbon/human/H = M
	var/list/mob_equip = list()
	if(H.species.hud && H.species.hud.equip_slots)
		mob_equip = H.species.hud.equip_slots

	if(H.species && !(slot in mob_equip))
		return 0

	//First check if the item can be equipped to the desired slot.
	if("[slot]" in slot_flags_enumeration)
		var/req_flags = slot_flags_enumeration["[slot]"]
		if(!(req_flags & slot_flags))
			return 0

	//Next check that the slot is free
	if(H.get_equipped_item(slot))
		return 0

	//Next check if the slot is accessible.
	var/mob/_user = disable_warning? null : H
	if(!H.slot_is_accessible(slot, src, _user))
		return 0

	//Lastly, check special rules for the desired slot.
	switch(slot)
		if(slot_l_ear, slot_r_ear)
			var/slot_other_ear = (slot == slot_l_ear)? slot_r_ear : slot_l_ear
			if( (w_class > ITEM_SIZE_TINY) && !(slot_flags & SLOT_EARS) )
				return 0
			if( (slot_flags & SLOT_TWOEARS) && H.get_equipped_item(slot_other_ear) )
				return 0
		if(slot_wear_id)
			if(!H.w_uniform && (slot_w_uniform in mob_equip))
				if(!disable_warning)
					H << SPAN_WARNING("You need a jumpsuit before you can attach this [name].")
				return 0
		if(slot_l_store, slot_r_store)
			if(!H.w_uniform && (slot_w_uniform in mob_equip))
				if(!disable_warning)
					H << SPAN_WARNING("You need a jumpsuit before you can attach this [name].")
				return 0
			if(slot_flags & SLOT_DENYPOCKET)
				return 0
			if( w_class > ITEM_SIZE_SMALL && !(slot_flags & SLOT_POCKET) )
				return 0
		if(slot_s_store)
			if(!H.wear_suit && (slot_wear_suit in mob_equip))
				if(!disable_warning)
					H << SPAN_WARNING("You need a suit before you can attach this [name].")
				return 0
			if(!H.wear_suit.allowed)
				if(!disable_warning)
					usr << SPAN_WARNING("You somehow have a suit with no defined allowed items for suit storage, stop that.")
				return 0
			if( !(istype(src, /obj/item/device/pda) || istype(src, /obj/item/weapon/pen) || is_type_in_list(src, H.wear_suit.allowed)) )
				return 0
		if(slot_handcuffed)
			if(!istype(src, /obj/item/weapon/handcuffs))
				return 0
		if(slot_legcuffed)
			if(!istype(src, /obj/item/weapon/legcuffs))
				return 0
		if(slot_in_backpack) //used entirely for equipping spawned mobs or at round start
			var/allow = 0
			if(H.back && istype(H.back, /obj/item/weapon/storage/backpack))
				var/obj/item/weapon/storage/backpack/B = H.back
				if(B.can_be_inserted(src,1))
					allow = 1
			if(!allow)
				return 0
		if(slot_accessory_buffer)
			if(!H.w_uniform && (slot_w_uniform in mob_equip))
				if(!disable_warning)
					H << SPAN_WARNING("You need a jumpsuit before you can attach this [name].")
				return 0
			var/obj/item/clothing/under/uniform = H.w_uniform
			if(uniform.accessories.len && !uniform.can_attach_accessory(src))
				if (!disable_warning)
					H << SPAN_WARNING("You already have an accessory of this type attached to your [uniform].")
				return 0
	return 1


/obj/item/proc/mob_can_unequip(mob/M, slot, disable_warning = 0)
	if(!slot) return 0
	if(!M) return 0

	if(!canremove)
		return 0
	if(!M.slot_is_accessible(slot, src, disable_warning? null : M))
		return 0
	return 1


/obj/item/proc/is_equipped()
	if (istype(loc, /mob))
		if (equip_slot != slot_none)
			return TRUE
	return FALSE


/obj/item/proc/is_worn()
	if (istype(loc, /mob))
		if (equip_slot != slot_none && equip_slot != slot_l_hand && equip_slot != slot_r_hand)
			return TRUE
	return FALSE


/obj/item/proc/is_held()
	if (istype(loc, /mob))
		if (equip_slot == slot_l_hand || equip_slot == slot_r_hand)
			return TRUE
	return FALSE


/obj/item/proc/get_equip_slot()
	if (istype(loc, /mob))
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

