/obj/effect/pulsar
	name = "pulsar"
	desc = "An insanely quickly rotating star, that releases 2 giant ratiation beams"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "pulsar"
	anchored = TRUE

//based on area/overmap
/area/pulsar
	name = "Pulsar Map"
	icon_state = "grid"
	requires_power = 0
	base_turf = /turf/unsimulated/map/pulsar

/turf/unsimulated/map/pulsar/New()
	..()
	name = "Deep Space"

/obj/effect/pulsar_beam
	name = "radiation beam"
	desc = "A beam of high energy radiation"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "pulsar_beam"

/obj/effect/pulsar_beam/dl
	icon_state = "pulsar_beam_dl"

/obj/effect/pulsar_beam/ur
	icon_state = "pulsar_beam_ur"

/obj/effect/pulsar_ship
	name = "Technomancer satellite orbit"
	desc = "The orbit target for the satellite"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ihs_capital_g"
	var/obj/effect/pulsar_ship/shadow
	var/do_decay = TRUE
	var/decay_timer = 10 SECONDS
	var/fuel = 100
	var/fuel_movement_cost = 5

/obj/effect/pulsar_ship/New()
	. = ..()
	if(do_decay)
		addtimer(CALLBACK(src, .proc/decay_orbit), decay_timer)

/obj/effect/pulsar_ship/proc/decay_orbit()
	var/movedir = pick(NORTH, SOUTH, EAST, WEST)
	try_move(movedir)
	addtimer(CALLBACK(src, .proc/decay_orbit), decay_timer)

/obj/effect/pulsar_ship/proc/try_move(newdir)
	var/turf/newloc = get_step(src, newdir)
	if(!newloc || newloc.x > GLOB.maps_data.pulsar_size - 1 || newloc.x < 1 || newloc.y > GLOB.maps_data.pulsar_size - 1 || newloc.y < 1) // If movement outside of the map, reverse decay dir
		Move(get_step(src, turn(newdir, 180)))
		shadow.Move(get_step(shadow, newdir))
	else
		Move(newloc)
		shadow.Move(get_step(shadow, turn(newdir, 180)))

/obj/effect/pulsar_ship/shadow
	do_decay = FALSE
	alpha = 255 * 0.5

//Pulsar events

/datum/pulsar_event
	var/name = "parent of all pulsar events"

/datum/pulsar_event/proc/check_tile(tile)
	var/turf/T = tile
	if(!istype(T))
		return FALSE
	var/list/banned_objects = list(/obj/effect/pulsar)
	banned_objects += typesof(/obj/effect/pulsar_beam)
	banned_objects += typesof(/obj/effect/pulsar_ship)
	for(var/O in T)
		if(O in banned_objects)
			return FALSE
	return TRUE

/datum/pulsar_event/proc/get_valid_tile()
	var/tile_x = rand(2, GLOB.maps_data.pulsar_size - 2)
	var/tile_y = rand(2, GLOB.maps_data.pulsar_size - 2)
	var/turf/T = locate(tile_x, tile_y, GLOB.maps_data.pulsar_z)
	if(istype(T) && check_tile(T))
		return T
	return get_valid_tile() //Infinite reccurson highly improabable

/datum/pulsar_event/proc/on_trigger()
	return

/datum/pulsar_event/pulsar_portals
	name = "pulsar portals"

/datum/pulsar_event/pulsar_portals/on_trigger()
	var/turf/portal_1_turf = get_valid_tile()
	var/turf/portal_2_turf = get_valid_tile()
	var/obj/effect/portal/perfect/portal_1 = new /obj/effect/portal/perfect(portal_1_turf)
	var/obj/effect/portal/perfect/portal_2 = new /obj/effect/portal/perfect(portal_2_turf)
	portal_1.set_target(portal_2_turf)
	portal_2.set_target(portal_1_turf)
	//Shadows for the map
	var/turf/mirror_tile_1 = locate(GLOB.maps_data.pulsar_size - portal_1_turf.x, GLOB.maps_data.pulsar_size - portal_1_turf.y, portal_1_turf.z)
	var/turf/mirror_tile_2 = locate(GLOB.maps_data.pulsar_size - portal_2_turf.x, GLOB.maps_data.pulsar_size - portal_2_turf.y, portal_2_turf.z)
	var/obj/effect/portal/perfect/portal_1_shadow = new /obj/effect/portal/perfect(mirror_tile_1)
	var/obj/effect/portal/perfect/portal_2_shadow = new /obj/effect/portal/perfect(mirror_tile_2)
	portal_1_shadow.set_target(mirror_tile_2)
	portal_2_shadow.set_target(mirror_tile_1)
	portal_1_shadow.alpha = 255 * 0.5
	portal_2_shadow.alpha = 255 * 0.5

