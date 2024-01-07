/obj/structure/heavy_vehicle_frame
	name = "exosuit frame"
	desc = "The frame for an exosuit."
	icon = MECH_PARTS_ICON
	icon_state = "backbone"
	density = TRUE
	pixel_x = -8

	// Holders for the final product.
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body
	var/is_wired = NONE
	var/is_reinforced = NONE
	var/set_name
	dir = SOUTH
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 10, MATERIAL_PLASTEEL = 5)

	var/material/material = null

// Return reinforcement material too, if any.
/obj/structure/heavy_vehicle_frame/get_matter()
	var/list/matter = ..()
	. = matter.Copy()

	if(material)
		LAZYAPLUS(., material.name, 10)

/obj/structure/heavy_vehicle_frame/proc/set_colour(var/new_colour)
	var/painted_component = FALSE
	for(var/obj/item/mech_component/comp in list(body, arms, legs, head))
		if(comp.set_colour(new_colour))
			painted_component = TRUE
	if(painted_component)
		update_icon()

/obj/structure/heavy_vehicle_frame/Destroy()
	QDEL_NULL(arms)
	QDEL_NULL(legs)
	QDEL_NULL(head)
	QDEL_NULL(body)
	. = ..()

/obj/structure/heavy_vehicle_frame/examine(var/mob/user)
	. = ..()
	if(!arms)
		to_chat(user, SPAN_WARNING("It is missing manipulators."))
	if(!legs)
		to_chat(user, SPAN_WARNING("It is missing propulsion."))
	if(!head)
		to_chat(user, SPAN_WARNING("It is missing sensors."))
	if(!body)
		to_chat(user, SPAN_WARNING("It is missing a chassis."))
	if(is_wired == FRAME_WIRED)
		to_chat(user, SPAN_WARNING("It has not had its wiring adjusted."))
	else if(!is_wired)
		to_chat(user, SPAN_WARNING("It has not yet been wired."))
	if(is_reinforced == FRAME_REINFORCED)
		to_chat(user, SPAN_WARNING("It has not had its internal reinforcement secured."))
	else if(is_reinforced == FRAME_REINFORCED_SECURE)
		to_chat(user, SPAN_WARNING("It has not had its internal reinforcement welded in."))
	else if(!is_reinforced)
		to_chat(user, SPAN_WARNING("It does not have any internal reinforcement."))

/obj/structure/heavy_vehicle_frame/update_icon()
	. = ..()
	var/list/new_overlays = get_mech_images(list(legs, head, body, arms), layer)
	if(body)
		density = TRUE
		overlays += get_mech_image(null, "[body.icon_state]_cockpit", body.icon, body.color)
		if(body.pilot_coverage < 100 || body.transparent_cabin)
			new_overlays += get_mech_image(null, "[body.icon_state]_open_overlay", body.icon, body.color)
	else
		density = FALSE
	overlays = new_overlays
	if(density != opacity)
		set_opacity(density)

/obj/structure/heavy_vehicle_frame/set_dir()
	..(SOUTH)

