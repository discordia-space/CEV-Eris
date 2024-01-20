/*
 * Contents:
 *		Welding mask
 *		Cakehat
 *		Ushanka
 *		Pumpkin head
 *		Kitty ears
 *
 */

/*
 * Welding mask
 */
/obj/item/clothing/head/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = "welding"
	item_state_slots = list(
		slot_l_hand_str = "welding",
		slot_r_hand_str = "welding",
		)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_GLASS = 2)
	var/up = 0
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	flags_inv = (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
	body_parts_covered = HEAD|FACE|EYES
	action_button_name = "Flip Welding Mask"
	siemens_coefficient = 0.9
	volumeClass = ITEM_SIZE_NORMAL
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_MODERATE
	style = STYLE_NEG_LOW
	style_coverage = COVERS_WHOLE_FACE
	var/base_state
	armorComps = list(
		/obj/item/armor_component/plate/steel
	)

/obj/item/clothing/head/welding/attack_self()
	if(!base_state)
		base_state = icon_state
	toggle()


/obj/item/clothing/head/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding mask"
	set src in usr

	if(!usr.incapacitated())
		if(src.up)
			src.up = !src.up
			body_parts_covered |= (EYES|FACE)
			flags_inv |= (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			icon_state = base_state
			to_chat(usr, "You flip the [src] down to protect your eyes.")
			style_coverage = COVERS_WHOLE_FACE
		else
			src.up = !src.up
			body_parts_covered &= ~(EYES|FACE)
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			flags_inv &= ~(HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			icon_state = "[base_state]up"
			to_chat(usr, "You push the [src] up out of your face.")
			style_coverage = COVERS_HAIR
		if(ishuman(usr))
			var/mob/living/carbon/human/beingofeyes = usr
			beingofeyes.update_equipment_vision()
		update_wear_icon()	//so our mob-overlays
		usr.update_action_buttons()


/*
 * Cakehat
 */
/obj/item/clothing/head/cakehat
	name = "cake-hat"
	desc = "It's tasty looking!"
	icon_state = "cake0"
	item_state = "cake0"
	var/onfire = 0
	body_parts_covered = HEAD
	style_coverage = COVERS_HAIR

/obj/item/clothing/head/cakehat/Process()
	if(!onfire)
		STOP_PROCESSING(SSobj, src)
		return

	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/living/carbon/human/M = location
		if(M.l_hand == src || M.r_hand == src || M.head == src)
			location = M.loc

	if (istype(location, /turf))
		location.hotspot_expose(700, 1)

/obj/item/clothing/head/cakehat/attack_self(mob/user as mob)
	src.onfire = !( src.onfire )
	if (src.onfire)
		src.icon_state = "cake1"
		src.item_state = "cake1"
		START_PROCESSING(SSobj, src)
	else
		src.icon_state = "cake0"
		src.item_state = "cake0"
	return


/*
 * Ushanka
 */
/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushanka_down"
	flags_inv = HIDEEARS
	style_coverage = COVERS_HAIR
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/head/ushanka/attack_self(mob/user)
	if(src.icon_state == "ushanka_down")
		src.icon_state = "ushanka_up"
		to_chat(user, "You raise the ear flaps on the ushanka.")
	else
		src.icon_state = "ushanka_down"
		to_chat(user, "You lower the ear flaps on the ushanka.")

/obj/item/clothing/head/ushanka/black
	name = "serbian ushanka"
	desc = "Perfect for winter in Serbia, da?"
	icon_state = "ushankabl_down"

/obj/item/clothing/head/ushanka/black/attack_self(mob/user)
	if(src.icon_state == "ushankabl_down")
		src.icon_state = "ushankabl_up"
		to_chat(user, "You raise the ear flaps on the ushanka.")
	else
		src.icon_state = "ushankabl_down"
		to_chat(user, "You lower the ear flaps on the ushanka.")

/*
 * Pumpkin head
 */
/obj/item/clothing/head/pumpkinhead
	name = "carved pumpkin"
	desc = "A jack o' lantern! Believed to ward off evil spirits."
	icon_state = "hardhat0_pumpkin"//Could stand to be renamed
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	brightness_on = 2
	light_overlay = "helmet_light"
	volumeClass = ITEM_SIZE_NORMAL
	style_coverage = COVERS_WHOLE_HEAD



/obj/item/clothing/head/richard
	name = "chicken mask"
	desc = "You can hear the distant sounds of rhythmic electronica."
	icon_state = "richard"
	body_parts_covered = HEAD|FACE
	flags_inv = BLOCKHAIR
	style_coverage = COVERS_WHOLE_HEAD
