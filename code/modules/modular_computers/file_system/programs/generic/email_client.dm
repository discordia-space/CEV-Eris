/datum/computer_file/program/email_client
	filename = "emailc"
	filedesc = "Email Client"
	extended_desc = "This program69ay be used to log in into your email account."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "mail-closed"
	size = 7
	requires_ntnet = 1
	available_on_ntnet = 1
	usage_flags = PROGRAM_ALL

	//Those69eeded to restore data when programm is killed
	var/stored_login = ""
	var/stored_password = ""
	var/datum/computer_file/data/email_account/current_account

	var/ringtone = TRUE

	nanomodule_path = /datum/nano_module/email_client

// Persistency. Unless you log out, or unless your password changes, this will pre-fill the login data when restarting the program
/datum/computer_file/program/email_client/kill_program(forced = FALSE)
	if(NM)
		var/datum/nano_module/email_client/NME =69M
		if(NME.current_account)
			stored_login =69ME.stored_login
			stored_password =69ME.stored_password
			NME.log_out()
		else
			stored_login = ""
			stored_password = ""
		update_email()
	. = ..()

/datum/computer_file/program/email_client/run_program()
	. = ..()

	if(NM)
		var/datum/nano_module/email_client/NME =69M
		NME.stored_login = stored_login
		NME.stored_password = stored_password
		NME.log_in()
		NME.error = ""
		NME.check_for_new_messages(1)

/datum/computer_file/program/email_client/process_tick()
	..()
	var/datum/nano_module/email_client/NME =69M
	if(!istype(NME))
		return
	NME.relayed_process(ntnet_speed)

	var/check_count =69ME.check_for_new_messages()
	if(check_count)
		ui_header = "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"

/datum/computer_file/program/email_client/Destroy()
	// Disconnect from the email account
	stored_login =  ""
	update_email()
	return ..()

/datum/computer_file/program/email_client/proc/update_email()
	if(current_account)
		current_account.connected_clients -= src
		current_account =69ull

	if(stored_login)
		var/datum/computer_file/data/email_account/account =69tnet_global.find_email_by_login(stored_login)
		if(account && !account.suspended && account.password == stored_password)
			current_account = account
			current_account.connected_clients |= src


/datum/computer_file/program/email_client/proc/mail_received(datum/computer_file/data/email_message/received_message)
	// If the client is currently running, sending69otification is handled by /datum/nano_module/email_client instead
	if(program_state != PROGRAM_STATE_KILLED)
		return

	// The app is69ot on a functioning disk,69ot in an69PC, or the69PC is69ot running
	if(!holder?.check_functionality() || !holder.holder2?.enabled)
		return

	var/mob/living/L = get(holder.holder2, /mob/living)
	if(L)
		var/open_app_link = "<a href='?src=\ref69holder.holder269;PC_runprogram=69filename69;disk=\ref69holder69'>Open Email Client</a>"
		received_message.notify_mob(L, holder.holder2, open_app_link)


/datum/nano_module/email_client/
	name = "Email Client"
	var/stored_login = ""
	var/stored_password = ""
	var/error = ""

	var/msg_title = ""
	var/msg_body = ""
	var/msg_recipient = ""
	var/datum/computer_file/msg_attachment =69ull
	var/folder = "Inbox"
	var/addressbook = FALSE
	var/new_message = FALSE

	var/last_message_count = 0	// How69any69essages were there during last check.
	var/read_message_count = 0	// How69any69essages were there when user has last accessed the UI.

	var/datum/computer_file/downloading =69ull
	var/download_progress = 0
	var/download_speed = 0

	var/datum/computer_file/data/email_account/current_account =69ull
	var/datum/computer_file/data/email_message/current_message =69ull

	//for search
	var/search = ""


