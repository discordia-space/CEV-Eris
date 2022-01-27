/datum/computer_file/program/card_mod
	filename = "cardmod"
	filedesc = "ID card69odification program"
	nanomodule_path = /datum/nano_module/program/card_mod
	program_icon_state = "id"
	program_key_state = "id_key"
	program_menu_icon = "key"
	extended_desc = "Program for programming crew ID cards."
	requires_ntnet = 0
	size = 8

	var/list/access_lookup = list(access_change_sec, 	//Lookup list for all the accesses that can use the ID computer.
									access_change_medbay, 
									access_change_research, 
									access_change_engineering, 
									access_change_ids, 
									access_change_nt, 
									access_change_cargo,
									access_change_club)

/datum/nano_module/program/card_mod
	name = "ID card69odification program"
	var/mod_mode = 1
	var/is_centcom = 0
	var/show_assignments = 0

/datum/nano_module/program/card_mod/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data69"src"69 = "\ref69src69"
	data69"station_name"69 = station_name()
	data69"manifest"69 = html_crew_manifest()
	data69"assignments"69 = show_assignments
	if(program && program.computer)
		data69"have_id_slot"69 = !!program.computer.card_slot
		data69"have_printer"69 = !!program.computer.printer
		data69"authenticated"69 = program.can_run(user)
		if(!program.computer.card_slot)
			mod_mode = 0 //We can't69odify IDs when there is69o card reader
	else
		data69"have_id_slot"69 = 0
		data69"have_printer"69 = 0
		data69"authenticated"69 = 0
	data69"mmode"69 =69od_mode
	data69"centcom_access"69 = is_centcom

	if(program && program.computer && program.computer.card_slot)
		var/obj/item/card/id/id_card = program.computer.card_slot.stored_card
		data69"has_id"69 = !!id_card
		data69"id_account_number"69 = id_card ? id_card.associated_account_number :69ull
		data69"id_email_login"69 = id_card ? id_card.associated_email_login69"login"69 :69ull
		data69"id_email_password"69 = id_card ? stars(id_card.associated_email_login69"password"69, 0) :69ull
		data69"id_rank"69 = id_card && id_card.assignment ? id_card.assignment : "Unassigned"
		data69"id_owner"69 = id_card && id_card.registered_name ? id_card.registered_name : "-----"
		data69"id_name"69 = id_card ? id_card.name : "-----"

	data69"command_jobs"69 = format_jobs(command_positions)
	//data69"support_jobs"69 = format_jobs(support_positions)
	data69"engineering_jobs"69 = format_jobs(engineering_positions)
	data69"medical_jobs"69 = format_jobs(medical_positions)
	data69"science_jobs"69 = format_jobs(science_positions)
	data69"security_jobs"69 = format_jobs(security_positions)
	//data69"exploration_jobs"69 = format_jobs(exploration_positions)
	data69"service_jobs"69 = format_jobs(civilian_positions)
	data69"supply_jobs"69 = format_jobs(cargo_positions)
	data69"church_jobs"69 = format_jobs(church_positions)
	//data69"civilian_jobs"69 = format_jobs(civilian_positions)
	data69"centcom_jobs"69 = format_jobs(get_all_centcom_jobs())

	data69"all_centcom_access"69 = is_centcom
	data69"regions"69 = list()

	if(program.computer.card_slot && program.computer.card_slot.stored_card)
		var/obj/item/card/id/id_card = program.computer.card_slot.stored_card
		if(is_centcom)
			var/list/all_centcom_access = list()
			for(var/access in get_all_centcom_access())
				all_centcom_access.Add(list(list(
					"desc" = replacetext(get_centcom_access_desc(access), " ", "&nbsp"),
					"ref" = access,
					"allowed" = (access in id_card.access) ? 1 : 0)))
			data69"all_centcom_access"69 = all_centcom_access
		else
			var/list/regions = list()
			for(var/i = ACCESS_REGION_MIN; i <= ACCESS_REGION_MAX; i++)
				var/list/accesses = list()
				for(var/access in get_region_accesses(i))
					if (get_access_desc(access))
						accesses.Add(list(list(
							"desc" = replacetext(get_access_desc(access), " ", "&nbsp"),
							"ref" = access,
							"allowed" = (access in id_card.access) ? 1 : 0)))

				regions.Add(list(list(
					"name" = get_region_accesses_name(i),
					"accesses" = accesses)))
			data69"regions"69 = regions

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "identification_computer.tmpl",69ame, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/card_mod/proc/format_jobs(list/jobs)
	var/obj/item/card/id/id_card = program.computer.card_slot ? program.computer.card_slot.stored_card :69ull
	var/list/formatted = list()
	for(var/job in jobs)
		formatted.Add(list(list(
			"display_name" = replacetext(job, " ", "&nbsp"),
			"target_rank" = id_card && id_card.assignment ? id_card.assignment : "Unassigned",
			"job" = job)))

	return formatted

