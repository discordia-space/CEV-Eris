/obj/structure/catwalk
	layer = TURF_LAYER + 0.5
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	desc = "Cats really don't like these things."
	density = 0
	anchored = 1.0

	New()
		..()
		set_light(1.5)
		spawn(4)
			if(src)
				for(var/obj/structure/catwalk/C in get_turf(src))
					if(C != src)
						qdel(C)
				update_icon()
				for (var/dir in list(1,2,4,8,5,6,9,10))
					if(locate(/obj/structure/catwalk, get_step(src, dir)))
						var/obj/structure/catwalk/L = locate(/obj/structure/catwalk, get_step(src, dir))
						L.update_icon() //so siding get updated properly
	proc
		is_catwalk()
			return 1




/obj/structure/catwalk/update_icon()
	var/connectdir = 0
	for(var/direction in cardinal)
		if(locate(/obj/structure/catwalk, get_step(src, direction)))
			connectdir |= direction
	//if(locate(/obj/structure/catwalk) in get_step(src, dir))
    //istype(get_step(src,direction),/turf/simulated/floor)
	//istype((locate(/obj/structure/catwalk) in get_step(src, dir)), /obj/structure/catwalk)

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
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			user << "\blue Slicing lattice joints ..."
			new /obj/item/stack/rods(src.loc)
			new /obj/item/stack/rods(src.loc)
			new /obj/structure/lattice/(src.loc)
			qdel(src)
	return