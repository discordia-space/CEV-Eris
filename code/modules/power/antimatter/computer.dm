//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:05
#define STATE_DEFAULT 1
#define STATE_INJECTOR  2
#define STATE_ENGINE 3


/obj/machinery/computer/am_engine
	name = "Antimatter Engine Console"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "comm_computer"
	req_access = list(ACCESS_ENGINE)
	var/engine_id = 0
	var/authenticated = 0
	var/obj/machinery/power/am_engine/engine/connected_E =69ull
	var/obj/machinery/power/am_engine/injector/connected_I =69ull
	var/state = STATE_DEFAULT

/obj/machinery/computer/am_engine/New()
	..()
	spawn( 24 )
		for(var/obj/machinery/power/am_engine/engine/E in world)
			if(E.engine_id == src.engine_id)
				src.connected_E = E
		for(var/obj/machinery/power/am_engine/injector/I in world)
			if(I.engine_id == src.engine_id)
				src.connected_I = I
	return

/obj/machinery/computer/am_engine/Topic(href, href_list)
	if(..())
		return
	usr.machine = src

	if(!href_list69"operation"69)
		return
	switch(href_list69"operation"69)
		//69ain interface
		if("activate")
			src.connected_E.engine_process()
		if("engine")
			src.state = STATE_ENGINE
		if("injector")
			src.state = STATE_INJECTOR
		if("main")
			src.state = STATE_DEFAULT
		if("login")
			var/mob/M = usr
			var/obj/item/card/id/I =69.get_active_hand()
			if (I && istype(I))
				if(src.check_access(I))
					authenticated = 1
		if("deactivate")
			src.connected_E.stopping = 1
		if("logout")
			authenticated = 0

	src.updateUsrDialog()

/obj/machinery/computer/am_engine/attack_ai(var/mob/user as69ob)
	return src.attack_hand(user)

/obj/machinery/computer/am_engine/attack_paw(var/mob/user as69ob)
	return src.attack_hand(user)

/obj/machinery/computer/am_engine/attack_hand(var/mob/user as69ob)
	if(..())
		return
	user.machine = src
	var/dat = "<head><title>Engine Computer</title></head><body>"
	switch(src.state)
		if(STATE_DEFAULT)
			if (src.authenticated)
				dat += "<BR>\69 <A HREF='?src=\ref69src69;operation=logout'>Log Out</A> \69<br>"
				dat += "<BR>\69 <A HREF='?src=\ref69src69;operation=engine'>Engine69enu</A> \69"
				dat += "<BR>\69 <A HREF='?src=\ref69src69;operation=injector'>Injector69enu</A> \69"
			else
				dat += "<BR>\69 <A HREF='?src=\ref69src69;operation=login'>Log In</A> \69"
		if(STATE_INJECTOR)
			if(src.connected_I.injecting)
				dat += "<BR>\69 Injecting \69<br>"
			else
				dat += "<BR>\69 Injecting69ot in progress \69<br>"
		if(STATE_ENGINE)
			if(src.connected_E.stopping)
				dat += "<BR>\69 STOPPING \69"
			else if(src.connected_E.operating && !src.connected_E.stopping)
				dat += "<BR>\69 <A HREF='?src=\ref69src69;operation=deactivate'>Emergency Stop</A> \69"
			else
				dat += "<BR>\69 <A HREF='?src=\ref69src69;operation=activate'>Activate Engine</A> \69"
			dat += "<BR>Contents:<br>69src.connected_E.H_fuel69kg of Hydrogen<br>69src.connected_E.antiH_fuel69kg of Anti-Hydrogen<br>"

	dat += "<BR>\69 69(src.state != STATE_DEFAULT) ? "<A HREF='?src=\ref69src69;operation=main'>Main69enu</A> | " : ""69<A HREF='?src=\ref69user69;mach_close=communications'>Close</A> \69"
	user << browse(dat, "window=communications;size=400x500")
	onclose(user, "communications")

