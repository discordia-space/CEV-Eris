/obj/machinery/autolathe/excelsior
	name = "Excelsior autolathe"
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/machines/excelsior/autolathe.dmi'
	icon_state = "stanok"
	circuit = /obj/item/weapon/circuitboard/excelsiorautolathe

	build_type = AUTOLATHE | BIOPRINTER
	speed = 4
	storage_capacity = 240
	unsuitable_materials = list()	// Can use biomatter too.

/obj/machinery/autolathe/excelsior/Initialize()
	. = ..()
	container = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)

/obj/machinery/autolathe/excelsior/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "[initial(icon_state)]_off"
