//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2

/obj/machinery/door/airlock/multi_tile/get_overlay_icon()
	return icon

/obj/machinery/door/airlock/multi_tile/on_door_direction_update_trigger(from_door = FALSE)
	if(!auto_change_door_direction)
		door_flicker.dir = dir
		return
	var/turf/simulated/wall/W1 = get_step(src, SOUTH)
	var/turf/simulated/wall/W2 = get_step(src, NORTH)
	var/south_detected = istype(W1) || locate(/obj/structure/low_wall) in W1
	var/north_detected = istype(W2) || locate(/obj/structure/low_wall) in W2
	if(!south_detected)
		var/turf/simulated/wall/wall_check = get_step(W1, SOUTH)
		south_detected = istype(wall_check) || locate(/obj/structure/low_wall) in wall_check
	if(!north_detected)
		var/turf/simulated/wall/wall_check = get_step(W2, NORTH)
		north_detected = istype(wall_check) || locate(/obj/structure/low_wall) in wall_check
	if(south_detected && north_detected)
		dir = WEST
	else
		dir = NORTH
	SetBounds()
	create_fillers()

/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(EAST, WEST))
		bound_width = world.icon_size
		bound_height = width * world.icon_size
	else
		bound_width = width * world.icon_size
		bound_height = world.icon_size

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Door2x1glass.dmi'
	opacity = FALSE
	glass = TRUE
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/glass/get_overlay_icon()
	return 'icons/obj/doors/door2x1_misc.dmi'

/obj/machinery/door/airlock/multi_tile/metal
	name = "Airlock"
	icon = 'icons/obj/doors/Door2x1metal.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/proc/create_fillers()
	if(f5)
		QDEL_NULL(f5)
	if(f6)
		QDEL_NULL(f6)
	var/turf/f5_turf = get_turf(src)
	var/turf/f6_turf = get_turf(src)

	if(dir == WEST)
		if(istype(get_step(src, NORTH), /turf/simulated/wall) || locate(/obj/structure/low_wall) in get_step(src, NORTH))
			f6_turf = get_step(src, SOUTH)
		else
			f6_turf = get_step(src, NORTH)
	else
		if(istype(get_step(src, EAST), /turf/simulated/wall) || locate(/obj/structure/low_wall) in get_step(src, EAST))
			f6_turf = get_step(src, WEST)
		else
			f6_turf = get_step(src, EAST)
	f5 = new /obj/machinery/filler_object(f5_turf)
	f6 = new /obj/machinery/filler_object(f6_turf)
	f5.density = FALSE
	f6.density = FALSE
	f5.set_opacity(opacity)
	f6.set_opacity(opacity)

/obj/machinery/door/airlock/multi_tile/metal/Destroy()
	qdel(f5)
	qdel(f6)
	. = ..()

/obj/machinery/filler_object
	name = ""
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = ""
	density = FALSE
	anchored = TRUE

/obj/machinery/door/airlock/multi_tile/metal/mait
	icon = 'icons/obj/doors/Door2x1_Maint.dmi'
