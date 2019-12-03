/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	action_button_name = "Toggle Headlamp"
	brightness_on = 4 //luminosity when on
	light_overlay = "hardhat_light"
	armor = list(
		melee = ARMOR_BULLET_SMALL,
		bullet = ARMOR_BULLET_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_MINOR,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.8
	w_class = ITEM_SIZE_NORMAL
	price_tag = 30

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"
	name = "firefighter helmet"
	item_flags = STOPPRESSUREDAMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat0_white"
	item_flags = STOPPRESSUREDAMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/dblue
	icon_state = "hardhat0_dblue"
