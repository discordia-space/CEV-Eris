//Captain's Spacesuit
/obj/item/clothing/head/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	item_state = "capspace"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	matter = list(MATERIAL_STEEL = 5, MATERIAL_PLASTEEL = 8, MATERIAL_GOLD = 2, MATERIAL_SILVER = 2, MATERIAL_CARDBOARD = 3)
	armor = list(
		melee = 50,
		bullet = 40,
		energy = 40,
		bomb = 50,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive corporate armor. YOU are in charge!"
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTEEL = 15, MATERIAL_GOLD = 4, MATERIAL_SILVER = 4, MATERIAL_CARDBOARD = 5)
	icon_state = "caparmor"
	item_state = "capspacesuit"
	armor = list(
		melee = 50,
		bullet = 40,
		energy = 40,
		bomb = 50,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.7
	stiffness = MEDIUM_STIFFNESS
