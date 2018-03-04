/datum/storyteller/proc/declare_completion()
	var/text = ""
	if(current_antags.len)
		var/list/antags_by_ids = list()
		text += "<br><font size=3><b>Round antagonists were:</b></font>"
		for(var/datum/antagonist/A in current_antags)
			if(!A.faction)
				if(!islist(antags_by_ids[A.id]))
					antags_by_ids[A.id] = list()
				antags_by_ids[A.id] += A

		for(var/a_id in antags_by_ids)
			var/list/L = antags_by_ids[a_id]
			var/datum/antagonist/fA = L[1]
			text += "<br>"
			if(L.len > 1)
				text += "<br><b>The [fA.role_text_plural]:</b>"
				for(var/datum/antagonist/A in antags_by_ids[a_id])
					text += A.print_success()
			else
				text += "<br><b>The [fA.role_text]:</b>"
				text += fA.print_success()

	if(current_factions.len)
		text += "<font size=3><b>Round factions were:</b></font>"
		for(var/datum/faction/F in current_factions)
			text += F.print_success()


	var/surviving_total = 0
	var/ghosts = 0

	var/escaped_total = 0


	var/list/area/escape_locations = list(
		/area/shuttle/escape_pod1/centcom,
		/area/shuttle/escape_pod2/centcom,
		/area/shuttle/escape_pod3/centcom,
		/area/shuttle/escape_pod5/centcom
		)

	for(var/mob/M in player_list)
		if(M.client)
			if(M.stat != DEAD)
				surviving_total++
				if(M.loc && M.loc.loc && M.loc.loc.type in escape_locations)
					escaped_total++
			if(isghost(M))
				ghosts++
	text += "<br>"
	if(surviving_total > 0)
		text += "<br>There [surviving_total>1 ? "were <b>[surviving_total] survivors</b>" : "was <b>one survivor</b>"]"
		text += " (<b>[escaped_total>0 ? escaped_total : "none"] escaped</b>) and <b>[ghosts] ghosts</b>.<br>"
	else
		text += "There were <b>no survivors</b> (<b>[ghosts] ghosts</b>)."
	world << text
/datum/storyteller/proc/storyteller_panel()
	var/data = "<center><font size='3'><b>STORYTELLER PANEL</b></font></center>"

	data += "<b><a href='?src=\ref[src];panel=1'>\[UPDATE\]</a></b>"
	data += "<table><tr><td>"
	data += "[src.name] ([src.config_tag])"
	data += "<br>Round duration: <b>[round(world.time / 36000)]:[add_zero(world.time / 600 % 60, 2)]:[world.time / 100 % 6][world.time / 100 % 10]</b>"
	data += "<br>Time to next event: <b><a href='?src=\ref[src];edit_timer=1'>[(event_spawn_timer-world.time)/10]</a></b> s"
	data += "<br>Last spawn stage: <b>[event_spawn_stage]</b>"
	data += "<br>Debug mode: <b><a href='?src=\ref[src];toggle_debug=1'>\[[debug_mode?"ON":"OFF"]\]</a></b>"
	data += "<br>One role per player: <b><a href='?src=\ref[src];toggle_orpp=1'>\[[one_role_per_player?"YES":"NO"]\]</a></b>"
	data += "</td><td style=\"padding-left: 40px\">"

	data += "Heads: [heads] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_heads=1'>\[EDIT\]</a>"
	data += "<br>Security: [sec] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_sec=1'>\[EDIT\]</a>"
	data += "<br>Engineering: [eng] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_eng=1'>\[EDIT\]</a>"
	data += "<br>Medical: [med] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_med=1'>\[EDIT\]</a>"
	data += "<br>Science: [sci] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_sci=1'>\[EDIT\]</a>"
	data += "<br><b>Total: [crew]</b> "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_crew=1'>\[EDIT\]</a>"

	data += "</td></tr></table>"
	data += "<hr>"
	data += "<b>Settings:</b>"
	data += "[storyteller_panel_extra()]"
	data += "<hr>"
	data += "<b><a href='?src=\ref[src];force_spawn=1'>\[FORCE ROLE SPAWN\]</a></b>"
	data += "<hr>"
	data += "<B>Evacuation</B>"
	if (!evacuation_controller.is_idle())
		data += "<a href='?src=\ref[src];call_shuttle=1'>Call Evacuation</a><br>"
	else
		var/timeleft = evacuation_controller.get_eta()
		if (evacuation_controller.waiting_to_leave())
			data += "ETA: [(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]<BR>"
			data += "<a href='?src=\ref[src];call_shuttle=2'>Send Back</a><br>"
	data += "<br><a href='?src=\ref[src];delay_round_end=1'>[ticker.delay_end ? "End Round Normally" : "Delay Round End"]</a>"

	data += "<hr><b>Current antags:</b><div style=\"border:1px solid black;\"><ul>"

	for(var/datum/antagonist/A in current_antags)
		var/act = "<font color=red>DEAD</font>"
		if(!A.is_dead())
			if(!A.is_active())
				act = "<font color=silver>AFK</font>"
			else
				act = "OK"

		data += "<li>[A.role_text] - [A.owner?(A.owner.name):"no owner"] ([act])<a href='?src=\ref[A];panel=1'>\[EDIT\]</a></li>"

	data += "</ul></div><hr>"
	data += "<br>Calculate weight: <b><a href='?src=\ref[src];toggle_weight_calc=1'>[calculate_weights?"\[AUTO\]":"\[MANUAL\]"]</a></b>"
	data += "<br><b>Events: <a href='?src=\ref[src];update_weights=1'>\[UPDATE WEIGHTS\]</a></b><div style=\"border:1px solid black;\"><ul>"

	for(var/datum/storyevent/S in storyevents)
		data += "<li>[S.id] - weight: [S.weight_cache] <a href='?src=\ref[src];event=[S.id];ev_calc_weight=1'>\[UPD\]</a>"
		if(!calculate_weights)
			data += "<a href='?src=\ref[src];event=[S.id];ev_set_weight=1'>\[SET\]</a>  "
		data += "<a href='?src=\ref[src];event=[S.id];ev_toggle=1'>\[[S.spawnable?"SPAWN":"NO"]\]</a>"
		data += "<a href='?src=\ref[src];event=[S.id];ev_debug=1'>\[VV\]</a>"
		data += "<b><a href='?src=\ref[src];event=[S.id];ev_spawn=1'>\[SPAWN\]</a></b></li>"
		data += "</li>"

	data += "</ul></div>"

	usr << browse(data,"window=story")

