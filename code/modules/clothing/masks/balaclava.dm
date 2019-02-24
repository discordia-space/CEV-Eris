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
	var/open = 0 //0 = full, 1 = cover mouth, 2 = cover head

/obj/item/clothing/mask/balaclava/tactical/proc/adjust_mask(mob/user)
	if(!usr.incapacitated())
		open = (open + 1) % 3
		switch(open)
			if (2)
				flags_inv = BLOCKHEADHAIR
				body_parts_covered = HEAD
				icon_state = "swatclava_open"
				user << "You put the balaclava away, revealing your face."
			if (1)
				flags_inv = HIDEFACE|BLOCKFACEHAIR
				body_parts_covered = FACE
				icon_state = "swatclava_mouth"
				user << "You pull the balaclava up to cover your mouth."
			if (0)
				flags_inv = HIDEFACE|BLOCKHAIR
				body_parts_covered = FACE|HEAD
				icon_state = "swatclava"
				user << "You pull the balaclava up to cover your head."
		usr.update_inv_wear_mask()

/obj/item/clothing/mask/balaclava/tactical/attack_self(mob/user)
	adjust_mask(user)

/obj/item/clothing/mask/balaclava/tactical/verb/toggle()
		set category = "Object"
		set name = "Adjust balaclava"
		set src in usr
		adjust_mask(usr)
