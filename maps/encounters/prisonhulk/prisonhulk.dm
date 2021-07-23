#include "prisonhulk.dmm"

/obj/map_data/prisonhulk
	name = "Prison Hulk Level"
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE
	height = 1

//MINING-1 // CLUSTER
/obj/effect/overmap/sector/prisonhulk
	name = "derelict hulk"
	desc = "An abandoned space hulk, which appears to be a former prison vessel. Minimal life signs."
	generic_waypoints = list(
		"nav_prisonhulk_1",
		"nav_prisonhulk_2"
	)
	known = 1

	name_stages = list("prison hulk", "unknown object", "unknown spatial phenomenon")
	icon_stages = list("spacehulk", "object", "poi")

/obj/effect/shuttle_landmark/prisonhulk/nav1
	name = "Prison Hulk Navpoint #1"
	icon_state = "shuttle-green"
	landmark_tag = "nav_prisonhulk_1"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/prisonhulk/nav2
	name = "Prison Hulk Navpoint #2"
	icon_state = "shuttle-green"
	landmark_tag = "nav_prisonhulk_2"
	base_turf = /turf/space
