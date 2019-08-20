/obj/machinery/complant_maker
	name = "implant reconstructor"
	desc = "This machine repurposes implants, robot components and bionics, reworking their circuitry into the Excelsior implant pattern which allows recruitment."
	icon = 'icons/obj/machines/excelsior/reconstructor.dmi'
	icon_state = "idle"
	circuit = /obj/item/weapon/circuitboard/excelsiorreconstructor
	anchored = TRUE
	density = TRUE

	var/build_time = 40
	var/working = FALSE
	var/start_time = 0

/obj/machinery/complant_maker/RefreshParts()
	var/total = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		total += M.rating

	build_time = max(10, 70-total)

/obj/machinery/complant_maker/attackby(var/obj/item/I, var/mob/user)
	if(working)
		to_chat(user, SPAN_WARNING("[src] is active. Wait for it to finish."))

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(panel_open)
		return

	if(istype(I,/obj/item/weapon/implant) || istype(I,/obj/item/robot_parts) || istype(I,/obj/item/prosthesis))
		user.remove_from_mob(I)
		qdel(I)

		working = TRUE
		start_time = world.time

		flick(image(icon, "closing"), src)

		update_icon()


/obj/machinery/complant_maker/Process()
	if(stat & NOPOWER)
		if(working)
			flick(image(icon, "opening"), src)
		working = FALSE
		update_icon()
		return

	if(working && world.time >= start_time + build_time)
		new /obj/item/weapon/implantcase/excelsior(src.loc)
		flick(image(icon, "opening"), src)
		working = FALSE

	update_icon()


/obj/machinery/complant_maker/update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
	else
		icon_state = "idle"

	if(working)
		icon_state = "working"

	overlays.Cut()

	if(panel_open)
		overlays.Add(image(icon, "panel"))