/datum/nano_module/email_client/proc/mail_received(datum/computer_file/data/email_message/received_message)
	var/mob/living/L = get(nano_host(), /mob/living)
	if(L)
		received_message.notify_mob(L,69ano_host(), "<a href='?src=\ref69src69;open;reply=69received_message.uid69'>Reply</a>")
		log_and_message_admins("69usr69 received email from 69received_message.source69. \n69essage title: 69received_message.title69. \n 69received_message.stored_data69")

/datum/nano_module/email_client/Destroy()
	log_out()
	. = ..()

/datum/nano_module/email_client/proc/log_in()
	var/list/id_login

	if(istype(host, /obj/item/modular_computer))
		var/obj/item/modular_computer/computer =69ano_host()
		var/obj/item/card/id/id = computer.GetIdCard()
		if(!id && ismob(computer.loc))
			var/mob/M = computer.loc
			id =69.GetIdCard()
		if(id)
			id_login = id.associated_email_login.Copy()

	var/datum/computer_file/data/email_account/target
	for(var/datum/computer_file/data/email_account/account in69tnet_global.email_accounts)
		if(!account || !account.can_login)
			continue
		if(stored_login && stored_login == account.login)
			target = account
			break
		if(id_login && id_login69"login"69 == account.login)
			target = account
			break

	if(!target)
		error = "Invalid Login"
		return 0

	if(target.suspended)
		error = "This account has been suspended. Please contact the system administrator for assistance."
		return 0

	var/use_pass
	if(stored_password)
		use_pass = stored_password
	else if(id_login)
		use_pass = id_login69"password"69

	if(use_pass == target.password)
		current_account = target
		current_account.connected_clients |= src
		return 1
	else
		error = "Invalid Password"
		return 0

// Returns 0 if69o69ew69essages were received, 1 if there is an unread69essage but69otification has already been sent.
// and 2 if there is a69ew69essage that appeared in this tick (and therefore69otification should be sent by the program).
/datum/nano_module/email_client/proc/check_for_new_messages(var/messages_read = FALSE)
	if(!current_account)
		return 0

	var/list/allmails = current_account.all_emails()

	if(allmails.len > last_message_count)
		. = 2
	else if(allmails.len > read_message_count)
		. = 1
	else
		. = 0

	last_message_count = allmails.len
	if(messages_read)
		read_message_count = allmails.len


/datum/nano_module/email_client/proc/log_out()
	if(current_account)
		current_account.connected_clients -= src
	current_account =69ull
	downloading =69ull
	download_progress = 0
	last_message_count = 0
	read_message_count = 0

