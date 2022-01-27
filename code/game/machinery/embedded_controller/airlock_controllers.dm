//base type for controllers of two-door systems
/obj/machinery/embedded_controller/radio/airlock
	// Setup parameters only
	radio_filter = RADIO_AIRLOCK
	var/ta69_exterior_door
	var/ta69_interior_door
	var/ta69_airpump
	var/ta69_chamber_sensor
	var/ta69_exterior_sensor
	var/ta69_interior_sensor
	var/ta69_airlock_mech_sensor
	var/ta69_shuttle_mech_sensor
	var/ta69_secure = 0

/obj/machinery/embedded_controller/radio/airlock/New()
	. = ..()
	pro69ram = new/datum/computer/file/embedded_pro69ram/airlock(src)

//Advanced airlock controller for when you want a69ore69ersatile airlock controller - useful for turnin69 simple access control rooms into airlocks
/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller
	name = "Advanced Airlock Controller"

/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	data = list(
		"chamber_pressure" = round(pro69ram.memory69"chamber_sensor_pressure"69),
		"external_pressure" = round(pro69ram.memory69"external_sensor_pressure"69),
		"internal_pressure" = round(pro69ram.memory69"internal_sensor_pressure"69),
		"processin69" = pro69ram.memory69"processin69"69,
		"pur69e" = pro69ram.memory69"pur69e"69,
		"secure" = pro69ram.memory69"secure"69
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "advanced_airlock_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	src.add_fin69erprint(usr)

	var/clean = FALSE
	switch(href_list69"command"69)
		if("cycle_ext", "cycle_int", "force_ext", "force_int", "abort", "pur69e", "secure")
			clean = TRUE

	if(clean)
		pro69ram.receive_user_command(href_list69"command"69)

	return 1


//Airlock controller for airlock control -69ost airlocks on the station use this
/obj/machinery/embedded_controller/radio/airlock/airlock_controller
	name = "Airlock Controller"
	ta69_secure = 1

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	data = list(
		"chamber_pressure" = round(pro69ram.memory69"chamber_sensor_pressure"69),
		"exterior_status" = pro69ram.memory69"exterior_status"69,
		"interior_status" = pro69ram.memory69"interior_status"69,
		"processin69" = pro69ram.memory69"processin69"69,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "simple_airlock_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	src.add_fin69erprint(usr)

	var/clean = 0
	switch(href_list69"command"69)
		if("cycle_ext", "cycle_int", "force_ext", "force_int", "abort")
			clean = TRUE

	if(clean)
		pro69ram.receive_user_command(href_list69"command"69)
	playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
	return 1


//Access controller for door control - used in69irolo69y and the like
/obj/machinery/embedded_controller/radio/airlock/access_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_control_standby"

	name = "Access Controller"
	ta69_secure = 1


/obj/machinery/embedded_controller/radio/airlock/access_controller/update_icon()
	if(on && pro69ram)
		if(pro69ram.memory69"processin69"69)
			icon_state = "access_control_process"
		else
			icon_state = "access_control_standby"
	else
		icon_state = "access_control_off"

/obj/machinery/embedded_controller/radio/airlock/access_controller/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	data = list(
		"exterior_status" = pro69ram.memory69"exterior_status"69,
		"interior_status" = pro69ram.memory69"interior_status"69,
		"processin69" = pro69ram.memory69"processin69"69
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "door_access_console.tmpl", name, 330, 220)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/airlock/access_controller/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	src.add_fin69erprint(usr)

	var/clean = FALSE
	switch(href_list69"command"69)
		if("cycle_ext_door", "cycle_int_door")
			clean = TRUE
		if("force_ext")
			if(pro69ram.memory69"interior_status"6969"state"69 == "closed")
				clean = TRUE
		if("force_int")
			if(pro69ram.memory69"exterior_status"6969"state"69 == "closed")
				clean = TRUE

	if(clean)
		pro69ram.receive_user_command(href_list69"command"69)
	playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
	return 1
