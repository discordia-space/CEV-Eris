/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/structures.dmi'
	icon_state = "latticefull"
	density = FALSE
	plane = FLOOR_PLANE
	anchored = TRUE
	w_class = ITEM_SIZE_NORMAL
	layer = LATTICE_LAYER //under pipes
	//	flags = CONDUCT

/obj/structure/lattice/Initialize()
	. = ..()
///// Z-Level Stuff
	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open) || istype(src.loc, /turf/simulated/floor/hull) ||  istype(src.loc, /turf/simulated/floor/exoplanet))) // || istype(src.loc, /turf/simulated/floor/open)
///// Z-Level Stuff
		return INITIALIZE_HINT_QDEL
	for(var/obj/structure/lattice/LAT in src.loc)
		if(LAT != src)
			qdel(LAT)
	icon = 'icons/obj/smoothlattice.dmi'
	icon_state = "latticeblank"
	updateOverlays()
	for (var/dir in cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays()

/obj/structure/lattice/Destroy()
	for (var/dir in cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays(src.loc)
	. = ..()

/obj/structure/lattice/attackby(obj/item/I, mob/user)
	if(I.get_tool_type(user, list(QUALITY_WELDING), src))
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			to_chat(user, SPAN_NOTICE("Slicing lattice joints ..."))
			new /obj/item/stack/rods(get_turf(user))
			qdel(src)
	if (istype(I, /obj/item/stack/rods) || istype(I, /obj/item/stack/rods/cyborg))
		var/obj/item/stack/rods/R = I
		if(R.amount <= 2 && !istype(R, /obj/item/stack/rods/cyborg))
			return

		else

			to_chat(user, SPAN_NOTICE("You start connecting [R.name] to [src.name] ..."))
			if(do_after(user,50, src))
				if(R.use(2))
					src.alpha = 0
				new /obj/structure/catwalk(src.loc)
				qdel(src)
			return
	if (istype(I, /obj/item/stack))
		var/turf/T = get_turf(src)
		return T.attackby(I, user) //BubbleWrap - hand this off to the underlying turf instead
	return

/obj/structure/lattice/proc/updateOverlays()
	//if(!(istype(src.loc, /turf/space)))
	//	qdel(src)
	spawn(1)
		overlays = list()

		var/dir_sum = 0

		var/turf/T
		for (var/direction in cardinal)
			T = get_step(src, direction)
			if(locate(/obj/structure/lattice, T) || locate(/obj/structure/catwalk, T))
				dir_sum += direction
			else if(!istype(T, /turf/space) && !istype(T, /turf/simulated/open))
				dir_sum += direction

		icon_state = "lattice[dir_sum]"
		return


/obj/structure/lattice/can_prevent_fall()
	return TRUE
