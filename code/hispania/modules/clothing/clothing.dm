/obj/item/clothing/can_be_equipped(mob/user, slot, disable_warning = 0)

	//if we can't equip the item anyway, don't bother with species_restricted (also cuts down on spam)
	if(!..())
		return FALSE

	// Skip species restriction checks on non-equipment slots
	if(slot in unworn_slots)
		return TRUE

	if(species_restricted && ishuman(user))

		var/wearable = null
		var/exclusive = null
		var/mob/living/carbon/human/H = user

		if("exclude" in species_restricted)
			exclusive = TRUE

		if(H.species)
			if(exclusive)
				if(!(H.species.name in species_restricted))
					wearable = TRUE
			else
				if(H.species.name in species_restricted)
					wearable = TRUE

			if(!wearable)
				to_chat(user, "<span class='warning'>Your species cannot wear [src].</span>")
				return FALSE

	return TRUE
