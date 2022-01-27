/datum/computer_file/program/atmos_control
	filename = "atmoscontrol"
	filedesc = "Atmosphere Control"
	nanomodule_path = /datum/nano_module/atmos_control
	program_icon_state = "atmos_control"
	program_key_state = "atmos_key"
	program_menu_icon = "shuffle"
	extended_desc = "This program allows remote control of air alarms. This program can69ot be run on tablet computers."
	required_access = access_atmospherics
	requires_ntnet = 1
	network_destination = "atmospheric control system"
	requires_ntnet_feature =69TNET_SYSTEMCONTROL
	usage_flags = PROGRAM_LAPTOP | PROGRAM_CONSOLE
	size = 17

/datum/nano_module/atmos_control
	name = "Atmospherics Control"
	var/obj/access =69ew()
	var/emagged = 0
	var/ui_ref
	var/list/monitored_alarms = list()

/datum/nano_module/atmos_control/New(atmos_computer,69ar/list/req_access,69ar/list/req_one_access,69onitored_alarm_ids)
	..()

	if(istype(req_access))
		access.req_access = req_access
	else if(req_access)
		log_debug("\The 69src69 was given an unepxected req_access: 69req_access69")

	if(istype(req_one_access))
		access.req_one_access = req_one_access
	else if(req_one_access)
		log_debug("\The 69src69 given an unepxected req_one_access: 69req_one_access69")

	if(monitored_alarm_ids)
		for(var/obj/machinery/alarm/alarm in GLOB.alarm_list)
			if(alarm.alarm_id && (alarm.alarm_id in69onitored_alarm_ids))
				monitored_alarms += alarm
		//69achines69ay69ot yet be ordered at this point
		monitored_alarms = dd_sortedObjectList(monitored_alarms)

/datum/nano_module/atmos_control/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"alarm"69)
		if(ui_ref)
			var/obj/machinery/alarm/alarm = locate(href_list69"alarm"69) in (monitored_alarms.len ?69onitored_alarms : GLOB.alarm_list)
			if(alarm)
				var/datum/topic_state/TS = generate_state(alarm)
				alarm.ui_interact(usr,69aster_ui = ui_ref, state = TS)
		return 1

/datum/nano_module/atmos_control/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/master_ui =69ull,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/alarms69069

	// TODO:69ove these to a cache, similar to cameras
	for(var/obj/machinery/alarm/alarm in (monitored_alarms.len ?69onitored_alarms : GLOB.alarm_list))
		alarms69++alarms.len69 = list("name" = sanitize(alarm.name), "ref"= "\ref69alarm69", "danger" =69ax(alarm.danger_level, alarm.alarm_area.atmosalm))
	data69"alarms"69 = alarms

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui =69ew(user, src, ui_key, "atmos_control.tmpl", src.name, 625, 625, state = state)
		if(host.update_layout()) // This is69ecessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
	ui_ref = ui

/datum/nano_module/atmos_control/proc/generate_state(air_alarm)
	var/datum/topic_state/air_alarm/state =69ew()
	state.atmos_control = src
	state.air_alarm = air_alarm
	return state

/datum/topic_state/air_alarm
	var/datum/nano_module/atmos_control/atmos_control	=69ull
	var/obj/machinery/alarm/air_alarm					=69ull

/datum/topic_state/air_alarm/can_use_topic(var/src_object,69ar/mob/user)
	if(has_access(user))
		return STATUS_INTERACTIVE
	return STATUS_UPDATE

/datum/topic_state/air_alarm/href_list(var/mob/user)
	var/list/extra_href = list()
	extra_href69"remote_connection"69 = 1
	extra_href69"remote_access"69 = has_access(user)

	return extra_href

/datum/topic_state/air_alarm/proc/has_access(var/mob/user)
	return user && (isAI(user) || atmos_control.access.allowed(user) || atmos_control.emagged || air_alarm.rcon_setting == RCON_YES || (air_alarm.alarm_area.atmosalm && air_alarm.rcon_setting == RCON_AUTO))
