//Bioreactor loader
//This part will take little objects (items) and put it into the chamber
//Useful, if you work with conveyor or just want to put things in process


/obj/machinery/multistructure/bioreactor_part/loader
	name = "bioreactor input"
	icon_state = "loader"
	idle_power_usage = 120
	active_power_usage = 300
	pixel_x = -8
	layer = LOW_OBJ_LAYER
	var/dir_input = WEST
	var/dir_output = NORTH

/obj/machinery/multistructure/bioreactor_part/loader/Initialize()
	. = ..()
	set_light(1, 1, COLOR_LIGHTING_BLUE_MACHINERY)


/obj/machinery/multistructure/bioreactor_part/loader/Destroy()
	if(contents.len)
		for(var/obj/object_inside_me in contents)
			object_inside_me.forceMove(get_turf(src))
	return ..()


/obj/machinery/multistructure/bioreactor_part/loader/Process()
	if(!MS || !MS_bioreactor.is_operational() || !MS_bioreactor.chamber_solution)
		use_power(1)
		return
	use_power(2)
	if(contents.len)
		for(var/atom/movable/A in contents)
			var/obj/machinery/multistructure/bioreactor_part/platform/empty_platform = MS_bioreactor.get_unoccupied_platform()
			if(empty_platform)
				A.forceMove(get_step(src, dir_output))
	else
		grab()


/obj/machinery/multistructure/bioreactor_part/loader/proc/grab()
	var/turf/T = get_step(src, dir_input)
	for(var/atom/movable/A in T)
		if(!A.anchored && contents.len <= 10)
			if(isliving(A))
				var/mob/living/L = A
				if(L.stat != DEAD || ishuman(L))
					continue
			A.forceMove(loc)
			spawn(1)
				A.forceMove(src)
				flick("loader_take", src)
			break
