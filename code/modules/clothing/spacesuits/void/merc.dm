/obj/item/clothing/head/helmet/space/void/SCAF
	name = "SCAF helmet"
	desc = "A thick airtight helmet designed for planetside warfare retrofitted with seals to act like normal space suit helmet."
	icon_state = "scaf"
	item_state = "scaf"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BULLET_PROFICIENT,
		energy = ARMOR_ENERGY_MAJOR,
		bomb = ARMOR_BOMB_LARGE,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "helmet_light_green"

/obj/item/clothing/suit/space/void/SCAF
	name = "SCAF suit"
	desc = "A bulky antique suit of refurbished infantry armour, retrofitted with seals and coatings to make it EVA capable but also reducing mobility."
	icon_state = "scaf"
	item_state = "scaf"
	slowdown = 1.3
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	armor = list(
		melee = ARMOR_MELEE_PROFICIENT,
		bullet = ARMOR_BULLET_MAJOR,
		energy = ARMOR_ENERGY_MAJOR,
		bomb = ARMOR_BOMB_LARGE,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list("Human")


//Voidsuit for traitors
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. This version is additionally reinforced against melee attacks."
	icon_state = "syndiehelm"
	item_state = "syndie_helm"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BULLET_LARGE,
		energy = ARMOR_ENERGY_MODERATE,
		bomb = ARMOR_BOMB_MODERATE,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_LARGE
	)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "helmet_light_ihs"

/obj/item/clothing/head/helmet/space/void/merc/update_icon()
	..()
	if(on)
		icon_state = "syndiehelm_on"
	else
		icon_state = initial(icon_state)
	return

/obj/item/clothing/suit/space/void/merc
	icon_state = "syndievoidsuit"
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. This version is additionally reinforced against melee attacks."
	item_state = "syndie_voidsuit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BULLET_LARGE,
		energy = ARMOR_ENERGY_MODERATE,
		bomb = ARMOR_BOMB_MODERATE,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_LARGE
	)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
