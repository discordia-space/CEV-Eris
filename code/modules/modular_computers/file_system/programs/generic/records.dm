
#define NULL_RECORD list("name" = null, "uid" = null, "creator" = null, "file_time" = null, "fields" = null, "access" = null, "access_edit" = null)
/datum/computer_file/program/records
	filename = "crewrecords"
	filedesc = "Crew Records"
	extended_desc = "This program allows access to the crew's various records."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 14
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/tgui/records
	usage_flags = PROGRAM_ALL

/datum/nano_module/tgui/records
	name = "Crew Records"
	var/datum/computer_file/report/crew_record/active_record
	var/message = null

/datum/nano_module/tgui/records/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/list/user_access = get_record_access(user)

	data["message"] = message
	if(active_record)
		data["front_pic"] = icon2base64html(active_record.photo_front)
		data["side_pic"] = icon2base64html(active_record.photo_side)
		data["pic_edit"] = check_access(user, access_heads) || check_access(user, access_security)
		data += active_record.generate_nano_data(user_access)
	else
		var/list/all_records = list()

		for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
			all_records.Add(list(list(
				"name" = R.get_name(),
				"rank" = R.get_job(),
				"id" = R.uid
			)))
		data["all_records"] = all_records
		data["creation"] = check_access(user, access_heads)
		data["dnasearch"] = check_access(user, access_moebius) || check_access(user, access_forensics_lockers)
		data["fingersearch"] = check_access(user, access_security)
		data += NULL_RECORD
	return data
#undef NULL_RECORD

	

/datum/nano_module/tgui/records/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui || currentui)
	if (!ui)
		currentui = new(user, src, "CrewRecords", name)
		currentui.open()


/datum/nano_module/tgui/records/proc/get_record_access(var/mob/user)
	var/list/user_access = using_access || user.GetAccess()

	var/obj/item/modular_computer/PC = nano_host()
	if(istype(PC) && PC.computer_emagged)
		user_access = user_access.Copy()
		user_access |= access_syndicate

	return user_access

/datum/nano_module/tgui/records/proc/edit_field(var/mob/user, var/field_ID)
	var/datum/computer_file/report/crew_record/R = active_record
	if(!R)
		return
	var/datum/report_field/F = R.field_from_ID(field_ID)
	if(!F)
		return
	if(!F.verify_access_edit(get_record_access(user)))
		to_chat(user, "<span class='notice'>\The [nano_host()] flashes an \"Access Denied\" warning.</span>")
		return
	F.ask_value(user)

/datum/nano_module/tgui/records/ui_act(action, params)
	if(..())
		return 1
	switch(action)
	
		if("clear_active")
			active_record = null
			return 1
		if("clear_message")
			message = null
			return 1
		if("set_active")
			var/ID = text2num(params["set_active"])
			for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
				if(R.uid == ID)
					active_record = R
					break
			return 1
		if("new_record")
			if(!check_access(usr, access_heads))
				to_chat(usr, "Access Denied.")
				return
			active_record = new/datum/computer_file/report/crew_record()
			GLOB.all_crew_records.Add(active_record)
			return 1
		if("print_active")
			if(!active_record)
				return
			print_text(record_to_html(active_record, get_record_access(usr)), usr)
			return 1
		if("search")
			var/field_name = params["search"]
			var/search = sanitize(input("Enter the value for search for.") as null|text)
			if(!search)
				return 1
			for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
				var/datum/report_field/field = R.field_from_name(field_name)
				if(lowertext(field.get_value()) == lowertext(search))
					active_record = R
					return 1
			message = "Unable to find record containing '[search]'"
			return 1

	var/datum/computer_file/report/crew_record/R = active_record
	if(!istype(R))
		return 1
	switch(action)
		if("edit_photo_front")
			var/photo = get_photo(usr)
			if(photo && active_record)
				active_record.photo_front = photo
			return 1
		if("edit_photo_side")
			var/photo = get_photo(usr)
			if(photo && active_record)
				active_record.photo_side = photo
			return 1
		if("edit_field")
			edit_field(usr, text2num(params["edit_field"]))
			return 1

/datum/nano_module/tgui/records/proc/get_photo(var/mob/user)
	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_hand()
		return photo.img
	if(istype(user, /mob/living/silicon))
		var/mob/living/silicon/tempAI = usr
		var/obj/item/photo/selection = tempAI.GetPicture()
		if (selection)
			return selection.img
