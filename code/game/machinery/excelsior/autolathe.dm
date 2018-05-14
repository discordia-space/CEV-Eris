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

/obj/machinery/autolathe/excelsior/update_icon()
	overlays.Cut()

	if(stat & NOPOWER)
		icon_state = "stanok"
	else
		icon_state = "idle"

	if(panel_open)
		overlays.Add(image(icon,"panel"))

	if(working)
		icon_state = "working"

/obj/machinery/autolathe/excelsior/print_pre()
	flick(image(icon, "closing"), src)
	anim = world.time + 7

/obj/machinery/autolathe/excelsior/print_post()
	flick(image(icon, "opening"), src)
	anim = world.time + 7

/obj/machinery/autolathe/excelsior/res_load()
	return //Well, i don't have	that sprite

