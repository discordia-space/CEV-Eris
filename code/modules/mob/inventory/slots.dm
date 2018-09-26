/proc/get_inventory_slot_datum(slot)
	var/global/list/datums
	if(!datums)
		datums = list()
		for(var/path in subtypesof(/datum/slot))
			var/datum/slot/S = path
			if(!initial(S.id))
				continue
			S = new S()
			if(S.id > datums.len)
				datums.len = S.id
			datums[S.id] = S
	return datums.len > slot ? datums[slot] : null

/datum/slot
	var/name
	var/id

	var/update_proc

	//restriction
	//req all of it
	var/req_item_in_slot
	var/req_organ //can be list

	//req one of it
	var/req_slot_flags
	var/req_type
	var/max_w_class

/datum/slot/proc/can_equip(obj/item/I, mob/living/carbon/human/owner, disable_warning)
	if(req_item_in_slot && !owner.get_equipped_item(req_item_in_slot))
		//owner << SPAN_WARNING("You need a jumpsuit before you can attach this [name].")
		return FALSE
	if(req_organ)
		if(islist(req_organ))
			for(var/organ in req_organ)
				if(!owner.has_organ(organ, req_organ[organ]))
					return FALSE
		else
			if(!owner.has_organ(req_organ))
				return FALSE

	if(req_type && istype(I, req_type))
		return TRUE
	else if(req_slot_flags && (req_slot_flags & I.slot_flags))
		return TRUE
	else if(max_w_class && (I.w_class <= max_w_class))
		return TRUE

	return FALSE

/datum/slot/proc/update_icon(mob/living/owner, redraw)
	call(owner, update_proc)(redraw)

/datum/slot/back
	name = "Back"
	id = slot_back
	req_organ = BP_CHEST
	req_slot_flags = SLOT_BACK
	update_proc = /mob/proc/update_inv_back

/datum/slot/mask
	name = "Mask"
	id = slot_wear_mask
	req_organ = BP_HEAD
	req_slot_flags = SLOT_MASK
	update_proc = /mob/proc/update_inv_wear_mask

/datum/slot/handcuffes
	name = "Handcuffes"
	id = slot_handcuffed
	req_organ = list(BP_L_ARM, BP_R_ARM)
	req_type = /obj/item/weapon/handcuffs
	update_proc = /mob/proc/update_inv_handcuffed

/datum/slot/legcuffes
	name = "Legcuffes"
	id = slot_legcuffed
	req_organ = list(BP_L_LEG, BP_R_LEG)
	req_type = /obj/item/weapon/legcuffs
	update_proc = /mob/proc/update_inv_legcuffed


/datum/slot/hand/can_equip()
	return TRUE

/datum/slot/hand/left
	name = "Left hand"
	id = slot_l_hand
	req_organ = list(BP_L_ARM = 1)
	update_proc = /mob/proc/update_inv_l_hand

/datum/slot/hand/rigth
	name = "Right hand"
	id = slot_r_hand
	req_organ = list(BP_R_ARM = 1)
	update_proc = /mob/proc/update_inv_r_hand

/datum/slot/belt
	name = "belt"
	id = slot_belt
	req_organ = BP_CHEST
	req_slot_flags = SLOT_BELT
	update_proc = /mob/proc/update_inv_belt

/datum/slot/id
	name = "ID card"
	id = slot_wear_id
	req_slot_flags = SLOT_ID
	update_proc = /mob/proc/update_inv_belt


/datum/slot/ear
	req_organ = BP_HEAD
	req_slot_flags = SLOT_EARS|SLOT_TWOEARS
	update_proc = /mob/proc/update_inv_ears

/datum/slot/ear/can_equip(obj/item/I, mob/living/carbon/human/owner, disable_warning)
	if(I.slot_flags & SLOT_TWOEARS)
		var/slot_other_ear = (id == slot_l_ear)? slot_r_ear : slot_l_ear
		return !owner.get_equipped_item(slot_other_ear)
	return ..()

/datum/slot/ear/left
	name = "Left ear"
	id = slot_l_ear

/datum/slot/ear/right
	name = "Right ear"
	id = slot_r_ear
	req_slot_flags = SLOT_EARS
	max_w_class = ITEM_SIZE_TINY


/datum/slot/glasses
	name = "Glasses"
	id = slot_glasses
	req_organ = BP_HEAD
	req_slot_flags = SLOT_EYES

/datum/slot/gloves
	name = "Gloves"
	id = slot_gloves
	req_organ = list(BP_L_ARM, BP_R_ARM)
	req_slot_flags = SLOT_GLOVES

/datum/slot/head
	name = "Head"
	id = slot_head
	req_organ = BP_HEAD
	req_slot_flags = SLOT_HEAD

/datum/slot/shoes
	name = "Shoes"
	id = slot_shoes
	req_organ = list(BP_L_LEG, BP_R_LEG)
	req_slot_flags = SLOT_FEET

/datum/slot/wear_suit
	name = "Wear suit"
	id = slot_wear_suit
	req_organ = BP_CHEST
	req_slot_flags = SLOT_OCLOTHING

/datum/slot/uniform
	name = "Uniform"
	id = slot_w_uniform
	req_organ = BP_CHEST
	req_slot_flags = SLOT_ICLOTHING

/datum/slot/store
	req_item_in_slot = slot_w_uniform
	max_w_class = ITEM_SIZE_SMALL

/datum/slot/store/can_equip(obj/item/I, mob/living/carbon/human/owner, disable_warning)
	if(I.slot_flags & SLOT_DENYPOCKET)
		return FALSE
	else
		return ..()

/datum/slot/store/left
	name = "Left store"
	id = slot_l_store

/datum/slot/store/rigth
	name = "Right store"
	id = slot_r_store


/datum/slot/special_store
	name = "Store"
	id = slot_s_store
	req_item_in_slot = slot_wear_suit

/datum/slot/special_store/can_equip(obj/item/I, mob/living/carbon/human/owner, disable_warning)
	if(!..())
		return FALSE
	var/obj/item/wear_suit = owner.get_equipped_item(slot_wear_suit)
	if(!wear_suit.allowed)
		if(!disable_warning)
			usr << SPAN_WARNING("You can't attach anything to that [wear_suit].")
		return FALSE
	return is_type_in_list(src, wear_suit.allowed + list(/obj/item/device/pda, /obj/item/weapon/pen))

/datum/slot/in_backpack
	name = "Slot in backpack"
	id = slot_in_backpack

/datum/slot/accessory
	name = "Slot accessory"
	id = slot_accessory_buffer


/*
slot_legs
*/