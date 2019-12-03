//Captain's Spacesuit
/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	item_state = "capspace"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BULLET_LARGE,
		energy = ARMOR_ENERGY_LARGE,
		bomb = ARMOR_BOMB_MODERATE,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_MODERATE
	)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive corporate armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state = "capspacesuit"
	slowdown = 1.5
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BULLET_LARGE,
		energy = ARMOR_ENERGY_LARGE,
		bomb = ARMOR_BOMB_MODERATE,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_MODERATE
	)
	siemens_coefficient = 0.7
