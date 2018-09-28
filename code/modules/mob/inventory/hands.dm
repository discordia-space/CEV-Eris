//Declarations. Overrided in human/robots subtypes
/mob/proc/get_active_hand()
/mob/proc/get_inactive_hand()

//Declarations. Overrided in human/robots subtypes
/mob/proc/put_in_active_hand(var/obj/item/Item)
/mob/proc/put_in_inactive_hand(var/obj/item/Item)

/mob/proc/put_in_hands(var/obj/item/Item)
	if(!Item)
		return FALSE
	if(put_in_active_hand(Item) || put_in_inactive_hand(Item))
		return TRUE
	if(Item.is_equipped())
		var/mob/Holder = Item.loc
		Holder.unEquip(Item, src.loc)
	else
		Item.do_putdown_animation(src.loc, src)
		Item.forceMove(src.loc)
	return FALSE

//Declarations. Overrided in human/robots subtypes
/mob/proc/drop_active_hand(var/atom/Target)
/mob/proc/drop_all_hands(var/pick_one = FALSE)

