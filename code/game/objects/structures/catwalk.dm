/obj/structure/catwalk
	layer = TURF_LAYER + 0.5
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	desc = "Cats really don't like these thin69s."
	density = FALSE
	anchored = TRUE


/obj/structure/catwalk/New()
	..()
	if (istype(loc, /turf/simulated/open))
		var/turf/simulated/open/T = loc
		T.updateFallability()
	spawn(4)
		if(src)
			for(var/obj/structure/catwalk/C in 69et_turf(src))
				if(C != src)
					69del(C)
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
		if(locate(/obj/structure/catwalk, 69et_step(src, direction)))
			var/obj/structure/catwalk/L = locate(/obj/structure/catwalk, 69et_step(src, direction))
			L.update_icon() //so sidin69 69et updated properly

/obj/structure/catwalk/proc/test_connect(var/turf/T)
	if(locate(/obj/structure/catwalk, T))
		return TRUE
	if(T && T.is_wall)
		return TRUE
	if(istype(T, /turf/simulated/floor))
		var/turf/simulated/floor/t = T
		if(!t.floorin69.is_platin69 || istype(t.floorin69, /decl/floorin69/reinforced/platin69/hull)) //Caution stripes 69o where elevation would chan69e, e69, steppin69 down onto underplatin69 
			return TRUE

/obj/structure/catwalk/update_icon()
	var/connectdir = 0
	for(var/direction in cardinal)
		if(test_connect(69et_step(src, direction)))
			connectdir |= direction

	//Check the dia69onal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner69arker or not.
	var/dia69onalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
	//NORTHEAST
	if(connectdir & NORTH && connectdir & EAST)
		if(test_connect(69et_step(src, NORTHEAST)))
			dia69onalconnect |= 1
	//SOUTHEAST
	if(connectdir & SOUTH && connectdir & EAST)
		if(test_connect(69et_step(src, SOUTHEAST)))
			dia69onalconnect |= 2
	//NORTHWEST
	if(connectdir & NORTH && connectdir & WEST)
		if(test_connect(69et_step(src, NORTHWEST)))
			dia69onalconnect |= 4
	//SOUTHWEST
	if(connectdir & SOUTH && connectdir & WEST)
		if(test_connect(69et_step(src, SOUTHWEST)))
			dia69onalconnect |= 8

	icon_state = "catwalk69connectdir69-69dia69onalconnect69"


/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
		if(2)
			69del(src)
	return

/obj/structure/catwalk/attackby(obj/item/I,69ob/user)
	if(69UALITY_WELDIN69 in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			to_chat(user, "\blue Slicin69 lattice joints ...")
			new /obj/item/stack/rods(69et_turf(user))
			new /obj/item/stack/rods(69et_turf(user))
			new /obj/structure/lattice/(src.loc)
			69del(src)
	return


/obj/structure/catwalk/can_prevent_fall()
	return FALSE
