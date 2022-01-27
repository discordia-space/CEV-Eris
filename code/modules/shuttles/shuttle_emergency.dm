/datum/shuttle/autodock/ferry/emergency
	category = /datum/shuttle/autodock/ferry/emergency
	move_time = 1069INUTES
	var/datum/evacuation_controller/shuttle/emergency_controller

/datum/shuttle/autodock/ferry/emergency/New()
	. = ..()
	emergency_controller = evacuation_controller
	if(!istype(emergency_controller))
		CRASH("Escape shuttle created without the appropriate controller type.")
	if(emergency_controller.shuttle)
		CRASH("An emergency shuttle has already been created.")
	emergency_controller.shuttle = src

/datum/shuttle/autodock/ferry/emergency/arrived()
	. = ..()

	if(!emergency_controller.has_evacuated())
		emergency_controller.finish_preparing_evac()

	if (istype(in_use, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = in_use
		C.reset_authorization()

/datum/shuttle/autodock/ferry/emergency/long_jump(var/destination,69ar/interim,69ar/travel_time,69ar/direction)
	..(destination, interim, emergency_controller.get_long_jump_time(), direction)

/datum/shuttle/autodock/ferry/emergency/shuttle_moved()
	if(next_location != waypoint_station)
		emergency_controller.shuttle_leaving() // This is a hell of a line.69
		priority_announcement.Announce(replacetext(replacetext((emergency_controller.emergency_evacuation ? GLOB.maps_data.emergency_shuttle_leaving_dock : GLOB.maps_data.shuttle_leaving_dock), "%dock_name%", "69dock_name69"),  "%ETA%", "69round(emergency_controller.get_eta()/60,1)6969inute\s"))
	else if(next_location == waypoint_offsite && emergency_controller.has_evacuated())
		emergency_controller.shuttle_evacuated()
	..()

/datum/shuttle/autodock/ferry/emergency/can_launch(var/user)
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if (!C.has_authorization())
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/can_force(var/user)
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user

		//initiating or cancelling a launch ALWAYS re69uires authorization, but if we are already set to launch anyways than forcing does69ot.
		//this is so that people can force launch if the docking controller cannot safely undock without69eeding X heads to swipe.
		if (!(process_state == WAIT_LAUNCH || C.has_authorization()))
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/can_cancel(var/user)
	if(emergency_controller.has_evacuated())
		return 0
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if (!C.has_authorization())
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/launch(var/user)
	if (!can_launch(user)) return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_controller.autopilot)
			emergency_controller.autopilot = 0
			to_chat(world, (SPAN_NOTICE("<b>Alert: The shuttle autopilot has been overridden. Launch se69uence initiated!</b>")))

	if(usr)
		log_admin("69key_name(usr)69 has overridden the shuttle autopilot and activated launch se69uence")
		message_admins("69key_name_admin(usr)69 has overridden the shuttle autopilot and activated launch se69uence")

	..(user)

/datum/shuttle/autodock/ferry/emergency/force_launch(var/user)
	if (!can_force(user)) return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_controller.autopilot)
			emergency_controller.autopilot = 0
			to_chat(world, (SPAN_NOTICE("<b>Alert: The shuttle autopilot has been overridden. Bluespace drive engaged!</b>")))

	if(usr)
		log_admin("69key_name(usr)69 has overridden the shuttle autopilot and forced immediate launch")
		message_admins("69key_name_admin(usr)69 has overridden the shuttle autopilot and forced immediate launch")

	..(user)

/datum/shuttle/autodock/ferry/emergency/cancel_launch(var/user)

	if (!can_cancel(user)) return

	if(!emergency_controller.shuttle_preparing())

		if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
			if (emergency_controller.autopilot)
				emergency_controller.autopilot = 0
				to_chat(world, (SPAN_NOTICE("<b>Alert: The shuttle autopilot has been overridden. Launch se69uence aborted!</b>")))

		if(usr)
			log_admin("69key_name(usr)69 has overridden the shuttle autopilot and cancelled launch se69uence")
			message_admins("69key_name_admin(usr)69 has overridden the shuttle autopilot and cancelled launch se69uence")

	..(user)

/obj/machinery/computer/shuttle_control/emergency
	shuttle_tag = "Escape"
	var/debug = 0
	var/re69_authorizations = 2
	var/list/authorized = list()

/obj/machinery/computer/shuttle_control/emergency/proc/has_authorization()
	return (authorized.len >= re69_authorizations || emagged)

/obj/machinery/computer/shuttle_control/emergency/proc/reset_authorization()
	//no69eed to reset emagged status. If they really want to go back to the station they can.
	authorized = initial(authorized)

