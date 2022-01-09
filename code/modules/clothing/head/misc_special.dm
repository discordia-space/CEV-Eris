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
		melee = 20,
		bullet = 10,
		energy = 10,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	flags_inv = (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
	body_parts_covered = HEAD|FACE|EYES
	action_button_name = "Flip Welding Mask"
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY
	style = STYLE_NEG_LOW
	var/base_state

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
		else
			src.up = !src.up
			body_parts_covered &= ~(EYES|FACE)
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			flags_inv &= ~(HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			icon_state = "[base_state]up"
			to_chat(usr, "You push the [src] up out of your face.")
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
		src.force = 3
		src.damtype = "fire"
		src.icon_state = "cake1"
		src.item_state = "cake1"
		START_PROCESSING(SSobj, src)
	else
		src.force = null
		src.damtype = "brute"
		src.icon_state = "cake0"
		src.item_state = "cake0"
	return


/*
 * Ushanka
 */
/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushankadown"
	flags_inv = HIDEEARS

/obj/item/clothing/head/ushanka/attack_self(mob/user)
	if(src.icon_state == "ushankadown")
		src.icon_state = "ushankaup"
		to_chat(user, "You raise the ear flaps on the ushanka.")
	else
		src.icon_state = "ushankadown"
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
	w_class = ITEM_SIZE_NORMAL

/*
 * Kitty ears
 */
/obj/item/clothing/head/kitty
	name = "kitty ears"
	desc = "A pair of kitty ears. Meow!"
	icon_state = "kitty"
	body_parts_covered = 0
	siemens_coefficient = 1.5
	item_icons = list()

/obj/item/clothing/head/kitty/equipped(mob/user, slot)
	if(slot == slot_head)
		update_icon(user)
	..()

/obj/item/clothing/head/kitty/update_icon(var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	var/icon/ears = new/icon('icons/inventory/head/mob.dmi', "kitty")
	ears.Blend(user.hair_color, ICON_ADD)

	var/icon/earbit = new/icon('icons/inventory/head/mob.dmi', "kittyinner")
	ears.Blend(earbit, ICON_OVERLAY)

/obj/item/clothing/head/richard
	name = "chicken mask"
	desc = "You can hear the distant sounds of rhythmic electronica."
	icon_state = "richard"
	body_parts_covered = HEAD|FACE
	flags_inv = BLOCKHAIR
