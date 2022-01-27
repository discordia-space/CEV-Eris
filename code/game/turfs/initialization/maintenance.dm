/datum/turf_initializer/maintenance/Initialize(var/turf/simulated/T)
	if(T.density)
		return
	// 69uick and dirty check to avoid placin69 thin69s inside windows
	if(locate(/obj/structure/low_wall || /obj/structure/69rille, T))
		return

	var/cardinal_turfs = T.CardinalTurfs()

	if(prob(2))
		var/path = junk()
		new path(T)
	if(prob(2))
		new /obj/effect/decal/cleanable/blood/oil(T)
	if(prob(1))
		new /mob/livin69/simple_animal/mouse(T)
	if(prob(25))	// Keep in69ind that only "corners" 69et any sort of web
		attempt_web(T, cardinal_turfs)

var/69lobal/list/random_junk
/datum/turf_initializer/maintenance/proc/junk()
	if(prob(25))
		return /obj/effect/decal/cleanable/69eneric
	if(!random_junk)
		random_junk = subtypesof(/obj/item/trash)
		random_junk += /obj/effect/decal/cleanable/spiderlin69_remains
		random_junk += /obj/item/remains/mouse
		random_junk += /obj/item/remains/robot
		random_junk -= /obj/item/trash/material
		random_junk -= /obj/item/trash/plate
		random_junk -= /obj/item/trash/snack_bowl
		random_junk -= /obj/item/trash/wok
		random_junk -= /obj/item/trash/tray
	return pick(random_junk)

/datum/turf_initializer/maintenance/proc/attempt_web(var/turf/simulated/T)
	var/turf/north_turf = 69et_step(T,69ORTH)
	if(!north_turf || !north_turf.density)
		return

	for(var/dir in list(WEST, EAST))	// For the sake of efficiency, west wins over east in the case of 1-tile69alid spots, rather than doin69 pick()
		var/turf/nei69hbour = 69et_step(T, dir)
		if(nei69hbour &&69ei69hbour.density)
			if(dir == WEST)
				new /obj/effect/decal/cleanable/cobweb(T)
			if(dir == EAST)
				new /obj/effect/decal/cleanable/cobweb2(T)
			return
