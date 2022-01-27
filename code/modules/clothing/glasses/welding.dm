/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the69ad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	action_button_name = "Flip Welding Goggles"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 2)
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY
	obscuration = HEAVY_OBSCURATION

/obj/item/clothing/glasses/welding/attack_self()
	adjust()


/obj/item/clothing/glasses/welding/verb/adjust()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(!src.active)
			src.active = !src.active
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			obscuration = initial(obscuration)
			to_chat(usr, "You flip \the 69src69 down to protect your eyes.")
		else
			src.active = !src.active
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "69initial(icon_state)69up"
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			obscuration = 0
			to_chat(usr, "You push \the 69src69 up out of your face.")
		update_wear_icon()
		usr.update_action_buttons()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles69ade from69ore expensive69aterials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	item_state = "rwelding-g"
	prescription = TRUE
	tint = TINT_MODERATE
	obscuration =69EDIUM_OBSCURATION
