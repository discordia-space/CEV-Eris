/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/structures.dmi'
	icon_state = "latticefull"
	density = 0
	anchored = 1.0
	w_class = ITEM_SIZE_NORMAL
	layer = 2.3 //under pipes
	//	flags = CONDUCT

/obj/structure/lattice/Initialize()
	. = ..()
///// Z-Level Stuff
	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open) || istype(src.loc, /turf/simulated/floor/hull))) // || istype(src.loc, /turf/simulated/floor/open)
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

/obj/structure/lattice/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/lattice/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(I, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(I.get_tool_type(user, list(QUALITY_WELDING)))
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_PRD))
			user << SPAN_NOTICE("Slicing lattice joints ...")
			PoolOrNew(/obj/item/stack/rods, src.loc)
			qdel(src)
	if (istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if(R.amount <= 2)
			return
		else
			R.use(2)
			user << SPAN_NOTICE("You start connecting [R.name] to [src.name] ...")
			if(do_after(user,50))
				src.alpha = 0
				new /obj/structure/catwalk(src.loc)
				qdel(src)
			return
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
