/obj/effect/overmap/sector/map_spawner/fortress
	name = "unknown spatial phenomenon"
	desc = "An abandoned space fortress, carved inside an asteroid. Might be a hundred years old."
	name_stages = list("abandoned fortress", "unknown object", "unknown spatial phenomenon")
	icon_stages = list("os_fortress", "object", "poi")
	map_to_load = "fortress"


/obj/effect/shuttle_landmark/fortress/nav1
	name = "Abandoned Fortress Navpoint #1"
	icon_state = "shuttle-green"
	landmark_tag = "nav_fortress_1"
	base_turf = /turf/space
	exploration_landmark = TRUE

/obj/effect/shuttle_landmark/fortress/nav2
	name = "Abandoned Fortress Navpoint #2"
	icon_state = "shuttle-green"
	landmark_tag = "nav_fortress_2"
	base_turf = /turf/space
	exploration_landmark = TRUE
