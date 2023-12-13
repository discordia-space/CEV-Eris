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
		ARMOR_BLUNT = 10,
		ARMOR_BULLET = 7,
		ARMOR_ENERGY = 7,
		ARMOR_BOMB =25,
		ARMOR_BIO =100,
		ARMOR_RAD =75
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
		ARMOR_BLUNT = 10,
		ARMOR_BULLET = 7,
		ARMOR_ENERGY = 7,
		ARMOR_BOMB =25,
		ARMOR_BIO =100,
		ARMOR_RAD =75
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
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =10,
		ARMOR_BIO =100,
		ARMOR_RAD =75
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
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =10,
		ARMOR_BIO =100,
		ARMOR_RAD =75
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
		ARMOR_BLUNT = 7,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =10,
		ARMOR_BIO =200,
		ARMOR_RAD =90
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
		ARMOR_BLUNT = 7,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =20,
		ARMOR_BIO =200,
		ARMOR_RAD =90
	)
	unacidable = TRUE
	spawn_blacklisted = TRUE