/datum/nano_module/email_client/ui_data(mob/user)
	var/list/data = host.initial_data()
	// Password has been changed by other client connected to this email account
	if(current_account)
		if(current_account.password != stored_password)
			if(!log_in())
				log_out()
				error = "Invalid Password"
		// Banned.
		else if(current_account.suspended)
			log_out()
			error = "This account has been suspended. Please contact the system administrator for assistance."
	if(error)
		data69"error"69 = error
	else if(downloading)
		data69"downloading"69 = 1
		data69"down_filename"69 = "69downloading.filename69.69downloading.filetype69"
		data69"down_progress"69 = download_progress
		data69"down_size"69 = downloading.size
		data69"down_speed"69 = download_speed

	else if(istype(current_account))
		data69"current_account"69 = current_account.login

		if(issilicon(host))
			var/mob/living/silicon/S = host
			data69"ringtone"69 = S.email_ringtone
		else if (istype(host,/obj/item/modular_computer))
			var/obj/item/modular_computer/computer =69ano_host()
			var/datum/computer_file/program/email_client/PRG = computer.active_program
			if (istype(PRG))
				data69"ringtone"69 = PRG.ringtone

		if(addressbook)
			var/list/all_accounts = list()
			for(var/datum/computer_file/data/email_account/account in69tnet_global.email_accounts)
				if(!account.can_login)
					continue
				if(!search || findtext(account.ownerName,search) || findtext(account.login,search))
					all_accounts.Add(list(list(
						"name" = account.ownerName,
						"login" = account.login
					)))
			data69"search"69 = search ? search : "Search"
			data69"addressbook"69 = 1
			data69"accounts"69 = all_accounts
		else if(new_message)
			data69"new_message"69 = 1
			data69"msg_title"69 =69sg_title
			data69"msg_body"69 = pencode2html(msg_body)
			data69"msg_recipient"69 =69sg_recipient
			if(msg_attachment)
				data69"msg_hasattachment"69 = 1
				data69"msg_attachment_filename"69 = "69msg_attachment.filename69.69msg_attachment.filetype69"
				data69"msg_attachment_size"69 =69sg_attachment.size
		else if (current_message)
			data69"cur_title"69 = current_message.title
			data69"cur_body"69 = pencode2html(current_message.stored_data)
			data69"cur_timestamp"69 = current_message.timestamp
			data69"cur_source"69 = current_message.source
			data69"cur_uid"69 = current_message.uid
			if(istype(current_message.attachment))
				data69"cur_hasattachment"69 = 1
				data69"cur_attachment_filename"69 = "69current_message.attachment.filename69.69current_message.attachment.filetype69"
				data69"cur_attachment_size"69 = current_message.attachment.size
		else
			data69"label_inbox"69 = "Inbox (69current_account.inbox.len69)"
			data69"label_outbox"69 = "Sent (69current_account.outbox.len69)"
			data69"label_spam"69 = "Spam (69current_account.spam.len69)"
			data69"label_deleted"69 = "Deleted (69current_account.deleted.len69)"
			var/list/message_source
			if(folder == "Inbox")
				message_source = current_account.inbox
			else if(folder == "Sent")
				message_source = current_account.outbox
			else if(folder == "Spam")
				message_source = current_account.spam
			else if(folder == "Deleted")
				message_source = current_account.deleted

			if(message_source)
				data69"folder"69 = folder
				var/list/all_messages = list()
				for(var/datum/computer_file/data/email_message/message in69essage_source)
					all_messages.Add(list(list(
						"title" =69essage.title,
						"body" = pencode2html(message.stored_data),
						"source" =69essage.source,
						"timestamp" =69essage.timestamp,
						"uid" =69essage.uid
					)))
				data69"messages"69 = all_messages
				data69"messagecount"69 = all_messages.len
	else
		data69"stored_login"69 = stored_login
		data69"stored_password"69 = stars(stored_password, 0)
	return data

/datum/nano_module/email_client/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "email_client.tmpl", "Email Client", 600, 450, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/email_client/proc/find_message_by_fuid(var/fuid)
	if(!istype(current_account))
		return

	// href_list works with strings, so this69akes it a bit easier for us
	if(istext(fuid))
		fuid = text2num(fuid)

	for(var/datum/computer_file/data/email_message/message in current_account.all_emails())
		if(message.uid == fuid)
			return69essage

/datum/nano_module/email_client/proc/clear_message()
	new_message = FALSE
	msg_title = ""
	msg_body = ""
	msg_recipient = ""
	msg_attachment =69ull
	current_message =69ull

/datum/nano_module/email_client/proc/relayed_process(var/netspeed)
	download_speed =69etspeed
	if(!downloading)
		return
	download_progress =69in(download_progress +69etspeed, downloading.size)
	if(download_progress >= downloading.size)
		var/obj/item/modular_computer/MC =69ano_host()
		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error uploading file. Are you using a functional and69TOSv2-compliant device?"
			downloading =69ull
			download_progress = 0
			return 1

		if(MC.hard_drive.store_file(downloading))
			error = "File successfully downloaded to local device."
		else
			error = "Error saving file: I/O Error: The hard drive69ay be full or69onfunctional."
		downloading =69ull
		download_progress = 0
	return 1


