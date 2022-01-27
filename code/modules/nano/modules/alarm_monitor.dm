/datum/nano_module/alarm_monitor
	name = "Alarm69onitor"
	var/list_cameras = 0						// Whether or69ot to list camera references. A future goal would be to69erge this with the enginering/security camera console. Currently really only for AI-use.
	var/list/datum/alarm_handler/alarm_handlers // The particular list of alarm handlers this alarm69onitor should present to the user.
	available_to_ai = FALSE

/datum/nano_module/alarm_monitor/New()
	..()
	alarm_handlers = list()

/datum/nano_module/alarm_monitor/all
	available_to_ai = TRUE

/datum/nano_module/alarm_monitor/all/New()
	..()
	alarm_handlers = SSalarm.all_handlers

/datum/nano_module/alarm_monitor/engineering/New()
	..()
	alarm_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, power_alarm)

/datum/nano_module/alarm_monitor/security/New()
	..()
	alarm_handlers = list(camera_alarm,69otion_alarm)

/datum/nano_module/alarm_monitor/proc/register_alarm(var/object,69ar/procName)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.register_alarm(object, procName)

/datum/nano_module/alarm_monitor/proc/unregister_alarm(var/object)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.unregister_alarm(object)

/datum/nano_module/alarm_monitor/proc/all_alarms()
	var/list/all_alarms =69ew()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.alarms(get_host_z())

	return all_alarms

/datum/nano_module/alarm_monitor/proc/major_alarms()
	var/list/all_alarms =69ew()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.major_alarms(get_host_z())

	return all_alarms

//69odified69ersion of above proc that uses slightly less resources, returns 1 if there is a69ajor alarm, 0 otherwise.
/datum/nano_module/alarm_monitor/proc/has_major_alarms()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		if(AH.has_major_alarms(get_host_z()))
			return 1

	return 0

/datum/nano_module/alarm_monitor/proc/minor_alarms()
	var/list/all_alarms =69ew()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.minor_alarms(get_host_z())

	return all_alarms

/datum/nano_module/alarm_monitor/Topic(ref, href_list)
	if(..())
		return 1
	if(href_list69"switchTo"69)
		var/obj/machinery/camera/C = locate(href_list69"switchTo"69) in cameranet.cameras
		if(!C)
			return

		usr.switch_to_camera(C)
		return 1

/datum/nano_module/alarm_monitor/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/list/data = host.initial_data()

	var/categories69069
	for(var/datum/alarm_handler/AH in alarm_handlers)
		categories69++categories.len69 = list("category" = AH.category, "alarms" = list())
		for(var/datum/alarm/A in AH.major_alarms(get_host_z()))
			var/cameras69069
			var/lost_sources69069

			if(isAI(user))
				for(var/obj/machinery/camera/C in A.cameras())
					cameras69++cameras.len69 = C.nano_structure()
			for(var/datum/alarm_source/AS in A.sources)
				if(!AS.source)
					lost_sources69++lost_sources.len69 = AS.source_name

			categories69categories.len6969"alarms"69 += list(list(
					"name" = sanitize(A.alarm_name()),
					"origin_lost" = A.origin ==69ull,
					"has_cameras" = cameras.len,
					"cameras" = cameras,
					"lost_sources" = lost_sources.len ? sanitize(english_list(lost_sources,69othing_text = "", and_text = ", ")) : ""))
	data69"categories"69 = categories

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "alarm_monitor.tmpl", "Alarm69onitoring Console", 800, 800, state = state)
		if(host.update_layout()) // This is69ecessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
