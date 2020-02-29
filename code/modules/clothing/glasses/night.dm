/obj/item/clothing/glasses/powered/night
	name = "Night Vision Goggles"
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

/obj/item/clothing/glasses/bullet_proof_ironhammer
	name = "Night Vision Goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "bulletproof_ironhammer_goggles"
	darkness_view = 7
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flags = ABSTRACT

/obj/item/clothing/glasses/bullet_proof_ironhammer/Initialize()
	. = ..()
	overlay = global_hud.nvg
