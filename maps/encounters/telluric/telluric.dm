#include "telluric.dmm"

/obj/map_data/telluric
	name = "Telluric Planet Level"
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE
	height = 1
	is_sealed = TRUE

/obj/effect/overmap/sector/telluric
	name = "telluric"
	desc = "A telluric planet of medium size."
	icon = 'icons/effects/352x352.dmi'
	icon_state = "telluric"
	pixel_x = -160
	pixel_y = -160
	generic_waypoints = list(
		"nav_telluric_1",
		"nav_telluric_2"
	)
	known = 1
	in_space = 0

/obj/effect/shuttle_landmark/telluric/nav1
	name = "Telluric Planet Landing zone #1"
	icon_state = "shuttle-green"
	landmark_tag = "nav_telluric_1"
	base_area = /area/telluric
	base_turf = /turf/simulated/floor/asteroid

/obj/effect/shuttle_landmark/telluric/nav2
	name = "Telluric Planet Landing zone #2"
	icon_state = "shuttle-green"
	landmark_tag = "nav_telluric_2"
	base_area = /area/telluric
	base_turf = /turf/simulated/floor/asteroid
