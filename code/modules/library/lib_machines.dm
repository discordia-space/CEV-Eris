/* Library69achines
 *
 * Contains:
 *		Borrowbook datum
 *		Library Public Computer
 *		Library Computer
 *		Library Scanner
 *		Book Binder
 */

/*
 * Borrowbook datum
 */
datum/borrowbook // Datum used to keep track of who has borrowed what when and for how long.
	var/bookname
	var/mobname
	var/getdate
	var/duedate

/*
 * Library Public Computer
 */
/obj/machinery/librarypubliccomp
	name = "visitor computer"
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	var/screenstate = 0
	var/title
	var/category = "Any"
	var/author
	var/SQLquery

/obj/machinery/librarypubliccomp/attack_hand(var/mob/user as69ob)
	usr.set_machine(src)
	var/dat = "<HEAD><TITLE>Library69isitor</TITLE></HEAD><BODY>\n" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	switch(screenstate)
		if(0)
			dat += {"<h2>Search Settings</h2><br>
			<A href='?src=\ref69src69;settitle=1'>Filter by Title: 69title69</A><BR>
			<A href='?src=\ref69src69;setcategory=1'>Filter by Category: 69category69</A><BR>
			<A href='?src=\ref69src69;setauthor=1'>Filter by Author: 69author69</A><BR>
			<A href='?src=\ref69src69;search=1'>\69Start Search\69</A><BR>"}
		if(1)
			establish_db_connection()
			if(!dbcon.IsConnected())
				dat += "<font color=red><b>ERROR</b>: Unable to contact External Archive. Please contact your system administrator for assistance.</font><BR>"
			else if(!SQLquery)
				dat += "<font color=red><b>ERROR</b>:69alformed search request. Please contact your system administrator for assistance.</font><BR>"
			else
				dat += {"<table>
				<tr><td>AUTHOR</td><td>TITLE</td><td>CATEGORY</td><td>SS<sup>13</sup>BN</td></tr>"}

				var/DBQuery/query = dbcon.NewQuery(SQLquery)
				query.Execute()

				while(query.NextRow())
					var/author = query.item69169
					var/title = query.item69269
					var/category = query.item69369
					var/id = query.item69469
					dat += "<tr><td>69author69</td><td>69title69</td><td>69category69</td><td>69id69</td></tr>"
				dat += "</table><BR>"
			dat += "<A href='?src=\ref69src69;back=1'>\69Go Back\69</A><BR>"
	user << browse(dat, "window=publiclibrary")
	onclose(user, "publiclibrary")

/obj/machinery/librarypubliccomp/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=publiclibrary")
		onclose(usr, "publiclibrary")
		return

	if(href_list69"settitle"69)
		var/newtitle = input("Enter a title to search for:") as text|null
		if(newtitle)
			title = sanitize(newtitle)
		else
			title =69ull
		title = sanitizeSQL(title)
	if(href_list69"setcategory"69)
		var/newcategory = input("Choose a category to search for:") in list("Any", "Fiction", "Non-Fiction", "Adult", "Reference", "Religion")
		if(newcategory)
			category = sanitize(newcategory)
		else
			category = "Any"
		category = sanitizeSQL(category)
	if(href_list69"setauthor"69)
		var/newauthor = input("Enter an author to search for:") as text|null
		if(newauthor)
			author = sanitize(newauthor)
		else
			author =69ull
		author = sanitizeSQL(author)
	if(href_list69"search"69)
		SQLquery = "SELECT author, title, category, id FROM library WHERE "
		if(category == "Any")
			SQLquery += "author LIKE '%69author69%' AND title LIKE '%69title69%'"
		else
			SQLquery += "author LIKE '%69author69%' AND title LIKE '%69title69%' AND category='69category69'"
		screenstate = 1

	if(href_list69"back"69)
		screenstate = 0

	src.updateUsrDialog()
	keyboardsound(usr)
	return


/*
 * Library Computer
 */
// TODO:69ake this an actual /obj/machinery/computer that can be crafted from circuit boards and such
// It is August 22nd, 2012... This TODO has already been here for69onths.. I wonder how long it'll last before someone does something about it.
/obj/machinery/librarycomp
	name = "Check-In/Out Computer"
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	var/screenstate = 0 // 0 -69ain69enu, 1 - Inventory, 2 - Checked Out, 3 - Check Out a Book
	var/sortby = "author"
	var/buffer_book
	var/buffer_mob
	var/upload_category = "Fiction"
	var/list/checkouts = list()
	var/list/inventory = list()
	var/checkoutperiod = 5 // In69inutes
	var/obj/machinery/libraryscanner/scanner // Book scanner that will be used when uploading books to the Archive

	var/bibledelay = 0 // LOL69O SPAM (169inute delay) -- Doohl

/obj/machinery/librarycomp/attack_hand(var/mob/user as69ob)
	usr.set_machine(src)
	var/dat = "<HEAD><TITLE>Book Inventory69anagement</TITLE></HEAD><BODY>\n" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	switch(screenstate)
		if(0)
			//69ain69enu
			dat += {"<A href='?src=\ref69src69;switchscreen=1'>1.69iew General Inventory</A><BR>
			<A href='?src=\ref69src69;switchscreen=2'>2.69iew Checked Out Inventory</A><BR>
			<A href='?src=\ref69src69;switchscreen=3'>3. Check out a Book</A><BR>
			<A href='?src=\ref69src69;switchscreen=4'>4. Connect to External Archive</A><BR>
			<A href='?src=\ref69src69;switchscreen=5'>5. Upload69ew Title to Archive</A><BR>"}
			if(src.emagged)
				dat += "<A href='?src=\ref69src69;switchscreen=6'>6. Access the Forbidden Lore69ault</A><BR>"
		if(1)
			// Inventory
			dat += "<H3>Inventory</H3><BR>"
			for(var/obj/item/book/b in inventory)
				dat += "69b.name69 <A href='?src=\ref69src69;delbook=\ref69b69'>(Delete)</A><BR>"
			dat += "<A href='?src=\ref69src69;switchscreen=0'>(Return to69ain69enu)</A><BR>"
		if(2)
			// Checked Out
			dat += "<h3>Checked Out Books</h3><BR>"
			for(var/datum/borrowbook/b in checkouts)
				var/timetaken = world.time - b.getdate
				//timetaken *= 10
				timetaken /= 600
				timetaken = round(timetaken)
				var/timedue = b.duedate - world.time
				//timedue *= 10
				timedue /= 600
				if(timedue <= 0)
					timedue = "<font color=red><b>(OVERDUE)</b> 69timedue69</font>"
				else
					timedue = round(timedue)
				dat += {"\"69b.bookname69\", Checked out to: 69b.mobname69<BR>--- Taken: 69timetaken6969inutes ago, Due: in 69timedue6969inutes<BR>
				<A href='?src=\ref69src69;checkin=\ref69b69'>(Check In)</A><BR><BR>"}
			dat += "<A href='?src=\ref69src69;switchscreen=0'>(Return to69ain69enu)</A><BR>"
		if(3)
			// Check Out a Book
			dat += {"<h3>Check Out a Book</h3><BR>
			Book: 69src.buffer_book69
			<A href='?src=\ref69src69;editbook=1'>\69Edit\69</A><BR>
			Recipient: 69src.buffer_mob69
			<A href='?src=\ref69src69;editmob=1'>\69Edit\69</A><BR>
			Checkout Date : 69world.time/60069<BR>
			Due Date: 69(world.time + checkoutperiod)/60069<BR>
			(Checkout Period: 69checkoutperiod6969inutes) (<A href='?src=\ref69src69;increasetime=1'>+</A>/<A href='?src=\ref69src69;decreasetime=1'>-</A>)
			<A href='?src=\ref69src69;checkout=1'>(Commit Entry)</A><BR>
			<A href='?src=\ref69src69;switchscreen=0'>(Return to69ain69enu)</A><BR>"}
		if(4)
			dat += "<h3>External Archive</h3>"
			establish_db_connection()
			if(!dbcon.IsConnected())
				dat += "<font color=red><b>ERROR</b>: Unable to contact External Archive. Please contact your system administrator for assistance.</font>"
			else
				dat += {"<A href='?src=\ref69src69;orderbyid=1'>(Order book by SS<sup>13</sup>BN)</A><BR><BR>
				<table>
				<tr><td><A href='?src=\ref69src69;sort=author>AUTHOR</A></td><td><A href='?src=\ref69src69;sort=title>TITLE</A></td><td><A href='?src=\ref69src69;sort=category>CATEGORY</A></td><td></td></tr>"}
				var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, category FROM library ORDER BY 69sortby69")
				query.Execute()

				while(query.NextRow())
					var/id = query.item69169
					var/author = query.item69269
					var/title = query.item69369
					var/category = query.item69469
					dat += "<tr><td>69author69</td><td>69title69</td><td>69category69</td><td><A href='?src=\ref69src69;targetid=69id69'>\69Order\69</A></td></tr>"
				dat += "</table>"
			dat += "<BR><A href='?src=\ref69src69;switchscreen=0'>(Return to69ain69enu)</A><BR>"
		if(5)
			dat += "<H3>Upload a69ew Title</H3>"
			if(!scanner)
				for(var/obj/machinery/libraryscanner/S in range(9))
					scanner = S
					break
			if(!scanner)
				dat += "<FONT color=red>No scanner found within wireless69etwork range.</FONT><BR>"
			else if(!scanner.cache)
				dat += "<FONT color=red>No data found in scanner69emory.</FONT><BR>"
			else
				dat += {"<TT>Data69arked for upload...</TT><BR>
				<TT>Title: </TT>69scanner.cache.name69<BR>"}
				if(!scanner.cache.author)
					scanner.cache.author = "Anonymous"
				dat += {"<TT>Author: </TT><A href='?src=\ref69src69;setauthor=1'>69scanner.cache.author69</A><BR>
				<TT>Category: </TT><A href='?src=\ref69src69;setcategory=1'>69upload_category69</A><BR>
				<A href='?src=\ref69src69;upload=1'>\69Upload\69</A><BR>"}
			dat += "<A href='?src=\ref69src69;switchscreen=0'>(Return to69ain69enu)</A><BR>"
		if(6)
			dat += {"<h3>Accessing Forbidden Lore69ault69 1.3</h3>
			Are you absolutely sure you want to proceed? EldritchTomes Inc. takes69o responsibilities for loss of sanity resulting from this action.<p>
			<A href='?src=\ref69src69;arccheckout=1'>Yes.</A><BR>
			<A href='?src=\ref69src69;switchscreen=0'>No.</A><BR>"}

	//dat += "<A HREF='?src=\ref69user69;mach_close=library'>Close</A><br><br>"
	user << browse(dat, "window=library")
	onclose(user, "library")

/obj/machinery/librarycomp/emag_act(var/remaining_charges,69ar/mob/user)
	if (src.density && !src.emagged)
		src.emagged = 1
		return 1

/obj/machinery/librarycomp/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = W
		scanner.computer = src
		to_chat(user, "69scanner69's associated69achine has been set to 69src69.")
		for (var/mob/V in hearers(src))
			V.show_message("69src69 lets out a low, short blip.", 2)
	else
		..()

/obj/machinery/librarycomp/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=library")
		onclose(usr, "library")
		return

	if(href_list69"switchscreen"69)
		switch(href_list69"switchscreen"69)
			if("0")
				screenstate = 0
			if("1")
				screenstate = 1
			if("2")
				screenstate = 2
			if("3")
				screenstate = 3
			if("4")
				screenstate = 4
			if("5")
				screenstate = 5
			if("6")
				if(!bibledelay)

					var/obj/item/book/ritual/cruciform/B =69ew /obj/item/book/ritual/cruciform()
					B.loc=src.loc
					bibledelay = 1
					spawn(60)
						bibledelay = 0

				else
					for (var/mob/V in hearers(src))
						V.show_message("<b>69src69</b>'s69onitor flashes, \"Bible printer currently unavailable, please wait a69oment.\"")

			if("7")
				screenstate = 7
	if(href_list69"increasetime"69)
		checkoutperiod += 1
	if(href_list69"decreasetime"69)
		checkoutperiod -= 1
		if(checkoutperiod < 1)
			checkoutperiod = 1
	if(href_list69"editbook"69)
		buffer_book = sanitizeSafe(input("Enter the book's title:") as text|null)
	if(href_list69"editmob"69)
		buffer_mob = sanitize(input("Enter the recipient's69ame:") as text|null,69AX_NAME_LEN)
	if(href_list69"checkout"69)
		var/datum/borrowbook/b =69ew /datum/borrowbook
		b.bookname = sanitizeSafe(buffer_book)
		b.mobname = sanitize(buffer_mob)
		b.getdate = world.time
		b.duedate = world.time + (checkoutperiod * 600)
		checkouts.Add(b)
	if(href_list69"checkin"69)
		var/datum/borrowbook/b = locate(href_list69"checkin"69)
		checkouts.Remove(b)
	if(href_list69"delbook"69)
		var/obj/item/book/b = locate(href_list69"delbook"69)
		inventory.Remove(b)
	if(href_list69"setauthor"69)
		var/newauthor = sanitize(input("Enter the author's69ame: ") as text|null)
		if(newauthor)
			scanner.cache.author =69ewauthor
	if(href_list69"setcategory"69)
		var/newcategory = input("Choose a category: ") in list("Fiction", "Non-Fiction", "Adult", "Reference", "Religion")
		if(newcategory)
			upload_category =69ewcategory
	if(href_list69"upload"69)
		if(scanner)
			if(scanner.cache)
				var/choice = input("Are you certain you wish to upload this title to the Archive?") in list("Confirm", "Abort")
				if(choice == "Confirm")
					if(scanner.cache.unique)
						alert("This book has been rejected from the database. Aborting!")
					else
						establish_db_connection()
						if(!dbcon.IsConnected())
							alert("Connection to Archive has been severed. Aborting.")
						else
							/*
							var/sqltitle = dbcon.Quote(scanner.cache.name)
							var/sqlauthor = dbcon.Quote(scanner.cache.author)
							var/sqlcontent = dbcon.Quote(scanner.cache.dat)
							var/sqlcategory = dbcon.Quote(upload_category)
							*/
							var/sqltitle = sanitizeSQL(scanner.cache.name)
							var/sqlauthor = sanitizeSQL(scanner.cache.author)
							var/sqlcontent = sanitizeSQL(scanner.cache.dat)
							var/sqlcategory = sanitizeSQL(upload_category)

							var/author_id =69ull
							var/DBQuery/get_author_id = dbcon.NewQuery("SELECT id FROM players WHERE ckey='69usr.ckey69'")
							get_author_id.Execute()
							if(get_author_id.NextRow())
								author_id = get_author_id.item69169

							var/DBQuery/query = dbcon.NewQuery("INSERT INTO library (author, title, content, category, author_id)69ALUES ('69sqlauthor69', '69sqltitle69', '69sqlcontent69', '69sqlcategory69', 69author_id69)")
							if(!query.Execute())
								to_chat(usr, query.ErrorMsg())
							else
								log_and_message_admins("has uploaded the book titled 69scanner.cache.name69, 69length(scanner.cache.dat)69 signs")
								log_game("69usr.name69/69usr.key69 has uploaded the book titled 69scanner.cache.name69, 69length(scanner.cache.dat)69 signs")
								alert("Upload Complete.")

	if(href_list69"targetid"69)
		var/sqlid = sanitizeSQL(href_list69"targetid"69)
		establish_db_connection()
		if(!dbcon.IsConnected())
			alert("Connection to Archive has been severed. Aborting.")
		if(bibledelay)
			for (var/mob/V in hearers(src))
				V.show_message("<b>69src69</b>'s69onitor flashes, \"Printer unavailable. Please allow a short time before attempting to print.\"")
		else
			bibledelay = 1
			spawn(60)
				bibledelay = 0
			var/DBQuery/query = dbcon.NewQuery("SELECT * FROM library WHERE id=69sqlid69")
			query.Execute()

			while(query.NextRow())
				var/author = query.item69269
				var/title = query.item69369
				var/content = query.item69469
				var/obj/item/book/B =69ew(src.loc)
				B.name = "Book: 69title69"
				B.title = title
				B.author = author
				B.dat = content
				B.icon_state = "book69rand(1,7)69"
				src.visible_message("69src69's printer hums as it produces a completely bound book. How did it do that?")
				break
	if(href_list69"orderbyid"69)
		var/orderid = input("Enter your order:") as69um|null
		if(orderid)
			if(isnum(orderid))
				var/nhref = "src=\ref69src69;targetid=69orderid69"
				spawn() src.Topic(nhref, params2list(nhref), src)
	if(href_list69"sort"69 in list("author", "title", "category"))
		sortby = href_list69"sort"69
	src.updateUsrDialog()
	return

/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "scanner"
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	anchored = TRUE
	density = TRUE
	var/obj/item/book/cache		// Last scanned book

/obj/machinery/libraryscanner/attackby(var/obj/O as obj,69ar/mob/user as69ob)
	if(istype(O, /obj/item/book))
		user.drop_item()
		O.loc = src

/obj/machinery/libraryscanner/attack_hand(var/mob/user as69ob)
	usr.set_machine(src)
	var/dat = "<HEAD><TITLE>Scanner Control Interface</TITLE></HEAD><BODY>\n" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	if(cache)
		dat += "<FONT color=#005500>Data stored in69emory.</FONT><BR>"
	else
		dat += "No data stored in69emory.<BR>"
	dat += "<A href='?src=\ref69src69;scan=1'>\69Scan\69</A>"
	if(cache)
		dat += "       <A href='?src=\ref69src69;clear=1'>\69Clear69emory\69</A><BR><BR><A href='?src=\ref69src69;eject=1'>\69Remove Book\69</A>"
	else
		dat += "<BR>"
	user << browse(dat, "window=scanner")
	onclose(user, "scanner")

/obj/machinery/libraryscanner/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=scanner")
		onclose(usr, "scanner")
		return

	if(href_list69"scan"69)
		for(var/obj/item/book/B in contents)
			cache = B
			break
	if(href_list69"clear"69)
		cache =69ull
	if(href_list69"eject"69)
		for(var/obj/item/book/B in contents)
			B.loc = src.loc
	src.updateUsrDialog()
	return


/*
 * Book binder
 */
/obj/machinery/bookbinder
	name = "Book Binder"
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	anchored = TRUE
	density = TRUE

/obj/machinery/bookbinder/attackby(var/obj/O as obj,69ar/mob/user as69ob)
	if(istype(O, /obj/item/paper))
		user.drop_item()
		O.loc = src
		user.visible_message("69user69 loads some paper into 69src69.", "You load some paper into 69src69.")
		src.visible_message("69src69 begins to hum as it warms up its printing drums.")
		sleep(rand(200,400))
		src.visible_message("69src69 whirs as it prints and binds a69ew book.")
		var/obj/item/book/b =69ew(src.loc)
		b.dat = O:info
		b.name = "Print Job #" + "69rand(100, 999)69"
		b.icon_state = "book69rand(1,7)69"
		qdel(O)
	else
		..()
