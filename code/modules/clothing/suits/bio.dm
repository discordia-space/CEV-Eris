//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio"
	item_state_slots = list(
		slot_l_hand_str = "bio_hood",
		slot_r_hand_str = "bio_hood",
		)
	desc = "A hood that protects the head and face from biological comtaminants."
	permeability_coefficient = 0.01
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =0,
		ARMOR_BIO =100,
		ARMOR_RAD =25
	)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES|EARS
	item_flags = COVER_PREVENT_MANIPULATION
	siemens_coefficient = 0.9
	price_tag = 50
	style = STYLE_NONE

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio"
	item_state = "bio_suit"
	volumeClass = ITEM_SIZE_BULKY//bulky item3
	spawn_blacklisted = FALSE
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_HAZMATSUIT
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	item_flags = COVER_PREVENT_MANIPULATION
	slowdown = 0.2
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =0,
		ARMOR_BIO =100,
		ARMOR_RAD =25
	)
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	siemens_coefficient = 0.9
	price_tag = 100
	style = STYLE_NONE

//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "Plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against viruses."
	icon_state = "plaguedoctor"
	item_state = "bio_suit"
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
