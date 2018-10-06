// ITEMS //
/*
Most procs from that categoy located in:
 code/game/objects/items.dm
*/


/obj/item/proc/update_wear_icon(redraw_mob = TRUE)
/*
Replacement for outdated update_holding_icon()/update_clothing_icon()
Found occupied slot and update it icon
*/


/obj/item/proc/pre_equip(var/mob/user, var/slot)
/*
Called just before an item is placed in an equipment slot.
Use this to do any necessary preparations for equipping
Immediately after this, the equipping will be handled and then equipped will be called.
Returning a non-zero value will silently abort the equip operation
Important notes:
	- Can take few ticks if needed!
	- Called before unequip (if holding by mob) and can still be located in another mob!
By default here located equip sound calls.
*/


/obj/item/proc/equipped(var/mob/Mob, var/slot)
/*
Called after an item is placed in an equipment slot
User is mob that equipped it
Slot uses the slot_X defines found in items_clothing.dm
*/

/obj/item/proc/dropped(mob/Mob)
/*
Called whenever an item is dropped from INVENTORY SLOT.
Important note:
	- It is called after loc is set, so if placed in a container its loc will be that container.
By default drop zoom if enabled.
*/


/obj/item/proc/can_be_equipped(mob/Mob, slot, disable_warning = FALSE)
/*
The mob M is attempting to equip this item into the slot passed through as 'slot'.
Return TRUE if it can do this and FALSE if it can't.
Set disable_warning to TRUE if you wish it to not give you outputs.
*/


/obj/item/proc/can_be_unequipped(mob/Mob, slot, disable_warning = FALSE)
/*
Analogue for can_be_equipped(..) but used for unequip
Default proc return canremove value.
*/


/obj/item/proc/is_equipped()
/*
Returns TRUE if the object is equipped to a mob, in any slot
Important note:
	- return TRUE/FALSE not occupied slot id!
*/


/obj/item/proc/is_worn()
/*
Analogue for is_equipped() but return TRUE if Item is equipped to one of body slots (not hands)
Important notes:
	- will return FALSE if item located in hands slot!
	- robot slots currently not counted as hands -> counted as body slots don't be confused
*/


/obj/item/proc/is_held()
/*
Kind of inverse proc for is_worn() return TRUE if item occupy one of hands slot
Important note:
	- robot slots currently not counted as hands
*/


/obj/item/proc/get_equip_slot()
/*
This is the correct way to get an object's equip slot.
Will return zero if the object is not currently equipped to anyone
*/


/obj/item/proc/try_uneqip(target, mob/living/user)
/*
Not directly related to inventory procs
Used for unequipping things from mob inventory to hands with mouse DragnDrop
Called by /obj/item/MouseDrop(obj/over_object)
*/