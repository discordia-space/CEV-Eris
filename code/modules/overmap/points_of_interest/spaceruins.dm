/obj/effect/overmap/sector/map_spawner/spaceruins
	name = "unknown spatial phenomenon"
	desc = "An assorted clutter of small asteroids and space trash, seems to be long abandoned."
	name_stages = list("space ruins", "unknown object", "unknown spatial phenomenon")
	icon_stages = list("os_ruins", "object", "poi")
	map_to_load = "ruins"


/obj/effect/shuttle_landmark/spaceruins/nav1
	name = "Abandoned Space Ruins #1"
	icon_state = "shuttle-green"
	landmark_tag = "nav_ruin_1"
	base_turf = /turf/space
	exploration_landmark = TRUE

/obj/effect/shuttle_landmark/spaceruins/nav2
	name = "Abandoned Space Ruins #2"
	icon_state = "shuttle-green"
	landmark_tag = "nav_ruin_2"
	base_turf = /turf/space
	exploration_landmark = TRUE
