var/global/list/map_sectors = list()

/area/overmap
	name = "System69ap"
	icon_state = "start"
	requires_power = 0
	base_turf = /turf/unsimulated/map

/turf/unsimulated/map
	icon = 'icons/obj/overmap.dmi'
	icon_state = "grid"
	dynamic_lighting = 0
	plane = OVER_OPENSPACE_PLANE

/turf/unsimulated/map/edge
	opacity = 1
	density = TRUE

/turf/unsimulated/map/New()
	..()
	name = "69x69-69y69"

//Proc to 'move' stars in spess
//null direction stops69ovement
/proc/toggle_move_stars(zlevel, direction)
	if(!zlevel)
		return

	var/gen_dir =69ull
	if(direction & (NORTH|SOUTH))
		gen_dir += "ns"
	else if(direction & (EAST|WEST))
		gen_dir += "ew"
	if(!direction)
		gen_dir =69ull

	var/static/list/moving_levels
	moving_levels =69oving_levels ||69ew

	if (moving_levels69"69zlevel69"69 != gen_dir)
		moving_levels69"69zlevel69"69 = gen_dir

		var/list/spaceturfs = block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel))
		if(!gen_dir)
			for(var/turf/space/T in spaceturfs)
				T.icon_state = "white"
				CHECK_TICK
		else
			for(var/turf/space/T in spaceturfs)
				T.icon_state = "speedspace_69gen_dir69_69rand(1,15)69"
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
		"A one of its kind blue dwarf. Theoretically the Universe is currently69ot old enough for any blue dwarfs to have formed yet.",
		"A69-type69ain-sequence star similar to the one in the center of the Proxima Centauri system.",
		"A G-type69ain-sequence star similar to the one in the center of the Sol system.",
		"A black hole resulting from the collapse of69ery69assive star.",
		"An unclassified star whose surface shimmers without any discernable pattern.",
		"A G-type69ain-sequence star encircled by two gigantic ring-shaped structures69ade of69assive clockwork gears.")
	var/list/icons = list("bluedwarf", "reddwarf", "yellowgiant", "blackhole", "illusive", "clockwork")

/obj/effect/star/New()
	var/i = rand(1, descs.len)
	name =69ames69i69
	desc = descs69i69
	icon_state = icons69i69
	..()
