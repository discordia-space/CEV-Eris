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
Checks all slots present in slot_equipment_priority list one by one
Returns found id of slot in which item was equipped or FALSE
It calls:
	- equip_to_slot_if_possible(Item, slot, disable_warning = TRUE)
*/


/mob/proc/equip_to_storage(obj/item/Item)
/*
Try find storage in mob inventory and put item in it.
Return founded storage or null.
Ovverided for human proc check "slot_back" first.
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


/proc/mob_can_equip(mob/living/L, obj/item/Item, slot, disable_warning = FALSE)
/*
Now we have two separated procs: Mob.can_equip(Item...) and Item.can_be_equipped(Mob...)
That proc is simple way to call them both if you wanna check "Can that mob equip this item in some slot"
It calls:
	- Mob.can_equip(Item, slot, disable_warning)
	- Item.can_be_equipped(Mob, slot, disable_warning)
*/



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