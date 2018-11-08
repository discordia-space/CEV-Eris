/mob/proc/slot_is_accessible(var/slot, var/obj/item/Item, mob/user=null)
	return TRUE


/proc/mob_can_equip(mob/living/Mob, obj/item/Item, slot, disable_warning)
	if(!istype(Mob) || !istype(Item) || !isnum(slot))
		return FALSE
	return Mob.can_equip(Item, slot, disable_warning) && Item.can_be_equipped(Mob, slot, disable_warning)


/mob/proc/can_equip(obj/item/Item, slot, disable_warning = FALSE)
	if(get_equipped_item(slot))
		if(!disable_warning)
			src << SPAN_WARNING("You already has something equipped here!")
		return FALSE
	return TRUE


/mob/living/carbon/human/can_equip(obj/item/Item, slot, disable_warning = FALSE)
	if(!slot)
		return FALSE
	if(species.hud && species.hud.equip_slots)
		if(!(slot in species.hud.equip_slots))
			if(!disable_warning)
				src << SPAN_WARNING("Your species can't wear that!")
			return FALSE

	var/datum/inventory_slot/S = SSinventory.get_slot_datum(slot)
	if(S && !S.can_equip(Item, src, disable_warning))
		return FALSE

	return slot_is_accessible(slot, Item, disable_warning? null : src) && ..()



/proc/mob_can_unequip(mob/living/Mob, obj/item/Item, disable_warning)
	if(!istype(Mob) || !istype(Item))
		return FALSE

	var/slot = Mob.get_inventory_slot(Item)
	if(!slot)
		return FALSE

	return Mob.can_unequip(Item, slot, disable_warning) && Item.can_be_unequipped(src, slot, disable_warning)


/mob/proc/can_unequip(obj/item/Item, slot, disable_warning = FALSE)
	return slot_is_accessible(slot, Item, disable_warning? null : src)




/mob/proc/get_inventory_slot(obj/item/Item)
	return Item && Item.get_holding_mob() == src && Item.get_equip_slot()

