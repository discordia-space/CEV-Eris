/obj/machinery/computer/secure_data
	name = "security records console"
	desc = "Used to69iew, edit and69aintain security records"
	icon_keyboard = "security_key"
	icon_screen = "security"
	li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	re69_one_access = list(access_security)
	circuit = /obj/item/electronics/circuitboard/secure_data
	var/obj/item/card/id/scan
	var/authenticated
	var/rank
	var/screen
	var/datum/data/record/active1 
	var/datum/data/record/active2
	var/a_id
	var/temp
	var/printin69
	var/can_chan69e_id = 0
	var/list/Perp
	var/tempname
	//Sortin6969ariables
	var/sortBy = "name"
	var/order = 1 // -1 = Descendin69 - 1 = Ascendin69

/obj/machinery/computer/secure_data/verb/eject_id()
	set cate69ory = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.stat || usr.lyin69)	return

	if(scan)
		to_chat(usr, "You remove \the 69scan69 from \the 69src69.")
		scan.loc = 69et_turf(src)
		if(!usr.69et_active_hand() && ishuman(usr))
			usr.put_in_hands(scan)
		scan = null
	else
		to_chat(usr, "There is nothin69 to remove from the console.")
	return

/obj/machinery/computer/secure_data/attackby(obj/item/O as obj, user as69ob)
	if(istype(O, /obj/item/card/id) && !scan)
		usr.drop_item()
		O.loc = src
		scan = O
		to_chat(user, "You insert 69O69.")
	..()

