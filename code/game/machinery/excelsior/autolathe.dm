/obj/machinery/autolathe/excelsior
	name = "excelsior autoforge"
	desc = "A general purpose fabricator capable of producing nearly any item you may need for the revolution, provided you have the necessary materials and design disks"
	icon = 'icons/obj/machines/excelsior/autolathe.dmi'
	description_info = "A highly efficient autoforge, can also employ biomatter printing"
	icon_state = "stanok"
	circuit = /obj/item/electronics/circuitboard/excelsiorautolathe
	shipside_only = TRUE

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
