/*
 * Contains:
 *		Security
 *		Inspector
 *		Ironhammer Commander
 */

/*
 * Security
 */

/obj/item/clothing/under/security_formal
	name = "ironhammer formal uniform"
	desc = "A navy blue suit. Often used by Ironhammer personnel, for shooting with style."
	icon_state = "ih_formal"
	item_state = "ih_formal"
	spawn_blacklisted = TRUE

/obj/item/clothing/under/rank/warden
	desc = "The uniform worn by Ironhammer Sergeants, the sight of it is often followed by shouting. It has\"Gunnery Sergeant\" rank pins on the shoulders."
	name = "Gunnery Sergeant jumpsuit"
	icon_state = "warden"
	item_state = "r_suit"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/warden/skirt
	name = "Gunnery Sergeant jumpskirt"
	desc = "It's made of a slightly sturdier material than standard jumpskirts, to allow for more robust protection. It has\"Gunnery Sergeant\" rank pins on the shoulders."
	icon_state = "warden_skirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/head/warden //legacy security hat
	name = "warden hat"
	desc = "A special helmet issued to the Warden of a securiy force."
	icon_state = "policehelm"
	body_parts_covered = NONE

/obj/item/clothing/under/rank/security
	name = "Ironhammer Operative's jumpsuit"
	desc = "The standard issue uniform of Ironhammer grunts all over the sector."
	icon_state = "security"
	item_state = "ba_suit"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/security/turtleneck
	name = "Ironhammer Operative's turtleneck"
	desc = "Same as the standard Ironhammer uniform but with a sleek black military style sweater. Best used in cold environments"
	icon_state = "securityrturtle"

/obj/item/clothing/under/rank/security/skirt
	name = "Ironhammer Operative's jumpskirt"
	desc = "It's made of a slightly sturdier material than standard jumpskirts, to allow for robust protection."
	icon_state = "security_skirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/medspec
	name = "Medical Specialist's jumpsuit"
	desc = "An Ironhammer uniform modified for use by medics. Comes with a white shirt and medical insignia. It has \"Specialist\" rank pins on the shoulders."
	icon_state = "medspec"
	item_state = "ba_suit"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/medspec/skirt
	name = "Medical Specialist's jumpskirt"
	desc = "It's made of a slightly sturdier material than standard jumpskirts, to allow for robust protection. It has \"Specialist\" rank pins on the shoulders."
	icon_state = "medspec_skirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/*
 * Inspector
 */
/obj/item/clothing/under/rank/inspector
	name = "inspector's suit"
	desc = "Fancy dress shirt, slacks and tie. The fancy civilian clothes of an Ironhammer Inspector."
	icon_state = "insp_under"
	item_state = "insp_under"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/det
	name = "inspector's suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks, complete with a blue striped tie and a faux-gold tie clip."
	icon_state = "detective"
	item_state = "det"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/det/black
	icon_state = "detective3"
	//item_state = "sl_suit"
	desc = "An immaculate white dress shirt, paired with a pair of dark grey dress pants, a red tie, and a charcoal vest."

/obj/item/clothing/head/detective
	name = "fedora"
	desc = "A brown fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."
	icon_state = "detective_brown"
	item_state_slots = list(
		slot_l_hand_str = "detective_hat",
		slot_r_hand_str = "detective_hat",
		)
	allowed = list(/obj/item/reagent_containers/food/snacks/candy_corn, /obj/item/pen)
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	siemens_coefficient = 0.8
	body_parts_covered = NONE

/obj/item/clothing/head/detective/grey
	icon_state = "detective_gray"
	desc = "A grey fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."

/obj/item/clothing/head/detective/black
	icon_state = "detective_black"
	desc = "A black fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."


/*
 * Ironhammer Commander
 */
/obj/item/clothing/under/rank/ih_commander
	desc = "The uniform of an on-field Ironhammer officer. Used to distinguish officers from the grunts. It has \"Lieutenant\" rank pins on the shoulder"
	name = "Ironhammer Commander's jumpsuit"
	icon_state = "hos"
	item_state = "r_suit"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/ih_commander/skirt
	name = "Ironhammer Commander's jumpskirt"
	desc = "A jumpskirt worn by those few with the dedication to achieve the position of \"Ironhammer Commander\"."
	icon_state = "hos_skirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/head/HoS
	name = "Ironhammer Commander Hat"
	desc = "The hat of the Ironhammer Commander. For showing the enlisted who's in charge."
	icon_state = "hoshat"
	body_parts_covered = NONE
	siemens_coefficient = 0.8

/*
 * "Navy" uniforms
 */
/obj/item/clothing/under/rank/cadet
	name = "Ironhammer Cadet's jumpskirt"
	desc = "A sailor's uniform used for cadets in training, though more frequently in acts of hazing."
	icon_state = "cadet"
	item_state = "cadet"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
