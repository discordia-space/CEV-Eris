


/obj/machinery/multistructure/bioreactor_part/loader
	name = "input"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "loader"
	var/dir_input = WEST


/obj/machinery/multistructure/bioreactor_part/loader/Process()
	if(!MS)
		return
	if(contents.len)
		for(var/object in contents)
			var/obj/machinery/multistructure/bioreactor_part/capsule/free_capsule = MS_bioreactor.get_unoccupied_capsule()
			if(free_capsule)
				free_capsule.take_obj(object)
	else
		grab()


/obj/machinery/multistructure/bioreactor_part/loader/proc/grab()
	var/atom/movable/target = locate() in loc
	if(target)
		target.forceMove(src)
	var/atom/movable/M = locate() in get_step(src, dir_input)
	if(M)
		if(isliving(M) || istype(M, /obj/item) && !M.anchored)
			spawn(1)
				M.forceMove(get_turf(src))