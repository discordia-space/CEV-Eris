// couldn't figure out a better place to put this
// move it to organ folder when organ modules are gone

//I is the item you want to check if is attached to the human you called this on
/mob/living/carbon/human/proc/is_item_attached(obj/item/I)
	. = FALSE
	var/held_in = get_holding_hand(I)
	if (held_in)
		var/obj/item/organ/external/relevant_arm = get_organ(held_in)
		var/relevant_module = relevant_arm.module
		if (relevant_module)
			if (istype(relevant_module, /obj/item/organ_module/active/simple))
				var/obj/item/organ_module/active/simple/active_simple = relevant_module
				return I == active_simple.holding
			else if (istype(relevant_module, /obj/item/organ_module/active/multitool))
				var/obj/item/organ_module/active/multitool/active_multitool = relevant_module
				return I in active_multitool.items

