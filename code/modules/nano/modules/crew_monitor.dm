/datum/nano_module/crew_monitor
	name = "Crew69onitor"

/datum/nano_module/crew_monitor/Topic(href, href_list)
	if(..())
		return 1
	// TODO: Allow setting any config.contact_levels from the interface.
	if(!isOnPlayerLevel(nano_host()))
		usr << "<span class='warning'>Unable to establish a connection</span>: You're too far away from the station!"
		return 0
	if(href_list69"track"69)
		if(isAI(usr))
			var/mob/living/silicon/ai/AI = usr
			var/mob/living/carbon/human/H = locate(href_list69"track"69) in SSmobs.mob_list
			if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
				AI.ai_actual_track(H)
		return 1

/datum/nano_module/crew_monitor/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/list/data = host.initial_data()
	var/turf/T = get_turf(nano_host())

	data69"isAI"69 = isAI(user)
	data69"crewmembers"69 = crew_repository.health_data(T)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui =69ew(user, src, ui_key, "crew_monitor.tmpl", "Crew69onitoring Computer", 900, 800, state = state)

		// adding a template with the key "mapContent" enables the69ap ui functionality
		ui.add_template("mapContent", "crew_monitor_map_content.tmpl")
		// adding a template with the key "mapHeader" replaces the69ap header content
		ui.add_template("mapHeader", "crew_monitor_map_header.tmpl")

		ui.set_initial_data(data)
		ui.open()

		// should69ake the UI auto-update; doesn't seem to?
		ui.set_auto_update(1)