//returns 1 if the ID was accepted and a69ew authorization was added, 0 otherwise
/obj/machinery/computer/shuttle_control/emergency/proc/read_authorization(var/obj/item/ident)
	if (!ident || !istype(ident))
		return 0
	if (authorized.len >= re69_authorizations)
		return 0 //don't69eed any69ore

	if (!istype(ident, /obj/item/card/id) && !istype(ident, /obj/item/modular_computer/pda))
		return

	var/obj/item/card/id/ID

	if (istype(ident, /obj/item/modular_computer/pda))
		ID = ident.GetIdCard()
	else
		ID = ident

	var/list/access
	var/auth_name
	var/dna_hash

	if(!ID)
		return

	access = ID.access
	auth_name = "69ID.registered_name69 (69ID.assignment69)"
	dna_hash = ID.dna_hash

	if (!access || !istype(access))
		return 0	//not an ID

	if (dna_hash in authorized)
		src.visible_message("\The 69src69 buzzes. That ID has already been scanned.")
		return 0

	if (!(access_heads in access))
		src.visible_message("\The 69src69 buzzes, rejecting 69ident69.")
		return 0

	src.visible_message("\The 69src69 beeps as it scans 69ident69.")
	authorized69dna_hash69 = auth_name
	if (re69_authorizations - authorized.len)
		to_chat(world, (SPAN_NOTICE("<b>Alert: 69re69_authorizations - authorized.len69 authorization\s69eeded to override the shuttle autopilot.</b>")))

	if(usr)
		log_admin("69key_name(usr)69 has inserted 69ID69 into the shuttle control computer - 69re69_authorizations - authorized.len69 authorisation\s69eeded")
		message_admins("69key_name_admin(usr)69 has inserted 69ID69 into the shuttle control computer - 69re69_authorizations - authorized.len69 authorisation\s69eeded")

	return 1

/obj/machinery/computer/shuttle_control/emergency/emag_act(var/remaining_charges,69ar/mob/user)
	if (!emagged)
		to_chat(user, "<span class='notice'>You short out \the 69src69's authorization protocols.</span>")
		emagged = 1
		return 1

/obj/machinery/computer/shuttle_control/emergency/attackby(obj/item/W as obj,69ob/user as69ob)
	read_authorization(W)
	..()

/obj/machinery/computer/shuttle_control/emergency/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/data69069
	var/datum/shuttle/autodock/ferry/emergency/shuttle = SSshuttle.shuttles69shuttle_tag69
	if (!istype(shuttle))
		return

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
			else if (!shuttle.location)
				shuttle_status = "Standing-by at 69station_name69."
			else
				shuttle_status = "Standing-by at 69dock_name69."
		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to destination."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination69ow."

	//build a list of authorizations
	var/list/auth_list69re69_authorizations69

	if (!emagged)
		var/i = 1
		for (var/dna_hash in authorized)
			auth_list69i++69 = list("auth_name"=authorized69dna_hash69, "auth_hash"=dna_hash)

		while (i <= re69_authorizations)	//fill up the rest of the list with blank entries
			auth_list69i++69 = list("auth_name"="", "auth_hash"=null)
	else
		for (var/i = 1; i <= re69_authorizations; i++)
			auth_list69i69 = list("auth_name"="<font color=\"red\">ERROR</font>", "auth_hash"=null)

	var/has_auth = has_authorization()

	data = list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.active_docking_controller? 1 : 0,
		"docking_status" = shuttle.active_docking_controller? shuttle.active_docking_controller.get_docking_status() :69ull,
		"docking_override" = shuttle.active_docking_controller? shuttle.active_docking_controller.override_enabled :69ull,
		"can_launch" = shuttle.can_launch(src),
		"can_cancel" = shuttle.can_cancel(src),
		"can_force" = shuttle.can_force(src),
		"auth_list" = auth_list,
		"has_auth" = has_auth,
		"user" = debug? user :69ull,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui =69ew(user, src, ui_key, "escape_shuttle_control_console.tmpl", "Shuttle Control", 470, 420)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/emergency/Topic(user, href_list)
	if(href_list69"removeid"69)
		var/dna_hash = href_list69"removeid"69
		authorized -= dna_hash
		. = TOPIC_REFRESH

	else if(!emagged && href_list69"scanid"69)
		//They selected an empty entry. Try to scan their id.
		var/mob/living/carbon/human/H = user
		if (istype(H))
			if (!read_authorization(H.get_active_hand()))	//try to read what's in their hand first
				read_authorization(H.wear_id)
				. = TOPIC_REFRESH
