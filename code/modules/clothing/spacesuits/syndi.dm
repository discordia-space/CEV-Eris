//Regular syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate
	name = "red space helmet"
	icon_state = "syndicate"
	item_state = "syndicate"
	desc = "A crimson helmet sporting clean lines and durable plating. Engineered to look menacing."
	armor = list(
		melee = ARMOR_MELEE_MODERATE,
		bullet = ARMOR_BULLET_MODERATE,
		energy = ARMOR_ENERGY_MODERATE,
		bomb = ARMOR_BOMB_SMALL,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.6

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "A crimson spacesuit sporting clean lines and durable plating. Robust, reliable, and slightly suspicious."
	w_class = ITEM_SIZE_NORMAL
	slowdown = 1
	armor = list(
		melee = ARMOR_MELEE_MODERATE,
		bullet = ARMOR_BULLET_MODERATE,
		energy = ARMOR_ENERGY_MODERATE,
		bomb = ARMOR_BOMB_SMALL,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.6
