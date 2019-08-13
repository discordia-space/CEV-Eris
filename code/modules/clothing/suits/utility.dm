/*
 * Contains:
 *		Fire protection
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Fire protection
 */

/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "firesuit"
	item_state = "firefighter"
	w_class = ITEM_SIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	extra_allowed = list(/obj/item/weapon/extinguisher)
	slowdown = 1.0
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	item_flags = STOPPRESSUREDAMAGE | COVER_PREVENT_MANIPULATION
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	price_tag = 50


/obj/item/clothing/suit/fire/firefighter
	icon_state = "firesuit"
	item_state = "firefighter"


/obj/item/clothing/suit/fire/heavy
	name = "firesuit"
	desc = "A suit that protects against extreme fire and heat."
	//icon_state = "thermal"
	item_state = "ro_suit"
	w_class = ITEM_SIZE_LARGE//bulky item
	slowdown = 1.5

/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "bomb hood"
	desc = "Use in case of bomb."
	icon_state = "bombsuit"
	armor = list(melee = 50, bullet = 50, energy = 50, bomb = 300, bio = 50, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES|EARS
	item_flags = COVER_PREVENT_MANIPULATION
	siemens_coefficient = 0
	equip_delay = 50
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY
	price_tag = 100

/obj/item/clothing/suit/bomb_suit
	name = "bomb suit"
	desc = "A suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	item_state = "bombsuit"
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown = 3.2
	armor = list(melee = 50, bullet = 50, energy = 50, bomb = 300, bio = 50, rad = 50)
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	heat_protection = UPPER_TORSO|LOWER_TORSO
	item_flags = COVER_PREVENT_MANIPULATION
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0
	equip_delay = 200
	price_tag = 300


/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	body_parts_covered = HEAD

/obj/item/clothing/suit/bomb_suit/security
	icon_state = "bombsuitsec"
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/*
 * Radiation protection
 */
/obj/item/clothing/head/radiation
	name = "Radiation Hood"
	icon_state = "rad"
	desc = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 0, bullet = 0, energy = 60, bomb = 0, bio = 100, rad = 100)
	price_tag = 50


/obj/item/clothing/suit/radiation
	name = "Radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	icon_state = "rad"
	item_state = "rad_suit"
	w_class = ITEM_SIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	extra_allowed = list(/obj/item/clothing/head/radiation)
	slowdown = 1.5
	armor = list(melee = 0, bullet = 0, energy = 60, bomb = 0, bio = 100, rad = 100)
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	price_tag = 100
