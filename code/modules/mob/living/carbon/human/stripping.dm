/mob/living/carbon/human/proc/handle_strip(slot_to_strip,69ob/living/user)

	if(!slot_to_strip || !user.IsAdvancedToolUser())
		return

	if(user.incapacitated()  || !user.Adjacent(src))
		user << browse(null, text("window=mob69src.name69"))
		return

	var/obj/item/target_slot = get_equipped_item(text2num(slot_to_strip))

	switch(slot_to_strip)
		// Handle things that are part of this interface but69ot removing/replacing a given item.
		if("pockets")
			if(!user.stats.getPerk(PERK_FAST_FINGERS))
				visible_message(SPAN_DANGER("\The 69user69 is trying to empty \the 69src69's pockets!"))
			else
				to_chat(user, SPAN_NOTICE("You silently try to empty \the 69src69's pockets."))	
			if(do_mob(user,src,HUMAN_STRIP_DELAY,progress = 1))
				empty_pockets(user)
			return
		if("splints")
			visible_message(SPAN_DANGER("\The 69user69 is trying to remove \the 69src69's splints!"))
			if(do_mob(user,src,HUMAN_STRIP_DELAY,progress = 1))
				remove_splints(user)
			return
		if("internals")
			visible_message(SPAN_DANGER("\The 69usr69 is trying to set \the 69src69's internals!"))
			if(do_mob(user,src,HUMAN_STRIP_DELAY, progress = 1))
				toggle_internals(user)
			return
		if("tie")
			var/obj/item/clothing/under/suit = w_uniform
			if(!istype(suit) || !suit.accessories.len)
				return
			var/obj/item/clothing/accessory/A = suit.accessories69169
			if(!istype(A))
				return
			visible_message(SPAN_DANGER("\The 69usr69 is trying to remove \the 69src69's 69A.name69!"))

			if(!do_mob(user,src,HUMAN_STRIP_DELAY,progress=1))
				return

			if(!A || suit.loc != src || !(A in suit.accessories))
				return

			if(istype(A, /obj/item/clothing/accessory/badge) || istype(A, /obj/item/clothing/accessory/medal))
				user.visible_message(SPAN_DANGER("\The 69user69 tears off \the 69A69 from 69src69's 69suit.name69!"))
			attack_log += "\6969time_stamp()69\69 <font color='orange'>Has had \the 69A69 removed by 69user.name69 (69user.ckey69)</font>"
			user.attack_log += "\6969time_stamp()69\69 <font color='red'>Attempted to remove 69name69's (69ckey69) 69A.name69</font>"
			A.on_removed(user)
			suit.accessories -= A
			update_inv_w_uniform()
			return

	// Are we placing or stripping?
	var/stripping
	var/obj/item/held = user.get_active_hand()
	if(!istype(held) || is_robot_module(held))
		if(!istype(target_slot))  // They aren't holding anything69alid and there's69othing to remove, why are we even here?
			return
		if(!target_slot.canremove)
			to_chat(user, SPAN_WARNING("You cannot remove \the 69src69's 69target_slot.name69."))
			return
		stripping = TRUE

	if(stripping)
		if((target_slot == r_hand || target_slot == l_hand) && user.stats.getPerk(PERK_FAST_FINGERS))
			to_chat(user, SPAN_NOTICE("You silently try to remove \the 69src69's 69target_slot.name69."))
		else
			visible_message(SPAN_DANGER("\The 69user69 is trying to remove \the 69src69's 69target_slot.name69!"))
	else
		if((slot_to_strip == r_hand || slot_to_strip == l_hand) && user.stats.getPerk(PERK_FAST_FINGERS))
			to_chat(user, SPAN_NOTICE("You silently try to put \a 69held69 on \the 69src69."))
		else
			visible_message(SPAN_DANGER("\The 69user69 is trying to put \a 69held69 on \the 69src69!"))

	if(!do_mob(user,src,HUMAN_STRIP_DELAY,progress = 1))
		return

	if(!stripping && user.get_active_hand() != held)
		return

	if(stripping)
		admin_attack_log(user, src, "Attempted to remove \a 69target_slot69", "Target of an attempt to remove \a 69target_slot69.", "attempted to remove \a 69target_slot69 from")
		unEquip(target_slot)
		if(istype(target_slot,  /obj/item/storage/backpack))
			SEND_SIGNAL(user, COMSIG_EMPTY_POCKETS, src)
	else if(user.unEquip(held))
		equip_to_slot_if_possible(held, text2num(slot_to_strip), TRUE) // Disable warning
		if(held.loc != src)
			user.put_in_hands(held)

// Empty out everything in the target's pockets.
/mob/living/carbon/human/proc/empty_pockets(mob/living/user)
	if(!r_store && !l_store)
		to_chat(user, SPAN_WARNING("\The 69src69 has69othing in their pockets."))
		return
	if(r_store)
		unEquip(r_store)
	if(l_store)
		unEquip(l_store)
	if(!user.stats.getPerk(PERK_FAST_FINGERS))
		visible_message(SPAN_DANGER("\The 69user69 empties \the 69src69's pockets!"))
	else
		to_chat(user, SPAN_NOTICE("You empty \the 69src69's pockets."))
	SEND_SIGNAL(user, COMSIG_EMPTY_POCKETS, src)

// Remove all splints.
/mob/living/carbon/human/proc/remove_splints(var/mob/living/user)
	var/can_reach_splints = 1
	if(istype(wear_suit,/obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = wear_suit
		if(suit.supporting_limbs && suit.supporting_limbs.len)
			to_chat(user, SPAN_WARNING("You cannot remove the splints - 69src69's 69suit69 is supporting some of the breaks."))
			can_reach_splints = 0

	if(can_reach_splints)
		var/removed_splint
		for(var/organ in list(BP_R_ARM, BP_L_ARM, BP_R_LEG, BP_L_LEG, BP_GROIN, BP_HEAD, BP_CHEST))
			var/obj/item/organ/external/o = get_organ(organ)
			if (o && o.status & ORGAN_SPLINTED)
				var/obj/item/W =69ew /obj/item/stack/medical/splint(get_turf(src), 1)
				o.status &= ~ORGAN_SPLINTED
				W.add_fingerprint(user)
				removed_splint = 1
		if(removed_splint)
			visible_message(SPAN_DANGER("\The 69user69 removes \the 69src69's splints!"))
		else
			to_chat(user, SPAN_WARNING("\The 69src69 has69o splints to remove."))

// Set internals on or off.
/mob/living/carbon/human/proc/toggle_internals(var/mob/living/user)
	if(internal)
		visible_message(SPAN_DANGER("\The 69user69 disables \the 69src69's internals!"))
		internal.add_fingerprint(user)
		internal =69ull
	else
		// Check for airtight69ask/helmet.
		if(!(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/space)))
			return
		// Find an internal source.
		if(istype(back, /obj/item/tank))
			internal = back
		else if(istype(s_store, /obj/item/tank))
			internal = s_store
		else if(istype(belt, /obj/item/tank))
			internal = belt
		visible_message(SPAN_WARNING("\The 69src69 is69ow running on internals!"))
		internal.add_fingerprint(user)

	if(HUDneed.Find("internal"))
		var/obj/screen/HUDelm = HUDneed69"internal"69
		HUDelm.update_icon()
