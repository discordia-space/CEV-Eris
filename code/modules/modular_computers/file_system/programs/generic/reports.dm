#define REPORTS_VIEW      1
#define REPORTS_DOWNLOAD  2

/datum/computer_file/program/reports
	filename = "repview"
	filedesc = "Report Editor"
	nanomodule_path = /datum/nano_module/program/reports
	extended_desc = "A general paperwork69iewing and editing utility."
	size = 6
	available_on_ntnet = TRUE
	requires_ntnet = 0
	usage_flags = PROGRAM_ALL

/datum/nano_module/program/reports
	name = "Report Editor"
	var/can_view_only = 0                              //Whether we are in69iew-only69ode.
	var/datum/computer_file/report/selected_report     //A report being69iewed/edited. This is a temporary copy.
	var/datum/computer_file/report/saved_report        //The computer file open.
	var/prog_state = REPORTS_VIEW

/datum/nano_module/program/reports/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = host.initial_data()
	data69"prog_state"69 = prog_state
	switch(prog_state)
		if(REPORTS_VIEW)
			if(selected_report)
				data69"report_data"69 = selected_report.generate_nano_data(get_access(user))
			data69"view_only"69 = can_view_only
			data69"printer"69 = program.computer.printer
		if(REPORTS_DOWNLOAD)
			var/list/L = list()
			for(var/datum/computer_file/report/report in69tnet_global.fetch_reports(get_access(user)))
				var/M = list()
				M69"name"69 = report.display_name()
				M69"uid"69 = report.uid
				L += list(M)
			data69"reports"69 = L

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "reports.tmpl",69ame, 700, 800, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/reports/proc/switch_state(new_state)
	if(prog_state ==69ew_state)
		return
	switch(new_state)
		if(REPORTS_VIEW)
			program.requires_ntnet_feature =69ull
			program.requires_ntnet = 0
			prog_state = REPORTS_VIEW
		if(REPORTS_DOWNLOAD)
			close_report()
			program.requires_ntnet_feature =69TNET_SOFTWAREDOWNLOAD
			program.requires_ntnet = 1
			prog_state = REPORTS_DOWNLOAD

/datum/nano_module/program/reports/proc/close_report()
	QDEL_NULL(selected_report)
	saved_report =69ull

/datum/nano_module/program/reports/proc/save_report(mob/user, save_as)
	if(!program.computer || !program.computer.hard_drive)
		to_chat(user, "Unable to find hard drive.")
		return
	selected_report.rename_file()
	if(!save_as)
		program.computer.hard_drive.remove_file(saved_report)
	if(!program.computer.hard_drive.try_store_file(selected_report))
		to_chat(user, "Error storing file. Please check your hard drive.")
		program.computer.hard_drive.store_file(saved_report) //Does69othing if already saved.
		return
	program.computer.hard_drive.store_file(selected_report)
	if(!save_as)
		qdel(saved_report)
	saved_report = selected_report
	selected_report = saved_report.clone()
	to_chat(user, "The report has been saved as 69saved_report.filename69.69saved_report.filetype69")

/datum/nano_module/program/reports/proc/load_report(mob/user)
	if(!program.computer || !program.computer.hard_drive)
		to_chat(user, "Unable to find hard drive.")
		return
	var/choices = list()
	for(var/datum/computer_file/report/R in program.computer.hard_drive.stored_files)
		choices69"69R.filename69.69R.filetype69"69 = R
	var/choice = input(user, "Which report would you like to load?", "Loading Report") as69ull|anything in choices
	if(choice in choices)
		var/datum/computer_file/report/chosen_report = choices69choice69
		var/editing = alert(user, "Would you like to69iew or edit the report", "Loading Report", "View", "Edit")
		if(editing == "View")
			if(!chosen_report.verify_access(get_access(user)))
				to_chat(user, "<span class='warning'>You lack access to69iew this report.</span>")
				return
			can_view_only = 1
		else
			if(!chosen_report.verify_access_edit(get_access(user)))
				to_chat(user, "<span class='warning'>You lack access to edit this report.</span>")
				return
			can_view_only = 0
		saved_report = chosen_report
		selected_report = chosen_report.clone()
		return 1

/datum/nano_module/program/reports/Topic(href, href_list)
	if(..())
		return 1
	var/mob/user = usr

	if(text2num(href_list69"warning"69)) //Gives the user a chance to avoid losing unsaved reports.
		if(alert(user, "Are you sure you want to leave this page? Unsubmitted data will be lost.",, "Yes", "No") == "No")
			return 1 //If yes, proceed to the actual action instead.

	if(href_list69"load"69)
		if(selected_report || saved_report)
			close_report()
		load_report(user)
		return 1
	if(href_list69"save"69)
		if(!selected_report)
			return 1
		if(!selected_report.verify_access(get_access(user)))
			return 1
		var/save_as = text2num(href_list69"save_as"69)
		save_report(user, save_as)
	if(href_list69"submit"69)
		if(!selected_report)
			return 1
		if(!selected_report.verify_access_edit(get_access(user)))
			return 1
		if(selected_report.submit(user))
			to_chat(user, "The 69src69 has been submitted.")
			if(alert(user, "Would you like to save a copy?","Save Report", "Yes", "No") == "Yes")
				save_report(user)
		return 1
	if(href_list69"discard"69)
		if(!selected_report)
			return 1
		close_report()
		return 1
	if(href_list69"edit"69)
		if(!selected_report)
			return 1
		var/field_ID = text2num(href_list69"ID"69)
		var/datum/report_field/field = selected_report.field_from_ID(field_ID)
		if(!field || !field.verify_access_edit(get_access(user)))
			return 1
		field.ask_value(user) //Handles the remaining IO.
		return 1
	if(href_list69"print"69)
		if(!selected_report || !program.computer || !program.computer.printer)
			return 1
		if(!selected_report.verify_access(get_access(user)))
			return 1
		var/with_fields = text2num(href_list69"print_mode"69)
		var/text = selected_report.generate_pencode(get_access(user), with_fields)
		if(!program.computer.printer.print_text(text, selected_report.display_name()))
			to_chat(user, "Hardware error: Printer was unable to print the file. It69ay be out of paper.")
		return 1
	if(href_list69"export"69)
		if(!selected_report || !program.computer || !program.computer.hard_drive)
			return 1
		if(!selected_report.verify_access(get_access(user)))
			return 1
		var/datum/computer_file/data/text/file =69ew
		selected_report.rename_file()
		file.stored_data = selected_report.generate_pencode(get_access(user),69o_html = 1) //TXT files can't have html; they use pencode only.
		file.filename = selected_report.filename
		to_chat(user, (program.computer.hard_drive.store_file(file) ? "The report has been exported as 69file.filename69.69file.filetype69" : "Error storing file. Please check your hard drive."))
		return 1

	if(href_list69"download"69)
		switch_state(REPORTS_DOWNLOAD)
		return 1
	if(href_list69"get_report"69)
		var/uid = text2num(href_list69"report"69)
		for(var/datum/computer_file/report/report in69tnet_global.fetch_reports(get_access(user)))
			if(report.uid == uid)
				selected_report = report.clone()
				can_view_only = 0
				switch_state(REPORTS_VIEW)
				return 1
		to_chat(user, "Network error: Selected report could69ot be downloaded. Check69etwork functionality and credentials.")
		return 1
	if(href_list69"home"69)
		switch_state(REPORTS_VIEW)
		return 1

#undef REPORTS_VIEW
#undef REPORTS_DOWNLOAD