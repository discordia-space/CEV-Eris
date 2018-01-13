/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD | EARS
	armor = list(melee = 35, bullet = 15, laser = 25,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	armor = list(melee = 35, bullet = 15, laser = 25,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EARS
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"

	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/augment
	name = "Augment Array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "Standart issue Ironhammer helmet. Basic hud and targeting system included."
	icon_state = "light_riot"
	body_parts_covered = HEAD|FACE|EARS
	armor = list(melee = 60, bullet = 15, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0)
	item_flags = THICKMATERIAL | COVER_PREVENT_MANIPULATION
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
	flash_protection = FLASH_PROTECTION_MAJOR
	action_button_name = "Toggle Security Hud"
	var/obj/item/clothing/glasses/hud/security/hud

/obj/item/clothing/head/helmet/riot/New()
	..()
	hud = new(src)
	hud.canremove = FALSE

/obj/item/clothing/head/helmet/riot/ui_action_click()
	toggle()

/obj/item/clothing/head/helmet/riot/verb/toggle()
	set name = "Toggle Security Hud"
	set desc = "Shows you jobs and criminal statuses"
	set category = "Object"
	var/mob/user = loc
	if(usr.stat || user.restrained())
		return
	if(user.get_equipped_item(slot_head) != src)
		return
	if(hud in src)
		if(user.equip_to_slot_if_possible(hud, slot_glasses))
			user << "You enable security hud on [src]."
			update_icon()
	else
		if(ismob(hud.loc))
			var/mob/hud_loc = hud.loc
			hud_loc.drop_from_inventory(hud, src)
			user << "You disable security hud on [src]."
		hud.forceMove(src)
		update_icon()
	usr.update_action_buttons()

/obj/item/clothing/head/helmet/riot/dropped(usr)
	..()
	if(hud.loc != src)
		if(ismob(hud.loc))
			var/mob/hud_loc = hud.loc
			hud_loc.drop_from_inventory(hud, src)
			hud_loc << "[hud] automaticly retract in [src]."
		hud.forceMove(src)
		update_icon()

/obj/item/clothing/head/helmet/riot/update_icon()
	if(hud in src)
		icon_state = "light_riot"
		set_light(0, 0)
	else
		icon_state = "light_riot_on"
		set_light(2, 2, "#F3B922")
	update_clothing_icon()
	..()
