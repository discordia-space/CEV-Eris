// EQUIP //


/mob/proc/equip_to_slot(obj/item/Item, slot, redraw_mob = TRUE)
/*
This is an UNSAFE proc.
It merely handles the actual job of equipping. Set vars, update icons. Also calls Item.equipped(mob, slot).
All the checks on whether you can or can't eqip need to be done before! Use mob_can_equip() for that task.
In most cases you will want to use equip_to_slot_if_possible()
*/


/mob/proc/equip_to_slot_if_possible(
	obj/item/Item,
	slot,
	disable_warning = FALSE,
	redraw_mob = TRUE
)
/*
This is a SAFE proc. Use this instead of equip_to_slot()!
Set disable_warning to disable the 'you are unable to equip that' warning.
Unset redraw_mob to prevent the mob from being redrawn at the end.


It calls:
	- Mob.can_equip(Item, slot, disable_warning) and Item.can_be_equiped(mob, slot, disable_warning)
	- If Item already equipped on someone other_mob.unEquip(Item) will be called.
	- Item.pre_equip(src, slot)
	- Mob.equip_to_slot(Item, slot, redraw_mob)
*/


/mob/proc/equip_to_slot_or_del(obj/item/Item, slot)
/*
Item will be deleted if it fails to equip with equip_to_slot_if_possible() proc
used to equip people when the rounds tarts and when events happen and such.

It calls:
	- equip_to_slot_if_possible(Item, slot, disable_warning = TRUE, redraw_mob = FALSE)
*/


/mob/proc/equip_to_appropriate_slot(obj/item/Item)
/*
Puts the Item into an appropriate slot in a human's inventory
returns FALSE if it cannot, TRUE if successful

It calls:
	- equip_to_slot_if_possible(Item, slot, disable_warning = TRUE)
*/


/mob/proc/equip_to_storage(obj/item/Item)
/*
Try find storage in mob inventory and put item in it.
Return founded storage or null.
Ovverided for human proc check "slot_back" first.
*/


// UNEQUIP //

/mob/proc/u_equip(obj/item/Item)
/*
This is an UNSAFE proc.
Inequip analogue for equip_to_slot(...)

It merely handles the actual job of equipping. Drop vars, update icons. Also calls Item.dropped(mob, slot).
Does nothing else.

DO NOT CALL THIS PROC DIRECTLY. It is meant to be called only by other inventory procs.
It's probably okay to use it if you are transferring the item between slots on the same mob,
but chances are you're safer calling remove_from_mob() or drop_from_inventory() anyways.

It calls:
	- Item.dropped(Mob, slot)
*/



/mob/proc/drop_from_inventory(obj/item/Item, atom/Target, drop_flag)
/*
This is a SAFE proc. You can use this instead of u_equip()!
Remove an Item from a mob and forceMove it into Target atom
Remove from mob means:
	- remove from mob client screen (if client exist)
	- remove from mobs contents (Item.forceMove(...)) / inventory (mob.u_equip(...))
If no Target is specify item will be moved to mob.loc and forceMoved with MOVED_DROP flag.
Check /atom/movable/proc/forceMove(...) for more info about flags.

It calls:
	- Mob.u_equip(Item)
	- Item.forceMove(Target)
*/


/mob/proc/unEquip(obj/item/Item, atom/Target)
/*
This differs from drop_from_inventory(...) in that it checks if the item can be unequipped first.
It calls:
	- Mob.can_unequip(Item, disable_warning) and Item.can_be_unequiped(Mob, disable_warning)
	- drop_from_inventory(Item, Target)
*/


