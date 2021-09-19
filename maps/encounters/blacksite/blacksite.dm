#include "blacksite_small.dmm"
#include "blacksite_medium.dmm"
#include "blacksite_large.dmm"

/obj/map_data/blacksite
	name = "Blacksite Level"
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE
	is_sealed = TRUE
	height = 1

/obj/map_data/blacksite/small
	name = "Small Blacksite Level"

/obj/map_data/blacksite/medium
	name = "Medium Blacksite Level"

/obj/map_data/blacksite/large
	name = "Large Blacksite Level"

/obj/effect/overmap/sector/blacksite
	name = "unknown spatial phenomenon"
	desc = "An abandoned blacksite, carved inside an asteroid. Might be a hundred years old."
	generic_waypoints = list(
		"nav_blacksite_1",
		"nav_blacksite_2"
	)
	known = 0
	invisibility = 101

	name_stages = list("abandoned blacksite", "unknown object", "unknown spatial phenomenon")
	icon_stages = list("ring_destroyed", "object", "poi")

/obj/effect/overmap/sector/blacksite/Initialize()
	. = ..()
	new /obj/effect/overmap_event/poi/blacksite(loc, src)

/obj/effect/overmap/sector/blacksite/small
	generic_waypoints = list(
		"nav_blacksite_small_1",
		"nav_blacksite_small_2"
	)

/obj/effect/overmap/sector/blacksite/medium
	generic_waypoints = list(
		"nav_blacksite_medium_1",
		"nav_blacksite_medium_2"
	)

/obj/effect/overmap/sector/blacksite/large
	generic_waypoints = list(
		"nav_blacksite_large_1",
		"nav_blacksite_large_2"
	)

/obj/effect/shuttle_landmark/blacksite/nav1
	name = "Abandoned Blacksite Navpoint #1"
	icon_state = "shuttle-green"
	landmark_tag = "nav_blacksite_1"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/blacksite/nav2
	name = "Abandoned Blacksite Navpoint #2"
	icon_state = "shuttle-green"
	landmark_tag = "nav_blacksite_2"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/blacksite/nav1/small
	name = "Abandoned Small Blacksite Navpoint #1"
	landmark_tag = "nav_blacksite_small_1"

/obj/effect/shuttle_landmark/blacksite/nav2/small
	name = "Abandoned Small Blacksite Navpoint #2"
	landmark_tag = "nav_blacksite_small_2"

/obj/effect/shuttle_landmark/blacksite/nav1/medium
	name = "Abandoned Small Blacksite Navpoint #1"
	landmark_tag = "nav_blacksite_medium_1"

/obj/effect/shuttle_landmark/blacksite/nav2/medium
	name = "Abandoned Small Blacksite Navpoint #2"
	landmark_tag = "nav_blacksite_medium_2"

/obj/effect/shuttle_landmark/blacksite/nav1/large
	name = "Abandoned Medium Blacksite Navpoint #1"
	landmark_tag = "nav_blacksite_large_1"

/obj/effect/shuttle_landmark/blacksite/nav2/large
	name = "Abandoned Large Blacksite Navpoint #2"
	landmark_tag = "nav_blacksite_large_2"
