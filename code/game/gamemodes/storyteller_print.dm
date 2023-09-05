/datum/storyteller/proc/declare_completion()
	var/text = ""
	if(GLOB.current_antags.len)
		var/list/antags_by_ids = list()
		text += "<br><font size=3><b>Round antagonists were:</b></font>"
		for(var/datum/antagonist/A in GLOB.current_antags)
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

	if(GLOB.current_factions.len)
		text += "<br><font size=3><b>Round factions were:</b></font>"
		for(var/datum/faction/F in GLOB.current_factions)
			text += F.print_success()


	var/surviving_total = 0
	var/ghosts = 0

	var/escaped_total = 0

	for(var/mob/M in GLOB.player_list)
		if(M.client)
			if(M.stat != DEAD)
				surviving_total++
				if(isOnAdminLevel(M))
					escaped_total++
			if(isghost(M))
				ghosts++
	text += "<br>"
	if(surviving_total > 0)
		text += "<br>There [surviving_total>1 ? "were <b>[surviving_total] survivors</b>" : "was <b>one survivor</b>"]"
		text += " (<b>[escaped_total>0 ? escaped_total : "none"] escaped</b>) and <b>[ghosts] ghosts</b>.<br>"
	else
		text += "There were <b>no survivors</b> (<b>[ghosts] ghosts</b>)."
	to_chat(world, text)



