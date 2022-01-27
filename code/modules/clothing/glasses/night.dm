/obj/item/clothing/glasses/powered/night
	name = "Night69ision Goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state = "glasses"
	darkness_view = 7
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	off_state = "denight"
	origin_tech = list(TECH_MAGNET = 2)
	price_tag = 500

	tick_cost = 1

/obj/item/clothing/glasses/powered/night/Initialize()
	. = ..()
	overlay = global_hud.nvg

/obj/item/clothing/glasses/powered/bullet_proof_ironhammer
	name = "Night69ision Goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "bulletproof_ironhammer_goggles"
	off_state = "bulletproof_ironhammer_goggles"
	action_button_name = null
	toggleable = FALSE
	darkness_view = 7
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flags = ABSTRACT
	spawn_blacklisted = TRUE

	tick_cost = 1

/obj/item/clothing/glasses/powered/bullet_proof_ironhammer/Initialize()
	. = ..()
	overlay = global_hud.nvg
