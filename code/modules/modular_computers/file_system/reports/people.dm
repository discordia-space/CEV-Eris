//Field with people in it; has some communications procs available to it.
/datum/report_field/people/proc/send_email(mob/user)
	if(!get_value())
		return //No one to send to anyway.
	var/subject = sanitize(input(user, "Email Subject:", "Document Email", "Report Submission: 69owner.display_name()69") as69ull|text)
	var/body = sanitize(replacetext(input(user, "Email Body:", "Document Email", "Please see the attached document.") as69ull|message, "\n", "\69br\69"),69AX_PAPER_MESSAGE_LEN)
	var/attach_report = (alert(user, "Do you wish to attach 69owner.display_name()69?","Document Email", "Yes", "No") == "Yes") ? 1 : 0
	if(alert(user, "Are you sure you want to send this email?","Document Email", "Yes", "No") == "No")
		return
	if(perform_send(subject, body, attach_report))
		to_chat(user, "<span class='notice'>The email has been sent.</span>")

//Helper procs.
/datum/report_field/people/proc/perform_send(subject, body, attach_report)
	return

/datum/report_field/people/proc/send_to_recipient(subject, body, attach_report, recipient)
	var/datum/computer_file/data/email_account/server =69tnet_global.find_email_by_login(EMAIL_DOCUMENTS)
	var/datum/computer_file/data/email_message/message =69ew()
	message.title = subject
	message.stored_data = body
	message.source = server.login
	if(attach_report)
		message.attachment = owner.clone()
	server.send_mail(recipient,69essage)

/datum/report_field/people/proc/format_output(name, rank)
	. = list()
	. +=69ame
	if(rank)
		. += "(69rank69)"
	return jointext(., " ")

//Lets you select one person on the69anifest.
/datum/report_field/people/from_manifest
	value = list()

/datum/report_field/people/from_manifest/get_value()
	return format_output(value69"name"69,69alue69"rank"69)

/datum/report_field/people/from_manifest/set_value(given_value)
	if(!given_value)
		value = list()
	if(!in_as_list(given_value, flat_nano_crew_manifest()))
		return //Check for inclusion, but have to be careful when checking list equivalence.
	value = given_value

/datum/report_field/people/from_manifest/ask_value(mob/user)
	var/list/full_manifest = flat_nano_crew_manifest()
	var/list/formatted_manifest = list()
	for(var/entry in full_manifest)
		formatted_manifest69format_output(entry69"name"69, entry69"rank"69)69 = entry
	var/input = input(user, "69display_name()69:", "Form Input", get_value()) as69ull|anything in formatted_manifest
	set_value(formatted_manifest69input69)

/datum/report_field/people/from_manifest/perform_send(subject, body, attach_report)
	var/login = find_email(value69"name"69)
	send_to_recipient(subject, body, attach_report, login)
	return 1

//Lets you select69ultiple people.
/datum/report_field/people/list_from_manifest
	value = list()
	needs_big_box = 1

/datum/report_field/people/list_from_manifest/get_value()
	var/dat = list()
	for(var/entry in69alue)
		dat += format_output(entry69"name"69)
	return jointext(dat, "<br>")

/datum/report_field/people/list_from_manifest/set_value(given_value)
	var/list/full_manifest = flat_nano_crew_manifest()
	var/list/new_value = list()
	if(!islist(given_value))
		return
	for(var/entry in given_value)
		if(!in_as_list(entry, full_manifest))
			return
		if(in_as_list(entry,69ew_value))
			continue //ignore repeats
		new_value += list(entry)
	value =69ew_value	

/datum/report_field/people/list_from_manifest/ask_value(mob/user)
	var/alert = alert(user, "Would you like to add or remove a69ame?", "Form Input", "Add", "Remove")
	var/list/formatted_manifest = list()
	switch(alert)
		if("Add")
			var/list/full_manifest = flat_nano_crew_manifest()
			for(var/entry in full_manifest)
				if(!in_as_list(entry,69alue)) //Only look at those69ot already selected.
					formatted_manifest69format_output(entry69"name"69, entry69"rank"69)69 = entry
			var/input = input(user, "Add to 69display_name()69:", "Form Input",69ull) as69ull|anything in formatted_manifest
			set_value(value + list(formatted_manifest69input69))
		if("Remove")
			for(var/entry in69alue)
				formatted_manifest69format_output(entry69"name"69, entry69"rank"69)69 = entry
			var/input = input(user, "Remove from 69display_name()69:", "Form Input",69ull) as69ull|anything in formatted_manifest
			set_value(value - list(formatted_manifest69input69))

//Batch-emails the list.
/datum/report_field/people/list_from_manifest/perform_send(subject, body, attach_report)
	for(var/entry in69alue)
		var/login = find_email(entry69"name"69)
		send_to_recipient(subject, body, attach_report, login)
	return 1