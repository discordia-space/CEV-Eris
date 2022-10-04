
//Bartender
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	desc = "A hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chefhat"
	item_state = "chefhat"
	spawn_blacklisted = TRUE

//Captain
/obj/item/clothing/head/caphat
	name = "captain's hat"
	icon_state = "captain"
	desc = "It's good being the king."
	spawn_blacklisted = TRUE
	item_state_slots = list(
		slot_l_hand_str = "caphat",
		slot_r_hand_str = "caphat",
		)
	body_parts_covered = 0

/obj/item/clothing/head/caphat/cap
	name = "captain's cap"
	desc = "You fear to wear it for the negligence it brings."
	icon_state = "capcap"
	spawn_blacklisted = TRUE

/obj/item/clothing/head/caphat/formal
	name = "parade hat"
	desc = "No one in a commanding position should be without a perfect, white hat of ultimate authority."
	icon_state = "officercap"
	spawn_blacklisted = TRUE

//HOP
/obj/item/clothing/head/caphat/hop
	name = "first officer's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"
	spawn_blacklisted = TRUE

//Chaplain
/obj/item/clothing/head/chaplain_hood
	name = "preacher's hood"
	desc = "It's hood that covers the head. It keeps you warm during the space winters."
	icon_state = "chaplain_hood"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD
	spawn_blacklisted = TRUE

/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = "Maximum piety in this star system."
	icon_state = "nun_hood"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD
	spawn_blacklisted = TRUE
	style_coverage = COVERS_HAIR

/obj/item/clothing/head/preacher
	name = "preacher hat"
	desc = "Useful for hiding disdainful eyes from the godless masses."
	icon_state = "church_hat"
	spawn_blacklisted = TRUE
	style_coverage = COVERS_EYES|COVERS_HAIR

//Mime
/obj/item/clothing/head/beret
	name = "beret"
	desc = "A beret, an artists favorite headwear."
	icon_state = "beret"
	body_parts_covered = 0
	spawn_blacklisted = TRUE
	style_coverage = COVERS_HAIR

//Security
/obj/item/clothing/head/beret/sec/navy/officer
	name = "Operative beret"
	desc = "A navy blue beret with an Operative's rank emblem. For operatives that are more inclined towards style than safety."
	icon_state = "beret_navy_officer"
	spawn_blacklisted = TRUE

/obj/item/clothing/head/beret/sec/navy/hos
	name = "Commander beret"
	desc = "Grey beret with a Commander's rank emblem. For commanders that are more inclined towards style than safety."
	icon_state = "beret_navy_hos"
	spawn_blacklisted = TRUE

/obj/item/clothing/head/beret/sec/navy/warden
	name = "Sergeant beret"
	desc = "Red beret with a Sergeant's rank emblem. For sergeants that are more inclined towards style than safety."
	icon_state = "beret_navy_warden"
	spawn_blacklisted = TRUE

/obj/item/clothing/head/beret/engineering
	name = "engineering beret"
	desc = "A beret with the engineering insignia emblazoned on it. For engineers that are more inclined towards style than safety."
	icon_state = "beret_engineering"
	spawn_blacklisted = TRUE

/obj/item/clothing/head/beret/purple
	name = "purple beret"
	desc = "A stylish, if purple, beret."
	icon_state = "beret_purple"
	spawn_blacklisted = TRUE

/obj/item/clothing/head/beret/artist
	name = "Feathered Beret"
	desc = "Fit for artists, frenchmen, and eccentric military officers across the cosmos."
	icon_state = "beret_artist"
	item_state = "beret_artist"
	spawn_frequency = 0

//Medical
/obj/item/clothing/head/surgery
	name = "surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs."
	icon_state = "surgcap_green"
	flags_inv = BLOCKHEADHAIR
	bad_type = /obj/item/clothing/head/surgery
	spawn_blacklisted = TRUE
	style_coverage = COVERS_HAIR
	style = STYLE_LOW

/obj/item/clothing/head/surgery/purple
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is deep purple."
	icon_state = "surgcap_purple"

/obj/item/clothing/head/surgery/blue
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is baby blue."
	icon_state = "surgcap_blue"

/obj/item/clothing/head/surgery/green
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is dark green."
	icon_state = "surgcap_green"
