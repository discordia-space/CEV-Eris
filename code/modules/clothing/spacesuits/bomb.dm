/*
 * Bomb protection
 */
/obj/item/clothing/head/space/bomb
	name = "bomb helmet"
	desc = "Use in case of bomb. The shielded visor makes aiming harder."
	icon_state = "bombsuit"
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =1000,
		ARMOR_BIO =100,
		ARMOR_RAD =90
	)
	siemens_coefficient = 0
	tint = TINT_LOW
	price_tag = 100
	matter = list(MATERIAL_PLASTIC = 10, MATERIAL_LEATHER = 2, MATERIAL_CLOTH = 2)
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plastic,
		/obj/item/armor_component/plate/plastic
	)

/obj/item/clothing/suit/space/bomb
	name = "bomb suit"
	desc = "A heavy armored space suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	item_state = "bombsuit"
	spawn_tags = SPAWN_TAG_HAZMATSUIT
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =1000,
		ARMOR_BIO =100,
		ARMOR_RAD =90
	)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0
	equip_delay = 10 SECONDS
	price_tag = 300
	slowdown = 4
	matter = list(MATERIAL_PLASTIC = 30, MATERIAL_LEATHER = 5, MATERIAL_CLOTH = 5)
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/sideguards/plasteel,
		/obj/item/armor_component/sideguards/plasteel,
		/obj/item/armor_component/plate/plastic,
		/obj/item/armor_component/plate/plastic,
		/obj/item/armor_component/sideguards/plastic
	)

/obj/item/clothing/head/space/bomb/security
	icon_state = "bombsuitsec"

/obj/item/clothing/suit/space/bomb/security
	icon_state = "bombsuitsec"
	spawn_blacklisted = TRUE
