//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/med_data//TODO:SANITY
	name = "medical records console"
	desc = "Used to69iew, edit and69aintain69edical records."
	icon_keyboard = "med_key"
	icon_screen = "medcomp"
	li69ht_color = COLOR_LI69HTIN69_69REEN_MACHINERY
	re69_one_access = list(access_moebius, access_forensics_lockers)
	circuit = /obj/item/electronics/circuitboard/med_data
	var/obj/item/card/id/scan
	var/authenticated
	var/rank
	var/screen
	var/datum/data/record/active1
	var/datum/data/record/active2
	var/a_id
	var/temp
	var/printin69

/obj/machinery/computer/med_data/verb/eject_id()
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

/obj/machinery/computer/med_data/attackby(var/obj/item/O,69ar/mob/user)
	if(istype(O, /obj/item/card/id) && !scan && user.unE69uip(O))
		O.loc = src
		scan = O
		to_chat(user, "You insert \the 69O69.")
	else
		..()

/obj/machinery/computer/med_data/attack_hand(mob/user as69ob)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/med_data/ui_interact(mob/user)
	var/dat
	if (src.temp)
		dat = text("<TT>69src.temp69</TT><BR><BR><A href='?src=\ref69src69;temp=1'>Clear Screen</A>")
	else
		dat = text("Confirm Identity: <A href='?src=\ref6969;scan=1'>6969</A><HR>", src, (src.scan ? text("6969", src.scan.name) : "----------"))
		if (src.authenticated)
			switch(src.screen)
				if(1)
					dat += {"
<A href='?src=\ref69src69;search=1'>Search Records</A>
<BR><A href='?src=\ref69src69;screen=2'>List Records</A>
<BR>
<BR><A href='?src=\ref69src69;screen=5'>Virus Database</A>
<BR><A href='?src=\ref69src69;screen=6'>Medbot Trackin69</A>
<BR>
<BR><A href='?src=\ref69src69;screen=3'>Record69aintenance</A>
<BR><A href='?src=\ref69src69;lo69out=1'>{Lo69 Out}</A><BR>
"}
				if(2)
					dat += "<B>Record List</B>:<HR>"
					if(!isnull(data_core.69eneral))
						for(var/datum/data/record/R in sortRecord(data_core.69eneral))
							dat += text("<A href='?src=\ref6969;d_rec=\ref6969'>6969: 6969<BR>", src, R, R.fields69"id"69, R.fields69"name"69)
							//Foreach 69oto(132)
					dat += text("<HR><A href='?src=\ref6969;screen=1'>Back</A>", src)
				if(3)
					dat += text("<B>Records69aintenance</B><HR>\n<A href='?src=\ref6969;back=1'>Backup To Disk</A><BR>\n<A href='?src=\ref6969;u_load=1'>Upload From disk</A><BR>\n<A href='?src=\ref6969;del_all=1'>Delete All Records</A><BR>\n<BR>\n<A href='?src=\ref6969;screen=1'>Back</A>", src, src, src, src)
				if(4)
					var/icon/front = active1.fields69"photo_front"69
					var/icon/side = active1.fields69"photo_side"69
					user << browse_rsc(front, "front.pn69")
					user << browse_rsc(side, "side.pn69")
					dat += "<CENTER><B>Medical Record</B></CENTER><BR>"
					if ((istype(src.active1, /datum/data/record) && data_core.69eneral.Find(src.active1)))
						dat += "<table><tr><td>Name: 69active1.fields69"name"6969 \
								ID: 69active1.fields69"id"6969<BR>\n	\
								Sex: <A href='?src=\ref69src69;field=sex'>69active1.fields69"sex"6969</A><BR>\n	\
								A69e: <A href='?src=\ref69src69;field=a69e'>69active1.fields69"a69e"6969</A><BR>\n	\
								Fin69erprint: <A href='?src=\ref69src69;field=fin69erprint'>69active1.fields69"fin69erprint"6969</A><BR>\n	\
								Physical Status: <A href='?src=\ref69src69;field=p_stat'>69active1.fields69"p_stat"6969</A><BR>\n	\
								Mental Status: <A href='?src=\ref69src69;field=m_stat'>69active1.fields69"m_stat"6969</A><BR></td><td ali69n = center69ali69n = top> \
								Photo:<br><im69 src=front.pn69 hei69ht=64 width=64 border=5><im69 src=side.pn69 hei69ht=64 width=64 border=5></td></tr></table>"
					else
						dat += "<B>69eneral Record Lost!</B><BR>"
					if ((istype(src.active2, /datum/data/record) && data_core.medical.Find(src.active2)))
						dat += text("<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: <A href='?src=\ref6969;field=b_type'>6969</A><BR>\nDNA: <A href='?src=\ref6969;field=b_dna'>6969</A><BR>\n<BR>\nMinor Disabilities: <A href='?src=\ref6969;field=mi_dis'>6969</A><BR>\nDetails: <A href='?src=\ref6969;field=mi_dis_d'>6969</A><BR>\n<BR>\nMajor Disabilities: <A href='?src=\ref6969;field=ma_dis'>6969</A><BR>\nDetails: <A href='?src=\ref6969;field=ma_dis_d'>6969</A><BR>\n<BR>\nAller69ies: <A href='?src=\ref6969;field=al69'>6969</A><BR>\nDetails: <A href='?src=\ref6969;field=al69_d'>6969</A><BR>\n<BR>\nCurrent Diseases: <A href='?src=\ref6969;field=cdi'>6969</A> (per disease info placed in lo69/comment section)<BR>\nDetails: <A href='?src=\ref6969;field=cdi_d'>6969</A><BR>\n<BR>\nImportant Notes:<BR>\n\t<A href='?src=\ref6969;field=notes'>6969</A><BR>\n<BR>\n<CENTER><B>Comments/Lo69</B></CENTER><BR>", src, src.active2.fields69"b_type"69, src, src.active2.fields69"b_dna"69, src, src.active2.fields69"mi_dis"69, src, src.active2.fields69"mi_dis_d"69, src, src.active2.fields69"ma_dis"69, src, src.active2.fields69"ma_dis_d"69, src, src.active2.fields69"al69"69, src, src.active2.fields69"al69_d"69, src, src.active2.fields69"cdi"69, src, src.active2.fields69"cdi_d"69, src, decode(src.active2.fields69"notes"69))
						var/counter = 1
						while(src.active2.fields69text("com_6969", counter)69)
							dat += text("6969<BR><A href='?src=\ref6969;del_c=6969'>Delete Entry</A><BR><BR>", src.active2.fields69text("com_6969", counter)69, src, counter)
							counter++
						dat += text("<A href='?src=\ref6969;add_c=1'>Add Entry</A><BR><BR>", src)
						dat += text("<A href='?src=\ref6969;del_r=1'>Delete Record (Medical Only)</A><BR><BR>", src)
					else
						dat += "<B>Medical Record Lost!</B><BR>"
						dat += text("<A href='?src=\ref69src69;new=1'>New Record</A><BR><BR>")
					dat += text("\n<A href='?src=\ref6969;print_p=1'>Print Record</A><BR>\n<A href='?src=\ref6969;screen=2'>Back</A><BR>", src, src)
				if(5)
					dat += "<CENTER><B>Virus Database</B></CENTER>"
					/*	Advanced diseases is weak! Feeble! 69lory to69irus2!
					for(var/Dt in typesof(/datum/disease/))
						var/datum/disease/Dis = new Dt(0)
						if(istype(Dis, /datum/disease/advance))
							continue // TODO (tm): Add advance diseases to the69irus database which no one uses.
						if(!Dis.desc)
							continue
						dat += "<br><a href='?src=\ref69src69;vir=69Dt69'>69Dis.name69</a>"
					*/
					for (var/ID in69irusDB)
						var/datum/data/record/v =69irusDB69ID69
						dat += "<br><a href='?src=\ref69src69;vir=\ref69v69'>69v.fields69"name"6969</a>"

					dat += "<br><a href='?src=\ref69src69;screen=1'>Back</a>"
				if(6)
					dat += "<center><b>Medical Robot69onitor</b></center>"
					dat += "<a href='?src=\ref69src69;screen=1'>Back</a>"
					dat += "<br><b>Medical Robots:</b>"
					var/bdat
					for(var/mob/livin69/bot/medbot/M in world)

						if(M.z != src.z)	continue	//only find69edibots on the same z-level as the computer
						var/turf/bl = 69et_turf(M)
						if(bl)	//if it can't find a turf for the69edibot, then it probably shouldn't be showin69 up
							bdat += "69M.name69 - <b>\6969bl.x69,69bl.y69\69</b> - 69M.on ? "Online" : "Offline"69<br>"
							if((!isnull(M.rea69ent_69lass)) &&69.use_beaker)
								bdat += "Reservoir: \6969M.rea69ent_69lass.rea69ents.total_volume69/69M.rea69ent_69lass.rea69ents.maximum_volume69\69<br>"
							else
								bdat += "Usin69 Internal Synthesizer.<br>"
					if(!bdat)
						dat += "<br><center>None detected</center>"
					else
						dat += "<br>69bdat69"

				else
		else
			dat += text("<A href='?src=\ref6969;lo69in=1'>{Lo69 In}</A>", src)
	user << browse(text("<HEAD><TITLE>Medical Records</TITLE></HEAD><TT>6969</TT>", dat), "window=med_rec")
	onclose(user, "med_rec")
	return

/obj/machinery/computer/med_data/Topic(href, href_list)
	if(..())
		return 1

	if (!( data_core.69eneral.Find(src.active1) ))
		src.active1 = null

	if (!( data_core.medical.Find(src.active2) ))
		src.active2 = null

	if ((usr.contents.Find(src) || (in_ran69e(src, usr) && istype(src.loc, /turf))) || (issilicon(usr)))
		usr.set_machine(src)

		if (href_list69"temp"69)
			src.temp = null

		if (href_list69"scan"69)
			if (src.scan)

				if(ishuman(usr))
					scan.loc = usr.loc

					if(!usr.69et_active_hand())
						usr.put_in_hands(scan)

					scan = null

				else
					src.scan.loc = src.loc
					src.scan = null

			else
				var/obj/item/I = usr.69et_active_hand()
				if (istype(I, /obj/item/card/id))
					usr.drop_item()
					I.loc = src
					src.scan = I

		else if (href_list69"lo69out"69)
			src.authenticated = null
			src.screen = null
			src.active1 = null
			src.active2 = null

		else if (href_list69"lo69in"69)

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

			else if (istype(src.scan, /obj/item/card/id))
				src.active1 = null
				src.active2 = null

				if (src.check_access(src.scan))
					src.authenticated = src.scan.re69istered_name
					src.rank = src.scan.assi69nment
					src.screen = 1

		if (src.authenticated)

			if(href_list69"screen"69)
				src.screen = text2num(href_list69"screen"69)
				if(src.screen < 1)
					src.screen = 1

				src.active1 = null
				src.active2 = null

			if(href_list69"vir"69)
				var/datum/data/record/v = locate(href_list69"vir"69)
				src.temp = "<center>69NAv2 based69irus lifeform69-69v.fields69"id"6969</center>"
				src.temp += "<br><b>Name:</b> <A href='?src=\ref69src69;field=vir_name;edit_vir=\ref69v69'>69v.fields69"name"6969</A>"
				src.temp += "<br><b>Anti69en:</b> 69v.fields69"anti69en"6969"
				src.temp += "<br><b>Spread:</b> 69v.fields69"spread type"6969 "
				src.temp += "<br><b>Details:</b><br> <A href='?src=\ref69src69;field=vir_desc;edit_vir=\ref69v69'>69v.fields69"description"6969</A>"

			if (href_list69"del_all"69)
				src.temp = text("Are you sure you wish to delete all records?<br>\n\t<A href='?src=\ref6969;temp=1;del_all2=1'>Yes</A><br>\n\t<A href='?src=\ref6969;temp=1'>No</A><br>", src, src)

			if (href_list69"del_all2"69)
				for(var/datum/data/record/R in data_core.medical)
					//R = null
					69del(R)
					//Foreach 69oto(494)
				src.temp = "All records deleted."

			if (href_list69"field"69)
				var/a1 = src.active1
				var/a2 = src.active2
				switch(href_list69"field"69)
					if("fin69erprint")
						if (istype(src.active1, /datum/data/record))
							var/t1 = sanitize(input("Please input fin69erprint hash:", "Med. records", src.active1.fields69"fin69erprint"69, null)  as text)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active1 != a1))
								return
							src.active1.fields69"fin69erprint"69 = t1
					if("sex")
						if (istype(src.active1, /datum/data/record))
							if (src.active1.fields69"sex"69 == "Male")
								src.active1.fields69"sex"69 = "Female"
							else
								src.active1.fields69"sex"69 = "Male"
					if("a69e")
						if (istype(src.active1, /datum/data/record))
							var/t1 = input("Please input a69e:", "Med. records", src.active1.fields69"a69e"69, null)  as num
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active1 != a1))
								return
							src.active1.fields69"a69e"69 = t1
					if("mi_dis")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please input69inor disabilities list:", "Med. records", src.active2.fields69"mi_dis"69, null)  as text)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"mi_dis"69 = t1
					if("mi_dis_d")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please summarize69inor dis.:", "Med. records", src.active2.fields69"mi_dis_d"69, null)  as69essa69e)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"mi_dis_d"69 = t1
					if("ma_dis")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please input69ajor diabilities list:", "Med. records", src.active2.fields69"ma_dis"69, null)  as text)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"ma_dis"69 = t1
					if("ma_dis_d")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please summarize69ajor dis.:", "Med. records", src.active2.fields69"ma_dis_d"69, null)  as69essa69e)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"ma_dis_d"69 = t1
					if("al69")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please state aller69ies:", "Med. records", src.active2.fields69"al69"69, null)  as text)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"al69"69 = t1
					if("al69_d")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please summarize aller69ies:", "Med. records", src.active2.fields69"al69_d"69, null)  as69essa69e)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"al69_d"69 = t1
					if("cdi")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please state diseases:", "Med. records", src.active2.fields69"cdi"69, null)  as text)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"cdi"69 = t1
					if("cdi_d")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please summarize diseases:", "Med. records", src.active2.fields69"cdi_d"69, null)  as69essa69e)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"cdi_d"69 = t1
					if("notes")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please summarize notes:", "Med. records", html_decode(src.active2.fields69"notes"69), null)  as69essa69e, extra = 0)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"notes"69 = t1
					if("p_stat")
						if (istype(src.active1, /datum/data/record))
							src.temp = text("<B>Physical Condition:</B><BR>\n\t<A href='?src=\ref6969;temp=1;p_stat=deceased'>*Deceased*</A><BR>\n\t<A href='?src=\ref6969;temp=1;p_stat=ssd'>*SSD*</A><BR>\n\t<A href='?src=\ref6969;temp=1;p_stat=active'>Active</A><BR>\n\t<A href='?src=\ref6969;temp=1;p_stat=unfit'>Physically Unfit</A><BR>\n\t<A href='?src=\ref6969;temp=1;p_stat=disabled'>Disabled</A><BR>", src, src, src, src, src)
					if("m_stat")
						if (istype(src.active1, /datum/data/record))
							src.temp = text("<B>Mental Condition:</B><BR>\n\t<A href='?src=\ref6969;temp=1;m_stat=insane'>*Insane*</A><BR>\n\t<A href='?src=\ref6969;temp=1;m_stat=unstable'>*Unstable*</A><BR>\n\t<A href='?src=\ref6969;temp=1;m_stat=watch'>*Watch*</A><BR>\n\t<A href='?src=\ref6969;temp=1;m_stat=stable'>Stable</A><BR>", src, src, src, src)
					if("b_type")
						if (istype(src.active2, /datum/data/record))
							src.temp = text("<B>Blood Type:</B><BR>\n\t<A href='?src=\ref6969;temp=1;b_type=an'>A-</A> <A href='?src=\ref6969;temp=1;b_type=ap'>A+</A><BR>\n\t<A href='?src=\ref6969;temp=1;b_type=bn'>B-</A> <A href='?src=\ref6969;temp=1;b_type=bp'>B+</A><BR>\n\t<A href='?src=\ref6969;temp=1;b_type=abn'>AB-</A> <A href='?src=\ref6969;temp=1;b_type=abp'>AB+</A><BR>\n\t<A href='?src=\ref6969;temp=1;b_type=on'>O-</A> <A href='?src=\ref6969;temp=1;b_type=op'>O+</A><BR>", src, src, src, src, src, src, src, src)
					if("b_dna")
						if (istype(src.active2, /datum/data/record))
							var/t1 = sanitize(input("Please input DNA hash:", "Med. records", src.active2.fields69"b_dna"69, null)  as text)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
								return
							src.active2.fields69"b_dna"69 = t1
					if("vir_name")
						var/datum/data/record/v = locate(href_list69"edit_vir"69)
						if (v)
							var/t1 = sanitize(input("Please input patho69en name:", "VirusDB",69.fields69"name"69, null)  as text)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active1 != a1))
								return
							v.fields69"name"69 = t1
					if("vir_desc")
						var/datum/data/record/v = locate(href_list69"edit_vir"69)
						if (v)
							var/t1 = sanitize(input("Please input information about patho69en:", "VirusDB",69.fields69"description"69, null)  as69essa69e)
							if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active1 != a1))
								return
							v.fields69"description"69 = t1
					else

			if (href_list69"p_stat"69)
				if (src.active1)
					switch(href_list69"p_stat"69)
						if("deceased")
							src.active1.fields69"p_stat"69 = "*Deceased*"
						if("ssd")
							src.active1.fields69"p_stat"69 = "*SSD*"
						if("active")
							src.active1.fields69"p_stat"69 = "Active"
						if("unfit")
							src.active1.fields69"p_stat"69 = "Physically Unfit"
						if("disabled")
							src.active1.fields69"p_stat"69 = "Disabled"
					if(PDA_Manifest.len)
						PDA_Manifest.Cut()

			if (href_list69"m_stat"69)
				if (src.active1)
					switch(href_list69"m_stat"69)
						if("insane")
							src.active1.fields69"m_stat"69 = "*Insane*"
						if("unstable")
							src.active1.fields69"m_stat"69 = "*Unstable*"
						if("watch")
							src.active1.fields69"m_stat"69 = "*Watch*"
						if("stable")
							src.active1.fields69"m_stat"69 = "Stable"


			if (href_list69"b_type"69)
				if (src.active2)
					switch(href_list69"b_type"69)
						if("an")
							src.active2.fields69"b_type"69 = "A-"
						if("bn")
							src.active2.fields69"b_type"69 = "B-"
						if("abn")
							src.active2.fields69"b_type"69 = "AB-"
						if("on")
							src.active2.fields69"b_type"69 = "O-"
						if("ap")
							src.active2.fields69"b_type"69 = "A+"
						if("bp")
							src.active2.fields69"b_type"69 = "B+"
						if("abp")
							src.active2.fields69"b_type"69 = "AB+"
						if("op")
							src.active2.fields69"b_type"69 = "O+"


			if (href_list69"del_r"69)
				if (src.active2)
					src.temp = text("Are you sure you wish to delete the record (Medical Portion Only)?<br>\n\t<A href='?src=\ref6969;temp=1;del_r2=1'>Yes</A><br>\n\t<A href='?src=\ref6969;temp=1'>No</A><br>", src, src)

			if (href_list69"del_r2"69)
				if (src.active2)
					//src.active2 = null
					69del(src.active2)

			if (href_list69"d_rec"69)
				var/datum/data/record/R = locate(href_list69"d_rec"69)
				var/datum/data/record/M = locate(href_list69"d_rec"69)
				if (!( data_core.69eneral.Find(R) ))
					src.temp = "Record Not Found!"
					return
				for(var/datum/data/record/E in data_core.medical)
					if ((E.fields69"name"69 == R.fields69"name"69 || E.fields69"id"69 == R.fields69"id"69))
						M = E
					else
						//Foreach continue //69oto(2540)
				src.active1 = R
				src.active2 =69
				src.screen = 4

			if (href_list69"new"69)
				if ((istype(src.active1, /datum/data/record) && !( istype(src.active2, /datum/data/record) )))
					var/datum/data/record/R = new /datum/data/record(  )
					R.fields69"name"69 = src.active1.fields69"name"69
					R.fields69"id"69 = src.active1.fields69"id"69
					R.name = text("Medical Record #6969", R.fields69"id"69)
					R.fields69"b_type"69 = "Unknown"
					R.fields69"b_dna"69 = "Unknown"
					R.fields69"mi_dis"69 = "None"
					R.fields69"mi_dis_d"69 = "No69inor disabilities have been declared."
					R.fields69"ma_dis"69 = "None"
					R.fields69"ma_dis_d"69 = "No69ajor disabilities have been dia69nosed."
					R.fields69"al69"69 = "None"
					R.fields69"al69_d"69 = "No aller69ies have been detected in this patient."
					R.fields69"cdi"69 = "None"
					R.fields69"cdi_d"69 = "No diseases have been dia69nosed at the69oment."
					R.fields69"notes"69 = "No notes."
					data_core.medical += R
					src.active2 = R
					src.screen = 4

			if (href_list69"add_c"69)
				if (!( istype(src.active2, /datum/data/record) ))
					return
				var/a2 = src.active2
				var/t1 = sanitize(input("Add Comment:", "Med. records", null, null)  as69essa69e)
				if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_ran69e(src, usr) && (!issilicon(usr))) || src.active2 != a2))
					return
				var/counter = 1
				while(src.active2.fields69text("com_6969", counter)69)
					counter++
				src.active2.fields69text("com_69counter69")69 = text("Made by 69authenticated69 (69rank69) on 69time2text(world.realtime, "DDD69MM DD")69 69stationtime2text()69, 6969ame_year69<BR>69t169")

			if (href_list69"del_c"69)
				if ((istype(src.active2, /datum/data/record) && src.active2.fields69text("com_6969", href_list69"del_c"69)69))
					src.active2.fields69text("com_6969", href_list69"del_c"69)69 = "<B>Deleted</B>"

			if (href_list69"search"69)
				var/t1 = input("Search Strin69: (Name, DNA, or ID)", "Med. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( src.authenticated ) || usr.restrained() || ((!in_ran69e(src, usr)) && (!issilicon(usr)))))
					return
				src.active1 = null
				src.active2 = null
				t1 = lowertext(t1)
				for(var/datum/data/record/R in data_core.medical)
					if ((lowertext(R.fields69"name"69) == t1 || t1 == lowertext(R.fields69"id"69) || t1 == lowertext(R.fields69"b_dna"69)))
						src.active2 = R
					else
						//Foreach continue //69oto(3229)
				if (!( src.active2 ))
					src.temp = text("Could not locate record 6969.", t1)
				else
					for(var/datum/data/record/E in data_core.69eneral)
						if ((E.fields69"name"69 == src.active2.fields69"name"69 || E.fields69"id"69 == src.active2.fields69"id"69))
							src.active1 = E
						else
							//Foreach continue //69oto(3334)
					src.screen = 4

			if (href_list69"print_p"69)
				if (!( src.printin69 ))
					src.printin69 = 1
					var/datum/data/record/record1
					var/datum/data/record/record2
					if ((istype(src.active1, /datum/data/record) && data_core.69eneral.Find(src.active1)))
						record1 = active1
					if ((istype(src.active2, /datum/data/record) && data_core.medical.Find(src.active2)))
						record2 = active2
					sleep(50)
					var/obj/item/paper/P = new /obj/item/paper( src.loc )
					P.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
					if (record1)
						P.info += text("Name: 6969 ID: 6969<BR>\nSex: 6969<BR>\nA69e: 6969<BR>\nFin69erprint: 6969<BR>\nPhysical Status: 6969<BR>\nMental Status: 6969<BR>", record1.fields69"name"69, record1.fields69"id"69, record1.fields69"sex"69, record1.fields69"a69e"69, record1.fields69"fin69erprint"69, record1.fields69"p_stat"69, record1.fields69"m_stat"69)
						P.name = text("Medical Record (6969)", record1.fields69"name"69)
					else
						P.info += "<B>69eneral Record Lost!</B><BR>"
						P.name = "Medical Record"
					if (record2)
						P.info += text("<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: 6969<BR>\nDNA: 6969<BR>\n<BR>\nMinor Disabilities: 6969<BR>\nDetails: 6969<BR>\n<BR>\nMajor Disabilities: 6969<BR>\nDetails: 6969<BR>\n<BR>\nAller69ies: 6969<BR>\nDetails: 6969<BR>\n<BR>\nCurrent Diseases: 6969 (per disease info placed in lo69/comment section)<BR>\nDetails: 6969<BR>\n<BR>\nImportant Notes:<BR>\n\t6969<BR>\n<BR>\n<CENTER><B>Comments/Lo69</B></CENTER><BR>", record2.fields69"b_type"69, record2.fields69"b_dna"69, record2.fields69"mi_dis"69, record2.fields69"mi_dis_d"69, record2.fields69"ma_dis"69, record2.fields69"ma_dis_d"69, record2.fields69"al69"69, record2.fields69"al69_d"69, record2.fields69"cdi"69, record2.fields69"cdi_d"69, decode(record2.fields69"notes"69))
						var/counter = 1
						while(record2.fields69text("com_6969", counter)69)
							P.info += text("6969<BR>", record2.fields69text("com_6969", counter)69)
							counter++
					else
						P.info += "<B>Medical Record Lost!</B><BR>"
					P.info += "</TT>"
					src.printin69 = null

	src.add_fin69erprint(usr)
	src.updateUsrDialo69()
	return

/obj/machinery/computer/med_data/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for(var/datum/data/record/R in data_core.medical)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.fields69"name"69 = "69pick(pick(69LOB.first_names_male), pick(69LOB.first_names_female))69 69pick(69LOB.last_names)69"
				if(2)
					R.fields69"sex"69	= pick("Male", "Female")
				if(3)
					R.fields69"a69e"69 = rand(5, 85)
				if(4)
					R.fields69"b_type"69 = pick("A-", "B-", "AB-", "O-", "A+", "B+", "AB+", "O+")
				if(5)
					R.fields69"p_stat"69 = pick("*SSD*", "Active", "Physically Unfit", "Disabled")
					if(PDA_Manifest.len)
						PDA_Manifest.Cut()
				if(6)
					R.fields69"m_stat"69 = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			69del(R)
			continue

	..(severity)


/obj/machinery/computer/med_data/laptop
	name = "Medical Laptop"
	desc = "A cheap laptop."
	icon_state = "laptop"
	icon_keyboard = "laptop_key"
	icon_screen = "medlaptop"
	CheckFaceFla69 = 0
