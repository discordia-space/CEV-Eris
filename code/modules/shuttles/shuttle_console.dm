/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "shuttle"
	circuit = null

	var/shuttle_tag  // Used to coordinate data in shuttle controller.

	var/ui_template = "shuttle_control_console.tmpl"


/obj/machinery/computer/shuttle_control/attack_hand(user as mob)
	if(..(user))
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return 1

	nano_ui_interact(user)

/obj/machinery/computer/shuttle_control/proc/get_ui_data(var/datum/shuttle/autodock/shuttle)
	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"

	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else
				shuttle_status = "Standing-by at [shuttle.current_location]."

		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to [shuttle.next_location]."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	return list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.active_docking_controller ? 1 : 0,
		"docking_status" = shuttle.active_docking_controller ? shuttle.active_docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.active_docking_controller? shuttle.active_docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force(),
	)

/obj/machinery/computer/shuttle_control/proc/handle_topic_href(var/datum/shuttle/autodock/shuttle, var/list/href_list, var/user)
	if(!istype(shuttle))
		return TOPIC_NOACTION

	if(href_list["move"])
		if(!shuttle.next_location.is_valid(shuttle))
			to_chat(user, "<span class='warning'>Destination zone is invalid or obstructed.</span>")
			return TOPIC_HANDLED
		shuttle.launch(src)
		return TOPIC_REFRESH

	if(href_list["force"])
		shuttle.force_launch(src)
		return TOPIC_REFRESH

	if(href_list["cancel"])
		shuttle.cancel_launch(src)
		return TOPIC_REFRESH

/obj/machinery/computer/shuttle_control/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles[shuttle_tag]
	if (!istype(shuttle))
		to_chat(user, "<span class='warning'>Unable to establish link with the shuttle.</span>")
		return

	var/list/data = get_ui_data(shuttle)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, ui_template, "[shuttle_tag] Shuttle Control", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/Topic(user, href_list)
	return handle_topic_href(SSshuttle.shuttles[shuttle_tag], href_list, user)

/obj/machinery/computer/shuttle_control/emag_act(var/remaining_charges, var/mob/user)
	if (!hacked)
		req_access = list()
		req_one_access = list()
		hacked = 1
		to_chat(user, "You short out the console's ID checking system. It's now available to everyone!")
		return 1

/obj/machinery/computer/shuttle_control/bullet_act(var/obj/item/projectile/Proj)
	visible_message("\The [Proj] ricochets off \the [src]!")

/obj/machinery/computer/shuttle_control/explosion_act(target_power, explosion_handler/handler)
	return 0

/obj/machinery/computer/shuttle_control/emp_act()
	return
