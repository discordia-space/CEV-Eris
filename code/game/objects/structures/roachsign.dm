/obj/structure/roachsign
	name = "neon roach sign"
	desc = "An old, barely working neon sign for a roach grill."
	icon = 'icons/obj/structures/roachsign.dmi'
	icon_state = "roachsign"
	density = FALSE
	anchored = TRUE
	layer = SIGN_LAYER

/obj/structure/roachsign/Initialize()
	. = ..()
	set_light(2, 2, "#82C2D8")
