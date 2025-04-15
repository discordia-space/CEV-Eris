//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2
	assembly_type = /obj/structure/door_assembly/multi_tile


/obj/machinery/door/airlock/multi_tile/LateInitialize()
	..() // Call /obj/machinery/door/airlock/LateInitialize()
	if(dir > 3)
		f5 = new/obj/machinery/filler_object(loc)
		f6 = new/obj/machinery/filler_object(get_step(src,EAST))
	else
		f5 = new/obj/machinery/filler_object(loc)
		f6 = new/obj/machinery/filler_object(get_step(src,NORTH))
	f5.density = FALSE
	f6.density = FALSE
	f5.set_opacity(opacity)
	f6.set_opacity(opacity)


/obj/machinery/door/airlock/multi_tile/Destroy()
	qdel(f5)
	qdel(f6)
	. = ..()


/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Door2x1glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/multi_tile/metal
	name = "Airlock"
	icon = 'icons/obj/doors/Door2x1metal.dmi'

/obj/machinery/door/airlock/multi_tile/metal/mait
	icon = 'icons/obj/doors/Door2x1_Maint.dmi'

/obj/machinery/filler_object
	name = ""
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = ""
	density = FALSE
	anchored = TRUE
