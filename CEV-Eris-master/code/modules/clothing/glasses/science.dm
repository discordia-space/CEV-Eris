/obj/item/clothing/glasses/powered/science
	name = "Science Goggles"
	desc = "The goggles do nothing!"
	icon_state = "purple"
	item_state = "glasses"

	tick_cost = 0.1

/obj/item/clothing/glasses/powered/science/Initialize()
	. = ..()
	overlay = global_hud.science
