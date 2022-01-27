/datum/computer_file/program/suit_sensors
	filename = "sensormonitor"
	filedesc = "Suit Sensors69onitoring"
	nanomodule_path = /datum/nano_module/crew_monitor
	ui_header = "crew_green.gif"
	program_icon_state = "crew"
	program_key_state = "med_key"
	program_menu_icon = "heart"
	extended_desc = "This program connects to life signs69onitoring system to provide basic information on crew health."
	required_access = access_moebius
	requires_ntnet = 1
	network_destination = "crew lifesigns69onitoring system"
	size = 11
	var/has_alert = FALSE
	usage_flags = PROGRAM_ALL & ~PROGRAM_PDA

/datum/computer_file/program/suit_sensors/process_tick()
	..()

	var/datum/nano_module/crew_monitor/NMC =69M
	if(istype(NMC) && (NMC.has_alerts() != has_alert))
		if(!has_alert)
			program_icon_state = "crew-red"
			ui_header = "crew_red.gif"
		else
			program_icon_state = "crew"
			ui_header = "crew_green.gif"
		update_computer_icon()
		has_alert = !has_alert

	return 1

/datum/nano_module/crew_monitor
	name = "Crew69onitor"
	var/list/ddata
	var/list/crew
	//for search
	var/search = ""

/datum/nano_module/crew_monitor/proc/has_alerts()
	for(var/z_level in GLOB.maps_data.station_levels)
		if(crew_repository.has_health_alert(z_level))
			return TRUE
	return FALSE

/datum/nano_module/crew_monitor/Topic(href, href_list)
	if(..()) return TOPIC_HANDLED

	if(href_list69"track"69)
		if(isAI(usr))
			var/mob/living/silicon/ai/AI = usr
			var/mob/living/carbon/human/H = locate(href_list69"track"69) in SSmobs.mob_list
			if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
				AI.ai_actual_track(H)
		else
			var/datum/computer_file/program/host_program = host
			if(istype(host_program))
				var/obj/item/modular_computer/tablet/moebius/T = host_program.computer
				if(istype(T))
					var/mob/living/carbon/human/H = locate(href_list69"track"69) in SSmobs.mob_list
					T.target_mob = H
					if(!T.is_tracking)
						T.pinpoint()
		return TOPIC_HANDLED

	if(href_list69"search"69)
		var/new_search = sanitize(input("Enter the69alue for search for.") as69ull|text)
		if(!new_search ||69ew_search == "")
			search = ""
			return TOPIC_HANDLED
		search =69ew_search
		return TOPIC_HANDLED

	if(href_list69"mute"69)
		var/mob/living/carbon/human/H = locate(href_list69"mute"69) in SSmobs.mob_list
		if(H)
			GLOB.ignore_health_alerts_from.Add(H.name)
			// Run that so UI updates right after button is pressed, without 5 second delay
			for(var/z_level in GLOB.maps_data.station_levels)
				// Forced update, we don't want cached entry to be returned
				crew_repository.health_data(z_level, TRUE)
		return TOPIC_HANDLED

	if(href_list69"unmute"69)
		var/mob/living/carbon/human/H = locate(href_list69"unmute"69) in SSmobs.mob_list
		if(H)
			GLOB.ignore_health_alerts_from.Remove(H.name)
			for(var/z_level in GLOB.maps_data.station_levels)
				crew_repository.health_data(z_level, TRUE)
		return TOPIC_HANDLED

/datum/nano_module/crew_monitor/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/host_program = host
	var/tracking_tablet_used = (istype(host_program) && istype(host_program.computer, /obj/item/modular_computer/tablet/moebius))
	data69"can_mute"69 = tracking_tablet_used
	data69"can_track"69 = (isAI(user) || tracking_tablet_used)
	var/list/crewmembers = list()
	for(var/z_level in GLOB.maps_data.station_levels)
		crewmembers += crew_repository.health_data(z_level)
	crewmembers = sortNames(crewmembers)
	//now lets get problematic crewmembers in separate list so they could be shown first
	var/list/crewmembers_problematic = list()
	var/list/crewmembers_goodbois = list()

	for(var/i = 1, i <=crewmembers.len, i++)
		var/list/entry = crewmembers69i69
		if(!search || findtext(entry69"name"69,search))
			if(entry69"alert"69 || entry69"isCriminal"69)
				crewmembers_problematic += list(entry)
			else
				crewmembers_goodbois += list(entry)
	data69"crewmembers"69 = list()
	if(crewmembers_problematic.len)
		data69"crewmembers"69 += crewmembers_problematic
	if(crewmembers_goodbois.len)
		data69"crewmembers"69 += crewmembers_goodbois
	ddata = data
	crew = crewmembers_problematic
	data69"search"69 = search ? search : "Search"
	return data

/datum/nano_module/crew_monitor/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui =69ew(user, src, ui_key, "crew_monitor.tmpl", "Crew69onitoring Computer", 1050, 800, state = state)

		// adding a template with the key "mapContent" enables the69ap ui functionality
		ui.add_template("mapContent", "crew_monitor_map_content.tmpl")
		// adding a template with the key "mapHeader" replaces the69ap header content
		ui.add_template("mapHeader", "crew_monitor_map_header.tmpl")

		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
