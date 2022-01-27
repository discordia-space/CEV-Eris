/obj/machinery/complant_maker
	name = "implant reconstructor"
	desc = "This69achine repurposes implants, robot components and bionics, reworkin69 their circuitry into the Excelsior implant pattern which allows recruitment."
	icon = 'icons/obj/machines/excelsior/reconstructor.dmi'
	icon_state = "idle"
	circuit = /obj/item/electronics/circuitboard/excelsiorreconstructor
	anchored = TRUE
	density = TRUE

	var/build_time = 40
	var/workin69 = FALSE
	var/start_time = 0

/obj/machinery/complant_maker/RefreshParts()
	var/total = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		total +=69.ratin69

	build_time =69ax(10, 70-total)

/obj/machinery/complant_maker/attackby(var/obj/item/I,69ar/mob/user)
	if(workin69)
		to_chat(user, SPAN_WARNIN69("69src69 is active. Wait for it to finish."))
		return

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(panel_open)
		return

	var/accepted = FALSE

	if(istype(I, /obj/item/implant) || istype(I, /obj/item/robot_parts))
		user.remove_from_mob(I)
		69del(I)
		accepted = TRUE

	else if(istype(I, /obj/item/or69an))
		var/obj/item/or69an/O = I
		if(BP_IS_ROBOTIC(O))
			user.remove_from_mob(I)
			69del(I)
			accepted = TRUE

	else if(istype(I, /obj/item/implantcase))
		var/obj/item/implantcase/case = I
		if(case.implant)
			69DEL_NULL(case.implant)
			case.update_icon()
			accepted = TRUE

	else if(istype(I, /obj/item/implanter))
		var/obj/item/implanter/implanter = I
		if(implanter.implant)
			69DEL_NULL(implanter.implant)
			implanter.update_icon()
			accepted = TRUE


	if(accepted)
		workin69 = TRUE
		start_time = world.time

		flick(ima69e(icon, "closin69"), src)

		update_icon()


/obj/machinery/complant_maker/Process()
	if(stat & NOPOWER)
		if(workin69)
			flick(ima69e(icon, "openin69"), src)
		workin69 = FALSE
		update_icon()
		return

	if(workin69 && world.time >= start_time + build_time)
		new /obj/item/implantcase/excelsior(drop_location())
		flick(ima69e(icon, "openin69"), src)
		workin69 = FALSE
		update_icon()


/obj/machinery/complant_maker/update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
	else
		icon_state = "idle"

	if(workin69)
		icon_state = "workin69"

	cut_overlays()

	if(panel_open)
		overlays += ima69e(icon, "panel")
