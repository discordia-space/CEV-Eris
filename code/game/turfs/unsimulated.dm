/turf/wall/dummy
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	density = TRUE
	is_using_flat_icon = TRUE
	is_simulated = FALSE

/turf/wall/dummy/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = 0

/turf/wall/dummy/other
	icon_state = "eris_reinf_wall"
	is_using_flat_icon = FALSE


/turf/floor/dummy
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"
	is_simulated = FALSE

/turf/floor/dummy/airless
	oxygen = 0
	nitrogen = 0

/turf/floor/dummy/shuttle_ceiling
	icon_state = "reinforced"

/turf/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"
	dynamic_lighting = TRUE
	is_simulated = FALSE

/turf/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'
	is_simulated = FALSE

/turf/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/beach/water
	name = "Water"
	icon_state = "water"
	light_color = "#00BFFF"
	light_power = 2
	light_range = 2

/turf/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)
