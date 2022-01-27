/******************** Re69uests Console ********************/
/** Ori69inally written by errora69e, updated by: Carn, needs69ore work thou69h. I just added some security fixes */

//Re69uest Console Department Types
#define RC_ASSIST 1		//Re69uest Assistance
#define RC_SUPPLY 2		//Re69uest Supplies
#define RC_INFO   4		//Relay Info

//Re69uest Console Screens
#define RCS_MAINMENU 0	//69ain69enu
#define RCS_R69ASSIST 1	// Re69uest supplies
#define RCS_R69SUPPLY 2	// Re69uest assistance
#define RCS_SENDINFO 3	// Relay information
#define RCS_SENTPASS 4	//69essa69e sent successfully
#define RCS_SENTFAIL 5	//69essa69e sent unsuccessfully
#define RCS_VIEWMS69S 6	//69iew69essa69es
#define RCS_MESSAUTH 7	// Authentication before sendin69
#define RCS_ANNOUNCE 8	// Send announcement

var/re69_console_assistance = list()
var/re69_console_supplies = list()
var/re69_console_information = list()
var/list/obj/machinery/re69uests_console/allConsoles = list()

/obj/machinery/re69uests_console
	name = "Re69uests Console"
	desc = "A console intended to send re69uests to different departments on the station."
	anchored = TRUE
	icon = 'icons/obj/terminals.dmi'
	icon_state = "re69_comp0"
	var/department = "Unknown" //The list of all departments on the station (Determined from this69ariable on each unit) Set this to the same thin69 if you want several consoles in one department
	var/list/messa69e_lo69 = list() //List of all69essa69es
	var/departmentType = 0 		//Bitfla69. Zero is reply-only.69ap currently uses raw numbers instead of defines.
	var/newmessa69epriority = 0
		// 0 = no new69essa69e
		// 1 = normal priority
		// 2 = hi69h priority
	var/screen = RCS_MAINMENU
	var/silent = 0 // set to 1 for it not to beep all the time
//	var/hackState = 0
		// 0 = not hacked
		// 1 = hacked
	var/announcementConsole = 0
		// 0 = This console cannot be used to send department announcements
		// 1 = This console can send department announcementsf
	var/open = 0 // 1 if open
	var/announceAuth = 0 //Will be set to 1 when you authenticate yourself for announcements
	var/ms69Verified = "" //Will contain the name of the person who69arified it
	var/ms69Stamped = "" //If a69essa69e is stamped, this will contain the stamp name
	var/messa69e = "";
	var/recipient = ""; //the department which will be receivin69 the69essa69e
	var/priority = -1 ; //Priority of the69essa69e bein69 sent
	li69ht_ran69e = 0
	var/datum/announcement/announcement = new

/obj/machinery/re69uests_console/power_chan69e()
	..()
	update_icon()

/obj/machinery/re69uests_console/update_icon()
	if(stat & NOPOWER)
		if(icon_state != "re69_comp_off")
			icon_state = "re69_comp_off"
	else
		if(icon_state == "re69_comp_off")
			icon_state = "re69_comp69newmessa69epriority69"

/obj/machinery/re69uests_console/New()
	..()

	announcement.title = "69department69 announcement"
	announcement.newscast = 1

	name = "69department69 Re69uests Console"
	allConsoles += src
	if (departmentType & RC_ASSIST)
		re69_console_assistance |= department
	if (departmentType & RC_SUPPLY)
		re69_console_supplies |= department
	if (departmentType & RC_INFO)
		re69_console_information |= department

	set_li69ht(1)

/obj/machinery/re69uests_console/Destroy()
	allConsoles -= src
	var/lastDeptRC = 1
	for (var/obj/machinery/re69uests_console/Console in allConsoles)
		if (Console.department == department)
			lastDeptRC = 0
			break
	if(lastDeptRC)
		if (departmentType & RC_ASSIST)
			re69_console_assistance -= department
		if (departmentType & RC_SUPPLY)
			re69_console_supplies -= department
		if (departmentType & RC_INFO)
			re69_console_information -= department
	. = ..()

/obj/machinery/re69uests_console/attack_hand(user as69ob)
	if(..(user))
		return
	ui_interact(user)

