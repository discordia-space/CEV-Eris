/obj/structure/catwalk
	layer = TURF_LAYER + 0.5
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	desc = "Cats really don't like these things."
	density = 0
	anchored = 1.0

	footstep_sounds = list("human" = list('sound/effects/footstep/catwalk1.ogg',
						'sound/effects/footstep/catwalk2.ogg',
						'sound/effects/footstep/catwalk3.ogg',
						'sound/effects/footstep/catwalk4.ogg',
						'sound/effects/footstep/catwalk5.ogg'))

/obj/structure/catwalk/New()
	..()
	spawn(4)
		if(src)
			for(var/obj/structure/catwalk/C in get_turf(src))
				if(C != src)
					qdel(C)
			update_icon()
			redraw_nearby_catwalks()

/obj/structure/catwalk/Destroy()
	redraw_nearby_catwalks()
	. = ..()

/obj/structure/catwalk/proc/redraw_nearby_catwalks()
	for(var/direction in alldirs)
		if(locate(/obj/structure/catwalk, get_step(src, direction)))
			var/obj/structure/catwalk/L = locate(/obj/structure/catwalk, get_step(src, direction))
			L.update_icon() //so siding get updated properly


/obj/structure/catwalk/update_icon()
	var/connectdir = 0
	for(var/direction in cardinal)
		if(locate(/obj/structure/catwalk, get_step(src, direction)))
			connectdir |= direction

	//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
	var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
	//NORTHEAST
	if(connectdir & NORTH && connectdir & EAST)
		if(locate(/obj/structure/catwalk, get_step(src, NORTHEAST)))
			diagonalconnect |= 1
	//SOUTHEAST
	if(connectdir & SOUTH && connectdir & EAST)
		if(locate(/obj/structure/catwalk, get_step(src, SOUTHEAST)))
			diagonalconnect |= 2
	//NORTHWEST
	if(connectdir & NORTH && connectdir & WEST)
		if(locate(/obj/structure/catwalk, get_step(src, NORTHWEST)))
			diagonalconnect |= 4
	//SOUTHWEST
	if(connectdir & SOUTH && connectdir & WEST)
		if(locate(/obj/structure/catwalk, get_step(src, SOUTHWEST)))
			diagonalconnect |= 8

	icon_state = "catwalk[connectdir]-[diagonalconnect]"


/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			qdel(src)
	return

/obj/structure/catwalk/attackby(obj/item/I, mob/user)
	if(QUALITY_WELDING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_PRD))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			user << "\blue Slicing lattice joints ..."
			new /obj/item/stack/rods(src.loc)
			new /obj/item/stack/rods(src.loc)
			new /obj/structure/lattice/(src.loc)
			qdel(src)
	return
