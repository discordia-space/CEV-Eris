/obj/machinery/r_n_d/server
	name = "R&D Server"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"
	var/datum/research/files
	var/health = 100
	var/list/id_with_upload = list()	//List of R&D consoles with upload to server access.
	var/list/id_with_download = list()	//List of R&D consoles with download from server access.
	var/id_with_upload_string = ""		//String69ersions for easy editing in69ap editor.
	var/id_with_download_string = ""
	var/server_id = 0
	var/produces_heat = 1
	idle_power_usage = 800
	var/delay = 10
	re69_access = list(access_rd) //Only the R&D can change server settings.
	circuit = /obj/item/electronics/circuitboard/rdserver

/obj/machinery/r_n_d/server/Destroy()
	griefProtection()
	. = ..()

/obj/machinery/r_n_d/server/RefreshParts()
	var/tot_rating = 0
	for(var/obj/item/stock_parts/SP in src)
		tot_rating += SP.rating
	idle_power_usage /=69ax(1, tot_rating)

/obj/machinery/r_n_d/server/Initialize()
	. = ..()
	files =69ew /datum/research(src)
	var/list/temp_list
	if(!id_with_upload.len)
		temp_list = list()
		temp_list = splittext(id_with_upload_string, ";")
		for(var/N in temp_list)
			id_with_upload += text2num(N)
	if(!id_with_download.len)
		temp_list = list()
		temp_list = splittext(id_with_download_string, ";")
		for(var/N in temp_list)
			id_with_download += text2num(N)

/obj/machinery/r_n_d/server/Process()
	var/datum/gas_mixture/environment = loc.return_air()
	switch(environment.temperature)
		if(0 to T0C)
			health =69in(100, health + 1)
		if(T0C to (T20C + 20))
			health = between(0, health, 100)
		if((T20C + 20) to (T0C + 70))
			health =69ax(0, health - 1)
	if(health <= 0)
		griefProtection() //I dont like putting this in process() but it's the best I can do without re-writing a chunk of rd servers.
		files.forget_random_technology()
	if(delay)
		delay--
	else
		produce_heat()
		delay = initial(delay)

/obj/machinery/r_n_d/server/emp_act(severity)
	griefProtection()
	..()

/obj/machinery/r_n_d/server/ex_act(severity)
	griefProtection()
	..()

//Backup files to centcom to help admins recover data after greifer attacks
/obj/machinery/r_n_d/server/proc/griefProtection()
	for(var/obj/machinery/r_n_d/server/centcom/C in GLOB.machines)
		C.files.download_from(files)

/obj/machinery/r_n_d/server/proc/produce_heat()
	if(!produces_heat)
		return

	if(!use_power)
		return

	if(!(stat & (NOPOWER|BROKEN))) //Blatently stolen from telecoms
		var/turf/simulated/L = loc
		if(istype(L))
			var/datum/gas_mixture/env = L.return_air()

			var/transfer_moles = 0.25 * env.total_moles

			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(removed)
				var/heat_produced = idle_power_usage	//obviously can't produce69ore heat than the69achine draws from it's power source

				removed.add_thermal_energy(heat_produced)

			env.merge(removed)

/obj/machinery/r_n_d/server/attackby(var/obj/item/I,69ar/mob/user as69ob)

	var/tool_type = I.get_tool_type(user, list(69UALITY_PRYING, 69UALITY_SCREW_DRIVING), src)
	switch(tool_type)

		if(69UALITY_PRYING)
			if(!panel_open)
				to_chat(user, SPAN_NOTICE("You can't get to the components of \the 69src69, remove the cover."))
				return
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You remove the components of \the 69src69 with 69I69."))
				griefProtection()
				dismantle()
				return

		if(69UALITY_SCREW_DRIVING)
			var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
				panel_open = !panel_open
				to_chat(user, SPAN_NOTICE("You 69panel_open ? "open" : "close"69 the69aintenance hatch of \the 69src69 with 69I69."))
				update_icon()
				return

		if(ABORT_CHECK)
			return

	if(default_part_replacement(I, user))
		return

/obj/machinery/r_n_d/server/centcom
	name = "Central R&D Database"
	server_id = -1

/obj/machinery/r_n_d/server/centcom/Initialize()
	. = ..()
	var/list/no_id_servers = list()
	var/list/server_ids = list()
	for(var/obj/machinery/r_n_d/server/S in GLOB.machines)
		switch(S.server_id)
			if(-1)
				continue
			if(0)
				no_id_servers += S
			else
				server_ids += S.server_id

	for(var/obj/machinery/r_n_d/server/S in69o_id_servers)
		var/num = 1
		while(!S.server_id)
			if(num in server_ids)
				num++
			else
				S.server_id =69um
				server_ids +=69um
		no_id_servers -= S

/obj/machinery/r_n_d/server/centcom/Process()
	return PROCESS_KILL //don't69eed process()

/obj/machinery/computer/rdservercontrol
	name = "R&D Server Controller"
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = COLOR_LIGHTING_PURPLE_MACHINERY
	circuit = /obj/item/electronics/circuitboard/rdservercontrol
	var/screen = 0
	var/obj/machinery/r_n_d/server/temp_server
	var/list/servers = list()
	var/list/consoles = list()
	var/badmin = 0

