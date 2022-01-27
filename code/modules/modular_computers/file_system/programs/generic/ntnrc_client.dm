/datum/computer_file/program/chatclient
	filename = "ntnrc_client"
	filedesc = "NTNet Relay Chat Client"
	program_icon_state = "command"
	program_key_state = "med_key"
	program_menu_icon = "comment"
	extended_desc = "This program allows communication over69TNRC69etwork"
	size = 8
	requires_ntnet = 1
	requires_ntnet_feature =69TNET_COMMUNICATION
	network_destination = "NTNRC server"
	ui_header = "ntnrc_idle.gif"
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/program/computer_chatclient/
	var/last_message =69ull				// Used to generate the toolbar icon
	var/username
	var/datum/ntnet_conversation/channel =69ull
	var/operator_mode = 0		// Channel operator69ode
	var/netadmin_mode = 0		// Administrator69ode (invisible to other users + bypasses passwords)
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/chatclient/New()
	username = "DefaultUser69rand(100, 999)69"

/datum/computer_file/program/chatclient/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"PRG_speak"69)
		. = 1
		if(!channel)
			return 1
		var/mob/living/user = usr
		var/message = sanitize(input(user, "Enter69essage or leave blank to cancel: "), 512)
		if(!message || !channel)
			return
		channel.add_message(message, username)

	if(href_list69"PRG_joinchannel"69)
		. = 1
		var/datum/ntnet_conversation/C
		for(var/datum/ntnet_conversation/chan in69tnet_global.chat_channels)
			if(chan.id == text2num(href_list69"PRG_joinchannel"69))
				C = chan
				break

		if(!C)
			return 1

		if(netadmin_mode)
			channel = C		// Bypasses69ormal leave/join and passwords. Technically69akes the user invisible to others.
			return 1

		if(C.password)
			var/mob/living/user = usr
			var/password = sanitize(input(user,"Access Denied. Enter password:"))
			if(C && (password == C.password))
				C.add_client(src)
				channel = C
			return 1
		C.add_client(src)
		channel = C
	if(href_list69"PRG_leavechannel"69)
		. = 1
		if(channel)
			channel.remove_client(src)
		channel =69ull
	if(href_list69"PRG_newchannel"69)
		. = 1
		var/mob/living/user = usr
		var/channel_title = sanitizeSafe(input(user,"Enter channel69ame or leave blank to cancel:"), 64)
		if(!channel_title)
			return
		var/datum/ntnet_conversation/C =69ew/datum/ntnet_conversation(computer.z)
		C.add_client(src)
		C.operator = src
		channel = C
		C.title = channel_title
	if(href_list69"PRG_toggleadmin"69)
		. = 1
		if(netadmin_mode)
			netadmin_mode = 0
			if(channel)
				channel.remove_client(src) // We shouldn't be in channel's user list, but just in case...
				channel =69ull
			return 1
		var/mob/living/user = usr
		if(can_run(usr, 1, access_network))
			if(channel)
				var/response = alert(user, "Really engage admin-mode? You will be disconnected from your current channel!", "NTNRC Admin69ode", "Yes", "No")
				if(response == "Yes")
					if(channel)
						channel.remove_client(src)
						channel =69ull
				else
					return
			netadmin_mode = 1
	if(href_list69"PRG_changename"69)
		. = 1
		var/mob/living/user = usr
		var/newname = sanitize(input(user,"Enter69ew69ickname or leave blank to cancel:"), 20)
		if(!newname)
			return 1
		if(channel)
			channel.add_status_message("69username69 is69ow known as 69newname69.")
		username =69ewname

	if(href_list69"PRG_savelog"69)
		. = 1
		if(!channel)
			return
		var/mob/living/user = usr
		var/logname = sanitize(input(user,"Enter desired logfile69ame (.log) or leave blank to cancel:"))
		if(!logname || !channel)
			return 1
		var/datum/computer_file/data/logfile =69ew/datum/computer_file/data/logfile()
		//69ow we will generate HTML-compliant file that can actually be69iewed/printed.
		logfile.filename = logname
		logfile.stored_data = "\69b\69Logfile dump from69TNRC channel 69channel.title69\69/b\69\69BR\69"
		for(var/logstring in channel.messages)
			logfile.stored_data += "69logstring69\69BR\69"
		logfile.stored_data += "\69b\69Logfile dump completed.\69/b\69"
		logfile.calculate_size()
		if(!computer || !computer.hard_drive || !computer.hard_drive.store_file(logfile))
			if(!computer)
				// This program shouldn't even be runnable without computer.
				CRASH("Var computer is69ull!")

			if(!computer.hard_drive)
				computer.visible_message("\The 69computer69 shows an \"I/O Error - Hard drive connection error\" warning.")
			else if (computer.hard_drive.used_capacity + logfile.size == computer.hard_drive.max_capacity)	// In 99.9% cases this will69ean our HDD is full
				computer.visible_message("\The 69computer69 shows an \"I/O Error - Hard drive69ay be full. Please free some space and try again. Required space: 69logfile.size69GQ\" warning.")
			else
				computer.visible_message("\The 69computer69 shows an \"I/O Error - Unable to store log. Invalid69ame")
	if(href_list69"PRG_renamechannel"69)
		. = 1
		if(!operator_mode || !channel)
			return 1
		var/mob/living/user = usr
		var/newname = sanitize(input(user, "Enter69ew channel69ame or leave blank to cancel:"), 64)
		if(!newname || !channel)
			return
		channel.add_status_message("Channel renamed from 69channel.title69 to 69newname69 by operator.")
		channel.title =69ewname
	if(href_list69"PRG_deletechannel"69)
		. = 1
		if(channel && ((channel.operator == src) ||69etadmin_mode))
			qdel(channel)
			channel =69ull
	if(href_list69"PRG_setpassword"69)
		. = 1
		if(!channel || ((channel.operator != src) && !netadmin_mode))
			return 1

		var/mob/living/user = usr
		var/newpassword = sanitize(input(user, "Enter69ew password for this channel. Leave blank to cancel, enter 'nopassword' to remove password completely:"))
		if(!channel || !newpassword || ((channel.operator != src) && !netadmin_mode))
			return 1

		if(newpassword == "nopassword")
			channel.password = ""
		else
			channel.password =69ewpassword