/datum/storyteller/proc/storyteller_panel_extra()
	return ""

/datum/storyteller/Topic(href,href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list["force_spawn"])
		force_spawn_now = TRUE

	if(href_list["toggle_debug"])
		debug_mode = !debug_mode

	if(href_list["edit_heads"])
		heads = input("Enter new head crew count.","Debug",heads) as num

	if(href_list["edit_crew"])
		crew = input("Enter new total crew count.","Debug",crew) as num

	if(href_list["edit_sec"])
		sec = input("Enter new security crew count.","Debug",sec) as num

	if(href_list["edit_med"])
		med = input("Enter new medical crew count.","Debug",med) as num

	if(href_list["edit_eng"])
		eng = input("Enter new engineering crew count.","Debug",eng) as num

	if(href_list["edit_sci"])
		sci = input("Enter new science crew count.","Debug",sci) as num

	if(href_list["toggle_weight_calc"])
		calculate_weights = !calculate_weights

	if(href_list["update_weights"])
		for(var/datum/storyevent/R in storyevents)
			update_event_weight(R)

	if(href_list["edit_timer_t"])
		var/time = input("Tick of next role spawn:","Storyteller time",event_spawn_timer) as num
		set_timer(time)

	if(href_list["edit_timer"])
		var/time = input("Time to next role spawn:","Storyteller time",(event_spawn_timer-world.time)/10) as num
		set_timer((time*10)+world.time)

	if(href_list["toggle_orpp"])	//one role per player
		one_role_per_player = !one_role_per_player

	if(href_list["call_shuttle"])
		switch(href_list["call_shuttle"])
			if("1")
				if (evacuation_controller.call_evacuation(usr, TRUE))
					log_admin("[key_name(usr)] started the evacuation")
					message_admins("\blue [key_name_admin(usr)] started the evacuation", 1)
			if("2")
				if (evacuation_controller.call_evacuation(usr, TRUE))
					log_admin("[key_name(usr)] started the evacuation")
					message_admins("\blue [key_name_admin(usr)] started the evacuation", 1)

				else if (evacuation_controller.cancel_evacuation())
					log_admin("[key_name(usr)] cancelled the evacuation")
					message_admins("\blue [key_name_admin(usr)] cancelled the evacuation", 1)

	if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER))
			ticker.delay_end = !ticker.delay_end
			log_admin("[key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
			message_admins("\blue [key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].", 1)

	topic_extra(href,href_list)

	if(href_list["event"])
		var/datum/storyevent/evt = null
		for(var/datum/storyevent/S in storyevents)
			if(S.id == href_list["event"])
				evt = S
				break
		if(evt)
			if(href_list["ev_calc_weight"])
				update_event_weight(evt)
			if(href_list["ev_toggle"])
				evt.spawnable = !evt.spawnable
				message_admins("[evt.id] was [evt.spawnable?"allowed":"restricted"] to spawn by [key_name(usr)]")
			if(href_list["ev_spawn"])
				evt.create()
				message_admins("[evt.id] was force spawned by [key_name(usr)]")
			if(href_list["ev_debug"] && usr && usr.client)
				usr.client.debug_variables(evt)
			if(href_list["ev_set_weight"])
				evt.weight_cache = input("Enter new weight.","Weight",evt.weight_cache) as num


	storyteller_panel()

/datum/storyteller/proc/topic_extra(href,href_list)
	return

