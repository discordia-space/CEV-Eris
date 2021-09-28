#include "scrapyard.dmm"

/obj/map_data/scrapyard
	name = "Scrapyard"
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE
	height = 1

obj/effect/overmap/sector/scrapyard
	name = "scrapyard"
	desc = "An old spaceship graveyard."
	generic_waypoints = list(
		"nav_scrapyard_1",
		"nav_scrapyard_2"
	)
	known = 1
	name_stages = list("spaceship scrapyard", "unknown place", "unknown spatial phenomenon")
	icon_stages = list("os_fortress", "object", "poi")

/obj/effect/shuttle_landmark/scrapyard/nav1
	name = "Scrapyard #1"
	icon_state = "shuttle-green"
	landmark_tag = "nav_scrapyard_1"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/scrapyard/nav2
	name = "Scrapyard #2"
	icon_state = "shuttle-green"
	landmark_tag = "nav_scrapyard_2"
	base_turf = /turf/space
