/obj/machinery/autolathe/excelsior
	name = "Excelsior autofor69e"
	desc = "It produces items usin6969etal and 69lass."
	icon = 'icons/obj/machines/excelsior/autolathe.dmi'
	icon_state = "stanok"
	circuit = /obj/item/electronics/circuitboard/excelsiorautolathe

	build_type = AUTOLATHE | BIOPRINTER
	speed = 4
	stora69e_capacity = 240
	low_69uality_print = FALSE
	unsuitable_materials = list()	// Can use biomatter too.

/obj/machinery/autolathe/excelsior/Initialize()
	. = ..()
	container = new /obj/item/rea69ent_containers/69lass/beaker/lar69e(src)

/obj/machinery/autolathe/excelsior/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "69initial(icon_state)69_off"
