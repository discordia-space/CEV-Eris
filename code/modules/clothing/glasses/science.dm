/obj/item/clothing/glasses/powered/science
	name = "science goggles"
	desc = "A pair of goggles with a science HUD. These can show you reagents within transparent containers and organoid information."
	off_state = "purple"
	icon_state = "purple"
	item_state = "glasses"

	tick_cost = 0.1

/obj/item/clothing/glasses/powered/science/Initialize()
	. = ..()
	overlay = global_hud.science
