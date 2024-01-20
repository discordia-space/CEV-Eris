//Wizard Rig
/obj/item/clothing/head/space/void/wizard
	name = "gem-encrusted voidsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "rig0-wiz"
	item_state_slots = list(
		slot_l_hand_str = "wiz_helm",
		slot_r_hand_str = "wiz_helm",
		)
	unacidable = 1 //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(
		ARMOR_BLUNT = 10,
		ARMOR_BULLET = 10,
		ARMOR_ENERGY = 10,
		ARMOR_BOMB =25,
		ARMOR_BIO =100,
		ARMOR_RAD =90
	)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/void/wizard
	icon_state = "rig-wiz"
	name = "gem-encrusted voidsuit"
	desc = "A bizarre gem-encrusted suit that radiates strange energy readings."
	item_state = "wiz_voidsuit"
	slowdown = 1
	unacidable = 1
	armor = list(
		ARMOR_BLUNT = 10,
		ARMOR_BULLET = 10,
		ARMOR_ENERGY = 10,
		ARMOR_BOMB =25,
		ARMOR_BIO =100,
		ARMOR_RAD =90
	)
	siemens_coefficient = 0.7
	helmet = /obj/item/clothing/head/space/void/wizard
	spawn_blacklisted = TRUE
