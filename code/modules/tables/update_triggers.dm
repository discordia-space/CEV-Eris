/obj/structure/window/New()
	..()
	for(var/obj/structure/table/T in view(src, 1))
		T.update_connections()
		T.update_icon()

/obj/structure/window/Destroy()
	var/oldloc = loc
	loc=null
	for(var/obj/structure/table/T in view(oldloc, 1))
		T.update_connections()
		T.update_icon()
	loc=oldloc
	. = ..()

/obj/structure/window/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0, initiator = src)
	var/oldloc = loc
	. = ..()
	if(loc != oldloc)
		for(var/obj/structure/table/T in view(oldloc, 1) | view(loc, 1))
			T.update_connections()
			T.update_icon()
