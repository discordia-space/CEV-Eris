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
	flags_inv = HIDEFACE|BLOCKHAIR
	w_class = ITEM_SIZE_SMALL
	var/open = 0

/obj/item/clothing/mask/balaclava/tactical/proc/adjust_mask(mob/user)
	if(!usr.incapacitated())
		src.open = !src.open
		if (src.open)
			body_parts_covered = body_parts_covered & ~FACE
			icon_state = initial(icon_state) + "_open"
			user << "You open your face, putting the balaclava away."
		else
			gas_transfer_coefficient = initial(gas_transfer_coefficient)
			body_parts_covered = initial(body_parts_covered)
			icon_state = initial(icon_state)
			user << "You pull balaclava up to cover your face."
		update_clothing_icon()

/obj/item/clothing/mask/balaclava/tactical/attack_self(mob/user)
	adjust_mask(user)

/obj/item/clothing/mask/balaclava/tactical/verb/toggle()
		set category = "Object"
		set name = "Adjust balaclava"
		set src in usr
		adjust_mask(usr)
