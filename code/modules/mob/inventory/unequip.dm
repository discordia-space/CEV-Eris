/mob/proc/u_equip(obj/item/Item)

/mob/proc/drop_from_inventory(var/obj/item/Item, var/atom/Target = null, drop_flag = null)
	src.u_equip(Item)
	if (src.client)
		src.client.screen -= Item
	Item.layer = initial(Item.layer)
	Item.plane = initial(Item.plane)
	Item.screen_loc = null

	if(!Item || !Item.loc)
		return TRUE // self destroying objects (tk, grabs)

	if(!Target)
		Target = src.loc
		drop_flag = MOVED_DROP
	Item.forceMove(Target, drop_flag)
	return TRUE


/mob/proc/unEquip(obj/item/Item, atom/Target)
	var/slot = get_inventory_slot(Item)
	if(!slot)
		return FALSE
	if(!can_unequip(Item, slot) || !Item.can_be_unequipped(src, slot))
		return FALSE
	return drop_from_inventory(Item, Target)
