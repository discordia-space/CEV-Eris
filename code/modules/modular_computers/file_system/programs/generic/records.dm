/datum/computer_file/program/records
	filename = "crewrecords"
	filedesc = "Crew Records"
	extended_desc = "This program allows access to the crew's69arious records."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 14
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/records
	usage_flags = PROGRAM_ALL

/datum/nano_module/records
	name = "Crew Records"
	var/datum/computer_file/report/crew_record/active_record
	var/message =69ull

/datum/nano_module/records/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/list/user_access = get_record_access(user)

	data69"message"69 =69essage
	if(active_record)
		user << browse_rsc(active_record.photo_front, "front_69active_record.uid69.png")
		user << browse_rsc(active_record.photo_side, "side_69active_record.uid69.png")
		data69"pic_edit"69 = check_access(user, access_heads) || check_access(user, access_security)
		data += active_record.generate_nano_data(user_access)
	else
		var/list/all_records = list()

		for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
			all_records.Add(list(list(
				"name" = R.get_name(),
				"rank" = R.get_job(),
				"id" = R.uid
			)))
		data69"all_records"69 = all_records
		data69"creation"69 = check_access(user, access_heads)
		data69"dnasearch"69 = check_access(user, access_moebius) || check_access(user, access_forensics_lockers)
		data69"fingersearch"69 = check_access(user, access_security)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "crew_records.tmpl",69ame, 700, 540, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/records/proc/get_record_access(var/mob/user)
	var/list/user_access = using_access || user.GetAccess()

	var/obj/item/modular_computer/PC =69ano_host()
	if(istype(PC) && PC.computer_emagged)
		user_access = user_access.Copy()
		user_access |= access_syndicate

	return user_access

/datum/nano_module/records/proc/edit_field(var/mob/user,69ar/field_ID)
	var/datum/computer_file/report/crew_record/R = active_record
	if(!R)
		return
	var/datum/report_field/F = R.field_from_ID(field_ID)
	if(!F)
		return
	if(!F.verify_access_edit(get_record_access(user)))
		to_chat(user, "<span class='notice'>\The 69nano_host()69 flashes an \"Access Denied\" warning.</span>")
		return
	F.ask_value(user)

/datum/nano_module/records/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"clear_active"69)
		active_record =69ull
		return 1
	if(href_list69"clear_message"69)
		message =69ull
		return 1
	if(href_list69"set_active"69)
		var/ID = text2num(href_list69"set_active"69)
		for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
			if(R.uid == ID)
				active_record = R
				break
		return 1
	if(href_list69"new_record"69)
		if(!check_access(usr, access_heads))
			to_chat(usr, "Access Denied.")
			return
		active_record =69ew/datum/computer_file/report/crew_record()
		GLOB.all_crew_records.Add(active_record)
		return 1
	if(href_list69"print_active"69)
		if(!active_record)
			return
		print_text(record_to_html(active_record, get_record_access(usr)), usr)
		return 1
	if(href_list69"search"69)
		var/field_name = href_list69"search"69
		var/search = sanitize(input("Enter the69alue for search for.") as69ull|text)
		if(!search)
			return 1
		for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
			var/datum/report_field/field = R.field_from_name(field_name)
			if(lowertext(field.get_value()) == lowertext(search))
				active_record = R
				return 1
		message = "Unable to find record containing '69search69'"
		return 1

	var/datum/computer_file/report/crew_record/R = active_record
	if(!istype(R))
		return 1
	if(href_list69"edit_photo_front"69)
		var/photo = get_photo(usr)
		if(photo && active_record)
			active_record.photo_front = photo
			ui_interact(usr)
		return 1
	if(href_list69"edit_photo_side"69)
		var/photo = get_photo(usr)
		if(photo && active_record)
			active_record.photo_side = photo
			ui_interact(usr)
		return 1
	if(href_list69"edit_field"69)
		edit_field(usr, text2num(href_list69"edit_field"69))
		return 1

/datum/nano_module/records/proc/get_photo(var/mob/user)
	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_hand()
		return photo.img
	if(istype(user, /mob/living/silicon))
		var/mob/living/silicon/tempAI = usr
		var/obj/item/photo/selection = tempAI.GetPicture()
		if (selection)
			return selection.img
