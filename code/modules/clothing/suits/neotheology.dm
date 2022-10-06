/obj/item/clothing/head/armor/acolyte
	name = "Acolyte hood"
	desc = "Even the most devout deserve head protection."
	icon_state = "acolyte"
	item_state = "acolyte"
	flags_inv = BLOCKHAIR
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	armor = list(
		melee = 10,
		bullet = 7,
		energy = 7,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/armor/acolyte
	name = "Acolyte armor"
	desc = "Worn heavy, steadfast in the name of God."
	icon_state = "acolyte"
	item_state = "acolyte"
	matter = list(MATERIAL_PLASTIC = 30, MATERIAL_STEEL = 25, MATERIAL_BIOMATTER = 40)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(
		melee = 10,
		bullet = 7,
		energy = 7,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	//helmet = /obj/item/clothing/head/space/void/acolyte
	spawn_blacklisted = TRUE

/obj/item/clothing/head/armor/agrolyte
	name = "Agrolyte hood"
	desc = "Don't want anything getting in your eyes."
	icon_state = "botanist"
	item_state = "botanist"
	flags_inv = BLOCKHAIR
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	armor = list(
		melee = 5,
		bullet = 5,
		energy = 5,
		bomb = 10,
		bio = 100,
		rad = 75
	)
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/armor/agrolyte
	name = "Agrolyte armor"
	desc = "Every rose has its thorns."
	icon_state = "botanist"
	item_state = "botanist"
	slowdown = 0
	matter = list(MATERIAL_PLASTIC = 30, MATERIAL_STEEL = 15, MATERIAL_BIOMATTER = 40)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(
		melee = 5,
		bullet = 5,
		energy = 5,
		bomb = 10,
		bio = 100,
		rad = 75
	)
	spawn_blacklisted = TRUE

/obj/item/clothing/head/armor/custodian
	name = "Custodian helmet"
	desc = "Cleaning floors is more dangerous than it looks."
	icon_state = "custodian"
	item_state = "custodian"
	action_button_name = "Toggle Helmet Light"
	flags_inv = BLOCKHAIR
	light_overlay = "helmet_light"
	brightness_on = 4
	armor = list(
		melee = 7,
		bullet = 5,
		energy = 5,
		bomb = 10,
		bio = 200,
		rad = 90
	)
	unacidable = TRUE
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/armor/custodian
	name = "Custodian armor"
	desc = "Someone's gotta clean this mess."
	icon_state = "custodian"
	item_state = "custodian"
	matter = list(MATERIAL_PLASTIC = 40, MATERIAL_STEEL = 15, MATERIAL_BIOMATTER = 40)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(
		melee = 7,
		bullet = 5,
		energy = 5,
		bomb = 20,
		bio = 200,
		rad = 90
	)
	unacidable = TRUE
	spawn_blacklisted = TRUE
