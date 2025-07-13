//A temporary effect that does not DO anything except look pretty.
/obj/effect/temporary
	anchored = TRUE
	unacidable = 1
	mouse_opacity = 0
	density = FALSE
	plane = 0
	layer = 0

/obj/effect/temporary/Initialize(mapload, duration = 30, _icon = 'icons/effects/effects.dmi', _state)
	. = ..()
	icon = _icon
	icon_state = _state
	QDEL_IN(src, duration)