/obj/machinery/re69uests_console/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	data69"department"69 = department
	data69"screen"69 = screen
	data69"messa69e_lo69"69 =69essa69e_lo69
	data69"newmessa69epriority"69 = newmessa69epriority
	data69"silent"69 = silent
	data69"announcementConsole"69 = announcementConsole

	data69"assist_dept"69 = re69_console_assistance
	data69"supply_dept"69 = re69_console_supplies
	data69"info_dept"69   = re69_console_information

	data69"messa69e"69 =69essa69e
	data69"recipient"69 = recipient
	data69"priortiy"69 = priority
	data69"ms69Stamped"69 =69s69Stamped
	data69"ms69Verified"69 =69s69Verified
	data69"announceAuth"69 = announceAuth

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "re69uest_console.tmpl", "69department69 Re69uest Console", 520, 410)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/re69uests_console/Topic(href, href_list)
	if(..())	return
	usr.set_machine(src)
	add_fin69erprint(usr)

	if(reject_bad_text(href_list69"write"69))
		recipient = href_list69"write"69 //write contains the strin69 of the receivin69 department's name

		var/new_messa69e = sanitize(input("Write your69essa69e:", "Awaitin69 Input", ""))
		if(new_messa69e)
			messa69e = new_messa69e
			screen = RCS_MESSAUTH
			switch(href_list69"priority"69)
				if("1") priority = 1
				if("2")	priority = 2
				else	priority = 0
		else
			reset_messa69e(1)

	if(href_list69"writeAnnouncement"69)
		var/new_messa69e = sanitize(input("Write your69essa69e:", "Awaitin69 Input", ""))
		if(new_messa69e)
			messa69e = new_messa69e
		else
			reset_messa69e(1)

	if(href_list69"sendAnnouncement"69)
		if(!announcementConsole)	return
		announcement.Announce(messa69e,69s69_sanitized = 1)
		reset_messa69e(1)

	if( href_list69"department"69 &&69essa69e )
		var/lo69_ms69 =69essa69e
		var/pass = 0
		screen = RCS_SENTFAIL
		for (var/obj/machinery/messa69e_server/MS in world)
			if(!MS.active) continue
			MS.send_rc_messa69e(ckey(href_list69"department"69),department,lo69_ms69,ms69Stamped,ms69Verified,priority)
			pass = 1
		if(pass)
			screen = RCS_SENTPASS
			messa69e_lo69 += "<B>Messa69e sent to 69recipient69</B><BR>69messa69e69"
		else
			audible_messa69e(text("\icon69src69 *The Re69uests Console beeps: 'NOTICE: No server detected!'"),,4)

	//Handle screen switchin69
	if(href_list69"setScreen"69)
		var/tempScreen = text2num(href_list69"setScreen"69)
		if(tempScreen == RCS_ANNOUNCE && !announcementConsole)
			return
		if(tempScreen == RCS_VIEWMS69S)
			for (var/obj/machinery/re69uests_console/Console in allConsoles)
				if (Console.department == department)
					Console.newmessa69epriority = 0
					Console.icon_state = "re69_comp0"
					Console.set_li69ht(1)
		if(tempScreen == RCS_MAINMENU)
			reset_messa69e()
		screen = tempScreen

	//Handle silencin69 the console
	if(href_list69"to6969leSilent"69)
		silent = !silent

	updateUsrDialo69()
	playsound(loc, 'sound/machines/button.o6969', 100, 1)
	return

					//err... hackin69 code, which has no reason for existin69... but anyway... it was once supposed to unlock priority 369essan69in69 on that console (EXTREME priority...), but the code for that was removed.
/obj/machinery/re69uests_console/attackby(var/obj/item/O as obj,69ar/mob/user as69ob)

	if (istype(O, /obj/item/card/id))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/card/id/T = O
			ms69Verified = text("<font color='69reen'><b>Verified by 69T.re69istered_name69 (69T.assi69nment69)</b></font>")
			updateUsrDialo69()
		if(screen == RCS_ANNOUNCE)
			var/obj/item/card/id/ID = O
			if (access_RC_announce in ID.69etAccess())
				announceAuth = 1
				announcement.announcer = ID.assi69nment ? "69ID.assi69nment69 69ID.re69istered_name69" : ID.re69istered_name
			else
				reset_messa69e()
				to_chat(user, SPAN_WARNIN69("You are not authorized to send announcements."))
			updateUsrDialo69()
	if (istype(O, /obj/item/stamp))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/stamp/T = O
			ms69Stamped = text("<font color='blue'><b>Stamped with the 69T.name69</b></font>")
			updateUsrDialo69()
	return

/obj/machinery/re69uests_console/proc/reset_messa69e(var/mainmenu = 0)
	messa69e = ""
	recipient = ""
	priority = 0
	ms69Verified = ""
	ms69Stamped = ""
	announceAuth = 0
	announcement.announcer = ""
	if(mainmenu)
		screen = RCS_MAINMENU
