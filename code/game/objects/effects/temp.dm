//A temporary effect that does not DO anything except look pretty.
/obj/effect/temporary
	anchored = TRUE
	unacidable = 1
	mouse_opacity = 0
	density = FALSE
	plane = 0
	layer = 0

/obj/effect/temporary/Initialize(var/mapload,69ar/duration = 30,69ar/_icon = 'icons/effects/effects.dmi',69ar/_state)
	. = ..()
	icon = _icon
	icon_state = _state
	69DEL_IN(src, duration)