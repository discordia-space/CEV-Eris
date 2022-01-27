/datum/nano_module/power_monitor
	name = "Power69onitor"
	var/list/grid_sensors
	var/active_sensor =69ull	//name_tag of the currently selected sensor

/datum/nano_module/power_monitor/New()
	..()
	refresh_sensors()

// Checks whether there is an active alarm, if yes, returns 1, otherwise returns 0.
/datum/nano_module/power_monitor/proc/has_alarm()
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		if(S.check_grid_warning())
			return 1
	return 0

// If PC is69ot69ull header template is loaded. Use PC.get_header_data() to get relevant69anoui data from it. All data entries begin with "PC_...."
// In future it69ay be expanded to other69odular computer devices.
/datum/nano_module/power_monitor/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	var/list/sensors = list()
	// Focus: If it remains69ull if69o sensor is selected and UI will display sensor list, otherwise it will display sensor reading.
	var/obj/machinery/power/sensor/focus =69ull

	// Build list of data from sensor readings.
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		sensors.Add(list(list(
		"name" = S.name_tag,
		"alarm" = S.check_grid_warning()
		)))
		if(S.name_tag == active_sensor)
			focus = S

	data69"all_sensors"69 = sensors
	if(focus)
		data69"focus"69 = focus.return_reading_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "power_monitor.tmpl", "Power69onitoring Console", 800, 500, state = state)
		if(host.update_layout()) // This is69ecessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// Refreshes list of active sensors kept on this computer.
/datum/nano_module/power_monitor/proc/refresh_sensors()
	grid_sensors = list()
	var/turf/T = get_turf(nano_host())
	if(!T) // Safety check
		return
	for(var/obj/machinery/power/sensor/S in SSmachines.machinery)
		if((T && S.loc.z == T.z) || (S.long_range)) // Consoles have range on their Z-Level. Sensors with long_range69ar will work between Z levels.
			if(S.name_tag == "#UNKN#") // Default69ame. Shouldn't happen!
				warning("Powernet sensor with unset ID Tag! 69S.x69X 69S.y69Y 69S.z69Z")
			else
				grid_sensors += S

// Allows us to process UI clicks, which are relayed in form of hrefs.
/datum/nano_module/power_monitor/Topic(href, href_list)
	if(..())
		return 1
	if( href_list69"clear"69 )
		active_sensor =69ull
	if( href_list69"refresh"69 )
		refresh_sensors()
	else if( href_list69"setsensor"69 )
		active_sensor = href_list69"setsensor"69
