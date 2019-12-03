
/obj/item/clothing/head/helmet/space/void/acolyte
	name = "Acolyte hood"
	desc = "Even the most devout deserve head protection."
	icon_state = "acolyte"
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BULLET_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_SMALL,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_LARGE
	)

/obj/item/clothing/suit/space/void/acolyte
	name = "Acolyte armor"
	desc = "Worn heavy, steadfast in the name of God."
	icon_state = "acolyte"
	slowdown = 0.15
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BULLET_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_SMALL,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_LARGE
	)

/obj/item/clothing/head/helmet/space/void/agrolyte
	name = "Agrolyte hood"
	desc = "Don't want anything getting in your eyes."
	icon_state = "botanist"
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BULLET_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_SMALL,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_LARGE
	)

/obj/item/clothing/suit/space/void/agrolyte
	name = "Agrolyte armor"
	desc = "Every rose has its thorns."
	icon_state = "botanist"
	slowdown = 0
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BULLET_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_SMALL,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_LARGE
	)

/obj/item/clothing/head/helmet/space/void/custodian
	name = "Custodian helmet"
	desc = "Cleaning floors is more dangerous than it looks."
	icon_state = "custodian"
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BULLET_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_SMALL,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_MAJOR
	)
	unacidable = TRUE

/obj/item/clothing/suit/space/void/custodian
	name = "Custodian armor"
	desc = "Someone's gotta clean this mess."
	icon_state = "custodian"
	slowdown = 0.15
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BULLET_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_SMALL,
		bio = ARMOR_BIO_IMMUNE,
		rad = ARMOR_RAD_MAJOR
	)
	unacidable = TRUE
