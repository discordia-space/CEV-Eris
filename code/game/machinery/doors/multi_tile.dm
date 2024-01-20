//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2

/obj/machinery/door/airlock/multi_tile/New()
	..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0, initiator = src)
	. = ..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Door2x1glass.dmi'
	opacity = FALSE
	glass = TRUE
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/metal
	name = "Airlock"
	icon = 'icons/obj/doors/Door2x1metal.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/New()
	..()
	if(src.dir > 3)
		f5 = new/obj/machinery/filler_object(src.loc)
		f6 = new/obj/machinery/filler_object(get_step(src,EAST))
	else
		f5 = new/obj/machinery/filler_object(src.loc)
		f6 = new/obj/machinery/filler_object(get_step(src,NORTH))
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
