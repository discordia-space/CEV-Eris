/obj/machinery/autolathe/excelsior
	name = "Excelsior autolathe"
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/machines/excelsior/autolathe.dmi'
	icon_state = "stanok"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/weapon/circuitboard/excelsiorautolathe

	storage_capacity = 150

/obj/machinery/autolathe/excelsior/New()
	..()
	container = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)

/obj/machinery/autolathe/excelsior/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "[initial(icon_state)]_off"
