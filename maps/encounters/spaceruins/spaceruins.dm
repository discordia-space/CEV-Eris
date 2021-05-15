#include "spaceruins.dmm"

/obj/map_data/spaceruins
	name = "Space ruins Level"
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE
	height = 1
	is_sealed = TRUE


/obj/effect/overmap/sector/spaceruins
	name = "unknown spatial phenomenon"
	desc = "An assorted clutter of small asteroids and space trash, seems to be long abandoned."
	generic_waypoints = list(
		"nav_ruin_1",
		"nav_ruin_2"
	)
	known = 1

	name_stages = list("space ruins", "unknown object", "unknown spatial phenomenon")
	icon_stages = list("os_ruins", "object", "poi")

/obj/effect/shuttle_landmark/spaceruins/nav1
	name = "Abandoned Space Ruins #1"
	icon_state = "shuttle-green"
	landmark_tag = "nav_ruin_1"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/spaceruins/nav2
	name = "Abandoned Space Ruins #2"
	icon_state = "shuttle-green"
	landmark_tag = "nav_ruin_2"
	base_turf = /turf/space