/datum/storyteller/proc/storyteller_panel()
	var/data = "<center><font size='3'><b>STORYTELLER PANEL</b></font></center>"

	data += "<b><a href='?src=\ref[src];panel=1'>\[UPDATE\]</a></b>"
	data += "<table><tr><td>"
	data += "[src.name] (<A href='?src=\ref[src];c_mode=1'>Change</A>)"
	data += "<br>Round duration: <b>[round(world.time / 36000)]:[add_zero(world.time / 600 % 60, 2)]:[world.time / 100 % 6][world.time / 100 % 10]</b>"
	data += "<br>Debug mode: <b><a href='?src=\ref[src];toggle_debug=1'>\[[debug_mode?"ON":"OFF"]\]</a></b>"
	data += "<br>One role per player: <b><a href='?src=\ref[src];toggle_orpp=1'>\[[one_role_per_player?"YES":"NO"]\]</a></b>"
	data += "<br>Chaos Level: <a href='?src=\ref[src];edit_chaos=1'>\[[GLOB.chaos_level]\]</a>"
	data += "</td><td style=\"padding-left: 40px\">"

	data += "Heads: [heads] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_heads=1'>\[EDIT\]</a>"
	data += "<br>Ironhammer: [sec] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_sec=1'>\[EDIT\]</a>"
	data += "<br>Technomancers: [eng] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_eng=1'>\[EDIT\]</a>"
	data += "<br>Medical: [med] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_med=1'>\[EDIT\]</a>"
	data += "<br>Science: [sci] "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_sci=1'>\[EDIT\]</a>"
	data += "<br>NT Disciples: [disciples.len] "
	data += "<br><b>Total: [crew]</b> "
	if(debug_mode)
		data += "<a href='?src=\ref[src];edit_crew=1'>\[EDIT\]</a>"

	data += "</td><td style=\"padding-left: 40px\">"

	data += "<b>Event Pool Points:</b>"
	data += "<br>Mundane: [round(points[EVENT_LEVEL_MUNDANE], 0.1)] / [POOL_THRESHOLD_MUNDANE]   <a href='?src=\ref[src];modify_points=[EVENT_LEVEL_MUNDANE]'>\[ADD\]</a>"
	data += "<br>Moderate: [round(points[EVENT_LEVEL_MODERATE], 0.1)] / [POOL_THRESHOLD_MODERATE]   <a href='?src=\ref[src];modify_points=[EVENT_LEVEL_MODERATE]'>\[ADD\]</a>"
	data += "<br>Major: [round(points[EVENT_LEVEL_MAJOR], 0.1)] / [POOL_THRESHOLD_MAJOR]   <a href='?src=\ref[src];modify_points=[EVENT_LEVEL_MAJOR]'>\[ADD\]</a>"
	data += "<br>Roleset: [round(points[EVENT_LEVEL_ROLESET], 0.1)] / [POOL_THRESHOLD_ROLESET]   <a href='?src=\ref[src];modify_points=[EVENT_LEVEL_ROLESET]'>\[ADD\]</a>"

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
	data += "<br><a href='?src=\ref[src];delay_round_end=1'>[SSticker.delay_end ? "End Round Normally" : "Delay Round End"]</a>"

	data += "<hr><b>Current antags:</b><div style=\"border:1px solid black;\"><ul>"

	if (GLOB.current_antags.len)
		for(var/datum/antagonist/A in GLOB.current_antags)
			var/act = "<font color=red>DEAD</font>"
			if(!A.is_dead())
				if(!A.is_active())
					act = "<font color=silver>AFK</font>"
				else
					act = "OK"



			data += "<li>[A.role_text] - [A.owner?(A.owner.name):"no owner"] ([act])<a href='?src=\ref[A];panel=1'>\[EDIT\]</a></li>"
	else
		data += "<b>There are no antagonists</b>"

	data += "</ul></div><hr>"
	data += "<br>Calculate weight: <b><a href='?src=\ref[src];toggle_weight_calc=1'>[calculate_weights?"\[AUTO\]":"\[MANUAL\]"]</a></b>"
	data += "<br><b>Events: <a href='?src=\ref[src];update_weights=1'>\[UPDATE WEIGHTS\]</a></b><div style=\"border:1px solid black;\">"


	//This complex block will print out all the events with various info
	var/severity = EVENT_LEVEL_MUNDANE
	for(var/list/L in list(event_pool_mundane, event_pool_moderate, event_pool_major, event_pool_roleset))
		data += "|[severity_to_string[severity]] events:"
		data += "|Points: [points[severity]]"
		data += "<ul>"
		for (var/datum/storyevent/S in L)
			data += "<li>[S.id] - weight: [L[S]] <a href='?src=\ref[src];event=[S.id];ev_calc_weight=1'>\[UPD\]</a>"
			if(!calculate_weights)
				data += "<a href='?src=\ref[src];event=[S.id];ev_set_weight=1'>\[SET\]</a>  "
			data += "<a href='?src=\ref[src];event=[S.id];ev_toggle=1'>\[[S.enabled?"ALLOWED":"FORBIDDEN"]\]</a>"
			data += "<a href='?src=\ref[src];event=[S.id];ev_debug=1'>\[VV\]</a>"
			data += "<b><a href='?src=\ref[src];event=[S.id];ev_spawn=1;severity=[severity]'>\[FORCE\]</a></b></li>"
			data += "</li>"
		data += "</ul>"
		data += "-------------------------<BR>"
		severity = get_next_severity(severity)

	data += "</div>"

	var/datum/browser/panel = new(usr, "story", "Story", 600, 600)
	panel.set_content(data)
	panel.open()

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

	if(href_list["edit_chaos"])
		GLOB.chaos_level = input("Enter new chaos level, only use values >=1.","Chaos Level",GLOB.chaos_level) as num

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
			return
		if (SSticker.current_state != GAME_STATE_PREGAME && SSticker.current_state != GAME_STATE_STARTUP)
			SSticker.delay_end = !SSticker.delay_end
			log_admin("[key_name(usr)] [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
			message_admins("\blue [key_name(usr)] [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"].", 1)
			return

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
				evt.enabled = !evt.enabled
				message_admins("Event \"[evt.id]\" was [evt.enabled?"allowed":"restricted"] to spawn by [key_name(usr)]")
				build_event_pools()
			if(href_list["ev_spawn"])
				//When in debug mode, we pass in the user.
					//If antag spawning fails, they will be spammed with text explaining why
				if (!evt.can_trigger(href_list["severity"], debug_mode? usr : null))
					var/answer = alert(usr, "\"[evt.id]\" is not allowed to trigger.\n\
					To find out why, turn on debug mode in the storyteller panel and try again. \n\
					You can also try to bypass the requirement and force it anyway, but this is unlikely to work\n \
					 Would you like to force it anyway?", "Force Event? ", "yes", "no")
					if (answer == "no")
						return

				var/result = evt.create(href_list["severity"])
				if (result)
					log_and_message_admins("Event \"[evt.id]\" was successfully force spawned by [key_name(usr)]")
				else
					log_and_message_admins("[key_name(usr)] failed to force spawn \"[evt.id]\".")
			if(href_list["ev_debug"] && usr && usr.client)
				usr.client.debug_variables(evt)
			if(href_list["ev_set_weight"])
				evt.weight_cache = input("Enter new weight.","Weight",evt.weight_cache) as num

	if(href_list["modify_points"])
		var/pooltype = href_list["modify_points"]
		var/add_points = input("Pool [pooltype] currently has [round(points[pooltype], 0.01)]. How many do you wish to add? Enter a negative value to subtract points","Altering Points",eng) as num
		modify_points(add_points, pooltype)

	storyteller_panel()

	//anything below is placed there so it triggers after the storytellerpanel updates.

	if(href_list["c_mode"])
		. = usr.client.holder.Topic(href, href_list)

/datum/storyteller/proc/topic_extra(href,href_list)
	return

