/obj/item/clothing/mask/balaclava
	name = "balaclava"
	desc = "LOADSAMONEY"
	icon_state = "balaclava"
	item_state = "balaclava"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = FACE|HEAD
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/mask/balaclava/tactical
	name = "tactical balaclava"
	desc = "Designed to both hide identities and keep your face comfy and warm."
	icon_state = "swatclava"
	item_state = "balaclava"
	action_button_name = "Adjust Balaclava"
	var/open = 0 //0 = full, 1 = head only, 2 = face only

/obj/item/clothing/mask/balaclava/tactical/proc/adjust_mask(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(!user.incapacitated())
		switch(open)
			if (0)
				flags_inv = BLOCKHEADHAIR
				body_parts_covered = HEAD
				icon_state = "swatclava_open"
				to_chat(user, "You put the balaclava away, revealing your face.")
				open = 1
			if (1)
				flags_inv = HIDEFACE|BLOCKFACEHAIR
				body_parts_covered = FACE
				icon_state = "swatclava_mouth"
				to_chat(user, "You adjust the balaclava up to cover your mouth.")
				open = 2
			else
				flags_inv = HIDEFACE|BLOCKHAIR
				body_parts_covered = FACE|HEAD
				icon_state = "swatclava"
				to_chat(user, "You pull the balaclava up to cover your whole head.")
				open = 0
		user.update_hair(0)
		user.update_inv_ears(0)
		user.update_inv_wear_mask() //Updates mob icons

/obj/item/clothing/mask/balaclava/tactical/attack_self(mob/user)
	adjust_mask(user)

/obj/item/clothing/mask/balaclava/tactical/verb/toggle()
		set category = "Object"
		set name = "Adjust balaclava"
		set src in usr
		adjust_mask(usr)
