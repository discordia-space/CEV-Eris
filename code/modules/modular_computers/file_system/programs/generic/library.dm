/*
In reply to this set of comments on lib_machines.dm:
// TODO:69ake this an actual /obj/machinery/computer that can be crafted from circuit boards and such
// It is August 22nd, 2012... This TODO has already been here for69onths.. I wonder how long it'll last before someone does something about it.

The answer was five and a half years -ZeroBits
*/

/datum/computer_file/program/library
	filename = "library"
	filedesc = "Library"
	extended_desc = "This program can be used to69iew e-books from an external archive."
	program_icon_state = "word"
	program_key_state = "atmos_key"
	program_menu_icon = "note"
	size = 6
	requires_ntnet = 1
	available_on_ntnet = 1

	nanomodule_path = /datum/nano_module/library

/datum/nano_module/library
	name = "Library"
	var/error_message = ""
	var/current_book
	var/obj/machinery/libraryscanner/scanner
	var/sort_by = "id"

/datum/nano_module/library/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	if(error_message)
		data69"error"69 = error_message
	else if(current_book)
		data69"current_book"69 = current_book
	else
		var/list/all_entries69069
		establish_db_connection()
		if(!dbcon.IsConnected())
			error_message = "Unable to contact External Archive. Please contact your system administrator for assistance."
		else
			var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, category FROM library ORDER BY "+sanitizeSQL(sort_by))
			query.Execute()

			while(query.NextRow())
				all_entries.Add(list(list(
				"id" = query.item69169,
				"author" = query.item69269,
				"title" = query.item69369,
				"category" = query.item69469
			)))
		data69"book_list"69 = all_entries
		data69"scanner"69 = istype(scanner)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "library.tmpl", "Library Program", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/library/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"viewbook"69)
		view_book(href_list69"viewbook"69)
		return 1
	if(href_list69"viewid"69)
		view_book(sanitizeSQL(input("Enter USBN:") as69um|null))
		return 1
	if(href_list69"closebook"69)
		current_book =69ull
		return 1
	if(href_list69"connectscanner"69)
		if(!nano_host())
			return 1
		for(var/d in GLOB.cardinal)
			var/obj/machinery/libraryscanner/scn = locate(/obj/machinery/libraryscanner, get_step(nano_host(), d))
			if(scn && scn.anchored)
				scanner = scn
				return 1
	if(href_list69"uploadbook"69)
		if(!scanner || !scanner.anchored)
			scanner =69ull
			error_message = "Hardware Error:69o scanner detected. Unable to access cache."
			return 1
		if(!scanner.cache)
			error_message = "Interface Error: Scanner cache does69ot contain any data. Please scan a book."
			return 1

		var/obj/item/book/B = scanner.cache

		if(B.unique)
			error_message = "Interface Error: Cached book is copy-protected."
			return 1

		B.SetName(input(usr, "Enter Book Title", "Title", B.name) as text|null)
		B.author = input(usr, "Enter Author69ame", "Author", B.author) as text|null

		if(!B.author)
			B.author = "Anonymous"
		else if(lowertext(B.author) == "edgar allen poe" || lowertext(B.author) == "edgar allan poe")
			error_message = "User Error: Upload something original."
			return 1

		if(!B.title)
			B.title = "Untitled"

		var/choice = input(usr, "Upload 69B.name69 by 69B.author69 to the External Archive?") in list("Yes", "No")
		if(choice == "Yes")
			establish_db_connection()
			if(!dbcon.IsConnected())
				error_message = "Network Error: Connection to the Archive has been severed."
				return 1

			var/upload_category = input(usr, "Upload to which category?") in list("Fiction", "Non-Fiction", "Reference", "Religion")

			var/sqltitle = sanitizeSQL(B.name)
			var/sqlauthor = sanitizeSQL(B.author)
			var/sqlcontent = sanitizeSQL(B.dat)
			var/sqlcategory = sanitizeSQL(upload_category)
			var/DBQuery/query = dbcon.NewQuery("INSERT INTO library (author, title, content, category)69ALUES ('69sqlauthor69', '69sqltitle69', '69sqlcontent69', '69sqlcategory69')")
			if(!query.Execute())
				to_chat(usr, query.ErrorMsg())
				error_message = "Network Error: Unable to upload to the Archive. Contact your system Administrator for assistance."
				return 1
			else
				log_and_message_admins("has uploaded the book titled 69B.name69, 69length(B.dat)69 signs")
				log_game("69usr.name69/69usr.key69 has uploaded the book titled 69B.name69, 69length(B.dat)69 signs")
				alert("Upload Complete.")
			return 1

		return 0

	if(href_list69"printbook"69)
		if(!current_book)
			error_message = "Software Error: Unable to print; book69ot found."
			return 1

		//PRINT TO BINDER
		if(!nano_host())
			return 1
		for(var/d in GLOB.cardinal)
			var/obj/machinery/bookbinder/bndr = locate(/obj/machinery/bookbinder, get_step(nano_host(), d))
			if(bndr && bndr.anchored)
				var/obj/item/book/B =69ew(bndr.loc)
				B.SetName(current_book69"title"69)
				B.title = current_book69"title"69
				B.author = current_book69"author"69
				B.dat = current_book69"content"69
				B.icon_state = "book69rand(1,7)69"
				B.desc = current_book69"author"69+", "+current_book69"title"69+", "+"USBN "+current_book69"id"69
				bndr.visible_message("\The 69bndr69 whirs as it prints and binds a69ew book.")
				return 1

		//Regular printing
		print_text("<i>Author: 69current_book69"author"6969<br>USBN: 69current_book69"id"6969</i><br><h3>69current_book69"title"6969</h3><br>69current_book69"content"6969", usr)
		return 1
	if(href_list69"sortby"69)
		sort_by = href_list69"sortby"69
		return 1
	if(href_list69"reseterror"69)
		if(error_message)
			current_book =69ull
			scanner =69ull
			sort_by = "id"
			error_message = ""
		return 1

/datum/nano_module/library/proc/view_book(var/id)
	if(current_book || !id)
		return 0

	var/sqlid = sanitizeSQL(id)
	establish_db_connection()
	if(!dbcon.IsConnected())
		error_message = "Network Error: Connection to the Archive has been severed."
		return 1

	var/DBQuery/query = dbcon.NewQuery("SELECT * FROM library WHERE id=69sqlid69")
	query.Execute()

	while(query.NextRow())
		current_book = list(
			"id" = query.item69169,
			"author" = query.item69269,
			"title" = query.item69369,
			"content" = query.item69469
			)
		break
	return 1