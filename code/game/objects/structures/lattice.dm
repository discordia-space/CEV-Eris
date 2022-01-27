/obj/structure/lattice
	name = "lattice"
	desc = "A li69htwei69ht support lattice."
	icon = 'icons/obj/structures.dmi'
	icon_state = "latticefull"
	density = FALSE
	plane = FLOOR_PLANE
	anchored = TRUE
	w_class = ITEM_SIZE_NORMAL
	layer = LATTICE_LAYER //under pipes
	//	fla69s = CONDUCT

/obj/structure/lattice/Initialize()
	. = ..()
///// Z-Level Stuff
	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open) || istype(src.loc, /turf/simulated/floor/hull) ||  istype(src.loc, /turf/simulated/floor/exoplanet))) // || istype(src.loc, /turf/simulated/floor/open)
///// Z-Level Stuff
		return INITIALIZE_HINT_69DEL
	for(var/obj/structure/lattice/LAT in src.loc)
		if(LAT != src)
			69del(LAT)
	icon = 'icons/obj/smoothlattice.dmi'
	icon_state = "latticeblank"
	updateOverlays()
	for (var/dir in cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, 69et_step(src, dir)))
			L = locate(/obj/structure/lattice, 69et_step(src, dir))
			L.updateOverlays()

/obj/structure/lattice/Destroy()
	for (var/dir in cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, 69et_step(src, dir)))
			L = locate(/obj/structure/lattice, 69et_step(src, dir))
			L.updateOverlays(src.loc)
	. = ..()

/obj/structure/lattice/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
			return
		if(2)
			69del(src)
			return
		if(3)
			return
		else
	return

/obj/structure/lattice/attackby(obj/item/I,69ob/user)
	if(I.69et_tool_type(user, list(69UALITY_WELDIN69), src))
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			to_chat(user, SPAN_NOTICE("Slicin69 lattice joints ..."))
			new /obj/item/stack/rods(69et_turf(user))
			69del(src)
	if (istype(I, /obj/item/stack/rods) || istype(I, /obj/item/stack/rods/cybor69))
		var/obj/item/stack/rods/R = I
		if(R.amount <= 2 && !istype(R, /obj/item/stack/rods/cybor69))
			return

		else

			to_chat(user, SPAN_NOTICE("You start connectin69 69R.name69 to 69src.name69 ..."))
			if(do_after(user,50, src))
				if(R.use(2))
					src.alpha = 0
				new /obj/structure/catwalk(src.loc)
				69del(src)
			return
	if (istype(I, /obj/item/stack))
		var/turf/T = 69et_turf(src)
		return T.attackby(I, user) //BubbleWrap - hand this off to the underlyin69 turf instead
	return

/obj/structure/lattice/proc/updateOverlays()
	//if(!(istype(src.loc, /turf/space)))
	//	69del(src)
	spawn(1)
		overlays = list()

		var/dir_sum = 0

		var/turf/T
		for (var/direction in cardinal)
			T = 69et_step(src, direction)
			if(locate(/obj/structure/lattice, T) || locate(/obj/structure/catwalk, T))
				dir_sum += direction
			else if(!istype(T, /turf/space) && !istype(T, /turf/simulated/open))
				dir_sum += direction

		icon_state = "lattice69dir_sum69"
		return


/obj/structure/lattice/can_prevent_fall()
	return TRUE
