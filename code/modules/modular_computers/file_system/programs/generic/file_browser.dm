/datum/computer_file/program/filemanager
	filename = "filemanager"
	filedesc = "File69anager"
	extended_desc = "This program allows69anagement of files."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "folder-collapsed"
	size = 6
	requires_ntnet = 0
	available_on_ntnet = 0
	undeletable = 1
	nanomodule_path = /datum/nano_module/program/computer_filemanager/
	var/open_file
	var/error
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/filemanager/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"PRG_openfile"69)
		. = 1
		open_file = href_list69"PRG_openfile"69
	if(href_list69"PRG_newtextfile"69)
		. = 1
		var/newname = sanitize(input(usr, "Enter file69ame or leave blank to cancel:", "File rename"))
		if(!newname)
			return 1
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return 1
		var/datum/computer_file/data/F =69ew/datum/computer_file/data()
		F.filename =69ewname
		F.filetype = "TXT"
		HDD.store_file(F)
	if(href_list69"PRG_deletefile"69)
		. = 1
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return 1
		var/datum/computer_file/file = HDD.find_file_by_name(href_list69"PRG_deletefile"69)
		if(!file || file.undeletable)
			return 1
		HDD.remove_file(file)
	if(href_list69"PRG_usbdeletefile"69)
		. = 1
		var/obj/item/computer_hardware/hard_drive/RHDD = computer.portable_drive
		if(!RHDD)
			return 1
		var/datum/computer_file/file = RHDD.find_file_by_name(href_list69"PRG_usbdeletefile"69)
		if(!file || file.undeletable)
			return 1
		RHDD.remove_file(file)
	if(href_list69"PRG_closefile"69)
		. = 1
		open_file =69ull
		error =69ull
	if(href_list69"PRG_clone"69)
		. = 1
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return 1
		var/datum/computer_file/F = HDD.find_file_by_name(href_list69"PRG_clone"69)
		if(!F || !istype(F))
			return 1
		var/datum/computer_file/C = F.clone(1)
		HDD.store_file(C)
	if(href_list69"PRG_rename"69)
		. = 1
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return 1
		var/datum/computer_file/file = HDD.find_file_by_name(href_list69"PRG_rename"69)
		if(!file || !istype(file))
			return 1
		var/newname = sanitize(input(usr, "Enter69ew file69ame:", "File rename", file.filename))
		if(file &&69ewname)
			file.filename =69ewname
	if(href_list69"PRG_edit"69)
		. = 1
		if(!open_file)
			return 1
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return 1
		var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
		if(!F || !istype(F))
			return 1
		if(F.read_only && (alert("WARNING: This file is69ot compatible with editor. Editing it69ay result in permanently corrupted formatting or damaged data consistency. Edit anyway?", "Incompatible File", "No", "Yes") == "No"))
			return 1

		var/oldtext = html_decode(F.stored_data)
		oldtext = replacetext(oldtext, "\69br\69", "\n")

		var/newtext = sanitize(replacetext(input(usr, "Editing file 69open_file69. You69ay use69ost tags used in paper formatting:", "Text Editor", oldtext), "\n", "\69br\69"),69AX_TEXTFILE_LENGTH)
		if(!newtext)
			return

		if(F)
			var/datum/computer_file/data/backup = F.clone()
			HDD.remove_file(F)
			F.stored_data =69ewtext
			F.calculate_size()
			// We can't store the updated file, it's probably too large. Print an error and restore backed up69ersion.
			// This is69ostly intended to prevent people from losing texts they spent lot of time working on due to running out of space.
			// They will be able to copy-paste the text from error screen and store it in69otepad or something.
			if(!HDD.store_file(F))
				error = "I/O error: Unable to overwrite file. Hard drive is probably full. You69ay want to backup your changes before closing this window:<br><br>69html_decode(F.stored_data)69<br><br>"
				HDD.store_file(backup)
	if(href_list69"PRG_printfile"69)
		. = 1
		if(!open_file)
			return 1
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return 1
		var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
		if(!F || !istype(F))
			return 1
		if(!computer.printer)
			error = "Missing Hardware: Your computer does69ot have required hardware to complete this operation."
			return 1
		if(!computer.printer.print_text(pencode2html(F.stored_data)))
			error = "Hardware error: Printer was unable to print the file. It69ay be out of paper."
			return 1
	if(href_list69"PRG_copytousb"69)
		. = 1
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/obj/item/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
		if(!HDD || !RHDD)
			return 1
		var/datum/computer_file/F = HDD.find_file_by_name(href_list69"PRG_copytousb"69)
		if(!F || !istype(F))
			return 1
		var/datum/computer_file/C = F.clone(0)
		RHDD.store_file(C)
	if(href_list69"PRG_copyfromusb"69)
		. = 1
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/obj/item/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
		if(!HDD || !RHDD)
			return 1
		var/datum/computer_file/F = RHDD.find_file_by_name(href_list69"PRG_copyfromusb"69)
		if(!F || !istype(F))
			return 1
		var/datum/computer_file/C = F.clone(0)
		HDD.store_file(C)
	if(.)
		SSnano.update_uis(NM)

/datum/nano_module/program/computer_filemanager
	name = "File69anager"

/datum/nano_module/program/computer_filemanager/ui_data()
	var/list/data = host.initial_data()

	var/datum/computer_file/program/filemanager/PRG
	PRG = program

	if(PRG.error)
		data69"error"69 = PRG.error

	if(!PRG.computer || !PRG.computer.hard_drive)
		data69"error"69 = "I/O ERROR: Unable to access hard drive."

	else
		if(PRG.computer.hard_drive)
			data69"internal_disk"69 = PRG.computer.hard_drive.ui_data()

		if(PRG.computer.portable_drive)
			data69"portable_disk"69 = PRG.computer.portable_drive.ui_data()

		if(PRG.open_file)
			var/datum/computer_file/data/file

			file = PRG.computer.hard_drive.find_file_by_name(PRG.open_file)
			if(file.filetype == "AUD")
				data69"error"69 = "Software error: Please use a dedicated Audio Player program to read audio files."
			else if(!istype(file))
				data69"error"69 = "I/O ERROR: Unable to open file."
			else
				data69"filedata"69 = pencode2html(file.stored_data)
				data69"filename"69 = "69file.filename69.69file.filetype69"

	return data

/datum/nano_module/program/computer_filemanager/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "mpc_file_manager.tmpl",69ame, 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
