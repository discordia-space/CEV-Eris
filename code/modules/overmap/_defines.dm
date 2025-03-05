var/global/list/map_sectors = list()

/area/overmap
	name = "System Map"
	icon_state = "start"
	requires_power = FALSE
	base_turf = /turf/map

/turf/map
	icon = 'icons/obj/overmap.dmi'
	icon_state = "grid"
	dynamic_lighting = 0
	plane = OVER_OPENSPACE_PLANE
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	is_simulated = FALSE

/turf/map/edge
	opacity = 1
	density = TRUE

/turf/map/New()
	..()
	name = "[x]-[y]"

//Proc to 'move' stars in spess
//null direction stops movement
/proc/toggle_move_stars(zlevel, direction)
	if(!zlevel)
		return

	var/gen_dir = null
	if(direction & (NORTH|SOUTH))
		gen_dir += "ns"
	else if(direction & (EAST|WEST))
		gen_dir += "ew"
	if(!direction)
		gen_dir = null

	var/static/list/moving_levels
	moving_levels = moving_levels || new

	if (moving_levels["[zlevel]"] != gen_dir)
		moving_levels["[zlevel]"] = gen_dir

		var/list/spaceturfs = block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel))
		if(!gen_dir)
			for(var/turf/space/T in spaceturfs)
				T.icon_state = "white"
				CHECK_TICK
		else
			for(var/turf/space/T in spaceturfs)
				T.icon_state = "speedspace_[gen_dir]_[rand(1,15)]"
				for(var/atom/movable/AM in T)
					if (AM.simulated && !AM.anchored)
						AM.throw_at(get_step(T,reverse_direction(direction)), 5, 1)
						CHECK_TICK
				CHECK_TICK

/obj/effect/star
	name = "generic star"
	desc = "A generic star."
	icon = 'icons/obj/overmap.dmi'
	icon_state = "generic"
	anchored = TRUE

	var/list/names = list("blue dwarf", "red dwarf", "yellow giant", "black hole", "illusive star", "clockwork star")
	var/list/descs = list(
		"A one of its kind blue dwarf. Theoretically the Universe is currently not old enough for any blue dwarfs to have formed yet.",
		"A M-type main-sequence star similar to the one in the center of the Proxima Centauri system.",
		"A G-type main-sequence star similar to the one in the center of the Sol system.",
		"A black hole resulting from the collapse of very massive star.",
		"An unclassified star whose surface shimmers without any discernable pattern.",
		"A G-type main-sequence star encircled by two gigantic ring-shaped structures made of massive clockwork gears.")
	var/list/icons = list("bluedwarf", "reddwarf", "yellowgiant", "blackhole", "illusive", "clockwork")

/obj/effect/star/New()
	var/i = rand(1, descs.len)
	name = names[i]
	desc = descs[i]
	icon_state = icons[i]
	..()
