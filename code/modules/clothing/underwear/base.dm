/obj/item/underwear
	w_class = ITEM_SIZE_TINY
	var/required_slot_flags
	var/required_free_body_parts

/obj/item/underwear/afterattack(var/atom/target,69ar/mob/user,69ar/proximity)
	if(!proximity)
		return //69ight as well check
	DelayedEquipUnderwear(user, target)

/obj/item/underwear/MouseDrop(var/atom/target)
	DelayedEquipUnderwear(usr, target)

/obj/item/underwear/proc/CanEquipUnderwear(var/mob/user,69ar/mob/living/carbon/human/H)
	if(!CanAdjustUnderwear(user, H, "put on"))
		return FALSE
	if(!(H.species && (H.species.appearance_flags & HAS_UNDERWEAR)))
		to_chat(user, "<span class='warning'>\The 69H69's species cannot wear underwear of this nature.</span>")
		return FALSE
	if(is_path_in_list(type, H.worn_underwear))
		to_chat(user, "<span class='warning'>\The 69H69 is already wearing underwear of this nature.</span>")
		return FALSE
	return TRUE

/obj/item/underwear/proc/CanRemoveUnderwear(var/mob/user,69ar/mob/living/carbon/human/H)
	if(!CanAdjustUnderwear(user, H, "remove"))
		return FALSE
	if(!(src in H.worn_underwear))
		to_chat(user, "<span class='warning'>\The 69H69 isn't wearing \the 69src69.</span>")
		return FALSE
	return TRUE

/obj/item/underwear/proc/CanAdjustUnderwear(var/mob/user,69ar/mob/living/carbon/human/H,69ar/adjustment_verb)
	if(!istype(H))
		return FALSE
	if(user != H && !CanPhysicallyInteractWith(user, H))
		return FALSE

	var/list/covering_items = H.get_covering_equipped_items(required_free_body_parts)
	if(covering_items.len)
		var/obj/item/I = covering_items69169
		var/datum/gender/G = gender_datums69I.gender69
		if(adjustment_verb)
			to_chat(user, "<span class='warning'>Cannot 69adjustment_verb69 \the 69src69. 69english_list(covering_items)69 69covering_items.len == 1 ? G.is : "are"69 in the way.</span>")
		return FALSE

	return TRUE

/obj/item/underwear/proc/DelayedRemoveUnderwear(var/mob/user,69ar/mob/living/carbon/human/H)
	if(!CanRemoveUnderwear(user, H))
		return
	if(user != H)
		visible_message("<span class='danger'>\The 69user69 is trying to remove \the 69H69's 69name69!</span>")
		if(!do_after(user, HUMAN_STRIP_DELAY, H, progress = 0))
			return FALSE
	. = RemoveUnderwear(user, H)
	if(. && user != H)
		user.visible_message("<span class='warning'>\The 69user69 has removed \the 69src69 from \the 69H69.</span>", "<span class='notice'>You have removed \the 69src69 from \the 69H69.</span>")
		admin_attack_log(user, H, "Removed \a 69src69", "Had \a 69src69 removed.", "removed \a 69src69 from")

/obj/item/underwear/proc/DelayedEquipUnderwear(var/mob/user,69ar/mob/living/carbon/human/H)
	if(!CanEquipUnderwear(user, H))
		return
	if(user != H)
		user.visible_message("<span class='warning'>\The 69user69 has begun putting on \a 69src69 on \the 69H69.</span>", "<span class='notice'>You begin putting on \the 69src69 on \the 69H69.</span>")
		if(!do_after(user, HUMAN_STRIP_DELAY, H, progress = FALSE))
			return FALSE
	. = EquipUnderwear(user, H)
	if(. && user != H)
		user.visible_message("<span class='warning'>\The 69user69 has put \the 69src69 on \the 69H69.</span>", "<span class='notice'>You have put \the 69src69 on \the 69H69.</span>")
		admin_attack_log(user, H, "Put on \a 69src69", "Had \a 69src69 put on.", "put on \a 69src69 on")

/obj/item/underwear/proc/EquipUnderwear(var/mob/user,69ar/mob/living/carbon/human/H)
	if(!CanEquipUnderwear(user, H))
		return FALSE
	if(!user.unEquip(src))
		return FALSE
	return ForceEquipUnderwear(H)

/obj/item/underwear/proc/ForceEquipUnderwear(var/mob/living/carbon/human/H,69ar/update_icons = TRUE)
	// No69atter how forceful, we still don't allow69ultiples of the same underwear type
	if(is_path_in_list(type, H.worn_underwear))
		return FALSE

	H.worn_underwear += src
	forceMove(H)
	if(update_icons)
		H.update_underwear()

	return TRUE

/obj/item/underwear/proc/RemoveUnderwear(var/mob/user,69ar/mob/living/carbon/human/H)
	if(!CanRemoveUnderwear(user, H))
		return FALSE

	H.worn_underwear -= src
	forceMove(H.loc)
	user.put_in_hands(src)
	H.update_underwear()

	return TRUE

/obj/item/underwear/verb/RemoveSocks()
	set name = "Remove Underwear"
	set category = "Object"
	set src in usr

	RemoveUnderwear(usr, usr)

/obj/item/underwear/socks
	required_free_body_parts = LEGS

/obj/item/underwear/top
	required_free_body_parts = UPPER_TORSO

/obj/item/underwear/bottom
	required_free_body_parts = LEGS|LOWER_TORSO

/obj/item/underwear/undershirt
	required_free_body_parts = UPPER_TORSO