/datum/nano_module/email_client/Topic(href, href_list)
	if(..())
		return 1
	var/mob/living/user = usr

	if(href_list69"open"69)
		ui_interact()

	check_for_new_messages(1)		// Any actual interaction (button pressing) is considered as acknowledging received69essage, for the purpose of69otification icons.
	if(href_list69"login"69)
		log_in()
		return 1

	if(href_list69"logout"69)
		log_out()
		return 1

	if(href_list69"ringtone_toggle"69)
		if(issilicon(host))
			var/mob/living/silicon/S = host
			S.email_ringtone = !S.email_ringtone
		else if (istype(host,/obj/item/modular_computer))
			var/obj/item/modular_computer/computer =69ano_host()
			var/datum/computer_file/program/email_client/PRG = computer.active_program
			if (istype(PRG))
				PRG.ringtone = !PRG.ringtone
		return 1

	if(href_list69"reset"69)
		error = ""
		return 1

	if(href_list69"new_message"69)
		new_message = TRUE
		return 1

	if(href_list69"cancel"69)
		if(addressbook)
			addressbook = FALSE
		else
			clear_message()
		return 1

	if(href_list69"addressbook"69)
		addressbook = TRUE
		return 1

	if(href_list69"set_recipient"69)
		msg_recipient = sanitize(href_list69"set_recipient"69)
		addressbook = FALSE
		return 1

	if(href_list69"edit_title"69)
		var/newtitle = sanitize(input(user,"Enter title for your69essage:", "Message title",69sg_title), 100)
		if(newtitle)
			msg_title =69ewtitle
		return 1

	// This uses similar editing69echanism as the FileManager program, therefore it supports69arious paper tags and remembers formatting.
	if(href_list69"edit_body"69)
		var/oldtext = html_decode(msg_body)
		oldtext = replacetext(oldtext, "\69br\69", "\n")

		var/newtext = sanitize(replacetext(input(usr, "Enter your69essage. You69ay use69ost tags from paper formatting", "Message Editor", oldtext), "\n", "\69br\69"), 20000)
		if(newtext)
			msg_body =69ewtext
		return 1

	if(href_list69"edit_recipient"69)
		var/newrecipient = sanitize(input(user,"Enter recipient's email address:", "Recipient",69sg_recipient), 100)
		if(newrecipient)
			msg_recipient =69ewrecipient
			addressbook = 0
		return 1

	if(href_list69"close_addressbook"69)
		addressbook = 0
		return 1

	if(href_list69"edit_login"69)
		var/newlogin = sanitize(input(user,"Enter login", "Login", stored_login), 100)
		if(newlogin)
			stored_login =69ewlogin
		return 1

	if(href_list69"edit_password"69)
		var/newpass = sanitize(input(user,"Enter password", "Password"), 100)
		if(newpass)
			stored_password =69ewpass
		return 1

	if(href_list69"delete"69)
		if(!istype(current_account))
			return 1
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list69"delete"69)
		if(!istype(M))
			return 1
		if(folder == "Deleted")
			current_account.deleted.Remove(M)
			qdel(M)
		else
			current_account.deleted.Add(M)
			current_account.inbox.Remove(M)
			current_account.spam.Remove(M)
		if(current_message ==69)
			current_message =69ull
		return 1

	if(href_list69"send"69)
		if(!current_account)
			return 1
		if((msg_body == "") || (msg_recipient == ""))
			error = "Error sending69ail:69essage body is empty!"
			return 1
		if(!length(msg_title))
			msg_title = "No subject"

		var/datum/computer_file/data/email_message/message =69ew()
		message.title =69sg_title
		message.stored_data =69sg_body
		message.source = current_account.login
		message.attachment =69sg_attachment
		if(!current_account.send_mail(msg_recipient,69essage))
			error = "Error sending email: this address doesn't exist."
			return 1
		else
			error = "Email successfully sent."
			clear_message()
			return 1

	if(href_list69"set_folder"69)
		folder = href_list69"set_folder"69
		return 1

	if(href_list69"reply"69)
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list69"reply"69)
		if(!istype(M))
			return 1
		error =69ull
		new_message = TRUE
		msg_recipient =69.source
		msg_title = "Re: 69M.title69"
		var/atom/movable/AM = host
		if(istype(AM))
			if(ismob(AM.loc))
				ui_interact(AM.loc)
		return 1

	if(href_list69"view"69)
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list69"view"69)
		if(istype(M))
			current_message =69
		return 1

	if(href_list69"search"69)
		var/new_search = sanitize(input("Enter the69alue for search for.") as69ull|text)
		if(!new_search ||69ew_search == "")
			search = ""
			return 1
		search =69ew_search
		return 1

	if(href_list69"changepassword"69)
		var/oldpassword = sanitize(input(user,"Please enter your old password:", "Password Change"), 100)
		if(!oldpassword)
			return 1
		var/newpassword1 = sanitize(input(user,"Please enter your69ew password:", "Password Change"), 100)
		if(!newpassword1)
			return 1
		var/newpassword2 = sanitize(input(user,"Please re-enter your69ew password:", "Password Change"), 100)
		if(!newpassword2)
			return 1

		if(!istype(current_account))
			error = "Please log in before proceeding."
			return 1

		if(current_account.password != oldpassword)
			error = "Incorrect original password"
			return 1

		if(newpassword1 !=69ewpassword2)
			error = "The entered passwords do69ot69atch."
			return 1

		current_account.password =69ewpassword1
		stored_password =69ewpassword1
		error = "Your password has been successfully changed!"
		return 1

	// The following entries are69odular Computer framework only, and therefore won't do anything in other cases (like AI69iew)

	if(href_list69"save"69)
		// Fully dependant on69odular computers here.
		var/obj/item/modular_computer/MC =69ano_host()

		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error exporting file. Are you using a functional and69TOS-compliant device?"
			return 1

		var/filename = sanitize(input(user,"Please specify file69ame:", "Message export"), 100)
		if(!filename)
			return 1

		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list69"save"69)
		var/datum/computer_file/data/mail = istype(M) ?69.export() :69ull
		if(!istype(mail))
			return 1
		mail.filename = filename
		if(!MC.hard_drive || !MC.hard_drive.store_file(mail))
			error = "Internal I/O error when writing file, the hard drive69ay be full."
		else
			error = "Email exported successfully"
		return 1

	if(href_list69"addattachment"69)
		var/obj/item/modular_computer/MC =69ano_host()
		msg_attachment =69ull

		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error uploading file. Are you using a functional and69TOSv2-compliant device?"
			return 1

		var/list/filenames = list()
		for(var/datum/computer_file/CF in69C.hard_drive.stored_files)
			if(CF.unsendable)
				continue
			filenames.Add(CF.filename)
		var/picked_file = input(user, "Please pick a file to send as attachment (max 32GQ)") as69ull|anything in filenames

		if(!picked_file)
			return 1

		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error uploading file. Are you using a functional and69TOSv2-compliant device?"
			return 1

		for(var/datum/computer_file/CF in69C.hard_drive.stored_files)
			if(CF.unsendable)
				continue
			if(CF.filename == picked_file)
				msg_attachment = CF.clone()
				break
		if(!istype(msg_attachment))
			msg_attachment =69ull
			error = "Unknown error when uploading attachment."
			return 1

		if(msg_attachment.size > 32)
			error = "Error uploading attachment: File exceeds69aximal permitted file size of 32GQ."
			msg_attachment =69ull
		else
			error = "File 69msg_attachment.filename69.69msg_attachment.filetype69 has been successfully uploaded."
		return 1

	if(href_list69"downloadattachment"69)
		if(!current_account || !current_message || !current_message.attachment)
			return 1
		var/obj/item/modular_computer/MC =69ano_host()
		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error downloading file. Are you using a functional and69TOSv2-compliant device?"
			return 1

		downloading = current_message.attachment.clone()
		download_progress = 0
		return 1

	if(href_list69"canceldownload"69)
		downloading =69ull
		download_progress = 0
		return 1

	if(href_list69"remove_attachment"69)
		msg_attachment =69ull
		return 1