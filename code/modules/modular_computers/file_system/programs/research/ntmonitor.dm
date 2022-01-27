/datum/computer_file/program/ntnetmonitor
	filename = "ntmonitor"
	filedesc = "NTNet Diagnostics and69onitoring"
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "wrench"
	extended_desc = "This program69onitors the local69TNet69etwork, provides access to logging systems, and allows for configuration changes"
	size = 12
	requires_ntnet = 1
	required_access = access_network
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/program/computer_ntnetmonitor/

/datum/nano_module/program/computer_ntnetmonitor
	name = "NTNet Diagnostics and69onitoring"
	available_to_ai = TRUE

/datum/nano_module/program/computer_ntnetmonitor/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	if(!ntnet_global)
		return
	var/list/data = host.initial_data()

	data += "skill_fail"
	if(!user.stat_check(STAT_COG, STAT_LEVEL_BASIC))
		var/datum/extension/fake_data/fake_data = get_or_create_extension(src, /datum/extension/fake_data, /datum/extension/fake_data, 20)
		data69"skill_fail"69 = fake_data.update_and_return_data()
	data69"terminal"69 = !!program

	data69"ntnetstatus"69 =69tnet_global.check_function()
	data69"ntnetrelays"69 =69tnet_global.relays.len
	data69"idsstatus"69 =69tnet_global.intrusion_detection_enabled
	data69"idsalarm"69 =69tnet_global.intrusion_detection_alarm

	data69"config_softwaredownload"69 =69tnet_global.setting_softwaredownload
	data69"config_peertopeer"69 =69tnet_global.setting_peertopeer
	data69"config_communication"69 =69tnet_global.setting_communication
	data69"config_systemcontrol"69 =69tnet_global.setting_systemcontrol

	data69"ntnetlogs"69 =69tnet_global.logs
	data69"ntnetmaxlogs"69 =69tnet_global.setting_maxlogcount

	data69"banned_nids"69 = list(ntnet_global.banned_nids)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "ntnet_monitor.tmpl", "NTNet Diagnostics and69onitoring Tool", 575, 700, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/computer_ntnetmonitor/Topic(href, href_list, state)
	var/mob/user = usr
	if(..())
		return 1

	if(!user.stat_check(STAT_COG, STAT_LEVEL_BASIC))
		return 1

	if(href_list69"resetIDS"69)
		if(ntnet_global)
			ntnet_global.resetIDS()
		return 1
	if(href_list69"toggleIDS"69)
		if(ntnet_global)
			ntnet_global.toggleIDS()
		return 1
	if(href_list69"toggleWireless"69)
		if(!ntnet_global)
			return 1

		//69TNet is disabled. Enabling can be done without user prompt
		if(ntnet_global.setting_disabled)
			ntnet_global.setting_disabled = 0
			return 1

		//69TNet is enabled and user is about to shut it down. Let's ask them if they really want to do it, as wirelessly connected computers won't connect without69TNet being enabled (which69ay prevent people from turning it back on)
		if(!user)
			return 1
		var/response = alert(user, "Really disable69TNet wireless? If your computer is connected wirelessly you won't be able to turn it back on! This will affect all connected wireless devices.", "NTNet shutdown", "Yes", "No")
		if(response == "Yes")
			ntnet_global.setting_disabled = 1
		return 1
	if(href_list69"purgelogs"69)
		if(ntnet_global)
			ntnet_global.purge_logs()
		return 1
	if(href_list69"updatemaxlogs"69)
		var/logcount = text2num(input(user,"Enter amount of logs to keep in69emory (69MIN_NTNET_LOGS69-69MAX_NTNET_LOGS69):"))
		if(ntnet_global)
			ntnet_global.update_max_log_count(logcount)
		return 1
	if(href_list69"toggle_function"69)
		if(!ntnet_global)
			return 1
		ntnet_global.toggle_function(href_list69"toggle_function"69)
		return 1
	if(href_list69"ban_nid"69)
		if(!ntnet_global)
			return 1
		var/nid = input(user,"Enter69ID of device which you want to block from the69etwork:", "Enter69ID") as69ull|num
		if(nid && CanUseTopic(user, state))
			ntnet_global.banned_nids |=69id
		return 1
	if(href_list69"unban_nid"69)
		if(!ntnet_global)
			return 1
		var/nid = input(user,"Enter69ID of device which you want to unblock from the69etwork:", "Enter69ID") as69ull|num
		if(nid && CanUseTopic(user, state))
			ntnet_global.banned_nids -=69id
		return 1