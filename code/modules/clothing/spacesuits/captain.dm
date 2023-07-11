//Captain's Spacesuit
/obj/item/clothing/head/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	item_state = "capspace"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	armor = list(
		melee = 12,
		bullet = 10,
		energy = 10,
		bomb = 250,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive corporate armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state = "capspacesuit"
	armor = list(
		melee = 12,
		bullet = 10,
		energy = 10,
		bomb = 250,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.7
