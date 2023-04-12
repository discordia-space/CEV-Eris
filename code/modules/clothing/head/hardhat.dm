/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat_yellow"
	action_button_name = "Toggle Headlamp"
	brightness_on = 4 //luminosity when on
	light_overlay = "hardhat_light"
	armor = list(
		melee = 2,
		bullet = 2,
		energy = 2,
		bomb = 50,
		bio = 10,
		rad = 25
	)
	siemens_coefficient = 0.8
	w_class = ITEM_SIZE_NORMAL
	price_tag = 30
	style = STYLE_NEG_LOW
	style_coverage = COVERS_HAIR

/obj/item/clothing/head/hardhat/visor
	name = "visored hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight and visor, which may protect eyes."
	icon_state = "hardhat_yellow_visor"
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEEYES

/obj/item/clothing/head/hardhat/blue
	icon_state = "hardhat_blue"

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat_orange"

/obj/item/clothing/head/hardhat/red
	name = "firefighter helmet"
	icon_state = "hardhat_red"
	item_flags = STOPPRESSUREDAMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat_white"
	item_flags = STOPPRESSUREDAMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
