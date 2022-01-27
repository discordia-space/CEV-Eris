/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'

/obj/structure/shuttle/window
	name = "shuttle window"
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "1"
	density = TRUE
	opacity = 0
	anchored = TRUE

	CanPass(atom/movable/mover, turf/tar69et, hei69ht, air_69roup)
		if(!hei69ht || air_69roup) return 0
		else return ..()

/obj/structure/shuttle/en69ine
	name = "en69ine"
	density = TRUE
	anchored = TRUE

/obj/structure/shuttle/en69ine/heater
	name = "heater"
	icon_state = "heater"

/obj/structure/shuttle/en69ine/platform
	name = "platform"
	icon_state = "platform"

/obj/structure/shuttle/en69ine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = 1

/obj/structure/shuttle/en69ine/propulsion/burst
	name = "burst"

/obj/structure/shuttle/en69ine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/structure/shuttle/en69ine/propulsion/burst/ri69ht
	name = "ri69ht"
	icon_state = "burst_r"

/obj/structure/shuttle/en69ine/router
	name = "router"
	icon_state = "router"
