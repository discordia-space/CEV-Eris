SUBSYSTEM_DEF(inventory)
	name = "Inventory"
	init_order = INIT_ORDER_INVENTORY
	flags = SS_NO_FIRE
	var/global/list/slots

/datum/controller/subsystem/inventory/Initialize(start_timeofday)
	slots = new()
	for(var/path in subtypesof(/datum/inventory_slot))
		var/datum/inventory_slot/S = path
		if(!initial(S.id))
			continue
		S = new S()
		if(S.id > slots.len)
			slots.len = S.id
		slots[S.id] = S
	. = ..()

/datum/controller/subsystem/inventory/proc/get_slot_datum(slot)
	return slots.len >= slot ? slots[slot] : null

/datum/controller/subsystem/inventory/proc/update_mob(mob/living/target, slot, redraw)
	var/datum/inventory_slot/IS = get_slot_datum(slot)
	if(IS)
		IS.update_icon(target, slot, redraw)
