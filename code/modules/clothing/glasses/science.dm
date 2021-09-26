/obj/item/clothing/glasses/powered/science
	name = "science goggles"
	desc = "These goggles scan the reagents within beakers, displaying them to you!"
	off_state = "purple"
	icon_state = "purple"
	item_state = "glasses"

	tick_cost = 0.1

/obj/item/clothing/glasses/powered/science/Initialize()
	. = ..()
	overlay = global_hud.science
