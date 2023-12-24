//Captain's Spacesuit
/obj/item/clothing/head/space/capspace
	name = "Captain's helmet"
	icon_state = "capspace"
	item_state = "capspace"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	rarity_value = 150
	armor = list(
		ARMOR_BLUNT = 35,
		ARMOR_BULLET = 30,
		ARMOR_ENERGY = 25,
		ARMOR_BOMB =250,
		ARMOR_BIO =100,
		ARMOR_RAD =50
	)
	siemens_coefficient = 0.7
	rarity_value = 200
	armorComps = list(
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/ceramic,
		/obj/item/armor_component/plate/plastic
	)

/obj/item/clothing/suit/space/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive corporate armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state = "capspacesuit"
	armor = list(
		ARMOR_BLUNT = 35,
		ARMOR_BULLET = 30,
		ARMOR_ENERGY = 25,
		ARMOR_BOMB =250,
		ARMOR_BIO =100,
		ARMOR_RAD =50
	)
	siemens_coefficient = 0.7
	rarity_value = 200
	armorComps = list(
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/ceramic,
		/obj/item/armor_component/plate/plastic
	)
