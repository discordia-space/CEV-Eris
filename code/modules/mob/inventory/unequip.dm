/mob/proc/u_equip(obj/item/Item)


/mob/proc/drop_from_inventory(var/obj/item/Item, var/atom/Target = null, drop_flag = null)
	src.u_equip(Item)

	if(!Item || !Item.loc)
		return TRUE // self destroying objects (tk, grabs)

	if(!Target)
		Target = src.loc
		drop_flag = MOVED_DROP

	Item.forceMove(Target, drop_flag)
	return TRUE



/mob/proc/unEquip(obj/item/Item, atom/Target)
	if(!mob_can_unequip(src, Item))
		src << SPAN_WARNING("You can't unequip [Item]!")
		return FALSE

	return drop_from_inventory(Item, Target)

