/datum/turf_initializer/maintenance/Initialize(var/turf/simulated/T)
	if(T.density)
		return
	// Quick and dirty check to avoid placing things inside windows
	if(locate(/obj/structure/low_wall || /obj/structure/grille, T))
		return

	var/cardinal_turfs = T.CardinalTurfs()

	if(prob(2))
		var/path = junk()
		new path(T)
	if(prob(2))
		new /obj/effect/decal/cleanable/blood/oil(T)
	if(prob(1))
		new /mob/living/simple_animal/mouse(T)
	if(prob(25))	// Keep in mind that only "corners" get any sort of web
		attempt_web(T, cardinal_turfs)

var/global/list/random_junk
/datum/turf_initializer/maintenance/proc/junk()
	if(prob(25))
		return /obj/effect/decal/cleanable/generic
	if(!random_junk)
		random_junk = subtypesof(/obj/item/trash)
		random_junk += /obj/effect/decal/cleanable/spiderling_remains
		random_junk += /obj/item/remains/mouse
		random_junk += /obj/item/remains/robot
		random_junk -= /obj/item/trash/material
		random_junk -= /obj/item/trash/plate
		random_junk -= /obj/item/trash/snack_bowl
		random_junk -= /obj/item/trash/syndi_cakes
		random_junk -= /obj/item/trash/tray
	return pick(random_junk)

/datum/turf_initializer/maintenance/proc/attempt_web(var/turf/simulated/T)
	var/turf/north_turf = get_step(T, NORTH)
	if(!north_turf || !north_turf.density)
		return

	for(var/dir in list(WEST, EAST))	// For the sake of efficiency, west wins over east in the case of 1-tile valid spots, rather than doing pick()
		var/turf/neighbour = get_step(T, dir)
		if(neighbour && neighbour.density)
			if(dir == WEST)
				new /obj/effect/decal/cleanable/cobweb(T)
			if(dir == EAST)
				new /obj/effect/decal/cleanable/cobweb2(T)
			return
