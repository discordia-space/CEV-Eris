/obj/item
	var/overslot = 0
	var/obj/item/overslot_contents = null

/mob/proc/slot_is_accessible(var/slot, var/obj/item/Item, mob/user=null)
	return TRUE

/proc/mob_can_equip(mob/living/Mob, obj/item/Item, slot, disable_warning)
	if(!istype(Mob) || !istype(Item) || !isnum(slot))
		return FALSE
	return Mob.can_equip(Item, slot, disable_warning) && Item.can_be_equipped(Mob, slot, disable_warning)

/mob/proc/can_equip(obj/item/Item, slot, disable_warning = FALSE, skip_item_check = FALSE, skip_covering_check = FALSE)
	if(skip_item_check)
		return TRUE
	var/obj/item/equipped = get_equipped_item(slot)
	if(equipped)
		if(Item.overslot && !equipped.overslot)
			return TRUE
		if(!disable_warning)
			to_chat(src, SPAN_WARNING("You already has something equipped here!"))
		return FALSE //Note, this one goes from if(equipped), not overslot check
	return TRUE

/mob/living/carbon/human/can_equip(obj/item/Item, slot, disable_warning = FALSE, skip_item_check = FALSE, skip_covering_check = FALSE)
	if(!slot)
		return FALSE

	if(!species.has_equip_slot(slot))
		to_chat(src, SPAN_WARNING("Your species can't wear that!"))
		return FALSE

	var/datum/inventory_slot/S = SSinventory.get_slot_datum(slot)
	if(S && !S.can_equip(Item, src, disable_warning))
		return FALSE

	if(!skip_covering_check && !slot_is_accessible(slot, Item, disable_warning? null : src))
		return FALSE

	return ..()