/obj/machinery/autolathe/excelsior
	name = "Excelsior autoforge"
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/machines/excelsior/autolathe.dmi'
	description_info = "A highly efficient autoforge, can also employ biomatter printing"
	icon_state = "stanok"
	circuit = /obj/item/electronics/circuitboard/excelsiorautolathe

	build_type = AUTOLATHE | BIOPRINTER
	speed = 4
	storage_capacity = 240
	low_quality_print = FALSE
	unsuitable_materials = list()	// Can use biomatter too.

/obj/machinery/autolathe/excelsior/Initialize()
	. = ..()
	container = new /obj/item/reagent_containers/glass/beaker/large(src)

/obj/machinery/autolathe/excelsior/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "[initial(icon_state)]_off"
