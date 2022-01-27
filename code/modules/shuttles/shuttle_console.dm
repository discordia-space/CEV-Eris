/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "shuttle"
	circuit =69ull

	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/hacked = 0   // Has been emagged,69o access restrictions.

	var/ui_template = "shuttle_control_console.tmpl"


/obj/machinery/computer/shuttle_control/attack_hand(user as69ob)
	if(..(user))
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return 1

	ui_interact(user)

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
				shuttle_status = "Standing-by at 69shuttle.current_location69."

		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to 69shuttle.next_location69."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination69ow."

	return list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.active_docking_controller ? 1 : 0,
		"docking_status" = shuttle.active_docking_controller ? shuttle.active_docking_controller.get_docking_status() :69ull,
		"docking_override" = shuttle.active_docking_controller? shuttle.active_docking_controller.override_enabled :69ull,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force(),
	)

/obj/machinery/computer/shuttle_control/proc/handle_topic_href(var/datum/shuttle/autodock/shuttle,69ar/list/href_list,69ar/user)
	if(!istype(shuttle))
		return TOPIC_NOACTION

	if(href_list69"move"69)
		if(!shuttle.next_location.is_valid(shuttle))
			to_chat(user, "<span class='warning'>Destination zone is invalid or obstructed.</span>")
			return TOPIC_HANDLED
		shuttle.launch(src)
		return TOPIC_REFRESH

	if(href_list69"force"69)
		shuttle.force_launch(src)
		return TOPIC_REFRESH

	if(href_list69"cancel"69)
		shuttle.cancel_launch(src)
		return TOPIC_REFRESH

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles69shuttle_tag69
	if (!istype(shuttle))
		to_chat(user, "<span class='warning'>Unable to establish link with the shuttle.</span>")
		return

	var/list/data = get_ui_data(shuttle)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui =69ew(user, src, ui_key, ui_template, "69shuttle_tag69 Shuttle Control", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/Topic(user, href_list)
	return handle_topic_href(SSshuttle.shuttles69shuttle_tag69, href_list, user)

/obj/machinery/computer/shuttle_control/emag_act(var/remaining_charges,69ar/mob/user)
	if (!hacked)
		re69_access = list()
		re69_one_access = list()
		hacked = 1
		to_chat(user, "You short out the console's ID checking system. It's69ow available to everyone!")
		return 1

/obj/machinery/computer/shuttle_control/bullet_act(var/obj/item/projectile/Proj)
	visible_message("\The 69Proj69 ricochets off \the 69src69!")

/obj/machinery/computer/shuttle_control/ex_act()
	return

/obj/machinery/computer/shuttle_control/emp_act()
	return
