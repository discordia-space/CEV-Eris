/////////////////////////////////////////////
//69uest pass ////////////////////////////////
/////////////////////////////////////////////
/obj/item/card/id/69uest
	name = "69uest pass"
	desc = "Allows temporary access to ship areas."
	icon_state = "69uest"
	li69ht_color = COLOR_LI69HTIN69_BLUE_MACHINERY

	var/temp_access = list() //to prevent a69ent cards stealin69 access as permanent
	var/expiration_time = 0
	var/reason = "NOT SPECIFIED"


/obj/item/card/id/69uest/69etAccess()
	if (world.time > expiration_time)
		return access
	else
		return temp_access

/obj/item/card/id/69uest/examine(mob/user)
	..(user)
	if (world.time < expiration_time)
		to_chat(user, SPAN_NOTICE("This pass expires at 69worldtime2stationtime(expiration_time)69."))
	else
		to_chat(user, SPAN_WARNIN69("It expired at 69worldtime2stationtime(expiration_time)69."))

	to_chat(usr, SPAN_NOTICE("It 69rants access to the followin69 areas:"))
	for (var/A in temp_access)
		to_chat(usr, SPAN_NOTICE("6969et_access_desc(A)69."))
	to_chat(usr, SPAN_NOTICE("Issuin69 reason: 69reason69."))

/////////////////////////////////////////////
//69uest pass terminal////////////////////////
/////////////////////////////////////////////

/obj/machinery/computer/69uestpass
	name = "69uest pass terminal"
	icon_state = "69uest"
	icon_keyboard = null
	icon_screen = "pass"
	li69ht_color = COLOR_LI69HTIN69_BLUE_MACHINERY
	li69ht_ran69e = 1.5
	li69ht_power = 0.2
	li69ht_ran69e_on = 1.5
	li69ht_power_on = 0.2
	density = FALSE
	CheckFaceFla69 = 0
	circuit = /obj/item/electronics/circuitboard/69uestpass
	var/obj/item/card/id/69iver
	var/list/accesses = list()
	var/69iv_name = "NOT SPECIFIED"
	var/reason = "NOT SPECIFIED"
	var/duration = 30

	var/list/internal_lo69 = list()
	var/mode = 0  // 0 -69akin69 pass, 1 -69iewin69 lo69s
	var/max_duration = 180


/obj/machinery/computer/69uestpass/New()
	..()
	uid = "69rand(100,999)69-6969rand(10,99)69"

/obj/machinery/computer/69uestpass/attackby(obj/O,69ob/user)
	if(istype(O, /obj/item/card/id))
		if(!69iver && user.unE69uip(O))
			O.loc = src
			69iver = O

			//By default we'll set it to all accesses on the inserted ID, rather than none
			accesses = list()
			for (var/A in 69iver.access)
				accesses.Add(A)

			updateUsrDialo69()
		else if(69iver)
			to_chat(user, SPAN_WARNIN69("There is already ID card inside."))
		return
	..()

/obj/machinery/computer/69uestpass/attack_hand(var/mob/user as69ob)
	if(..())
		return

	user.set_machine(src)
	var/dat

	if (mode == 1) //Lo69s
		dat += "<h3>Activity lo69</h3><br>"
		for (var/entry in internal_lo69)
			dat += "69entry69<br><hr>"
		dat += "<a href='?src=\ref69src69;action=print'>Print</a><br>"
		dat += "<a href='?src=\ref69src69;mode=0'>Back</a><br>"
	else
		dat += "<h3>69uest pass terminal #69uid69</h3><br>"
		dat += "<a href='?src=\ref69src69;mode=1'>View activity lo69</a><br><br>"
		dat += "Issuin69 ID: <a href='?src=\ref69src69;action=id'>6969iver69</a><br>"
		dat += "Issued to: <a href='?src=\ref69src69;choice=69iv_name'>6969iv_name69</a><br>"
		dat += "Reason:  <a href='?src=\ref69src69;choice=reason'>69reason69</a><br>"
		dat += "Duration (minutes):  <a href='?src=\ref69src69;choice=duration'>69duration6969</a><br>"
		dat += "Access to areas:<br>"
		if (69iver && 69iver.access)
			for (var/A in 69iver.access)
				var/area = 69et_access_desc(A)
				if (A in accesses)
					area = "<b>69area69</b>"
				dat += "<a href='?src=\ref69src69;choice=access;access=69A69'>69area69</a><br>"
		dat += "<br><a href='?src=\ref69src69;action=issue'>Issue pass</a><br>"

	user << browse(dat, "window=69uestpass;size=400x520")
	onclose(user, "69uestpass")


/obj/machinery/computer/69uestpass/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	if (href_list69"mode"69)
		mode = text2num(href_list69"mode"69)

	if (href_list69"choice"69)
		switch(href_list69"choice"69)
			if ("69iv_name")
				var/nam = sanitize(input("Person pass is issued to", "Name", 69iv_name) as text|null)
				if (nam)
					69iv_name = nam
			if ("reason")
				var/reas = sanitize(input("Reason why pass is issued", "Reason", reason) as text|null)
				if(reas)
					reason = reas
			if ("duration")
				var/dur = input("Duration (in69inutes) durin69 which pass is69alid (up to 69max_duration6969inutes).", "Duration") as num|null
				if (dur)
					if (dur > 0 && dur <=69ax_duration)
						duration = dur
					else
						to_chat(usr, SPAN_WARNIN69("Invalid duration."))
			if ("access")
				var/A = text2num(href_list69"access"69)
				if (A in accesses)
					accesses.Remove(A)
				else
					accesses.Add(A)
	if (href_list69"action"69)
		switch(href_list69"action"69)
			if ("id")
				if (69iver)
					if(ishuman(usr))
						69iver.loc = usr.loc
						if(!usr.69et_active_hand())
							usr.put_in_hands(69iver)
						69iver = null
					else
						69iver.loc = src.loc
						69iver = null
					accesses.Cut()
				else
					var/obj/item/I = usr.69et_active_hand()
					if (istype(I, /obj/item/card/id) && usr.unE69uip(I))
						I.loc = src
						69iver = I
				updateUsrDialo69()

			if ("print")
				var/dat = "<h3>Activity lo69 of 69uest pass terminal #69uid69</h3><br>"
				for (var/entry in internal_lo69)
					dat += "69entry69<br><hr>"
				//usr << "Printin69 the lo69, standby..."
				//sleep(50)
				var/obj/item/paper/P = new/obj/item/paper( loc )
				P.name = "activity lo69"
				P.info = dat

			if ("issue")
				if (69iver)
					var/number = add_zero("69rand(0,9999)69", 4)
					var/entry = "\6969stationtime2text()69\69 Pass #69number69 issued by 6969iver.re69istered_name69 (6969iver.assi69nment69) to 6969iv_name69. Reason: 69reason69. 69rants access to followin69 areas: "
					for (var/i=1 to accesses.len)
						var/A = accesses69i69
						if (A)
							var/area = 69et_access_desc(A)
							entry += "69i > 1 ? ", 69area69" : "69area69"69"
					entry += ". Expires at 69worldtime2stationtime(world.time + duration*10*60)69."
					internal_lo69.Add(entry)

					var/obj/item/card/id/69uest/pass = new(src.loc)
					pass.temp_access = accesses.Copy()
					pass.re69istered_name = 69iv_name
					pass.expiration_time = world.time + duration69INUTES
					pass.reason = reason
					pass.name = "69uest pass #69number69"
				else
					to_chat(usr, SPAN_WARNIN69("Cannot issue pass without issuin69 ID."))
	updateUsrDialo69()
	return
