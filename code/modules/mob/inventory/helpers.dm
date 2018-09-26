/mob/living
	var/list/inventory = list()

/mob/living/proc/has_inventory_slot(slot)
	return slot in inventory


//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_hand()
	var/obj/item/E = get_equipped_item(slot)
	if (istype(E))
		if(istype(W))
			W.resolve_attackby(E, src)
		else
			E.attack_hand(src)
	else
		equip_to_slot_if_possible(W, slot)



//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/proc/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	return TRUE


/mob/proc/can_equip(obj/item/W, slot, disable_warning = FALSE)
	return FALSE


/mob/living/carbon/human/can_equip(obj/item/W, slot, disable_warning = FALSE)
	if(!slot)
		return FALSE

	if(species.hud && species.hud.equip_slots)
		if(!(slot in species.hud.equip_slots))
			if(!disable_warning)
				usr << SPAN_WARNING("Your species can't wear that!")
			return FALSE

	if(get_equipped_item(slot))
		if(!disable_warning)
			usr << SPAN_WARNING("You already has something equipped here!")
		return FALSE

	if(!slot_is_accessible(slot, src, disable_warning? null : src))
		return FALSE

	//Lastly, check special rules for the desired slot.
	switch(slot)
		if(slot_in_backpack) //used entirely for equipping spawned mobs or at round start
			var/allow = FALSE
			if(back && istype(back, /obj/item/weapon/storage/backpack))
				var/obj/item/weapon/storage/backpack/B = back
				if(B.can_be_inserted(src,1))
					allow = B
			if(!allow)
				return FALSE
		if(slot_accessory_buffer)
			if(!w_uniform && (slot_w_uniform in inventory))
				if(!disable_warning)
					src << SPAN_WARNING("You need a jumpsuit before you can attach this [name].")
				return FALSE
			var/obj/item/clothing/under/uniform = w_uniform
			if(uniform.accessories.len && !uniform.can_attach_accessory(src))
				if (!disable_warning)
					src << SPAN_WARNING("You already have an accessory of this type attached to your [uniform].")
				return FALSE

	return TRUE

/mob/proc/canUnEquip(obj/item/I, slot, disable_warning = FALSE)
	if(!slot_is_accessible(slot, src, disable_warning? null : src))
		return FALSE
	return TRUE




