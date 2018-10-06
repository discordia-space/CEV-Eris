/datum/inventory_slot
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

/datum/inventory_slot/proc/update_icon(mob/living/owner, redraw)
	if(update_proc)
		call(owner, update_proc)(redraw)

/datum/inventory_slot/back
	name = "Back"
	id = slot_back
	req_organ = BP_CHEST
	req_slot_flags = SLOT_BACK
	update_proc = /mob/proc/update_inv_back

/datum/inventory_slot/mask
	name = "Mask"
	id = slot_wear_mask
	req_organ = BP_HEAD
	req_slot_flags = SLOT_MASK
	update_proc = /mob/proc/update_inv_wear_mask

/datum/inventory_slot/handcuffs
	name = "Handcuffs"
	id = slot_handcuffed
	req_organ = list(BP_L_ARM, BP_R_ARM)
	req_type = /obj/item/weapon/handcuffs
	update_proc = /mob/proc/update_inv_handcuffed

/datum/inventory_slot/legcuffs
	name = "Legcuffs"
	id = slot_legcuffed
	req_organ = list(BP_L_LEG, BP_R_LEG)
	req_type = /obj/item/weapon/legcuffs
	update_proc = /mob/proc/update_inv_legcuffed


/datum/inventory_slot/hand
	req_type = /obj/item

/datum/inventory_slot/hand/left
	name = "Left hand"
	id = slot_l_hand
	req_organ = list(BP_L_ARM = 1)
	update_proc = /mob/proc/update_inv_l_hand

/datum/inventory_slot/hand/rigth
	name = "Right hand"
	id = slot_r_hand
	req_organ = list(BP_R_ARM = 1)
	update_proc = /mob/proc/update_inv_r_hand

/datum/inventory_slot/belt
	name = "belt"
	id = slot_belt
	req_organ = BP_CHEST
	req_slot_flags = SLOT_BELT
	update_proc = /mob/proc/update_inv_belt

/datum/inventory_slot/id
	name = "ID card"
	id = slot_wear_id
	req_slot_flags = SLOT_ID
	update_proc = /mob/proc/update_inv_wear_id


/datum/inventory_slot/ear
	req_organ = BP_HEAD
	req_slot_flags = SLOT_EARS|SLOT_TWOEARS
	update_proc = /mob/proc/update_inv_ears

/datum/inventory_slot/ear/left
	name = "Left ear"
	id = slot_l_ear

/datum/inventory_slot/ear/right
	name = "Right ear"
	id = slot_r_ear
	req_slot_flags = SLOT_EARS
	max_w_class = ITEM_SIZE_TINY


/datum/inventory_slot/glasses
	name = "Glasses"
	id = slot_glasses
	req_organ = BP_HEAD
	req_slot_flags = SLOT_EYES
	update_proc = /mob/proc/update_inv_glasses

/datum/inventory_slot/gloves
	name = "Gloves"
	id = slot_gloves
	req_organ = list(BP_L_ARM, BP_R_ARM)
	req_slot_flags = SLOT_GLOVES
	update_proc = /mob/proc/update_inv_gloves

/datum/inventory_slot/head
	name = "Head"
	id = slot_head
	req_organ = BP_HEAD
	req_slot_flags = SLOT_HEAD
	update_proc = /mob/proc/update_inv_head

/datum/inventory_slot/shoes
	name = "Shoes"
	id = slot_shoes
	req_organ = list(BP_L_LEG, BP_R_LEG)
	req_slot_flags = SLOT_FEET
	update_proc = /mob/proc/update_inv_shoes

/datum/inventory_slot/wear_suit
	name = "Wear suit"
	id = slot_wear_suit
	req_organ = BP_CHEST
	req_slot_flags = SLOT_OCLOTHING
	update_proc = /mob/proc/update_inv_wear_suit

/datum/inventory_slot/uniform
	name = "Uniform"
	id = slot_w_uniform
	req_organ = BP_CHEST
	req_slot_flags = SLOT_ICLOTHING
	update_proc = /mob/proc/update_inv_w_uniform

/datum/inventory_slot/store
	req_item_in_slot = slot_w_uniform
	max_w_class = ITEM_SIZE_SMALL
	update_proc = /mob/proc/update_inv_pockets

/datum/inventory_slot/store/left
	name = "Left store"
	id = slot_l_store

/datum/inventory_slot/store/rigth
	name = "Right store"
	id = slot_r_store


/datum/inventory_slot/special_store
	name = "Store"
	id = slot_s_store
	req_item_in_slot = slot_wear_suit
	update_proc = /mob/proc/update_inv_s_store


//Special virtual slots. Here for backcompability.
/datum/inventory_slot/in_backpack
	name = "Slot in backpack"
	id = slot_in_backpack


/datum/inventory_slot/accessory
	name = "Slot accessory"
	id = slot_accessory_buffer

/*
slot_legs
*/