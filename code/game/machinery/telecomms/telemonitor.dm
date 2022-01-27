/*
	Telecomms69onitor tracks the overall trafficing of a telecommunications network
	and displays a heirarchy of linked69achines.
*/


/obj/machinery/computer/telecomms/monitor
	name = "Telecommunications69onitor"
	icon_screen = "comm_monitor"

	var/screen = 0				// the screen number:
	var/list/machinelist = list()	// the69achines located by the computer
	var/obj/machinery/telecomms/SelectedMachine

	var/temp = ""				// temporary feedback69essages

	attack_hand(mob/user as69ob)
		if(stat & (BROKEN|NOPOWER))
			return
		user.set_machine(src)
		var/dat = "<TITLE>Telecommunications69onitor</TITLE><center><b>Telecommunications69onitor</b></center>"

		switch(screen)


		  // ---69ain69enu ---

			if(0)
				dat += "<br>69temp69<br><br>"
				dat += "<br>Current Network: <a href='?src=\ref69src69;network=1'>69network69</a><br>"
				if(machinelist.len)
					dat += "<br>Detected Network Entities:<ul>"
					for(var/obj/machinery/telecomms/T in69achinelist)
						dat += "<li><a href='?src=\ref69src69;viewmachine=69T.id69'>\ref69T69 69T.name69</a> (69T.id69)</li>"
					dat += "</ul>"
					dat += "<br><a href='?src=\ref69src69;operation=release'>\69Flush Buffer\69</a>"
				else
					dat += "<a href='?src=\ref69src69;operation=probe'>\69Probe Network\69</a>"


		  // ---69iewing69achine ---

			if(1)
				dat += "<br>69temp69<br>"
				dat += "<center><a href='?src=\ref69src69;operation=mainmenu'>\69Main69enu\69</a></center>"
				dat += "<br>Current Network: 69network69<br>"
				dat += "Selected Network Entity: 69SelectedMachine.name69 (69SelectedMachine.id69)<br>"
				dat += "Linked Entities: <ol>"
				for(var/obj/machinery/telecomms/T in SelectedMachine.links)
					if(!T.hide)
						dat += "<li><a href='?src=\ref69src69;viewmachine=69T.id69'>\ref69T.id69 69T.name69</a> (69T.id69)</li>"
				dat += "</ol>"



		user << browse(dat, "window=comm_monitor;size=575x400")
		onclose(user, "server_control")

		temp = ""
		return


	Topic(href, href_list)
		if(..())
			return


		add_fingerprint(usr)
		usr.set_machine(src)

		if(href_list69"viewmachine"69)
			screen = 1
			for(var/obj/machinery/telecomms/T in69achinelist)
				if(T.id == href_list69"viewmachine"69)
					SelectedMachine = T
					break

		if(href_list69"operation"69)
			switch(href_list69"operation"69)

				if("release")
					machinelist = list()
					screen = 0

				if("mainmenu")
					screen = 0

				if("probe")
					if(machinelist.len > 0)
						temp = "<font color = #D70B00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font>"

					else
						machinelist = find_machines()

						if(!machinelist.len)
							temp = "<font color = #D70B00>- FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN \6969network69\69 -</font>"
						else
							temp = "<font color = #336699>- 69machinelist.len69 ENTITIES LOCATED & BUFFERED -</font>"

						screen = 0


		if(href_list69"network"69)

			var/newnet = input(usr, "Which network do you want to69iew?", "Comm69onitor", network) as null|text
			if(newnet && ((usr in range(1, src) || issilicon(usr))))
				if(length(newnet) > 15)
					temp = "<font color = #D70B00>- FAILED: NETWORK TAG STRING TOO LENGHTLY -</font>"

				else
					network = newnet
					screen = 0
					machinelist = list()
					temp = "<font color = #336699>- NEW NETWORK TAG SET IN ADDRESS \6969network69\69 -</font>"

		updateUsrDialog()
		return

/obj/machinery/computer/telecomms/monitor/emag_act(var/remaining_charges,69ar/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You disable the security protocols"))
		src.updateUsrDialog()
		return 1