//Someone needs to break down the dat += into chunks instead of lon69 ass lines.
/obj/machinery/computer/secure_data/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/secure_data/ui_interact(user)
	if (src.z > 6)
		to_chat(user, "<span class='warnin69'>Unable to establish a connection:</span> You're too far away from the station!")
		return

	var/dat
	if (temp)
		dat = text("<TT>6969</TT><BR><BR><A href='?src=\ref6969;choice=Clear Screen'>Clear Screen</A>", temp, src)
	else
		dat = text("Confirm Identity: <A href='?src=\ref6969;choice=Confirm Identity'>6969</A><HR>", src, (scan ? text("6969", scan.name) : "----------"))
		if (authenticated)
			switch(screen)
				if(1)
					dat += {"<p style='text-ali69n:center;'>"}
					dat += text("<A href='?src=\ref6969;choice=Search Records'>Search Records</A><BR>", src)
					dat += text("<A href='?src=\ref6969;choice=New Record (69eneral)'>New Record</A><BR>", src)
					dat += {"
</p>
<table style="text-ali69n:center;" cellspacin69="0" width="100%">
<tr>
<th>Records:</th>
</tr>
</table>
<table style="text-ali69n:center;" border="1" cellspacin69="0" width="100%">
<tr>
<th><A href='?src=\ref69src69;choice=Sortin69;sort=name'>Name</A></th>
<th><A href='?src=\ref69src69;choice=Sortin69;sort=id'>ID</A></th>
<th><A href='?src=\ref69src69;choice=Sortin69;sort=rank'>Rank</A></th>
<th><A href='?src=\ref69src69;choice=Sortin69;sort=fin69erprint'>Fin69erprints</A></th>
<th>Criminal Status</th>
</tr>"}
					if(!isnull(data_core.69eneral))
						for(var/datum/data/record/R in sortRecord(data_core.69eneral, sortBy, order))
							var/crimstat = ""
							for(var/datum/data/record/E in data_core.security)
								if ((E.fields69"name"69 == R.fields69"name"69 && E.fields69"id"69 == R.fields69"id"69))
									crimstat = E.fields69"criminal"69
							var/back69round
							switch(crimstat)
								if("*Arrest*")
									back69round = "'back69round-color:#DC143C;'"
								if("Incarcerated")
									back69round = "'back69round-color:#CD853F;'"
								if("Parolled")
									back69round = "'back69round-color:#CD853F;'"
								if("Released")
									back69round = "'back69round-color:#3BB9FF;'"
								if("None")
									back69round = "'back69round-color:#00FF7F;'"
								if("")
									back69round = "'back69round-color:#FFFFFF;'"
									crimstat = "No Record."
							dat += text("<tr style=6969><td><A href='?src=\ref6969;choice=Browse Record;d_rec=\ref6969'>6969</a></td>", back69round, src, R, R.fields69"name"69)
							dat += text("<td>6969</td>", R.fields69"id"69)
							dat += text("<td>6969</td>", R.fields69"rank"69)
							dat += text("<td>6969</td>", R.fields69"fin69erprint"69)
							dat += text("<td>6969</td></tr>", crimstat)
						dat += "</table><hr width='75%' />"
					dat += text("<A href='?src=\ref6969;choice=Record69aintenance'>Record69aintenance</A><br><br>", src)
					dat += text("<A href='?src=\ref6969;choice=Lo69 Out'>{Lo69 Out}</A>",src)
				if(2)
					dat += "<B>Records69aintenance</B><HR>"
					dat += "<BR><A href='?src=\ref69src69;choice=Delete All Records'>Delete All Records</A><BR><BR><A href='?src=\ref69src69;choice=Return'>Back</A>"
				if(3)
					dat += "<CENTER><B>Security Record</B></CENTER><BR>"
					if ((istype(active1, /datum/data/record) && data_core.69eneral.Find(active1)))
						user << browse_rsc(active1.fields69"photo_front"69, "front.pn69")
						user << browse_rsc(active1.fields69"photo_side"69, "side.pn69")
						dat += {"
							<table><tr><td>
							Name: <A href='?src=\ref69src69;choice=Edit;field=name'>69active1.fields69"name"6969</A><BR>
							ID: <A href='?src=\ref69src69;choice=Edit;field=id'>69active1.fields69"id"6969</A><BR>
							Sex: <A href='?src=\ref69src69;choice=Edit;field=sex'>69active1.fields69"sex"6969</A><BR>
							A69e: <A href='?src=\ref69src69;choice=Edit;field=a69e'>69active1.fields69"a69e"6969</A><BR>
							Rank: <A href='?src=\ref69src69;choice=Edit;field=rank'>69active1.fields69"rank"6969</A><BR>
							Fin69erprint: <A href='?src=\ref69src69;choice=Edit;field=fin69erprint'>69active1.fields69"fin69erprint"6969</A><BR>
							Physical Status: 69active1.fields69"p_stat"6969<BR>
							Mental Status: 69active1.fields69"m_stat"6969<BR></td>
							<td ali69n = center69ali69n = top>Photo:<br>
							<table><td ali69n = center><im69 src=front.pn69 hei69ht=80 width=80 border=4><BR>
							<A href='?src=\ref69src69;choice=Edit;field=photo front'>Update front photo</A></td>
							<td ali69n = center><im69 src=side.pn69 hei69ht=80 width=80 border=4><BR>
							<A href='?src=\ref69src69;choice=Edit;field=photo side'>Update side photo</A></td></table>
							</td></tr></table>
						"}
					else
						dat += "<B>69eneral Record Lost!</B><BR>"
					if ((istype(active2, /datum/data/record) && data_core.security.Find(active2)))
						dat += "<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: \
								<A href='?src=\ref69src69;choice=Edit;field=criminal'>69active2.fields69"criminal"6969</A><BR>\n<BR>\n \
								Minor Crimes: <A href='?src=\ref69src69;choice=Edit;field=mi_crim'>69active2.fields69"mi_crim"6969</A><BR>\n \
								Details: <A href='?src=\ref69src69;choice=Edit;field=mi_crim_d'>69active2.fields69"mi_crim_d"6969</A><BR>\n<BR>\n\
								Major Crimes: <A href='?src=\ref69src69;choice=Edit;field=ma_crim'>69active2.fields69"ma_crim"6969</A><BR>\n \
								Details: <A href='?src=\ref69src69;choice=Edit;field=ma_crim_d'>69active2.fields69"ma_crim_d"6969</A><BR>\n<BR>\n \
								Important Notes:<BR>\n\t<A href='?src=\ref69src69;choice=Edit;field=notes'>69decode(active2.fields69"notes"69)69</A><BR>\n<BR>\n\
								<CENTER><B>Comments/Lo69</B></CENTER><BR>"
						var/counter = 1
						while(active2.fields69"com_69counter69"69)
							dat += text("6969<BR><A href='?src=\ref6969;choice=Delete Entry;del_c=6969'>Delete Entry</A><BR><BR>", active2.fields69"com_69counter69"69, src, counter)
							counter++
						dat += "<A href='?src=\ref69src69;choice=Add Entry'>Add Entry</A><BR><BR>"
						dat += "<A href='?src=\ref69src69;choice=Delete Record (Security)'>Delete Record (Security Only)</A><BR><BR>"
					else
						dat += "<B>Security Record Lost!</B><BR>"
						dat += "<A href='?src=\ref69src69;choice=New Record (Security)'>New Security Record</A><BR><BR>"
					dat += "<A href='?src=\ref69src69;choice=Delete Record (ALL)'>Delete Record (ALL)</A><BR><BR> \
							<A href='?src=\ref69src69;choice=Print Record'>Print Record</A><BR> \
							<A href='?src=\ref69src69;choice=Print Poster'>Print Wanted Poster</A><BR> \
							<A href='?src=\ref69src69;choice=Return'>Back</A><BR>"
				if(4)
					if(!Perp.len)
						dat += text("ERROR.  Strin69 could not be located.<br><br><A href='?src=\ref6969;choice=Return'>Back</A>", src)
					else
						dat += {"
							<table style="text-ali69n:center;" cellspacin69="0" width="100%">
							<tr><th>Search Results for '69tempname69':</th></tr></table>
							<table style="text-ali69n:center;" border="1" cellspacin69="0" width="100%">
							<tr>
							<th>Name</th>
							<th>ID</th>
							<th>Rank</th>
							<th>Fin69erprints</th>
							<th>Criminal Status</th>
							</tr>
						"}
						for(var/i=1, i<=Perp.len, i += 2)
							var/crimstat = ""
							var/datum/data/record/R = Perp69i69
							if(istype(Perp69i+169,/datum/data/record/))
								var/datum/data/record/E = Perp69i+169
								crimstat = E.fields69"criminal"69
							var/back69round
							switch(crimstat)
								if("*Arrest*")
									back69round = "'back69round-color:#DC143C;'"
								if("Incarcerated")
									back69round = "'back69round-color:#CD853F;'"
								if("Parolled")
									back69round = "'back69round-color:#CD853F;'"
								if("Released")
									back69round = "'back69round-color:#3BB9FF;'"
								if("None")
									back69round = "'back69round-color:#00FF7F;'"
								if("")
									back69round = "'back69round-color:#FFFFFF;'"
									crimstat = "No Record."
							dat += text("<tr style=6969><td><A href='?src=\ref6969;choice=Browse Record;d_rec=\ref6969'>6969</a></td>", back69round, src, R, R.fields69"name"69)
							dat += text("<td>6969</td>", R.fields69"id"69)
							dat += text("<td>6969</td>", R.fields69"rank"69)
							dat += text("<td>6969</td>", R.fields69"fin69erprint"69)
							dat += text("<td>6969</td></tr>", crimstat)
						dat += "</table><hr width='75%' />"
						dat += text("<br><A href='?src=\ref6969;choice=Return'>Return to index.</A>", src)
				else
		else
			dat += text("<A href='?src=\ref6969;choice=Lo69 In'>{Lo69 In}</A>", src)
	user << browse(text("<HEAD><TITLE>Security Records</TITLE></HEAD><TT>6969</TT>", dat), "window=secure_rec;size=600x400")
	onclose(user, "secure_rec")
	return

/*Revised /N
I can't be bothered to look69ore of the actual code outside of switch but that probably needs revisin69 too.
What a69ess.*/
/obj/machinery/computer/secure_data/Topic(href, href_list)
	if(..())
		return 1
	if (!( data_core.69eneral.Find(active1) ))
		active1 = null
	if (!( data_core.security.Find(active2) ))
		active2 = null
	if ((usr.contents.Find(src) || (in_ran69e(src, usr) && istype(loc, /turf))) || (issilicon(usr)))
		usr.set_machine(src)
		switch(href_list69"choice"69)
// SORTIN69!
			if("Sortin69")
				// Reverse the order if clicked twice
				if(sortBy == href_list69"sort"69)
					if(order == 1)
						order = -1
					else
						order = 1
				else
				// New sortin69 order!
					sortBy = href_list69"sort"69
					order = initial(order)
//BASIC FUNCTIONS
			if("Clear Screen")
				temp = null

			if ("Return")
				screen = 1
				active1 = null
				active2 = null

			if("Confirm Identity")
				if (scan)
					if(ishuman(usr) && !usr.69et_active_hand())
						usr.put_in_hands(scan)
					else
						scan.loc = 69et_turf(src)
					scan = null
				else
					var/obj/item/I = usr.69et_active_hand()
					if (istype(I, /obj/item/card/id) && usr.unE69uip(I))
						I.loc = src
						scan = I

			if("Lo69 Out")
				authenticated = null
				screen = null
				active1 = null
				active2 = null

			if("Lo69 In")
				if (isAI(usr))
					src.active1 = null
					src.active2 = null
					src.authenticated = usr.name
					src.rank = "AI"
					src.screen = 1
				else if (isrobot(usr))
					src.active1 = null
					src.active2 = null
					src.authenticated = usr.name
					var/mob/livin69/silicon/robot/R = usr
					src.rank = "69R.modtype69 69R.braintype69"
					src.screen = 1
				else if (istype(scan, /obj/item/card/id))
					active1 = null
					active2 = null
					if(check_access(scan))
						authenticated = scan.re69istered_name
						rank = scan.assi69nment
						screen = 1
//RECORD FUNCTIONS
			if("Search Records")
				var/t1 = input("Search Strin69: (Partial Name or ID or Fin69erprints or Rank)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.restrained() || !in_ran69e(src, usr)))
					return
				Perp = new/list()
				t1 = lowertext(t1)
				var/list/components = splittext(t1, " ")
				if(components.len > 5)
					return //Lets not let them search too 69reedily.
				for(var/datum/data/record/R in data_core.69eneral)
					var/temptext = R.fields69"name"69 + " " + R.fields69"id"69 + " " + R.fields69"fin69erprint"69 + " " + R.fields69"rank"69
					for(var/i = 1, i<=components.len, i++)
						if(findtext(temptext,components69i69))
							var/prelist = new/list(2)
							prelist69169 = R
							Perp += prelist
				for(var/i = 1, i<=Perp.len, i+=2)
					for(var/datum/data/record/E in data_core.security)
						var/datum/data/record/R = Perp69i69
						if ((E.fields69"name"69 == R.fields69"name"69 && E.fields69"id"69 == R.fields69"id"69))
							Perp69i+169 = E
				tempname = t1
				screen = 4

			if("Record69aintenance")
				screen = 2
				active1 = null
				active2 = null

			if ("Browse Record")
				var/datum/data/record/R = locate(href_list69"d_rec"69)
				var/S = locate(href_list69"d_rec"69)
				if (!( data_core.69eneral.Find(R) ))
					temp = "Record Not Found!"
				else
					for(var/datum/data/record/E in data_core.security)
						if ((E.fields69"name"69 == R.fields69"name"69 || E.fields69"id"69 == R.fields69"id"69))
							S = E
					active1 = R
					active2 = S
					screen = 3

/*			if ("Search Fin69erprints")
				var/t1 = input("Search Strin69: (Fin69erprint)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.restrained() || (!in_ran69e(src, usr)) && (!issilicon(usr))))
					return
				active1 = null
				active2 = null
				t1 = lowertext(t1)
				for(var/datum/data/record/R in data_core.69eneral)
					if (lowertext(R.fields69"fin69erprint"69) == t1)
						active1 = R
				if (!( active1 ))
					temp = text("Could not locate record 6969.", t1)
				else
					for(var/datum/data/record/E in data_core.security)
						if ((E.fields69"name"69 == active1.fields69"name"69 || E.fields69"id"69 == active1.fields69"id"69))
							active2 = E
					screen = 3	*/

			if ("Print Record")
				if (!( printin69 ))
					printin69 = 1
					var/datum/data/record/record1 = null
					var/datum/data/record/record2 = null
					if ((istype(active1, /datum/data/record) && data_core.69eneral.Find(active1)))
						record1 = active1
					if ((istype(active2, /datum/data/record) && data_core.security.Find(active2)))
						record2 = active2
					sleep(50)
					var/obj/item/paper/P = new /obj/item/paper( loc )
					P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
					if (record1)
						P.info += {"
							Name: 69record1.fields69"name"6969 ID: 69record1.fields69"id"6969<BR>
							Sex: 69record1.fields69"sex"6969<BR>
							A69e: 69record1.fields69"a69e"6969<BR>
							Fin69erprint: 69record1.fields69"fin69erprint"6969<BR>
							Physical Status: 69record1.fields69"p_stat"6969<BR>
							Mental Status: 69record1.fields69"m_stat"6969<BR>
						"}
						P.name = "Security Record (69record1.fields69"name"6969)"
					else
						P.info += "<B>69eneral Record Lost!</B><BR>"
						P.name = "Security Record"
					if (record2)
						P.info += {"
							<BR><CENTER><B>Security Data</B></CENTER><BR>
							Criminal Status: 69record2.fields69"criminal"6969<BR><BR>
							Minor Crimes: 69record2.fields69"mi_crim"6969<BR>
							Details: 69record2.fields69"mi_crim_d"6969<BR><BR>
							Major Crimes: 69record2.fields69"ma_crim"6969<BR>
							Details: 69record2.fields69"ma_crim_d"6969<BR><BR>
							Important Notes:<BR>
							\t69decode(record2.fields69"notes"69)69<BR><BR>
							<CENTER><B>Comments/Lo69</B></CENTER><BR>
						"}
						var/counter = 1
						while(record2.fields69text("com_6969", counter)69)
							P.info += text("6969<BR>", record2.fields69text("com_6969", counter)69)
							counter++
					else
						P.info += "<B>Security Record Lost!</B><BR>"
					P.info += "</TT>"
					printin69 = null
					updateUsrDialo69()

			if ("Print Poster")
				if(!printin69)
					var/wanted_name = sanitizeName(input("Please enter an alias for the criminal:", "Print Wanted Poster", active1.fields69"name"69) as text,69AX_NAME_LEN, 1)
					if(wanted_name)
						var/default_description = "A poster declarin69 69wanted_name69 to be a dan69erous individual, wanted by Nanotrasen. Report any si69htin69s to security immediately."
						var/major_crimes = active2.fields69"ma_crim"69
						var/minor_crimes = active2.fields69"mi_crim"69
						default_description += "\n69wanted_name69 is wanted for the followin69 crimes:\n"
						default_description += "\nMinor Crimes:\n69minor_crimes69\n69active2.fields69"mi_crim_d"6969\n"
						default_description += "\nMajor Crimes:\n69major_crimes69\n69active2.fields69"ma_crim_d"6969\n"
						printin69 = 1
						spawn(30)
							playsound(loc, 'sound/items/poster_bein69_created.o6969', 100, 1)
							if((istype(active1, /datum/data/record) && data_core.69eneral.Find(active1)))//make sure the record still exists.
								new /obj/item/contraband/poster/wanted(src.loc, active1.fields69"photo_front"69, wanted_name, default_description)
							printin69 = 0
//RECORD DELETE
			if ("Delete All Records")
				temp = ""
				temp += "Are you sure you wish to delete all Security records?<br>"
				temp += "<a href='?src=\ref69src69;choice=Pur69e All Records'>Yes</a><br>"
				temp += "<a href='?src=\ref69src69;choice=Clear Screen'>No</a>"

			if ("Pur69e All Records")
				for(var/datum/data/record/R in data_core.security)
					69del(R)
				temp = "All Security records deleted."

			if ("Add Entry")
				if (!( istype(active2, /datum/data/record) ))
					return
				var/a2 = active2
				var/t1 = sanitize(input("Add Comment:", "Secure. records", null, null)  as69essa69e)
				if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || active2 != a2))
					return
				var/counter = 1
				while(active2.fields69text("com_6969", counter)69)
					counter++
				active2.fields69text("com_69counter69")69 = text("Made by 69authenticated69 (69rank69) on 69time2text(world.realtime, "DDD69MM DD")69 69stationtime2text()69, 6969ame_year69<BR>69t169")

			if ("Delete Record (ALL)")
				if (active1)
					temp = "<h5>Are you sure you wish to delete the record (ALL)?</h5>"
					temp += "<a href='?src=\ref69src69;choice=Delete Record (ALL) Execute'>Yes</a><br>"
					temp += "<a href='?src=\ref69src69;choice=Clear Screen'>No</a>"

			if ("Delete Record (Security)")
				if (active2)
					temp = "<h5>Are you sure you wish to delete the record (Security Portion Only)?</h5>"
					temp += "<a href='?src=\ref69src69;choice=Delete Record (Security) Execute'>Yes</a><br>"
					temp += "<a href='?src=\ref69src69;choice=Clear Screen'>No</a>"

			if ("Delete Entry")
				if ((istype(active2, /datum/data/record) && active2.fields69text("com_6969", href_list69"del_c"69)69))
					active2.fields69text("com_6969", href_list69"del_c"69)69 = "<B>Deleted</B>"
//RECORD CREATE
			if ("New Record (Security)")
				if ((istype(active1, /datum/data/record) && !( istype(active2, /datum/data/record) )))
					active2 = data_core.CreateSecurityRecord(active1.fields69"name"69, active1.fields69"id"69)
					screen = 3

			if ("New Record (69eneral)")
				active1 = data_core.Create69eneralRecord()
				active2 = null

//FIELD FUNCTIONS
			if ("Edit")
				if (is_not_allowed(usr))
					return
				var/a1 = active1
				var/a2 = active2
				switch(href_list69"field"69)
					if("name")
						if (istype(active1, /datum/data/record))
							var/t1 = sanitizeName(input("Please input name:", "Secure. records", active1.fields69"name"69, null)  as text)
							if (!t1 || active1 != a1)
								return
							active1.fields69"name"69 = t1
					if("id")
						if (istype(active2, /datum/data/record))
							var/t1 = sanitize(input("Please input id:", "Secure. records", active1.fields69"id"69, null)  as text)
							if (!t1 || active1 != a1)
								return
							active1.fields69"id"69 = t1
					if("fin69erprint")
						if (istype(active1, /datum/data/record))
							var/t1 = sanitize(input("Please input fin69erprint hash:", "Secure. records", active1.fields69"fin69erprint"69, null)  as text)
							if (!t1 || active1 != a1)
								return
							active1.fields69"fin69erprint"69 = t1
					if("sex")
						if (istype(active1, /datum/data/record))
							if (active1.fields69"sex"69 == "Male")
								active1.fields69"sex"69 = "Female"
							else
								active1.fields69"sex"69 = "Male"
					if("a69e")
						if (istype(active1, /datum/data/record))
							var/t1 = input("Please input a69e:", "Secure. records", active1.fields69"a69e"69, null)  as num
							if (!t1 || active1 != a1)
								return
							active1.fields69"a69e"69 = t1
					if("mi_crim")
						if (istype(active2, /datum/data/record))
							var/t1 = sanitize(input("Please input69inor disabilities list:", "Secure. records", active2.fields69"mi_crim"69, null)  as text)
							if (!t1 || active2 != a2)
								return
							active2.fields69"mi_crim"69 = t1
					if("mi_crim_d")
						if (istype(active2, /datum/data/record))
							var/t1 = sanitize(input("Please summarize69inor dis.:", "Secure. records", active2.fields69"mi_crim_d"69, null)  as69essa69e)
							if (!t1 || active2 != a2)
								return
							active2.fields69"mi_crim_d"69 = t1
					if("ma_crim")
						if (istype(active2, /datum/data/record))
							var/t1 = sanitize(input("Please input69ajor diabilities list:", "Secure. records", active2.fields69"ma_crim"69, null)  as text)
							if (!t1 || active2 != a2)
								return
							active2.fields69"ma_crim"69 = t1
					if("ma_crim_d")
						if (istype(active2, /datum/data/record))
							var/t1 = sanitize(input("Please summarize69ajor dis.:", "Secure. records", active2.fields69"ma_crim_d"69, null)  as69essa69e)
							if (!t1 || active2 != a2)
								return
							active2.fields69"ma_crim_d"69 = t1
					if("notes")
						if (istype(active2, /datum/data/record))
							var/t1 = sanitize(input("Please summarize notes:", "Secure. records", html_decode(active2.fields69"notes"69), null)  as69essa69e, extra = 0)
							if (!t1 || active2 != a2)
								return
							active2.fields69"notes"69 = t1
					if("criminal")
						if (istype(active2, /datum/data/record))
							temp = "<h5>Criminal Status:</h5>"
							temp += "<ul>"
							temp += "<li><a href='?src=\ref69src69;choice=Chan69e Criminal Status;criminal2=none'>None</a></li>"
							temp += "<li><a href='?src=\ref69src69;choice=Chan69e Criminal Status;criminal2=arrest'>*Arrest*</a></li>"
							temp += "<li><a href='?src=\ref69src69;choice=Chan69e Criminal Status;criminal2=incarcerated'>Incarcerated</a></li>"
							temp += "<li><a href='?src=\ref69src69;choice=Chan69e Criminal Status;criminal2=parolled'>Parolled</a></li>"
							temp += "<li><a href='?src=\ref69src69;choice=Chan69e Criminal Status;criminal2=released'>Released</a></li>"
							temp += "</ul>"
					if("rank")
						var/list/L = list( "First Officer", "Captain", "AI" )
						//This was so silly before the chan69e. Now it actually works without beatin69 your head a69ainst the keyboard. /N
						if ((istype(active1, /datum/data/record) && L.Find(rank)))
							temp = "<h5>Rank:</h5>"
							temp += "<ul>"
							for(var/rank in 69LOB.joblist)
								temp += "<li><a href='?src=\ref69src69;choice=Chan69e Rank;rank=69rank69'>69rank69</a></li>"
							temp += "</ul>"
						else
							alert(usr, "You do not have the re69uired rank to do this!")
					if("species")
						if (istype(active1, /datum/data/record))
							var/t1 = sanitize(input("Please enter race:", "69eneral records", active1.fields69"species"69, null)  as69essa69e)
							if (!t1 || active1 != a1)
								return
							active1.fields69"species"69 = t1
					if("photo front")
						var/icon/photo = 69et_photo(usr)
						if(photo)
							active1.fields69"photo_front"69 = photo
					if("photo side")
						var/icon/photo = 69et_photo(usr)
						if(photo)
							active1.fields69"photo_side"69 = photo


//TEMPORARY69ENU FUNCTIONS
			else//To properly clear as per clear screen.
				temp=null
				switch(href_list69"choice"69)
					if ("Chan69e Rank")
						if (active1)
							active1.fields69"rank"69 = href_list69"rank"69
							if(href_list69"rank"69 in 69LOB.joblist)
								active1.fields69"real_rank"69 = href_list69"real_rank"69

					if ("Chan69e Criminal Status")
						if (active2)
							for(var/mob/livin69/carbon/human/H in 69LOB.player_list)
								BITSET(H.hud_updatefla69, WANTED_HUD)
							switch(href_list69"criminal2"69)
								if("none")
									active2.fields69"criminal"69 = "None"
								if("arrest")
									active2.fields69"criminal"69 = "*Arrest*"
								if("incarcerated")
									active2.fields69"criminal"69 = "Incarcerated"
								if("parolled")
									active2.fields69"criminal"69 = "Parolled"
								if("released")
									active2.fields69"criminal"69 = "Released"

					if ("Delete Record (Security) Execute")
						if (active2)
							69del(active2)

					if ("Delete Record (ALL) Execute")
						if (active1)
							for(var/datum/data/record/R in data_core.medical)
								if ((R.fields69"name"69 == active1.fields69"name"69 || R.fields69"id"69 == active1.fields69"id"69))
									69del(R)
								else
							69del(active1)
						if (active2)
							69del(active2)
					else
						temp = "This function does not appear to be workin69 at the69oment. Our apolo69ies."

	add_fin69erprint(usr)
	updateUsrDialo69()
	return

/obj/machinery/computer/secure_data/proc/is_not_allowed(var/mob/user)
	return !src.authenticated || user.stat || user.restrained() || (!in_ran69e(src, user) && (!issilicon(user)))

/obj/machinery/computer/secure_data/proc/69et_photo(var/mob/user)
	if(istype(user.69et_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.69et_active_hand()
		return photo.im69
	if(issilicon(user))
		var/mob/livin69/silicon/tempAI = usr
		var/obj/item/photo/selection = tempAI.69etPicture()
		if (selection)
			return selection.im69

/obj/machinery/computer/secure_data/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for(var/datum/data/record/R in data_core.security)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.fields69"name"69 = "69pick(pick(69LOB.first_names_male), pick(69LOB.first_names_female))69 69pick(69LOB.last_names)69"
				if(2)
					R.fields69"sex"69	= pick("Male", "Female")
				if(3)
					R.fields69"a69e"69 = rand(5, 85)
				if(4)
					R.fields69"criminal"69 = pick("None", "*Arrest*", "Incarcerated", "Parolled", "Released")
				if(5)
					R.fields69"p_stat"69 = pick("*Unconcious*", "Active", "Physically Unfit")
					if(PDA_Manifest.len)
						PDA_Manifest.Cut()
				if(6)
					R.fields69"m_stat"69 = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			69del(R)
			continue

	..(severity)

/obj/machinery/computer/secure_data/detective_computer
	icon = 'icons/obj/computer.dmi'
	icon_state = "messyfiles"
