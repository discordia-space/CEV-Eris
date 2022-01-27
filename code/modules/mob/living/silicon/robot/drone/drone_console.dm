GLOBAL_LIST_INIT(drones, list())

/obj/machinery/computer/drone_control
	name = "Maintenance Drone Control"
	desc = "Used to69onitor the ship's drone population and the assembler that services them."
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "power_key"
	icon_screen = "dron_control_monitor"
	req_access = list(access_engine_equip)
	circuit = /obj/item/electronics/circuitboard/drone_control

	//Used when pinging drones.
	var/drone_call_area = "Engineering"
	//Used to enable or disable drone fabrication.
	var/obj/machinery/drone_fabricator/dronefab

/obj/machinery/computer/drone_control/attack_hand(var/mob/user as69ob)
	if(..())
		return

	if(!allowed(user))
		to_chat(user, SPAN_DANGER("Access denied."))
		return

	user.set_machine(src)
	var/dat
	dat += "<B>Maintenance Units</B><BR>"

	for(var/mob/living/silicon/robot/drone/D in GLOB.drones)
		if(isNotStationLevel(D.z))
			continue
		dat += "<BR>69D.real_name69 (69D.stat == 2 ? "<font color='red'>INACTIVE</FONT>" : "<font color='green'>ACTIVE</FONT>"69)"
		dat += "<font dize = 9><BR>Cell charge: 69D.cell.charge69/69D.cell.maxcharge69."
		dat += "<BR>Currently located in: 69get_area(D)69."
		dat += "<BR><A href='?src=\ref69src69;resync=\ref69D69'>Resync</A> | <A href='?src=\ref69src69;shutdown=\ref69D69'>Shutdown</A></font>"

	dat += "<BR><BR><B>Request drone presence in area:</B> <A href='?src=\ref69src69;setarea=1'>69drone_call_area69</A> (<A href='?src=\ref69src69;ping=1'>Send ping</A>)"

	dat += "<BR><BR><B>Drone fabricator</B>: "
	dat += "69dronefab ? "<A href='?src=\ref69src69;toggle_fab=1'>69(dronefab.produce_drones && !(dronefab.stat &69OPOWER)) ? "ACTIVE" : "INACTIVE"69</A>" : "<font color='red'><b>FABRICATOR69OT DETECTED.</b></font> (<A href='?src=\ref69src69;search_fab=1'>search</a>)"69"
	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return


/obj/machinery/computer/drone_control/Topic(href, href_list)
	if(..())
		return

	if(!allowed(usr))
		to_chat(usr, SPAN_DANGER("Access denied."))
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (issilicon(usr)))
		usr.set_machine(src)

	if (href_list69"setarea"69)

		//Probably should consider using another list, but this one will do.
		var/t_area = input("Select the area to ping.", "Set Target Area",69ull) as69ull|anything in tagger_locations

		if(!t_area)
			return

		drone_call_area = t_area
		to_chat(usr, SPAN_NOTICE("You set the area selector to 69drone_call_area69."))

	else if (href_list69"ping"69)

		to_chat(usr, SPAN_NOTICE("You issue a69aintenance request for all active drones, highlighting 69drone_call_area69."))
		for(var/mob/living/silicon/robot/drone/D in GLOB.drones)
			if(D.client && D.stat == 0)
				to_chat(D, "--69aintenance drone presence requested in: 69drone_call_area69.")

	else if (href_list69"resync"69)

		var/mob/living/silicon/robot/drone/D = locate(href_list69"resync"69)

		if(D.stat != 2)
			to_chat(usr, SPAN_DANGER("You issue a law synchronization directive for the drone."))
			D.law_resync()

	else if (href_list69"shutdown"69)

		var/mob/living/silicon/robot/drone/D = locate(href_list69"shutdown"69)

		if(D.stat != 2)
			to_chat(usr, SPAN_DANGER("You issue a kill command for the unfortunate drone."))
			message_admins("69key_name_admin(usr)69 issued kill order for drone 69key_name_admin(D)69 from control console.")
			log_game("69key_name(usr)69 issued kill order for 69key_name(src)69 from control console.")
			D.shut_down()

	else if (href_list69"search_fab"69)
		if(dronefab)
			return

		for(var/obj/machinery/drone_fabricator/fab in oview(3,src))

			if(fab.stat &69OPOWER)
				continue

			dronefab = fab
			to_chat(usr, SPAN_NOTICE("Drone fabricator located."))
			return

		to_chat(usr, SPAN_DANGER("Unable to locate drone fabricator."))

	else if (href_list69"toggle_fab"69)

		if(!dronefab)
			return

		if(get_dist(src,dronefab) > 3)
			dronefab =69ull
			to_chat(usr, SPAN_DANGER("Unable to locate drone fabricator."))
			return

		dronefab.produce_drones = !dronefab.produce_drones
		to_chat(usr, "<span class='notice'>You 69dronefab.produce_drones ? "enable" : "disable"69 drone production in the69earby fabricator.</span>")

	src.updateUsrDialog()