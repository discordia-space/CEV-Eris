/datum/computer_file/program/email_administration
	filename = "emailadmin"
	filedesc = "Email Administration Utility"
	extended_desc = "This program69ay be used to administrate69TNet's emailing service."
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "mail-open"
	size = 12
	requires_ntnet = 1
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/program/email_administration
	required_access = access_network

/datum/nano_module/program/email_administration
	name = "Email Administration"
	available_to_ai = TRUE
	var/datum/computer_file/data/email_account/current_account =69ull
	var/datum/computer_file/data/email_message/current_message =69ull
	var/error = ""

/datum/nano_module/program/email_administration/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data += "skill_fail"
	if(!user.stat_check(STAT_COG, STAT_LEVEL_BASIC))
		var/datum/extension/fake_data/fake_data = get_or_create_extension(src, /datum/extension/fake_data, /datum/extension/fake_data, 15)
		data69"skill_fail"69 = fake_data.update_and_return_data()
	data69"terminal"69 = !!program

	if(error)
		data69"error"69 = error
	else if(istype(current_message))
		data69"msg_title"69 = current_message.title
		data69"msg_body"69 = pencode2html(current_message.stored_data)
		data69"msg_timestamp"69 = current_message.timestamp
		data69"msg_source"69 = current_message.source
	else if(istype(current_account))
		data69"current_account"69 = current_account.login
		data69"cur_suspended"69 = current_account.suspended
		var/list/all_messages = list()
		for(var/datum/computer_file/data/email_message/message in (current_account.inbox | current_account.spam | current_account.deleted))
			all_messages.Add(list(list(
				"title" =69essage.title,
				"source" =69essage.source,
				"timestamp" =69essage.timestamp,
				"uid" =69essage.uid
			)))
		data69"messages"69 = all_messages
		data69"messagecount"69 = all_messages.len
	else
		var/list/all_accounts = list()
		for(var/datum/computer_file/data/email_account/account in69tnet_global.email_accounts)
			if(!account.can_login)
				continue
			all_accounts.Add(list(list(
				"login" = account.login,
				"uid" = account.uid
			)))
		data69"accounts"69 = all_accounts
		data69"accountcount"69 = all_accounts.len

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "email_administration.tmpl", "Email Administration Utility", 600, 450, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/program/email_administration/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	if(!istype(user))
		return 1

	if(!user.stat_check(STAT_COG, STAT_LEVEL_BASIC))
		return 1

	// High security - can only be operated when the user has an ID with access on them.
	var/obj/item/card/id/I = user.GetIdCard()
	if(!istype(I) || !(access_network in I.access))
		return 1

	if(href_list69"back"69)
		if(error)
			error = ""
		else if(current_message)
			current_message =69ull
		else
			current_account =69ull
		return 1

	if(href_list69"ban"69)
		if(!current_account)
			return 1

		current_account.suspended = !current_account.suspended
		ntnet_global.add_log_with_ids_check("EMAIL LOG: SA-EDIT Account 69current_account.login69 has been 69current_account.suspended ? "" : "un" 69suspended by SA 69I.registered_name69 (69I.assignment69).")
		error = "Account 69current_account.login69 has been 69current_account.suspended ? "" : "un" 69suspended."
		return 1

	if(href_list69"changepass"69)
		if(!current_account)
			return 1

		var/newpass = sanitize(input(user,"Enter69ew password for account 69current_account.login69", "Password"), 100)
		if(!newpass)
			return 1
		current_account.password =69ewpass
		ntnet_global.add_log_with_ids_check("EMAIL LOG: SA-EDIT Password for account 69current_account.login69 has been changed by SA 69I.registered_name69 (69I.assignment69).")
		return 1

	if(href_list69"viewmail"69)
		if(!current_account)
			return 1

		for(var/datum/computer_file/data/email_message/received_message in (current_account.inbox | current_account.spam | current_account.deleted))
			if(received_message.uid == text2num(href_list69"viewmail"69))
				current_message = received_message
				break
		return 1

	if(href_list69"viewaccount"69)
		for(var/datum/computer_file/data/email_account/email_account in69tnet_global.email_accounts)
			if(email_account.uid == text2num(href_list69"viewaccount"69))
				current_account = email_account
				break
		return 1

	if(href_list69"newaccount"69)
		var/newdomain = sanitize(input(user,"Pick domain:", "Domain69ame") as69ull|anything in GLOB.maps_data.usable_email_tlds)
		if(!newdomain)
			return 1
		var/newlogin = sanitize(input(user,"Pick account69ame (@69newdomain69):", "Account69ame"), 100)
		if(!newlogin)
			return 1

		var/complete_login = "69newlogin69@69newdomain69"
		if(ntnet_global.find_email_by_login(complete_login))
			error = "Error creating account: An account with same address already exists."
			return 1

		var/datum/computer_file/data/email_account/new_account =69ew/datum/computer_file/data/email_account()
		new_account.login = complete_login
		new_account.password = GenerateKey()
		error = "Email 69new_account.login69 has been created, with generated password 69new_account.password69"
		return 1