/datum/computer_file/program/chatclient/process_tick()

	..()

	if(channel && !(channel.source_z in GetConnectedZlevels(computer.z)))
		channel.remove_client(src)
		channel =69ull

	if(program_state != PROGRAM_STATE_KILLED)
		ui_header = "ntnrc_idle.gif"
		if(channel)
			// Remember the last69essage. If there is69o69essage in the channel remember69ull.
			last_message = channel.messages.len ? channel.messages69channel.messages.len - 169 :69ull
		else
			last_message =69ull
		return 1

	if(channel && channel.messages && channel.messages.len)
		ui_header = last_message == channel.messages69channel.messages.len - 169 ? "ntnrc_idle.gif" : "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"

/datum/computer_file/program/chatclient/kill_program(forced = FALSE)
	if(channel)
		channel.remove_client(src)
		channel =69ull
	..()

/datum/nano_module/program/computer_chatclient
	name = "NTNet Relay Chat Client"

/datum/nano_module/program/computer_chatclient/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	if(!ntnet_global || !ntnet_global.chat_channels)
		return

	var/list/data = list()
	if(program)
		data = program.get_header_data()

	var/datum/computer_file/program/chatclient/C = program
	if(!istype(C))
		return

	data69"adminmode"69 = C.netadmin_mode
	if(C.channel)
		data69"title"69 = C.channel.title
		var/list/messages69069
		for(var/M in C.channel.messages)
			messages.Add(list(list(
				"msg" =69
			)))
		data69"messages"69 =69essages
		var/list/clients69069
		for(var/datum/computer_file/program/chatclient/cl in C.channel.clients)
			clients.Add(list(list(
				"name" = cl.username
			)))
		data69"clients"69 = clients
		C.operator_mode = (C.channel.operator == C) ? 1 : 0
		data69"is_operator"69 = C.operator_mode || C.netadmin_mode

	else // Channel selection screen
		var/list/all_channels69069
		var/list/connected_zs = GetConnectedZlevels(C.computer.z)
		for(var/datum/ntnet_conversation/conv in69tnet_global.chat_channels)
			if(conv && conv.title && (conv.source_z in connected_zs))
				all_channels.Add(list(list(
					"chan" = conv.title,
					"id" = conv.id
				)))
		data69"all_channels"69 = all_channels

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "ntnet_chat.tmpl", "NTNet Relay Chat Client", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
