// Currently not actually represented in file systems, though the support for it is in place already.
/datum/computer_file/data/email_message/
	stored_data = ""
	var/title = ""
	var/source = ""
	var/spam = FALSE
	var/timestamp = ""
	var/datum/computer_file/attachment = null

/datum/computer_file/data/email_message/clone()
	var/datum/computer_file/data/email_message/temp = ..()
	temp.title = title
	temp.source = source
	temp.spam = spam
	temp.timestamp = timestamp
	if(attachment)
		temp.attachment = attachment.clone()
	return temp

/datum/computer_file/data/email_message/proc/notify_mob(mob/living/L, atom/notification_source, extra_lines)
	notify_from_source(notification_source)

	var/list/msg = list()
	msg += "*--*"
	msg += SPAN_NOTICE("New mail received from [source]:")
	msg += "<b>Subject:</b> [title]"
	msg += "<b>Message:</b>"
	msg += pencode2html(stored_data)

	if(attachment)
		msg += "<b>Attachment:</b> [attachment.filename].[attachment.filetype] ([attachment.size]GQ)"

	if(extra_lines)
		msg += extra_lines

	msg += "*--*"

	to_chat(L, jointext(msg, "\n"))


/datum/computer_file/data/email_message/proc/notify_from_source(atom/notification_source)
	if(issilicon(notification_source))
		var/mob/living/silicon/S = notification_source
		if(S.email_ringtone)
			playsound(S, 'sound/machines/twobeep.ogg', 50, 1)

	else if(istype(notification_source, /obj/item/modular_computer))
		var/obj/item/modular_computer/computer = notification_source
		var/datum/computer_file/program/email_client/PRG = computer.active_program
		if (istype(PRG) && PRG.ringtone)
			computer.visible_message("\The [host] beeps softly, indicating a new email has been received.", 1)
			playsound(computer, 'sound/machines/twobeep.ogg', 50, 1)


// Turns /email_message/ file into regular /data/ file.
/datum/computer_file/data/email_message/proc/export()
	var/datum/computer_file/data/dat = new/datum/computer_file/data()
	dat.stored_data =  "Received from [source] at [timestamp]."
	dat.stored_data += "\[b\][title]\[/b\]"
	dat.stored_data += stored_data
	dat.calculate_size()
	return dat

/datum/computer_file/data/email_message/proc/set_timestamp()
	timestamp = stationtime2text()

