// Operates69anoUI
/obj/item/modular_computer/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	if(!screen_on || !enabled || bsod)
		if(ui)
			ui.close()
		return 0
	if(!try_use_power(0))
		if(ui)
			ui.close()
		return 0

	// If we have an active program switch to it69ow.
	if(active_program)
		if(ui) // This is the69ain laptop screen. Since we are switching to program's UI close it for69ow.
			ui.close()
		active_program.ui_interact(user)
		return

	// We are still here, that69eans there is69o program loaded. Load the BIOS/ROM/OS/whatever you want to call it.
	// This screen simply lists available programs and user69ay select them.
	if(!hard_drive || !hard_drive.stored_files || !hard_drive.stored_files.len)
		visible_message("\The 69src69 beeps three times, it's screen displaying \"DISK ERROR\" warning.")
		return //69o HDD,69o HDD files list or69o stored files. Something is69ery broken.

	var/list/data = get_header_data()

	data69"hard_drive"69 = get_program_data(hard_drive)

	if(portable_drive)
		data69"portable_drive"69 = get_program_data(portable_drive)


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "mpc_mainscreen.tmpl", "NTOS69ain69enu", 400, 500)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// Handles user's GUI input
/obj/item/modular_computer/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"PC_exit"69)
		kill_program()
		return 1
	if(href_list69"PC_enable_component"69)
		var/obj/item/computer_hardware/H = find_hardware_by_name(href_list69"component"69)
		if(istype(H) && !H.enabled)
			H.enabled = TRUE
			H.enabled()
		. = 1
	if(href_list69"PC_disable_component"69)
		var/obj/item/computer_hardware/H = find_hardware_by_name(href_list69"component"69)
		if(istype(H) && H.enabled)
			H.enabled = FALSE
			H.disabled()
		. = 1
	if(href_list69"PC_toggle_component"69)
		var/obj/item/computer_hardware/H = find_hardware_by_name(href_list69"component"69)
		if(istype(H))
			H.enabled = !H.enabled
			if(H.enabled)
				H.enabled()
			else
				H.disabled()
		. = 1
	if(href_list69"PC_shutdown"69)
		shutdown_computer()
		return 1
	if(href_list69"PC_minimize"69)
		var/mob/user = usr
		minimize_program(user)

	if(href_list69"PC_killprogram"69)
		var/prog_name = href_list69"PC_killprogram"69
		var/obj/item/computer_hardware/hard_drive/prog_disk = locate(href_list69"disk"69) in src
		if(!prog_disk)
			return 1

		for(var/p in all_threads)
			var/datum/computer_file/program/PRG = p
			if(PRG.program_state == PROGRAM_STATE_KILLED)
				continue

			if(PRG.filename == prog_name && (PRG in prog_disk.stored_files))
				PRG.kill_program(forced=TRUE)
				to_chat(usr, SPAN_NOTICE("Program 69PRG.filename69.69PRG.filetype69 has been killed."))
				. = 1

	if(href_list69"PC_runprogram"69)
		var/obj/item/computer_hardware/hard_drive/prog_disk = locate(href_list69"disk"69) in src
		return run_program(href_list69"PC_runprogram"69, prog_disk)

	if(href_list69"PC_setautorun"69)
		if(!hard_drive)
			return
		set_autorun(href_list69"PC_setautorun"69)
	if(href_list69"PC_terminal"69)
		open_terminal(usr)
		return 1

	if(.)
		update_uis()


// Function used by69anoUI to obtain a list of programs for a given disk
/obj/item/modular_computer/proc/get_program_data(obj/item/computer_hardware/hard_drive/disk)
	var/datum/computer_file/data/autorun = disk.find_file_by_name("autorun")

	var/list/disk_data = list(
		"ref" = "\ref69disk69",
		"name" = disk.get_disk_name(),
		"autorun" = istype(autorun) ? autorun.stored_data : ""
	)

	var/list/programs = list()
	for(var/datum/computer_file/program/PRG in disk.stored_files)
		var/list/program = list(
			"name" = PRG.filename,
			"desc" = PRG.filedesc,
			"icon" = PRG.program_menu_icon,
			"running" = (PRG in all_threads)
			)
		programs.Add(list(program))
	disk_data69"programs"69 = programs

	return disk_data


// Function used by69anoUI's to obtain data for header. All relevant entries begin with "PC_"
/obj/item/modular_computer/proc/get_header_data()
	var/list/data = list()

	if(cell)
		switch(cell.percent())
			if(80 to 200) // 100 should be69aximal but just in case..
				data69"PC_batteryicon"69 = "batt_100.gif"
			if(60 to 80)
				data69"PC_batteryicon"69 = "batt_80.gif"
			if(40 to 60)
				data69"PC_batteryicon"69 = "batt_60.gif"
			if(20 to 40)
				data69"PC_batteryicon"69 = "batt_40.gif"
			if(5 to 20)
				data69"PC_batteryicon"69 = "batt_20.gif"
			else
				data69"PC_batteryicon"69 = "batt_5.gif"
		data69"PC_batterypercent"69 = "69round(cell.percent())69 %"
		data69"PC_showbatteryicon"69 = TRUE
	else
		data69"PC_batteryicon"69 = "batt_5.gif"
		data69"PC_batterypercent"69 = "N/C"
		data69"PC_showbatteryicon"69 = FALSE

	if(led)
		data69"PC_light_name"69 = led.name
		data69"PC_light_on"69 = led.enabled

	if(tesla_link && tesla_link.enabled && apc_powered)
		data69"PC_apclinkicon"69 = "charging.gif"

	if(network_card &&69etwork_card.is_banned())
		data69"PC_ntneticon"69 = "sig_warning.gif"
	else
		switch(get_ntnet_status())
			if(0)
				data69"PC_ntneticon"69 = "sig_none.gif"
			if(1)
				data69"PC_ntneticon"69 = "sig_low.gif"
			if(2)
				data69"PC_ntneticon"69 = "sig_high.gif"
			if(3)
				data69"PC_ntneticon"69 = "sig_lan.gif"

	if(gps_sensor)
		data69"has_gps"69 = TRUE
		if (gps_sensor.check_functionality())
			data69"gps_icon"69 = "satelite_on.gif"
		else
			data69"gps_icon"69 = "satelite_off.gif"
		data69"gps_data"69 = gps_sensor.get_position_text()

	var/list/program_headers = list()
	for(var/p in all_threads)
		var/datum/computer_file/program/PRG = p
		if(!PRG.ui_header)
			continue
		program_headers.Add(list(list(
			"icon" = PRG.ui_header
		)))
	data69"PC_programheaders"69 = program_headers

	data69"PC_stationtime"69 = stationtime2text()
	data69"PC_hasheader"69 = 1
	data69"PC_showexitprogram"69 = active_program ? 1 : 0 // Hides "Exit Program" button on69ainscreen
	return data