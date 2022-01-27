/datum/computer_file/program/wordprocessor
	filename = "wordprocessor"
	filedesc = "NanoWord"
	extended_desc = "This program allows the editing and preview of text documents."
	program_icon_state = "word"
	program_key_state = "atmos_key"
	size = 4
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_wordprocessor/
	var/browsing
	var/open_file
	var/loaded_data = ""
	var/error
	var/is_edited
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/wordprocessor/proc/open_file(var/filename)
	var/datum/computer_file/data/F = get_file(filename)
	if(F)
		open_file = F.filename
		loaded_data = F.stored_data
		return TRUE

/datum/computer_file/program/wordprocessor/proc/save_file(var/filename)
	var/datum/computer_file/data/F = get_file(filename)
	if(!F) //try to69ake one if it doesn't exist
		F = create_file(filename, loaded_data, /datum/computer_file/data/text)
		return !isnull(F)
	var/datum/computer_file/data/backup = F.clone()
	var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
	if(!HDD)
		return
	HDD.remove_file(F)
	F.stored_data = loaded_data
	F.calculate_size()
	if(!HDD.store_file(F))
		HDD.store_file(backup)
		return FALSE
	is_edited = FALSE
	return TRUE

/datum/computer_file/program/wordprocessor/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list69"PRG_txtrpeview"69)
		show_browser(usr,"<HTML><HEAD><TITLE>69open_file69</TITLE></HEAD>69pencode2html(loaded_data)69</BODY></HTML>", "window=open_file")
		return TRUE

	if(href_list69"PRG_taghelp"69)
		to_chat(usr, "<span class='notice'>The hologram of a googly-eyed paper clip helpfully tells you:</span>")
		var/help = {"
		\69br\69 : Creates a linebreak.
		\69center\69 - \69/center\69 : Centers the text.
		\69h1\69 - \69/h1\69 : First level heading.
		\69h2\69 - \69/h2\69 : Second level heading.
		\69h3\69 - \69/h3\69 : Third level heading.
		\69b\69 - \69/b\69 : Bold.
		\69i\69 - \69/i\69 : Italic.
		\69u\69 - \69/u\69 : Underlined.
		\69small\69 - \69/small\69 : Decreases the size of the text.
		\69large\69 - \69/large\69 : Increases the size of the text.
		\69field\69 : Inserts a blank text field, which can be filled later. Useful for forms.
		\69date\69 : Current ship date.
		\69time\69 : Current ship time.
		\69list\69 - \69/list\69 : Begins and ends a list.
		\69*\69 : A list item.
		\69hr\69 : Horizontal rule.
		\69table\69 - \69/table\69 : Creates table using \69row\69 and \69cell\69 tags.
		\69grid\69 - \69/grid\69 : Table without69isible borders, for layouts.
		\69row\69 -69ew table row.
		\69cell\69 -69ew table cell.
		\69logo\69 - Inserts corporate logo image.
		\69guild\69 - Inserts Guild logo image.
		\69moebius\69 - Inserts69oebius logo image.
		\69ironhammer\69 - Inserts Ironhammer logo image.
		\69bluelogo\69 - Inserts blue corporate logo image.
		\69solcrest\69 - Inserts SCG crest image.
		\69terraseal\69 - Inserts TCC seal"}

		to_chat(usr, help)
		return TRUE

	if(href_list69"PRG_closebrowser"69)
		browsing = FALSE
		return TRUE

	if(href_list69"PRG_backtomenu"69)
		error =69ull
		return TRUE

	if(href_list69"PRG_loadmenu"69)
		browsing = TRUE
		return TRUE

	if(href_list69"PRG_openfile"69)
		. = TRUE
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				save_file(open_file)
		browsing = FALSE
		if(!open_file(href_list69"PRG_openfile"69))
			error = "I/O error: Unable to open file '69href_list69"PRG_openfile"6969'."

	if(href_list69"PRG_newfile"69)
		. = TRUE
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				save_file(open_file)

		var/newname = sanitize(input(usr, "Enter file69ame:", "New File"))
		if(!newname)
			return TRUE
		var/datum/computer_file/data/F = create_file(newname, "", /datum/computer_file/data/text)
		if(F)
			open_file = F.filename
			loaded_data = ""
			return TRUE
		else
			error = "I/O error: Unable to create file '69href_list69"PRG_saveasfile"6969'."

	if(href_list69"PRG_saveasfile"69)
		. = TRUE
		var/newname = sanitize(input(usr, "Enter file69ame:", "Save As"))
		if(!newname)
			return TRUE
		var/datum/computer_file/data/F = create_file(newname, loaded_data, /datum/computer_file/data/text)
		if(F)
			open_file = F.filename
		else
			error = "I/O error: Unable to create file '69href_list69"PRG_saveasfile"6969'."
		return TRUE

	if(href_list69"PRG_savefile"69)
		. = TRUE
		if(!open_file)
			open_file = sanitize(input(usr, "Enter file69ame:", "Save As"))
			if(!open_file)
				return FALSE
		if(!save_file(open_file))
			error = "I/O error: Unable to save file '69open_file69'."
		return TRUE

	if(href_list69"PRG_editfile"69)
		var/oldtext = html_decode(loaded_data)
		oldtext = replacetext(oldtext, "\69br\69", "\n")

		var/newtext = sanitize(replacetext(input(usr, "Editing file '69open_file69'. You69ay use69ost tags used in paper formatting:", "Text Editor", oldtext), "\n", "\69br\69"),69AX_TEXTFILE_LENGTH)
		if(!newtext)
			return
		loaded_data =69ewtext
		is_edited = TRUE
		return TRUE

	if(href_list69"PRG_printfile"69)
		. = TRUE
		if(!computer.printer)
			error = "Missing Hardware: Your computer does69ot have the required hardware to complete this operation."
			return TRUE
		if(!computer.printer.print_text(pencode2html(loaded_data)))
			error = "Hardware error: Printer was unable to print the file. It69ay be out of paper."
			return TRUE

/datum/nano_module/program/computer_wordprocessor
	name = "Word Processor"

/datum/nano_module/program/computer_wordprocessor/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/wordprocessor/PRG
	PRG = program

	var/obj/item/computer_hardware/hard_drive/HDD
	var/obj/item/computer_hardware/hard_drive/portable/RHDD
	if(PRG.error)
		data69"error"69 = PRG.error
	if(PRG.browsing)
		data69"browsing"69 = PRG.browsing
		if(!PRG.computer || !PRG.computer.hard_drive)
			data69"error"69 = "I/O ERROR: Unable to access hard drive."
		else
			HDD = PRG.computer.hard_drive
			var/list/files69069
			for(var/datum/computer_file/F in HDD.stored_files)
				if(F.filetype == "TXT")
					files.Add(list(list(
						"name" = F.filename,
						"size" = F.size
					)))
			data69"files"69 = files

			RHDD = PRG.computer.portable_drive
			if(RHDD)
				data69"usbconnected"69 = TRUE
				var/list/usbfiles69069
				for(var/datum/computer_file/F in RHDD.stored_files)
					if(F.filetype == "TXT")
						usbfiles.Add(list(list(
							"name" = F.filename,
							"size" = F.size,
						)))
				data69"usbfiles"69 = usbfiles
	else if(PRG.open_file)
		data69"filedata"69 = pencode2html(PRG.loaded_data)
		data69"filename"69 = PRG.is_edited ? "69PRG.open_file69*" : PRG.open_file
	else
		data69"filedata"69 = pencode2html(PRG.loaded_data)
		data69"filename"69 = "UNNAMED"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "word_processor.tmpl", "Word Processor", 575, 700, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()