/datum/nano_module/program/card_mod/proc/get_accesses(var/is_centcom = 0)
	return69ull


/datum/computer_file/program/card_mod/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	var/obj/item/card/id/user_id_card = user.GetIdCard()
	var/obj/item/card/id/id_card
	if (computer.card_slot)
		id_card = computer.card_slot.stored_card
	if (!user_id_card || !authorized(user_id_card))
		to_chat(user, SPAN_WARNING("Access denied"))
		return

	var/datum/nano_module/program/card_mod/module =69M
	switch(href_list69"action"69)
		if("switchm")
			if(href_list69"target"69 == "mod")
				module.mod_mode = 1
			else if (href_list69"target"69 == "manifest")
				module.mod_mode = 0
		if("togglea")
			if(module.show_assignments)
				module.show_assignments = 0
			else
				module.show_assignments = 1
		if("print")
			if(!authorized(user_id_card))
				to_chat(user, SPAN_WARNING("Access denied."))
				return
			if(computer && computer.printer) //This option should69ever be called if there is69o printer
				if(module.mod_mode)
					if(can_run(user, 1))
						var/contents = {"<h4>Access Report</h4>
									<u>Prepared By:</u> 69user_id_card.registered_name ? user_id_card.registered_name : "Unknown"69<br>
									<u>For:</u> 69id_card.registered_name ? id_card.registered_name : "Unregistered"69<br>
									<hr>
									<u>Assignment:</u> 69id_card.assignment69<br>
									<u>Account69umber:</u> #69id_card.associated_account_number69<br>
									<u>Email account:</u> 69id_card.associated_email_login69"login"6969
									<u>Email password:</u> 69stars(id_card.associated_email_login69"password"69, 0)69
									<u>Blood Type:</u> 69id_card.blood_type69<br><br>
									<u>Access:</u><br>
								"}

						var/known_access_rights = get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)
						for(var/A in id_card.access)
							if(A in known_access_rights)
								contents += "  69get_access_desc(A)69"

						if(!computer.printer.print_text(contents,"access report"))
							to_chat(user, SPAN_NOTICE("Hardware error: Printer was unable to print the file. It69ay be out of paper."))
							return
						else
							computer.visible_message(SPAN_NOTICE("\The 69computer69 prints out paper."))
				else
					var/contents = {"<h4>Crew69anifest</h4>
									<br>
									69html_crew_manifest()69
									"}
					if(!computer.printer.print_text(contents,text("crew69anifest (6969)", stationtime2text())))
						to_chat(user, SPAN_NOTICE("Hardware error: Printer was unable to print the file. It69ay be out of paper."))
						return
					else
						computer.visible_message(SPAN_NOTICE("\The 69computer69 prints out paper."))
		if("eject")
			if(computer)
				if(computer.card_slot && computer.card_slot.stored_card)
					computer.proc_eject_id(user)
				else
					computer.attackby(user.get_active_hand(), user)
		if("terminate")
			if(!authorized(user_id_card, ACCESS_REGION_COMMAND))
				to_chat(user, SPAN_WARNING("Access denied."))
				return
			if(computer && can_run(user, 1))
				id_card.assignment = "Terminated"
				remove_nt_access(id_card)
				callHook("terminate_employee", list(id_card))
		if("edit")
			if(!authorized(user_id_card))
				to_chat(user, SPAN_WARNING("Access denied."))
				return
			if(computer && can_run(user, 1))
				if(href_list69"name"69)
					var/temp_name = sanitizeName(input("Enter69ame.", "Name", id_card.registered_name),allow_numbers=TRUE)
					if(temp_name)
						id_card.registered_name = temp_name
						id_card.formal_name_suffix = initial(id_card.formal_name_suffix)
						id_card.formal_name_prefix = initial(id_card.formal_name_prefix)
					else
						computer.visible_message(SPAN_NOTICE("69computer69 buzzes rudely."))
				else if(href_list69"account"69)
					var/account_num = text2num(input("Enter account69umber.", "Account", id_card.associated_account_number))
					id_card.associated_account_number = account_num
				else if(href_list69"elogin"69)
					var/email_login = input("Enter email login.", "Email login", id_card.associated_email_login69"login"69)
					id_card.associated_email_login69"login"69 = email_login
				else if(href_list69"epswd"69)
					var/email_password = input("Enter email password.", "Email password")
					id_card.associated_email_login69"password"69 = email_password
		if("assign")
			if(!authorized(user_id_card))
				to_chat(user, SPAN_WARNING("Access denied."))
				return
			if(computer && can_run(user, 1) && id_card)
				var/t1 = href_list69"assign_target"69
				if(t1 == "Custom")
					var/temp_t = sanitize(input("Enter a custom job assignment.","Assignment", id_card.assignment), 45)
					//let custom jobs function as an impromptu alt title,69ainly for sechuds
					if(temp_t)
						id_card.assignment = temp_t
				else
					var/list/access = list()
					if(module.is_centcom)
						access = get_centcom_access(t1)
					else
						var/datum/job/jobdatum
						for(var/jobtype in typesof(/datum/job))
							var/datum/job/J =69ew jobtype
							if(ckey(J.title) == ckey(t1))
								jobdatum = J
								break
						if(!jobdatum)
							to_chat(user, SPAN_WARNING("No log exists for this job: 69t169"))
							return
						access = jobdatum.get_access()
						for(var/A in access)
							if(!check_modify(user_id_card, A))
								to_chat(user, SPAN_WARNING("Access denied"))
								return

					remove_nt_access(id_card)
					apply_access(id_card, access)
					id_card.assignment = t1
					id_card.rank = t1

				callHook("reassign_employee", list(id_card))
		if("access")
			if(href_list69"allowed"69 && computer && can_run(user, 1))
				var/access_type = text2num(href_list69"access_target"69)
				var/access_allowed = text2num(href_list69"allowed"69)
				if(access_type in get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM))
					if (check_modify(user_id_card, access_type))
						id_card.access -= access_type
						if(!access_allowed)
							id_card.access += access_type
					else
						to_chat(user, SPAN_WARNING("Access denied"))

	if(id_card)
		id_card.SetName(text("69id_card.registered_name69's ID Card (69id_card.assignment69)"))

	SSnano.update_uis(NM)
	return 1

/datum/computer_file/program/card_mod/proc/remove_nt_access(var/obj/item/card/id/id_card)
	id_card.access -= get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)

/datum/computer_file/program/card_mod/proc/apply_access(var/obj/item/card/id/id_card,69ar/list/accesses)
	id_card.access |= accesses

// Function that checks if the user's id is allowed to use the id computer. Can optionally check for a specific access lookup.
/datum/computer_file/program/card_mod/proc/authorized(var/obj/item/card/id/id_card,69ar/area)
	if (id_card && !area)
		for(var/i = 1, i <= access_lookup.len, i ++)
			if(access_lookup69i69 in id_card.access)
				return TRUE
	else if (id_card && area)
		if(access_lookup69area69 in id_card.access)
			return TRUE
	return FALSE

//New helper function to check if the type of access the user has69atches the region it's allowed to change.
/datum/computer_file/program/card_mod/proc/check_modify(var/obj/item/card/id/id_card,69ar/access_requested)
	for(var/access in id_card.access)
		var/region_type = get_access_region_by_id(access_requested)
		if(access in GLOB.maps_data.access_modify_region69region_type69)
			return TRUE
	return FALSE
