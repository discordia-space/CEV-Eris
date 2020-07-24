/obj/item/clothing/head/space/void/acolyte
	name = "Acolyte hood"
	desc = "Even the most devout deserve head protection."
	icon_state = "acolyte"
	armor = list(
		melee = 25,
		bullet = 25,
		energy = 25,
		bomb = 25,
		bio = 100,
		rad = 75
	)

/obj/item/clothing/suit/space/void/acolyte
	name = "Acolyte armor"
	desc = "Worn heavy, steadfast in the name of God."
	icon_state = "acolyte"
	slowdown = 0.3
	armor = list(
		melee = 25,
		bullet = 25,
		energy = 25,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	helmet = /obj/item/clothing/head/space/void/acolyte

/obj/item/clothing/head/space/void/agrolyte
	name = "Agrolyte hood"
	desc = "Don't want anything getting in your eyes."
	icon_state = "botanist"
	armor = list(
		melee = 20,
		bullet = 10,
		energy = 10,
		bomb = 25,
		bio = 100,
		rad = 75
	)

/obj/item/clothing/suit/space/void/agrolyte
	name = "Agrolyte armor"
	desc = "Every rose has its thorns."
	icon_state = "botanist"
	slowdown = 0
	armor = list(
		melee = 20,
		bullet = 10,
		energy = 10,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	helmet = /obj/item/clothing/head/space/void/agrolyte

/obj/item/clothing/head/space/void/custodian
	name = "Custodian helmet"
	desc = "Cleaning floors is more dangerous than it looks."
	icon_state = "custodian"
	armor = list(
		melee = 20,
		bullet = 10,
		energy = 10,
		bomb = 25,
		bio = 200,
		rad = 90
	)
	unacidable = TRUE

/obj/item/clothing/suit/space/void/custodian
	name = "Custodian armor"
	desc = "Someone's gotta clean this mess."
	icon_state = "custodian"
	slowdown = 0.05
	armor = list(
		melee = 20,
		bullet = 10,
		energy = 10,
		bomb = 25,
		bio = 200,
		rad = 90
	)
	unacidable = TRUE
	helmet = /obj/item/clothing/head/space/void/custodian