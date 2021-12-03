//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "A... present?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strangepresent"
	density = TRUE
	anchored = FALSE

// nt magik
/obj/effect/overlay/nt_construction
	name = "neotheology construct"
	desc = "It shimmers and glows a little."
	icon = 'icons/effects/nt_construction.dmi'
	icon_state = "rcd_short"
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 128

/obj/effect/overlay/nt_construction/proc/cleanup()
	spawn(5)
		light.destroy()
	spawn(20)
		qdel(src)

/obj/effect/overlay/nt_construction/New(loc, lifetime)
	..(loc)
	if(lifetime >= 9 SECONDS)
		icon_state = "rcd"
	if(lifetime >= 7 SECONDS)
		icon_state = "rcd_short"
	if(lifetime >= 5 SECONDS)
		icon_state = "rcd_shorter"
	if(lifetime >= 3 SECONDS)
		icon_state = "rcd_shortest"

	set_light(2, 1.5, "#f8df83")

/obj/effect/overlay/nt_construction/proc/success()
	set_light(2, 2, "#e6d2a8")
	icon_state = "rcd_end"
	cleanup()

/obj/effect/overlay/nt_construction/proc/failure()
	set_light(2, 2, "#f38d74")
	icon_state += "_reverse"
	cleanup()
