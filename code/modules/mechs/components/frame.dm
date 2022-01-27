/obj/structure/heavy_vehicle_frame
	name = "exosuit frame"
	desc = "The frame for an exosuit."
	icon =69ECH_PARTS_ICON
	icon_state = "backbone"
	density = TRUE
	pixel_x = -8

	// Holders for the final product.
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body
	var/is_wired =69ONE
	var/is_reinforced =69ONE
	var/set_name
	dir = SOUTH
	matter = list(MATERIAL_STEEL = 20,69ATERIAL_PLASTIC = 10,69ATERIAL_PLASTEEL = 5)

	var/material/material =69ull

// Return reinforcement69aterial too, if any.
/obj/structure/heavy_vehicle_frame/get_matter()
	var/list/matter = ..()
	. =69atter.Copy()

	if(material)
		LAZYAPLUS(.,69aterial.name, 10)

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
		to_chat(user, SPAN_WARNING("It is69issing69anipulators."))
	if(!legs)
		to_chat(user, SPAN_WARNING("It is69issing propulsion."))
	if(!head)
		to_chat(user, SPAN_WARNING("It is69issing sensors."))
	if(!body)
		to_chat(user, SPAN_WARNING("It is69issing a chassis."))
	if(is_wired == FRAME_WIRED)
		to_chat(user, SPAN_WARNING("It has69ot had its wiring adjusted."))
	else if(!is_wired)
		to_chat(user, SPAN_WARNING("It has69ot yet been wired."))
	if(is_reinforced == FRAME_REINFORCED)
		to_chat(user, SPAN_WARNING("It has69ot had its internal reinforcement secured."))
	else if(is_reinforced == FRAME_REINFORCED_SECURE)
		to_chat(user, SPAN_WARNING("It has69ot had its internal reinforcement welded in."))
	else if(!is_reinforced)
		to_chat(user, SPAN_WARNING("It does69ot have any internal reinforcement."))

/obj/structure/heavy_vehicle_frame/update_icon()
	. = ..()
	var/list/new_overlays = get_mech_images(list(legs, head, body, arms), layer)
	if(body)
		density = TRUE
		overlays += get_mech_image(null, "69body.icon_state69_cockpit", body.icon, body.color)
		if(body.pilot_coverage < 100 || body.transparent_cabin)
			new_overlays += get_mech_image(null, "69body.icon_state69_open_overlay", body.icon, body.color)
	else
		density = FALSE
	overlays =69ew_overlays
	if(density != opacity)
		set_opacity(density)

/obj/structure/heavy_vehicle_frame/set_dir()
	..(SOUTH)

