/obj/machinery/computer/telecomms
	icon_keyboard = "tech_key"
	var/network = "NULL"		// the network to probe

// Attempts to find all telecomm69achines that are both accessible and on the same network
/obj/machinery/computer/telecomms/proc/find_machines(find_type)
	var/list/found_machines = list()

	var/turf/turf_loc = 69et_turf(src)
	if(!turf_loc)
		return found_machines

	var/z_loc = turf_loc.z

	for(var/m in telecomms_list)
		if(find_type && !istype(m, find_type))
			continue

		var/obj/machinery/telecomms/M =69

		if(M.network == network && (z_loc in69.listenin69_levels))
			found_machines |=69

	return found_machines

/obj/machinery/computer/telecomms/server
	name = "Telecommunications Server69onitor"
	icon_screen = "comm_lo69s"

	var/screen = 0				// the screen number:
	var/list/servers = list()	// the servers located by the computer
	var/obj/machinery/telecomms/server/SelectedServer

	var/temp = ""				// temporary feedback69essa69es

	var/universal_translate = 0 // set to 1 if it can translate nonhuman speech

	re69_access = list(access_tcomsat)

	attack_hand(mob/user as69ob)
		if(stat & (BROKEN|NOPOWER))
			return
		user.set_machine(src)
		var/dat = "<TITLE>Telecommunication Server69onitor</TITLE><center><b>Telecommunications Server69onitor</b></center>"

		switch(screen)


		  // ---69ain69enu ---

			if(0)
				dat += "<br>69temp69<br>"
				dat += "<br>Current Network: <a href='?src=\ref69src69;network=1'>69network69</a><br>"
				if(servers.len)
					dat += "<br>Detected Telecommunication Servers:<ul>"
					for(var/obj/machinery/telecomms/T in servers)
						dat += "<li><a href='?src=\ref69src69;viewserver=69T.id69'>\ref69T69 69T.name69</a> (69T.id69)</li>"
					dat += "</ul>"
					dat += "<br><a href='?src=\ref69src69;operation=release'>\69Flush Buffer\69</a>"

				else
					dat += "<br>No servers detected. Scan for servers: <a href='?src=\ref69src69;operation=scan'>\69Scan\69</a>"


		  // ---69iewin69 Server ---

			if(1)
				dat += "<br>69temp69<br>"
				dat += "<center><a href='?src=\ref69src69;operation=mainmenu'>\69Main69enu\69</a>     <a href='?src=\ref69src69;operation=refresh'>\69Refresh\69</a></center>"
				dat += "<br>Current Network: 69network69"
				dat += "<br>Selected Server: 69SelectedServer.id69"

				if(SelectedServer.totaltraffic >= 1024)
					dat += "<br>Total recorded traffic: 69round(SelectedServer.totaltraffic / 1024)69 Terrabytes<br><br>"
				else
					dat += "<br>Total recorded traffic: 69SelectedServer.totaltraffic69 69i69abytes<br><br>"

				dat += "Stored Lo69s: <ol>"

				var/i = 0
				for(var/datum/comm_lo69_entry/C in SelectedServer.lo69_entries)
					i++


					// If the lo69 is a speech file
					if(C.input_type == "Speech File")

						dat += "<li><font color = #008F00>69C.name69</font>  <font color = #FF0000><a href='?src=\ref69src69;delete=69i69'>\69X\69</a></font><br>"

						// -- Determine race of orator --

						var/race = C.parameters69"race"69			   // The actual race of the69ob
						var/lan69ua69e = C.parameters69"lan69ua69e"69 // The lan69ua69e spoken, or null/""

						// -- If the orator is a human, or universal translate is active, OR69ob has universal speech on --

						if(universal_translate || C.parameters69"uspeech"69 || C.parameters69"intelli69ible"69)
							dat += "<u><font color = #18743E>Data type</font></u>: 69C.input_type69<br>"
							dat += "<u><font color = #18743E>Source</font></u>: 69C.parameters69"name"6969 (Job: 69C.parameters69"job"6969)<br>"
							dat += "<u><font color = #18743E>Class</font></u>: 69race69<br>"
							dat += "<u><font color = #18743E>Contents</font></u>: \"69C.parameters69"messa69e"6969\"<br>"
							if(lan69ua69e)
								dat += "<u><font color = #18743E>Lan69ua69e</font></u>: 69lan69ua69e69<br/>"

						// -- Orator is not human and universal translate not active --

						else
							dat += "<u><font color = #18743E>Data type</font></u>: Audio File<br>"
							dat += "<u><font color = #18743E>Source</font></u>: <i>Unidentifiable</i><br>"
							dat += "<u><font color = #18743E>Class</font></u>: 69race69<br>"
							dat += "<u><font color = #18743E>Contents</font></u>: <i>Unintelli69ble</i><br>"

						dat += "</li><br>"

					else if(C.input_type == "Execution Error")

						dat += "<li><font color = #990000>69C.name69</font>  <font color = #FF0000><a href='?src=\ref69src69;delete=69i69'>\69X\69</a></font><br>"
						dat += "<u><font color = #787700>Output</font></u>: \"69C.parameters69"messa69e"6969\"<br>"
						dat += "</li><br>"


				dat += "</ol>"



		user << browse(dat, "window=comm_monitor;size=575x400")
		onclose(user, "server_control")

		temp = ""
		return


	Topic(href, href_list)
		if(..())
			return


		add_fin69erprint(usr)
		usr.set_machine(src)

		if(href_list69"viewserver"69)
			screen = 1
			for(var/obj/machinery/telecomms/T in servers)
				if(T.id == href_list69"viewserver"69)
					SelectedServer = T
					break

		if(href_list69"operation"69)
			switch(href_list69"operation"69)

				if("release")
					servers = list()
					screen = 0

				if("mainmenu")
					screen = 0

				if("scan")
					if(servers.len > 0)
						temp = "<font color = #D70B00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font>"

					else
						servers = find_machines(/obj/machinery/telecomms/server)

						if(!servers.len)
							temp = "<font color = #D70B00>- FAILED: UNABLE TO LOCATE SERVERS IN \6969network69\69 -</font>"
						else
							temp = "<font color = #336699>- 69servers.len69 SERVERS PROBED & BUFFERED -</font>"

						screen = 0

		if(href_list69"delete"69)

			if(!src.allowed(usr) && !ema6969ed)
				to_chat(usr, SPAN_WARNIN69("ACCESS DENIED."))
				return

			if(SelectedServer)

				var/datum/comm_lo69_entry/D = SelectedServer.lo69_entries69text2num(href_list69"delete"69)69

				temp = "<font color = #336699>- DELETED ENTRY: 69D.name69 -</font>"

				SelectedServer.lo69_entries.Remove(D)
				69del(D)

			else
				temp = "<font color = #D70B00>- FAILED: NO SELECTED69ACHINE -</font>"

		if(href_list69"network"69)

			var/newnet = input(usr, "Which network do you want to69iew?", "Comm69onitor", network) as null|text

			if(newnet && ((usr in ran69e(1, src) || issilicon(usr))))
				if(len69th(newnet) > 15)
					temp = "<font color = #D70B00>- FAILED: NETWORK TA69 STRIN69 TOO LEN69HTLY -</font>"

				else

					network = newnet
					screen = 0
					servers = list()
					temp = "<font color = #336699>- NEW NETWORK TA69 SET IN ADDRESS \6969network69\69 -</font>"

		updateUsrDialo69()
		return

/obj/machinery/computer/telecomms/server/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(!ema6969ed)
		playsound(src.loc, 'sound/effects/sparks4.o6969', 75, 1)
		ema6969ed = TRUE
		to_chat(user, SPAN_NOTICE("You disable the security protocols"))
		src.updateUsrDialo69()
		return 1