/obj/structure/heavy_vehicle_frame/attackby(obj/item/I, mob/living/user)

	var/list/usable_qualities = list()
	if(!is_reinforced && !is_wired && !arms && !legs && !head && !body)
		usable_qualities += QUALITY_BOLT_TURNING

	else if(is_reinforced == FRAME_REINFORCED || is_reinforced == FRAME_REINFORCED_SECURE)
		usable_qualities += QUALITY_BOLT_TURNING

	if(is_reinforced == FRAME_REINFORCED_SECURE || is_reinforced == FRAME_REINFORCED_WELDED)
		usable_qualities += QUALITY_WELDING

	if(!istype(I, /obj/item/mech_component/manipulators))
		if((is_reinforced == FRAME_REINFORCED || arms || legs || head || body))
			usable_qualities += QUALITY_PRYING

	if(is_wired)
		usable_qualities += QUALITY_WIRE_CUTTING

	if(is_wired == FRAME_WIRED_ADJUSTED && is_reinforced == FRAME_REINFORCED_WELDED && legs && body)
		usable_qualities += QUALITY_SCREW_DRIVING

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		// Securing/unsecuring reinforcements, dismantling the frame
		if(QUALITY_BOLT_TURNING)
			if(!is_reinforced && !is_wired && !arms && !legs && !head && !body)
				visible_message("\The [user] begins dismantling \the [src].")

				if(!I.use_tool(user, src, WORKTIME_LONG, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					return

				if(is_reinforced || is_wired || arms || legs || head || body)
					return

				visible_message("\The [user] dismantles \the [src].")

				drop_materials(drop_location())
				qdel(src)
				return


			if(!is_reinforced)
				to_chat(user, SPAN_WARNING("There are no reinforcements inside \the [src]."))
				return
			if(is_reinforced == FRAME_REINFORCED_WELDED)
				to_chat(user, SPAN_WARNING("\The [src]'s internal reinforcments has been welded in."))
				return

			visible_message("\The [user] begins adjusting the reinforcements inside \the [src].")
			if(!I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				return

			if(!is_reinforced || is_reinforced == FRAME_REINFORCED_WELDED)
				return

			visible_message("\The [user] [is_reinforced == FRAME_REINFORCED_SECURE ? "unsecures" : "secures"] the reinforcements inside \the [src].")
			is_reinforced = (is_reinforced == FRAME_REINFORCED_SECURE) ? FRAME_REINFORCED : FRAME_REINFORCED_SECURE
			return

		// Welding/unwelding reinforcements
		if(QUALITY_WELDING)
			if(!is_reinforced)
				to_chat(user, SPAN_WARNING("There are no reinforcements to secure inside \the [src]."))
				return
			if(is_reinforced == FRAME_REINFORCED)
				to_chat(user, SPAN_WARNING("The reinforcements inside \the [src] has not been secured."))
				return

			visible_message("\The [user] begins welding the reinforcements inside \the [src].")

			if(!I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				return

			if(!is_reinforced || is_reinforced == FRAME_REINFORCED)
				return

			visible_message("\The [user] [is_reinforced == FRAME_REINFORCED_WELDED ? "unwelds the reinforcements from" : "welds the reinforcements into"] \the [src].")
			is_reinforced = (is_reinforced == FRAME_REINFORCED_WELDED) ? FRAME_REINFORCED_SECURE : FRAME_REINFORCED_WELDED
			return

		// Removing reinforcements or components
		if(QUALITY_PRYING)
			// Removing reinforcements
			if(is_reinforced == FRAME_REINFORCED)
				user.visible_message(SPAN_NOTICE("\The [user] starts prying the reinforcements off \the [src]."))
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC) && is_reinforced == FRAME_REINFORCED)
					user.visible_message(SPAN_NOTICE("\The [user] pries the reinforcements off \the [src]."))
					material.place_sheet(drop_location(), 10)
					material = null
					is_reinforced = NONE
				return

			// Removing components
			if(!arms && !body && !legs && !head)
				to_chat(user, SPAN_WARNING("There are no components to remove."))
				return

			var/to_remove = input("Which component would you like to remove") as null|anything in list(arms, body, legs, head)
			if(!to_remove || !(to_remove in list(arms, body, legs, head)))
				return

			if(!I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				return

			if(!(to_remove in list(arms, body, legs, head)))
				return

			if(uninstall_component(to_remove, user))
				if(to_remove == arms)
					arms = null
				else if(to_remove == body)
					body = null
				else if(to_remove == legs)
					legs = null
				else if(to_remove == head)
					head = null

			update_icon()
			return

		// Adjusting or removing wiring
		if(QUALITY_WIRE_CUTTING)
			if(!is_wired)
				to_chat(user, "There is no wiring in \the [src] to neaten.")
				return

			user.visible_message("\The [user] begins [is_wired == FRAME_WIRED_ADJUSTED ? "removing" : "adjusting"] the wiring inside \the [src]...")

			if(!I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				return

			if(!is_wired)
				return

			visible_message("\The [user] [is_wired == FRAME_WIRED_ADJUSTED ? "removes" : "adjusts"] the wiring in \the [src].")
			if(is_wired == FRAME_WIRED)
				is_wired = FRAME_WIRED_ADJUSTED
			else
				is_wired = NONE
				new /obj/item/stack/cable_coil(drop_location(), 10)
			return

		// Final construction step
		if(QUALITY_SCREW_DRIVING)
			// Check for basic components.
			if(!(legs && body))
				to_chat(user,  SPAN_WARNING("There are still parts missing from \the [src]."))
				return

			// Check for wiring.
			if(is_wired < FRAME_WIRED_ADJUSTED)
				if(is_wired == FRAME_WIRED)
					to_chat(user, SPAN_WARNING("\The [src]'s wiring has not been adjusted!"))
				else
					to_chat(user, SPAN_WARNING("\The [src] is not wired!"))
				return

			// Check for basing metal internal plating.
			if(is_reinforced < FRAME_REINFORCED_WELDED)
				if(is_reinforced == FRAME_REINFORCED)
					to_chat(user, SPAN_WARNING("\The [src]'s internal reinforcement has not been secured!"))
				else if(is_reinforced == FRAME_REINFORCED_SECURE)
					to_chat(user, SPAN_WARNING("\The [src]'s internal reinforcement has not been welded down!"))
				else
					to_chat(user, SPAN_WARNING("\The [src] has no internal reinforcement!"))
				return

			visible_message(SPAN_NOTICE("\The [user] begins tightening screws, flipping connectors and finishing off \the [src]."))
			if(!I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_ZERO))
				return

			if(is_reinforced < FRAME_REINFORCED_WELDED || is_wired < FRAME_WIRED_ADJUSTED || !(legs && body))
				return

			// We're all done. Finalize the exosuit and pass the frame to the new system.
			var/mob/living/exosuit/M = new(get_turf(src), src)
			visible_message(SPAN_NOTICE("\The [user] finishes off \the [M]."))
			playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

			arms = null
			legs = null
			head = null
			body = null
			qdel(src)
			return

		if(ABORT_CHECK)
			return


	// Installing wiring.
	if(isCoil(I))
		if(is_wired)
			to_chat(user, SPAN_WARNING("\The [src] has already been wired."))
			return

		var/obj/item/stack/cable_coil/CC = I
		if(CC.get_amount() < 10)
			to_chat(user, SPAN_WARNING("You need at least ten units of cable to complete the exosuit."))
			return

		user.visible_message("\The [user] begins wiring \the [src]...")

		if(!do_after(user, 30))
			return

		if(!CC || !user || is_wired || !CC.use(10))
			return

		user.visible_message("\The [user] installs wiring in \the [src].")
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		is_wired = FRAME_WIRED

	// Installing reinforcements
	else if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/M = I
		if(M.material)
			if(is_reinforced)
				to_chat(user, SPAN_WARNING("There are already reinforcements installed in \the [src]."))
				return
			if(M.get_amount() < 10)
				to_chat(user, SPAN_WARNING("You need at least ten sheets to reinforce \the [src]."))
				return

			visible_message("\The [user] begins layering the interior of the \the [src] with \the [M].")

			if(!do_after(user, 30) || is_reinforced || !M.use(10))
				return

			visible_message("\The [user] reinforces \the [src] with \the [M].")
			playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			material = M.material
			is_reinforced = FRAME_REINFORCED
		else
			return ..()

	// Installing basic components.
	if(istype(I, /obj/item/mech_component/manipulators))
		if(istype(body, /obj/item/mech_component/chassis/forklift))
			to_chat(user, SPAN_WARNING("\The [src]'s chassis can not support manipulators!"))
			return
		if(arms)
			to_chat(user, SPAN_WARNING("\The [src] already has manipulators installed."))
			return
		if(install_component(I, user))
			if(arms)
				user.unEquip(I, loc)
				return
			arms = I
	else if(istype(I, /obj/item/mech_component/propulsion))
		if(legs)
			to_chat(user, SPAN_WARNING("\The [src] already has a propulsion system installed."))
			return
		if(istype(body, /obj/item/mech_component/chassis/forklift) && !istype(I, /obj/item/mech_component/propulsion/wheels))
			to_chat(user, SPAN_WARNING("\The [src]'s chassis can not support this type of propulsation, only wheels!"))
			return
		if(install_component(I, user))
			if(legs)
				user.unEquip(I, loc)
				return
			legs = I
	else if(istype(I, /obj/item/mech_component/sensors))
		if(istype(body, /obj/item/mech_component/chassis/forklift))
			to_chat(user, SPAN_WARNING("\The [src]'s chassis can not support sensors!"))
			return
		if(head)
			to_chat(user, SPAN_WARNING("\The [src] already has a sensor array installed."))
			return
		if(install_component(I, user))
			if(head)
				user.unEquip(I, loc)
				return
			head = I
	else if(istype(I, /obj/item/mech_component/chassis))
		if(body)
			to_chat(user, SPAN_WARNING("\The [src] already has an outer chassis installed."))
			return
		if(install_component(I, user))
			if(body)
				user.unEquip(I, loc)
				return
			body = I
	else
		return ..()
	update_icon()

/obj/structure/heavy_vehicle_frame/proc/install_component(obj/item/I, mob/living/user)
	var/obj/item/mech_component/MC = I
	if(istype(MC) && !MC.ready_to_install())
		to_chat(user, SPAN_WARNING("\The [MC] [MC.gender == PLURAL ? "are" : "is"] not ready to install."))
		return 0
	if(user)
		visible_message(SPAN_NOTICE("\The [user] begins installing \the [I] into \the [src]."))
		if(!user.canUnEquip(I) || !do_after(user, 30) || user.get_active_hand() != I)
			return
		if(!user.unEquip(I))
			return
	I.forceMove(src)
	if(istype(MC, /obj/item/mech_component/chassis/forklift))
		if(arms)
			arms.forceMove(get_turf(src))
			arms = null
		if(head)
			head.forceMove(get_turf(src))
			head = null
		if(legs && !istype(legs, /obj/item/mech_component/propulsion/wheels))
			legs.forceMove(get_turf(src))
			legs = null
	visible_message(SPAN_NOTICE("\The [user] installs \the [I] into \the [src]."))
	playsound(user.loc, 'sound/machines/click.ogg', 50, 1)
	return 1

/obj/structure/heavy_vehicle_frame/proc/uninstall_component(obj/item/I, mob/living/user)
	if(!istype(I) || (I.loc != src) || !istype(user))
		return FALSE
	if(!do_after(user, 40) || I.loc != src)
		return FALSE
	user.visible_message(SPAN_NOTICE("\The [user] crowbars \the [I] off \the [src]."))
	I.forceMove(get_turf(src))
	user.put_in_hands(I)
	playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	return TRUE