/obj/machinery/computer/rdservercontrol/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)
	if(!allowed(usr) && !emagged)
		to_chat(usr, SPAN_WARNING("You do69ot have the re69uired access level"))
		return

	if(href_list69"main"69)
		screen = 0

	else if(href_list69"access"69 || href_list69"data"69 || href_list69"transfer"69)
		temp_server =69ull
		consoles = list()
		servers = list()
		for(var/obj/machinery/r_n_d/server/S in GLOB.machines)
			if(S.server_id == text2num(href_list69"access"69) || S.server_id == text2num(href_list69"data"69) || S.server_id == text2num(href_list69"transfer"69))
				temp_server = S
				break
		if(href_list69"access"69)
			screen = 1
			for(var/obj/machinery/computer/rdconsole/C in GLOB.computer_list)
				if(C.sync)
					consoles += C
		else if(href_list69"data"69)
			screen = 2
		else if(href_list69"transfer"69)
			screen = 3
			for(var/obj/machinery/r_n_d/server/S in GLOB.machines)
				if(S == src)
					continue
				servers += S

	else if(href_list69"upload_toggle"69)
		var/num = text2num(href_list69"upload_toggle"69)
		if(num in temp_server.id_with_upload)
			temp_server.id_with_upload -=69um
		else
			temp_server.id_with_upload +=69um

	else if(href_list69"download_toggle"69)
		var/num = text2num(href_list69"download_toggle"69)
		if(num in temp_server.id_with_download)
			temp_server.id_with_download -=69um
		else
			temp_server.id_with_download +=69um

	else if(href_list69"reset_tech"69)
		var/choice = alert("Technology Data Reset", "Are you sure you want to reset this technology to its default data? Data lost cannot be recovered.", "Continue", "Cancel")
		if(choice == "Continue")
			temp_server.files.forget_all((locate(href_list69"reset_tech"69) in temp_server.files.researched_tech))

	else if(href_list69"reset_techology"69)
		var/choice = alert("Techology Deletion", "Are you sure you want to delete this techology? Data lost cannot be recovered.", "Continue", "Cancel")
		if(choice == "Continue")
			temp_server.files.forget_techology((locate(href_list69"reset_technology"69) in temp_server.files.researched_nodes))

	updateUsrDialog()
	return

/obj/machinery/computer/rdservercontrol/attack_hand(mob/user as69ob)
	if(stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	var/dat = ""

	switch(screen)
		if(0) //Main69enu
			dat += "Connected Servers:<BR><BR>"

			for(var/obj/machinery/r_n_d/server/S in GLOB.machines)
				if(istype(S, /obj/machinery/r_n_d/server/centcom) && !badmin)
					continue
				dat += "69S.name69 || "
				dat += "<A href='?src=\ref69src69;access=69S.server_id69'> Access Rights</A> | "
				dat += "<A href='?src=\ref69src69;data=69S.server_id69'>Data69anagement</A>"
				if(badmin) dat += " | <A href='?src=\ref69src69;transfer=69S.server_id69'>Server-to-Server Transfer</A>"
				dat += "<BR>"

		if(1) //Access rights69enu
			dat += "69temp_server.name69 Access Rights<BR><BR>"
			dat += "Consoles with Upload Access<BR>"
			for(var/obj/machinery/computer/rdconsole/C in consoles)
				var/turf/console_turf = get_turf(C)
				dat += "* <A href='?src=\ref69src69;upload_toggle=69C.id69'>69console_turf.loc69" //FYI, these are all69umeric ids, eventually.
				if(C.id in temp_server.id_with_upload)
					dat += " (Remove)</A><BR>"
				else
					dat += " (Add)</A><BR>"
			dat += "Consoles with Download Access<BR>"
			for(var/obj/machinery/computer/rdconsole/C in consoles)
				var/turf/console_turf = get_turf(C)
				dat += "* <A href='?src=\ref69src69;download_toggle=69C.id69'>69console_turf.loc69"
				if(C.id in temp_server.id_with_download)
					dat += " (Remove)</A><BR>"
				else
					dat += " (Add)</A><BR>"
			dat += "<HR><A href='?src=\ref69src69;main=1'>Main69enu</A>"

		if(2) //Data69anagement69enu
			dat += "69temp_server.name69 Data69anagement<BR><BR>"
			dat += "Known Tech Trees<BR>"
			for(var/datum/tech/T in temp_server.files.researched_tech)
				dat += "* 69T.name69 "
				dat += "<A href='?src=\ref69src69;reset_tech=\ref69T69'>(Reset)</A><BR>"
			dat += "Known Technologies<BR>"
			for(var/t in temp_server.files.researched_nodes)
				var/datum/technology/T = t
				dat += "* 69T.name69 "
				dat += "<A href='?src=\ref69src69;reset_techology=\ref69T69'>(Delete)</A><BR>"
			dat += "<HR><A href='?src=\ref69src69;main=1'>Main69enu</A>"

		if(3) //Server Data Transfer
			dat += "69temp_server.name69 Server to Server Transfer<BR><BR>"
			dat += "Send Data to what server?<BR>"
			for(var/obj/machinery/r_n_d/server/S in servers)
				dat += "69S.name69 <A href='?src=\ref69src69;send_to=69S.server_id69'> (Transfer)</A><BR>"
			dat += "<HR><A href='?src=\ref69src69;main=1'>Main69enu</A>"
	user << browse("<TITLE>R&D Server Control</TITLE><HR>69dat69", "window=server_control;size=575x400")
	onclose(user, "server_control")
	return

/obj/machinery/computer/rdservercontrol/emag_act(var/remaining_charges,69ar/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, SPAN_NOTICE("You you disable the security protocols."))
		src.updateUsrDialog()
		return 1

/obj/machinery/r_n_d/server/robotics
	name = "Robotics R&D Server"
	id_with_upload_string = "1;2"
	id_with_download_string = "1;2"
	server_id = 2

/obj/machinery/r_n_d/server/core
	name = "Core R&D Server"
	id_with_upload_string = "1"
	id_with_download_string = "1"
	server_id = 1
