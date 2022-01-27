// EQUIP //


/mob/proc/equip_to_slot(obj/item/Item, slot, redraw_mob = TRUE)
/*
This is an UNSAFE proc.
It69erely handles the actual job of equipping. Set69ars, update icons. Also calls Item.equipped(mob, slot).
All the checks on whether you can or can't eqip69eed to be done before! Use69ob_can_equip() for that task.
In69ost cases you will want to use equip_to_slot_if_possible()
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
Unset redraw_mob to prevent the69ob from being redrawn at the end.
It calls:
	-69ob.can_equip(Item, slot, disable_warning) and Item.can_be_equiped(mob, slot, disable_warning)
	- If Item already equipped on someone other_mob.unEquip(Item) will be called.
	- Item.pre_equip(src, slot)
	- if Item.pre_equip(..) take some time69ob.can_equip(...) and Item.can_be_equiped(...) will be called again .
	-69ob.equip_to_slot(Item, slot, redraw_mob)
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
Try find storage in69ob inventory and put item in it.
Return founded storage or69ull.
Ovverided for human proc check "slot_back" first.
*/



// HELPERS //


/mob/proc/attack_ui(slot)
/*
This proc is called whenever someone clicks an inventory ui slot.
If smth occupy slot, then reslolve_attack/attackhand will be called, else equip_to_slot_if_possible()
It calls:
	-69ob.get_active_hand()
	-69ob.get_equipped_item(slot)
	-69ob.equip_to_slot_if_possible(Item, slot)
	- or69ob.attackhand(equippedItem)
	- or equippedItem.resolve_attackby(Item,69ob)
*/


/mob/proc/slot_is_accessible(var/slot,69ar/obj/item/Item,69ob/user)
/*
Checks if a given slot can be accessed at this time, either to equip or unequip Item
*/


/mob/proc/can_equip(obj/item/Item, slot, disable_warning = FALSE)
/*
Return TRUE if69ob can equip Item
Don't confuse with Item.can_be_equipped(Mob, slot, disable_warning)
*/


/proc/mob_can_equip(mob/living/L, obj/item/Item, slot, disable_warning = FALSE)
/*
Now we have two separated procs:69ob.can_equip(Item...) and Item.can_be_equipped(Mob...)
That proc is simple way to call them both if you wanna check "Can that69ob equip this item in some slot"
It calls:
	-69ob.can_equip(Item, slot, disable_warning)
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


/obj/item/proc/pre_equip(var/mob/user,69ar/slot)
/*
Called just before an item is placed in an equipment slot.
Use this to do any69ecessary preparations for equipping
Immediately after this, the equipping will be handled and then equipped will be called.
Returning a69on-zero69alue will silently abort the equip operation
Important69otes:
	- Can take few ticks if69eeded!
	- Called before unequip (if holding by69ob) and can still be located in another69ob!
By default here located equip sound calls.
*/


/obj/item/proc/equipped(mob/Mob,69ar/slot)
/*
Called after an item is placed in an equipment slot
User is69ob that equipped it
Slot uses the slot_X defines found in items_clothing.dm
*/

/obj/item/proc/dropped(mob/Mob)
/*
Called whenever an item is dropped from INVENTORY SLOT.
Important69ote:
	- It is called after loc is set, so if placed in a container its loc will be that container.
By default drop zoom if enabled.
*/


/obj/item/proc/can_be_equipped(mob/Mob, slot, disable_warning = FALSE)
/*
The69ob69 is attempting to equip this item into the slot passed through as 'slot'.
Return TRUE if it can do this and FALSE if it can't.
Set disable_warning to TRUE if you wish it to69ot give you outputs.
*/


/obj/item/proc/can_be_unequipped(mob/Mob, slot, disable_warning = FALSE)
/*
Analogue for can_be_equipped(..) but used for unequip
Default proc return canremove69alue.
*/


/obj/item/proc/is_equipped()
/*
Returns TRUE if the object is equipped to a69ob, in any slot
Important69ote:
	- return TRUE/FALSE69ot occupied slot id!
*/


/obj/item/proc/is_worn()
/*
Analogue for is_equipped() but return TRUE if Item is equipped to one of body slots (not hands)
Important69otes:
	- will return FALSE if item located in hands slot!
	- robot slots currently69ot counted as hands -> counted as body slots don't be confused
*/


/obj/item/proc/is_held()
/*
Kind of inverse proc for is_worn() return TRUE if item occupy one of hands slot
Important69ote:
	- robot slots currently69ot counted as hands
*/


/obj/item/proc/get_equip_slot()
/*
This is the correct way to get an object's equip slot.
Will return zero if the object is69ot currently equipped to anyone
*/


/obj/item/proc/try_uneqip(target,69ob/living/user)
/*
Not directly related to inventory procs
Used for unequipping things from69ob inventory to hands with69ouse DragnDrop
Called by /obj/item/MouseDrop(obj/over_object)
*/