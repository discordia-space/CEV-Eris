/mob/proc/equip_to_slot(obj/item/W, slot, redraw_mob = TRUE)

/mob/proc/equip_to_slot_if_possible(obj/item/Item, slot, disable_warning, redraw_mob = TRUE)

	if(!istype(Item))
		return FALSE

	if(!can_equip(Item, slot) || !Item.can_be_equipped(src, slot))
		if(!disable_warning)
			src << SPAN_WARNING("You are unable to equip that.")
		return FALSE

	var/world_time = world.timeofday

	//Pre-equip intercepts here to let the item know it's about to be equipped
	if(Item.pre_equip(src, slot))
		return FALSE

	//Pre-equip can take time
	if(world_time != world.timeofday)
		if(!can_equip(Item, slot) || !Item.can_be_equipped(src, slot))
			if(!disable_warning)
				src << SPAN_WARNING("You are unable to equip that.")
			return FALSE

	if(Item.is_equipped())
		var/mob/Wearer = Item.loc
		if(!Wearer.unEquip(Item))
			return FALSE

	equip_to_slot(Item, slot, redraw_mob) //This proc should not ever fail.


	if(!istype(Item, /obj/item/clothing/suit/storage) || !istype(Item, /obj/item/weapon/storage))
		if(Item.w_class > ITEM_SIZE_NORMAL)
			play_long()
		else
			play_short()

	return TRUE


/mob/proc/equip_to_slot_or_del(obj/item/Item, slot)
	. = equip_to_slot_if_possible(Item, slot, disable_warning = TRUE, redraw_mob = FALSE)
	if(!.)
		qdel(Item)



//The list of slots by priority. equip_to_appropriate_slot() uses this list.
//Doesn't matter if a mob type doesn't have a slot.
//TODO: get rid of this.
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


/mob/proc/equip_to_appropriate_slot(obj/item/Item)
	if(!istype(Item))
		return FALSE

	for(var/slot in slot_equipment_priority)
		if(equip_to_slot_if_possible(Item, slot, disable_warning = TRUE))
			return TRUE

	return FALSE


/mob/proc/equip_to_storage(obj/item/Item)
	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/weapon/storage/S in get_equipped_items())
		if(S.can_be_inserted(Item, TRUE))
			Item.forceMove(S)
			return S

/mob/living/carbon/human/equip_to_storage(obj/item/Item)
	// Try put it in their backpack
	if(istype(src.back,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/backpack = src.back
		if(backpack.can_be_inserted(Item, TRUE))
			Item.forceMove(src.back)
			return backpack
	return ..()