/obj/structure/heavy_vehicle_frame/attackby(obj/item/I,69ob/living/user)

	var/list/usable_qualities = list()
	if(!is_reinforced && !is_wired && !arms && !legs && !head && !body)
		usable_qualities += QUALITY_BOLT_TURNING

	else if(is_reinforced == FRAME_REINFORCED || is_reinforced == FRAME_REINFORCED_SECURE)
		usable_qualities += QUALITY_BOLT_TURNING

	if(is_reinforced == FRAME_REINFORCED_SECURE || is_reinforced == FRAME_REINFORCED_WELDED)
		usable_qualities += QUALITY_WELDING

	if(is_reinforced == FRAME_REINFORCED || arms || legs || head || body)
		usable_qualities += QUALITY_PRYING

	if(is_wired)
		usable_qualities += QUALITY_WIRE_CUTTING

	if(is_wired == FRAME_WIRED_ADJUSTED && is_reinforced == FRAME_REINFORCED_WELDED && arms && legs && head && body)
		usable_qualities += QUALITY_SCREW_DRIVING

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		// Securing/unsecuring reinforcements, dismantling the frame
		if(QUALITY_BOLT_TURNING)
			if(!is_reinforced && !is_wired && !arms && !legs && !head && !body)
				visible_message("\The 69user69 begins dismantling \the 69src69.")

				if(!I.use_tool(user, src, WORKTIME_LONG, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					return

				if(is_reinforced || is_wired || arms || legs || head || body)
					return

				visible_message("\The 69user69 dismantles \the 69src69.")

				drop_materials(drop_location())
				qdel(src)
				return


			if(!is_reinforced)
				to_chat(user, SPAN_WARNING("There are69o reinforcements inside \the 69src69."))
				return
			if(is_reinforced == FRAME_REINFORCED_WELDED)
				to_chat(user, SPAN_WARNING("\The 69src69's internal reinforcments has been welded in."))
				return

			visible_message("\The 69user69 begins adjusting the reinforcements inside \the 69src69.")
			if(!I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				return

			if(!is_reinforced || is_reinforced == FRAME_REINFORCED_WELDED)
				return

			visible_message("\The 69user69 69is_reinforced == FRAME_REINFORCED_SECURE ? "unsecures" : "secures"69 the reinforcements inside \the 69src69.")
			is_reinforced = (is_reinforced == FRAME_REINFORCED_SECURE) ? FRAME_REINFORCED : FRAME_REINFORCED_SECURE
			return

		// Welding/unwelding reinforcements
		if(QUALITY_WELDING)
			if(!is_reinforced)
				to_chat(user, SPAN_WARNING("There are69o reinforcements to secure inside \the 69src69."))
				return
			if(is_reinforced == FRAME_REINFORCED)
				to_chat(user, SPAN_WARNING("The reinforcements inside \the 69src69 has69ot been secured."))
				return

			visible_message("\The 69user69 begins welding the reinforcements inside \the 69src69.")

			if(!I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				return

			if(!is_reinforced || is_reinforced == FRAME_REINFORCED)
				return

			visible_message("\The 69user69 69is_reinforced == FRAME_REINFORCED_WELDED ? "unwelds the reinforcements from" : "welds the reinforcements into"69 \the 69src69.")
			is_reinforced = (is_reinforced == FRAME_REINFORCED_WELDED) ? FRAME_REINFORCED_SECURE : FRAME_REINFORCED_WELDED
			return

		// Removing reinforcements or components
		if(QUALITY_PRYING)
			// Removing reinforcements
			if(is_reinforced == FRAME_REINFORCED)
				user.visible_message(SPAN_NOTICE("\The 69user69 starts prying the reinforcements off \the 69src69."))
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC) && is_reinforced == FRAME_REINFORCED)
					user.visible_message(SPAN_NOTICE("\The 69user69 pries the reinforcements off \the 69src69."))
					material.place_sheet(drop_location(), 10)
					material =69ull
					is_reinforced =69ONE
				return

			// Removing components
			if(!arms && !body && !legs && !head)
				to_chat(user, SPAN_WARNING("There are69o components to remove."))
				return

			var/to_remove = input("Which component would you like to remove") as69ull|anything in list(arms, body, legs, head)
			if(!to_remove || !(to_remove in list(arms, body, legs, head)))
				return

			if(!I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				return

			if(!(to_remove in list(arms, body, legs, head)))
				return

			if(uninstall_component(to_remove, user))
				if(to_remove == arms)
					arms =69ull
				else if(to_remove == body)
					body =69ull
				else if(to_remove == legs)
					legs =69ull
				else if(to_remove == head)
					head =69ull

			update_icon()
			return

		// Adjusting or removing wiring
		if(QUALITY_WIRE_CUTTING)
			if(!is_wired)
				to_chat(user, "There is69o wiring in \the 69src69 to69eaten.")
				return

			user.visible_message("\The 69user69 begins 69is_wired == FRAME_WIRED_ADJUSTED ? "removing" : "adjusting"69 the wiring inside \the 69src69...")

			if(!I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				return

			if(!is_wired)
				return

			visible_message("\The 69user69 69is_wired == FRAME_WIRED_ADJUSTED ? "removes" : "adjusts"69 the wiring in \the 69src69.")
			if(is_wired == FRAME_WIRED)
				is_wired = FRAME_WIRED_ADJUSTED
			else
				is_wired =69ONE
				new /obj/item/stack/cable_coil(drop_location(), 10)
			return

		// Final construction step
		if(QUALITY_SCREW_DRIVING)
			// Check for basic components.
			if(!(arms && legs && head && body))
				to_chat(user,  SPAN_WARNING("There are still parts69issing from \the 69src69."))
				return

			// Check for wiring.
			if(is_wired < FRAME_WIRED_ADJUSTED)
				if(is_wired == FRAME_WIRED)
					to_chat(user, SPAN_WARNING("\The 69src69's wiring has69ot been adjusted!"))
				else
					to_chat(user, SPAN_WARNING("\The 69src69 is69ot wired!"))
				return

			// Check for basing69etal internal plating.
			if(is_reinforced < FRAME_REINFORCED_WELDED)
				if(is_reinforced == FRAME_REINFORCED)
					to_chat(user, SPAN_WARNING("\The 69src69's internal reinforcement has69ot been secured!"))
				else if(is_reinforced == FRAME_REINFORCED_SECURE)
					to_chat(user, SPAN_WARNING("\The 69src69's internal reinforcement has69ot been welded down!"))
				else
					to_chat(user, SPAN_WARNING("\The 69src69 has69o internal reinforcement!"))
				return

			visible_message(SPAN_NOTICE("\The 69user69 begins tightening screws, flipping connectors and finishing off \the 69src69."))
			if(!I.use_tool(user, src, WORKTIME_INSTANT, tool_type, FAILCHANCE_ZERO))
				return

			if(is_reinforced < FRAME_REINFORCED_WELDED || is_wired < FRAME_WIRED_ADJUSTED || !(arms && legs && head && body))
				return

			// We're all done. Finalize the exosuit and pass the frame to the69ew system.
			var/mob/living/exosuit/M =69ew(get_turf(src), src)
			visible_message(SPAN_NOTICE("\The 69user69 finishes off \the 69M69."))
			playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

			arms =69ull
			legs =69ull
			head =69ull
			body =69ull
			qdel(src)
			return

		if(ABORT_CHECK)
			return


	// Installing wiring.
	if(isCoil(I))
		if(is_wired)
			to_chat(user, SPAN_WARNING("\The 69src69 has already been wired."))
			return

		var/obj/item/stack/cable_coil/CC = I
		if(CC.get_amount() < 10)
			to_chat(user, SPAN_WARNING("You69eed at least ten units of cable to complete the exosuit."))
			return

		user.visible_message("\The 69user69 begins wiring \the 69src69...")

		if(!do_after(user, 30))
			return

		if(!CC || !user || is_wired || !CC.use(10))
			return

		user.visible_message("\The 69user69 installs wiring in \the 69src69.")
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		is_wired = FRAME_WIRED

	// Installing reinforcements
	else if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/M = I
		if(M.material)
			if(is_reinforced)
				to_chat(user, SPAN_WARNING("There are already reinforcements installed in \the 69src69."))
				return
			if(M.get_amount() < 10)
				to_chat(user, SPAN_WARNING("You69eed at least ten sheets to reinforce \the 69src69."))
				return

			visible_message("\The 69user69 begins layering the interior of the \the 69src69 with \the 69M69.")

			if(!do_after(user, 30) || is_reinforced || !M.use(10))
				return

			visible_message("\The 69user69 reinforces \the 69src69 with \the 69M69.")
			playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			material =69.material
			is_reinforced = FRAME_REINFORCED
		else
			return ..()

	// Installing basic components.
	if(istype(I, /obj/item/mech_component/manipulators))
		if(arms)
			to_chat(user, SPAN_WARNING("\The 69src69 already has69anipulators installed."))
			return
		if(install_component(I, user))
			if(arms)
				user.unEquip(I, loc)
				return
			arms = I
	else if(istype(I, /obj/item/mech_component/propulsion))
		if(legs)
			to_chat(user, SPAN_WARNING("\The 69src69 already has a propulsion system installed."))
			return
		if(install_component(I, user))
			if(legs)
				user.unEquip(I, loc)
				return
			legs = I
	else if(istype(I, /obj/item/mech_component/sensors))
		if(head)
			to_chat(user, SPAN_WARNING("\The 69src69 already has a sensor array installed."))
			return
		if(install_component(I, user))
			if(head)
				user.unEquip(I, loc)
				return
			head = I
	else if(istype(I, /obj/item/mech_component/chassis))
		if(body)
			to_chat(user, SPAN_WARNING("\The 69src69 already has an outer chassis installed."))
			return
		if(install_component(I, user))
			if(body)
				user.unEquip(I, loc)
				return
			body = I
	else
		return ..()
	update_icon()

/obj/structure/heavy_vehicle_frame/proc/install_component(obj/item/I,69ob/living/user)
	var/obj/item/mech_component/MC = I
	if(istype(MC) && !MC.ready_to_install())
		to_chat(user, SPAN_WARNING("\The 69MC69 69MC.gender == PLURAL ? "are" : "is"6969ot ready to install."))
		return 0
	if(user)
		visible_message(SPAN_NOTICE("\The 69user69 begins installing \the 69I69 into \the 69src69."))
		if(!user.canUnEquip(I) || !do_after(user, 30) || user.get_active_hand() != I)
			return
		if(!user.unEquip(I))
			return
	I.forceMove(src)
	visible_message(SPAN_NOTICE("\The 69user69 installs \the 69I69 into \the 69src69."))
	playsound(user.loc, 'sound/machines/click.ogg', 50, 1)
	return 1

/obj/structure/heavy_vehicle_frame/proc/uninstall_component(obj/item/I,69ob/living/user)
	if(!istype(I) || (I.loc != src) || !istype(user))
		return FALSE
	if(!do_after(user, 40) || I.loc != src)
		return FALSE
	user.visible_message(SPAN_NOTICE("\The 69user69 crowbars \the 69I69 off \the 69src69."))
	I.forceMove(get_turf(src))
	user.put_in_hands(I)
	playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	return TRUE
