/turf/wall/reinforced
	name = "reinforced wall"
	icon_state = "eris_reinf_wall"
	health = 600
	max_health = 600
	hardness = 140
	is_reinforced = TRUE
	wall_type = "eris_reinf_wall"

/turf/wall/reinforced/get_matter()
	return list(MATERIAL_PLASTEEL = 5)

/turf/wall/frontier
	icon_state = "frontier_wall"
	wall_style = "fancy"
	wall_type = "frontier_wall"

/turf/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE

/turf/shuttle/wall/cargo
	name = "Cargo Transport Shuttle (A5)"
	icon = 'icons/turf/shuttlecargo.dmi'
	icon_state = "cargoshwall1"

/turf/shuttle/wall/escpod
	name = "Escape Pod"
	icon = 'icons/turf/shuttleescpod.dmi'
	icon_state = "escpodwall1"

/turf/shuttle/wall/mining
	name = "Mining Barge"
	icon = 'icons/turf/shuttlemining.dmi'
	icon_state = "11,23"

/turf/shuttle/wall/science
	name = "Science Shuttle"
	icon = 'icons/turf/shuttlescience.dmi'
	icon_state = "6,18"

/turf/shuttle/wall/pulsar
	name = "Pulsar Shuttle"
	icon = 'icons/turf/shuttlepulsar.dmi'
	icon_state = "pulsarwall1"

/obj/structure/shuttle_part //For placing them over space, if sprite covers not whole tile.
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	anchored = TRUE
	density = TRUE
	bad_type = /obj/structure/shuttle_part

/obj/structure/shuttle_part/cargo
	name = "Cargo Transport Shuttle (A5)"
	icon = 'icons/turf/shuttlecargo.dmi'
	icon_state = "cargoshwall1"

/obj/structure/shuttle_part/escpod
	name = "Escape Pod"
	icon = 'icons/turf/shuttleescpod.dmi'
	icon_state = "escpodwall1"

/obj/structure/shuttle_part/mining
	name = "Mining Barge"
	icon = 'icons/turf/shuttlemining.dmi'
	icon_state = "11,23"

/obj/structure/shuttle_part/science
	name = "Science Shuttle"
	icon = 'icons/turf/shuttlescience.dmi'
	icon_state = "6,18"

/obj/structure/shuttle_part/pulsar
	name = "Pulsar Shuttle"
	icon = 'icons/turf/shuttlepulsar.dmi'
	icon_state = "pulsarwall1"

/obj/structure/shuttle_part/explosion_act(target_power, explosion_handler/handler)
	// full block
	return target_power

/turf/wall/untinted // Left here for the sake of not changing 50+ more files, most of which are maps

/*
	One Star/Alliance walls, for use on derelict stuff
*/
/turf/wall/untinted/onestar
	icon_state = "onestar_wall"
	wall_style = "minimalistic"
	wall_type = "onestar_wall"

/turf/wall/untinted/onestar_reinforced
	name = "reinforced wall"
	icon_state = "onestar_reinf_wall"
	health = 600
	max_health = 600
	hardness = 140
	is_reinforced = TRUE
	wall_style = "minimalistic"
	wall_type = "onestar_reinf_wall"
