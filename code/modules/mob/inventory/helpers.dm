/mob/living
	var/list/inventory = list()

/mob/living/proc/has_inventory_slot(slot)
	return slot in inventory


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



//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/proc/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	return TRUE


/mob/proc/can_equip(obj/item/W, slot, disable_warning = FALSE)
	return FALSE


/mob/living/carbon/human/can_equip(obj/item/Item, slot, disable_warning = FALSE)
	if(!slot)
		return FALSE

	if(species.hud && species.hud.equip_slots)
		if(!(slot in species.hud.equip_slots))
			if(!disable_warning)
				src << SPAN_WARNING("Your species can't wear that!")
			return FALSE

	if(get_equipped_item(slot))
		if(!disable_warning)
			src << SPAN_WARNING("You already has something equipped here!")
		return FALSE

	var/datum/slot/S = get_inventory_slot_datum(slot)
	if(S && !S.can_equip(Item, src, disable_warning))
		return FALSE

	return slot_is_accessible(slot, Item, disable_warning? null : src)

/mob/proc/can_unequip(obj/item/Item, slot, disable_warning = FALSE)
	return slot_is_accessible(slot, Item, disable_warning? null : src)


/mob/proc/get_inventory_slot(obj/item/I)
	return I && I.get_holding_mob() == src && I.get_equip_slot()

//Returns the item equipped to the specified slot, if any.
/mob/proc/get_equipped_item(var/slot)
	return null

//Outdated but still in use apparently. This should at least be a human proc.
/mob/proc/get_equipped_items()
	return list()



