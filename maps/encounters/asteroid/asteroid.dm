#include "asteroid.dmm"

//MINING-1 // CLUSTER
/obj/effect/overmap/sector/asteroid
	name = "unknown spatial phenomenon"
	desc = "A large asteroid. Mineral content detected."
	generic_waypoints = list(
		"nav_asteroid_1",
		"nav_asteroid_2"
	)
	known = 1
	in_space = 0
	
	name_stages = list("asteroid", "unknown object", "unknown spatial phenomenon")

/obj/effect/overmap/sector/asteroid/Initialize()
	. = ..()
	icon_stages = list(pick("asteroid0", "asteroid1", "asteroid2", "asteroid3"), "object", "poi")

/obj/effect/shuttle_landmark/asteroid/nav1
	name = "Asteroid Landing zone #1"
	icon_state = "shuttle-green"
	landmark_tag = "nav_asteroid_1"
	base_area = /area/mine/explored
	base_turf = /turf/floor/asteroid

/obj/effect/shuttle_landmark/asteroid/nav2
	name = "Asteroid Landing zone #2"
	icon_state = "shuttle-green"
	landmark_tag = "nav_asteroid_2"
	base_area = /area/mine/explored
	base_turf = /turf/floor/asteroid