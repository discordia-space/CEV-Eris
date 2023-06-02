/*
 * Bomb protection
 */
/obj/item/clothing/head/space/bomb
	name = "bomb helmet"
	desc = "Use in case of bomb. The shielded visor makes aiming harder."
	icon_state = "bombsuit"
	armor = list(
		melee = 10,
		bullet = 10,
		energy = 10,
		bomb = 1000,
		bio = 100,
		rad = 90
	)
	siemens_coefficient = 0
	tint = TINT_LOW
	price_tag = 100

/obj/item/clothing/suit/space/bomb
	name = "bomb suit"
	desc = "A heavy armored space suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	item_state = "bombsuit"
	spawn_tags = SPAWN_TAG_HAZMATSUIT
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	armor = list(
		melee = 10,
		bullet = 10,
		energy = 10,
		bomb = 1000,
		bio = 100,
		rad = 90
	)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0
	equip_delay = 10 SECONDS
	price_tag = 300
	slowdown = HEAVY_SLOWDOWN

/obj/item/clothing/head/space/bomb/security
	icon_state = "bombsuitsec"

/obj/item/clothing/suit/space/bomb/security
	icon_state = "bombsuitsec"
	spawn_blacklisted = TRUE
