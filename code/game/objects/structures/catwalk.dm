/obj/structure/catwalk
	layer = TURF_LAYER + 0.5
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	desc = "Cats really don't like these things."
	density = FALSE
	anchored = TRUE


/obj/structure/catwalk/New()
	..()
	if (istype(loc, /turf/simulated/open))
		var/turf/simulated/open/T = loc
		T.updateFallability()
	spawn(4)
		if(src)
			for(var/obj/structure/catwalk/C in get_turf(src))
				if(C != src)
					qdel(C)
			update_icon()
			redraw_nearby_catwalks()

/obj/structure/catwalk/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/catwalk/LateInitialize()
	..()
	update_icon()
	redraw_nearby_catwalks()

/obj/structure/catwalk/Destroy()
	if (istype(loc, /turf/simulated/open))
		var/turf/simulated/open/T = loc
		T.updateFallability(src)
	redraw_nearby_catwalks()
	. = ..()

/obj/structure/catwalk/proc/redraw_nearby_catwalks()
	for(var/direction in alldirs)
		if(locate(/obj/structure/catwalk, get_step(src, direction)))
			var/obj/structure/catwalk/L = locate(/obj/structure/catwalk, get_step(src, direction))
			L.update_icon() //so siding get updated properly

/obj/structure/catwalk/proc/test_connect(turf/T)
	if(locate(/obj/structure/catwalk, T))
		return TRUE
	if(T && T.is_wall)
		return TRUE
	if(istype(T, /turf/simulated/floor))
		var/turf/simulated/floor/F = T
		if(!F.flooring?.is_plating || istype(F.flooring, /decl/flooring/reinforced/plating/hull)) //Caution stripes go where elevation would change, eg, stepping down onto underplating
			return TRUE

/obj/structure/catwalk/update_icon()
	var/connectdir = 0
	for(var/direction in cardinal)
		if(test_connect(get_step(src, direction)))
			connectdir |= direction

	//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
	var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
	//NORTHEAST
	if(connectdir & NORTH && connectdir & EAST)
		if(test_connect(get_step(src, NORTHEAST)))
			diagonalconnect |= 1
	//SOUTHEAST
	if(connectdir & SOUTH && connectdir & EAST)
		if(test_connect(get_step(src, SOUTHEAST)))
			diagonalconnect |= 2
	//NORTHWEST
	if(connectdir & NORTH && connectdir & WEST)
		if(test_connect(get_step(src, NORTHWEST)))
			diagonalconnect |= 4
	//SOUTHWEST
	if(connectdir & SOUTH && connectdir & WEST)
		if(test_connect(get_step(src, SOUTHWEST)))
			diagonalconnect |= 8

	icon_state = "catwalk[connectdir]-[diagonalconnect]"

/obj/structure/catwalk/attackby(obj/item/I, mob/user)
	if(QUALITY_WELDING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			to_chat(user, "\blue Slicing lattice joints ...")
			new /obj/item/stack/rods(get_turf(user))
			new /obj/item/stack/rods(get_turf(user))
			new /obj/structure/lattice/(src.loc)
			qdel(src)
	return


/obj/structure/catwalk/can_prevent_fall()
	return FALSE
