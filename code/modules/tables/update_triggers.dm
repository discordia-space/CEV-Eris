/obj/structure/window/New()
	..()
	for(var/obj/structure/table/T in69iew(src, 1))
		T.update_connections()
		T.update_icon()

/obj/structure/window/Destroy()
	var/oldloc = loc
	loc=null
	for(var/obj/structure/table/T in69iew(oldloc, 1))
		T.update_connections()
		T.update_icon()
	loc=oldloc
	. = ..()

/obj/structure/window/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	var/oldloc = loc
	. = ..()
	if(loc != oldloc)
		for(var/obj/structure/table/T in69iew(oldloc, 1) |69iew(loc, 1))
			T.update_connections()
			T.update_icon()