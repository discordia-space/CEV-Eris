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

/obj/effect/pulsar_ship/proc/try_move(newdir, with_malicious_intent = FALSE)
	if(with_malicious_intent)
		if(fuel >= fuel_movement_cost)
			fuel -= fuel_movement_cost
		else
			return
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
