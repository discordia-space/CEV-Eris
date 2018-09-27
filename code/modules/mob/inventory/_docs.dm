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
	- if Item.pre_equip(..) take some time Mob.can_equip(...) and Item.can_be_equiped(...) will be called again .
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


// HANDS //

/*
All procs in that category is safety to call for any mob type.
You shouldn't do any special checks like is_robotmodule or ismob(item.loc)
But procs returning value is important!
*/

/mob/proc/get_active_hand()
/mob/proc/get_inactive_hand()
/*
Returns the thing in Mob active/inactive hand
get_active_hand() can return actual value for humans, robots and mb any other mobs
But get_inactive_hand() probably will return something only for humans
Because it's not simple to find inactive hand in any other type of mob
*/

/mob/proc/put_in_active_hand(var/obj/item/Item)
/mob/proc/put_in_inactive_hand(var/obj/item/Item)
/*
Puts the Item into Mob active/inactive hand if possible
Returns TRUE on success.
Again put_in_active_hand() will work for planty types of mob
But put_in_inactive_hand() probably will be suitable only for humans
Human ovveride calls:
	- Mob.equip_to_slot_if_possible(Item, slot_r_hand|slot_l_hand)
*/

/mob/proc/put_in_hands(var/obj/item/Item)
/*
Puts the item Mob active hand if possible. Failing that it tries our inactive hand.
Returns TRUE on success.
If both fail it drops Item on the floor and returns FALSE
If Item was equipped, it still will be dropped on the floor.
calls:
	- put_in_active_hand(Item)
	- put_in_inactive_hand(Item)
	- Item.is_equipped()
	- Item.loc.unEquip(Item, Mob.loc) // if was equipped
*/

/mob/proc/drop_active_hand(var/atom/Target)
/*
Drops the item from Mob active hand into Target
That proc previously called drop_item()
It calls:
	- Mob.get_active_hand()
	- Mob.unEquip(Item, Target)
*/

/mob/proc/drop_all_hands(var/pick_one = FALSE)
/*
Drop items from all Mob hands or one random hand
Pick_one - drop one random hand else drop all
Write instead drop_inactive_hand() to make it suitable for each type of mob
*/



// HELPERS //

/mob/proc/attack_ui(slot)
/*
This proc is called whenever someone clicks an inventory ui slot.
If smth occupy slot, then reslolve_attack/attackhand will be called, else equip_to_slot_if_possible()
It calls:
	- Mob.get_active_hand()
	- Mob.get_equipped_item(slot)
	- Mob.equip_to_slot_if_possible(Item, slot)
	- or Mob.attackhand(equippedItem)
	- or equippedItem.resolve_attackby(Item, Mob)
*/

/mob/proc/slot_is_accessible(var/slot, var/obj/item/Item, mob/user=null)
/*
Checks if a given slot can be accessed at this time, either to equip or unequip Item
*/


/mob/proc/can_equip(obj/item/Item, slot, disable_warning = FALSE)
/*
Return TRUE if Mob can equip Item
Don't confuse with Item.can_be_equipped(Mob, slot, disable_warning)
*/

/mob/proc/can_unequip(obj/item/Item, slot, disable_warning = FALSE)
/*
Return TRUE if Mob can unequip Item
Don't confuse with Item.can_be_unequipped(Mob, slot, disable_warning)
*/


/mob/proc/get_inventory_slot(obj/item/Item)
/*
Return id of slot what occupied with Item
It calls:
	- Item.get_holding_mob()
	- Item.get_equip_slot()
*/

/mob/proc/get_equipped_item(var/slot)
/*
Returns the item equipped to the specified slot, if any.
*/

/mob/proc/get_equipped_items()
/*
Return list of all items equipped by Mob or emply list if non items found
*/






