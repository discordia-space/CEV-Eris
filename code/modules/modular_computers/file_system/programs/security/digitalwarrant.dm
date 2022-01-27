LEGACY_RECORD_STRUCTURE(all_warrants, warrant)
/datum/computer_file/data/warrant/
	var/archived = FALSE

/datum/computer_file/program/digitalwarrant
	filename = "digitalwarrant"
	filedesc = "Warrant Assistant"
	extended_desc = "Official69Tsec program for creation and handling of warrants."
	size = 8
	program_icon_state = "warrant"
	program_key_state = "security_key"
	program_menu_icon = "star"
	requires_ntnet = 1
	available_on_ntnet = 1
	required_access = access_security
	nanomodule_path = /datum/nano_module/digitalwarrant/

/datum/nano_module/digitalwarrant/
	name = "Warrant Assistant"
	var/datum/computer_file/data/warrant/activewarrant

/datum/nano_module/digitalwarrant/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	if(activewarrant)
		data69"warrantname"69 = activewarrant.fields69"namewarrant"69
		data69"warrantjob"69 = activewarrant.fields69"jobwarrant"69
		data69"warrantcharges"69 = activewarrant.fields69"charges"69
		data69"warrantauth"69 = activewarrant.fields69"auth"69
		//data69"warrantidauth"69 = activewarrant.fields69"idauth"69
		data69"type"69 = activewarrant.fields69"arrestsearch"69
	else
		var/list/arrestwarrants = list()
		var/list/searchwarrants = list()
		var/list/archivedwarrants = list()
		for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
			var/charges = W.fields69"charges"69
			if(length(charges) > 50)
				charges = copytext(charges, 1, 50) + "..."
			var/warrant = list(
			"warrantname" = W.fields69"namewarrant"69,
			"charges" = charges,
			"auth" = W.fields69"auth"69,
			"id" = W.uid,
			"arrestsearch" = W.fields69"arrestsearch"69,
			"archived" = W.archived)
			if (warrant69"archived"69)
				archivedwarrants.Add(list(warrant))
			else if(warrant69"arrestsearch"69 == "arrest")
				arrestwarrants.Add(list(warrant))
			else
				searchwarrants.Add(list(warrant))
		data69"arrestwarrants"69 = arrestwarrants.len ? arrestwarrants :69ull
		data69"searchwarrants"69 = searchwarrants.len ? searchwarrants :69ull
		data69"archivedwarrants"69 = archivedwarrants.len? archivedwarrants :null

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "digitalwarrant.tmpl",69ame, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/digitalwarrant/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"sw_menu"69)
		activewarrant =69ull

	if(href_list69"editwarrant"69)
		. = 1
		for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
			if(W.uid == text2num(href_list69"editwarrant"69))
				activewarrant = W
				break

	// The following actions will only be possible if the user has an ID with security access equipped. This is in line with69odular computer framework's authentication69ethods,
	// which also use RFID scanning to allow or disallow access to some functions. Anyone can69iew warrants, editing requires ID. This also prevents situations where you show a tablet
	// to someone who is to be arrested, which allows them to change the stuff there.

	var/mob/user = usr
	if(!istype(user))
		return
	var/obj/item/card/id/I = user.GetIdCard()
	if(!istype(I) || !I.registered_name || !(access_security in I.access))
		to_chat(user, "Authentication error: Unable to locate ID with apropriate access to allow this operation.")
		return

	if(href_list69"sendtoarchive"69)
		. = 1
		for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
			if(W.uid == text2num(href_list69"sendtoarchive"69))
				W.archived = TRUE
				break

	if(href_list69"restore"69)
		. = 1
		for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
			if(W.uid == text2num(href_list69"restore"69))
				W.archived = FALSE
				break

	if(href_list69"addwarrant"69)
		. = 1
		var/datum/computer_file/data/warrant/W =69ew()
		if(CanInteract(user, GLOB.default_state))
			W.fields69"namewarrant"69 = "Unknown"
			W.fields69"jobwarrant"69 = "N/A"
			W.fields69"auth"69 = "Unauthorized"
			//W.fields69"idauth"69 = "Unauthorized"
			W.fields69"access"69 = list()
			if(href_list69"addwarrant"69 == "arrest")
				W.fields69"charges"69 = "No charges present"
				W.fields69"arrestsearch"69 = "arrest"
			if(href_list69"addwarrant"69 == "search")
				W.fields69"charges"69 = "No reason given"
				W.fields69"arrestsearch"69 = "search"
			activewarrant = W

	if(href_list69"savewarrant"69)
		. = 1
		broadcast_security_hud_message("\A 69activewarrant.fields69"arrestsearch"6969 warrant for <b>69activewarrant.fields69"namewarrant"6969</b> has been 69(activewarrant in GLOB.all_warrants) ? "edited" : "uploaded"69.",69ano_host())
		GLOB.all_warrants |= activewarrant
		activewarrant =69ull

	if(href_list69"deletewarrant"69)
		. = 1
		if(!activewarrant)
			for(var/datum/computer_file/report/crew_record/W in GLOB.all_crew_records)
				if(W.uid == text2num(href_list69"deletewarrant"69))
					activewarrant = W
					break
		GLOB.all_warrants -= activewarrant
		activewarrant =69ull

	if(href_list69"editwarrantname"69)
		. = 1
		var/namelist = list()
		for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
			namelist += "69CR.get_name()69 \6969CR.get_job()69\69"
		var/new_person = sanitize(input(usr, "Please input69ame") as69ull|anything in69amelist)
		if(CanInteract(user, GLOB.default_state))
			if (!new_person || !activewarrant)
				return
			// string trickery to extract69ame & job
			var/entry_components = splittext(new_person, " \69")
			var/name = entry_components69169
			var/job = copytext(entry_components69269, 1, length(entry_components69269))
			activewarrant.fields69"namewarrant"69 =69ame
			activewarrant.fields69"jobwarrant"69 = job

	if(href_list69"editwarrantnamecustom"69)
		. = 1
		var/new_name = sanitize(input("Please input69ame") as69ull|text)
		var/new_job = sanitize(input("Please input job") as69ull|text)
		if(CanInteract(user, GLOB.default_state))
			if (!new_name || !new_job || !activewarrant)
				return
			activewarrant.fields69"namewarrant"69 =69ew_name
			activewarrant.fields69"jobwarrant"69 =69ew_job

	if(href_list69"editwarrantnamelocation"69)
		. = 1
		var/new_name = sanitize(input("Please input69ame or location") as69ull|text)
		if(CanInteract(user, GLOB.default_state))
			if (!new_name || !activewarrant)
				return
			activewarrant.fields69"namewarrant"69 =69ew_name

	if(href_list69"editwarrantcharges"69)
		. = 1
		var/new_charges = sanitize(input("Please input charges", "Charges", activewarrant.fields69"charges"69) as69ull|text)
		if(CanInteract(user, GLOB.default_state))
			if (!new_charges || !activewarrant)
				return
			activewarrant.fields69"charges"69 =69ew_charges

	if(href_list69"editwarrantauth"69)
		. = 1
		if(!activewarrant)
			return
		activewarrant.fields69"auth"69 = "69I.registered_name69 - 69I.assignment ? I.assignment : "(Unknown)"69"

	/*if(href_list69"editwarrantidauth"69)
		. = 1
		if(!activewarrant)
			return
		// access-granting is only available for arrest warrants
		if(activewarrant.fields69"arrestsearch"69 == "search")
			return
		if(!(access_security in I.access))
			to_chat(user, "Authentication error: Unable to locate ID with appropriate access to allow this operation.")
			return
		*/

		// only works if they are in the crew records with a69alid job
		/*
		var/datum/computer_file/report/crew_record/warrant_subject
		var/datum/job/J = job_master.GetJob(activewarrant.fields69"jobwarrant"69)
		if(!J)
			to_chat(user, "Lookup error: Unable to locate specified job in access database.")
			return
		for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
			if(CR.get_name() == activewarrant.fields69"namewarrant"69 && CR.get_job() == J.title)
				warrant_subject = CR

		if(!warrant_subject)
			to_chat(user, "Lookup error: Unable to locate specified personnel in crew records.")
			return

		var/list/warrant_access = J.get_access()
		// warrants can69ever grant command access
		warrant_access.Remove(get_region_accesses(ACCESS_REGION_COMMAND))
		*/
		//activewarrant.fields69"idauth"69 = "69I.registered_name69 - 69I.assignment ? I.assignment : "(Unknown)"69"
		//activewarrant.fields69"access"69 = warrant_access

	if(href_list69"back"69)
		. = 1
		activewarrant =69ull
