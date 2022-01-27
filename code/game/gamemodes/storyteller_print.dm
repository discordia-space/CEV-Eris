/datum/storyteller/proc/declare_completion()
	var/text = ""
	if(69LOB.current_anta69s.len)
		var/list/anta69s_by_ids = list()
		text += "<br><font size=3><b>Round anta69onists were:</b></font>"
		for(var/datum/anta69onist/A in 69LOB.current_anta69s)
			if(!A.faction)
				if(!islist(anta69s_by_ids69A.id69))
					anta69s_by_ids69A.id69 = list()
				anta69s_by_ids69A.id69 += A

		for(var/a_id in anta69s_by_ids)
			var/list/L = anta69s_by_ids69a_id69
			var/datum/anta69onist/fA = L69169
			text += "<br>"
			if(L.len > 1)
				text += "<br><b>The 69fA.role_text_plural69:</b>"
				for(var/datum/anta69onist/A in anta69s_by_ids69a_id69)
					text += A.print_success()
			else
				text += "<br><b>The 69fA.role_text69:</b>"
				text += fA.print_success()

	if(69LOB.current_factions.len)
		text += "<br><font size=3><b>Round factions were:</b></font>"
		for(var/datum/faction/F in 69LOB.current_factions)
			text += F.print_success()


	var/survivin69_total = 0
	var/69hosts = 0

	var/escaped_total = 0

	for(var/mob/M in 69LOB.player_list)
		if(M.client)
			if(M.stat != DEAD)
				survivin69_total++
				if(isOnAdminLevel(M))
					escaped_total++
			if(is69host(M))
				69hosts++
	text += "<br>"
	if(survivin69_total > 0)
		text += "<br>There 69survivin69_total>1 ? "were <b>69survivin69_total69 survivors</b>" : "was <b>one survivor</b>"69"
		text += " (<b>69escaped_total>0 ? escaped_total : "none"69 escaped</b>) and <b>6969hosts69 69hosts</b>.<br>"
	else
		text += "There were <b>no survivors</b> (<b>6969hosts69 69hosts</b>)."
	to_chat(world, text)



/datum/storyteller/proc/storyteller_panel()
	var/data = "<center><font size='3'><b>STORYTELLER PANEL</b></font></center>"

	data += "<b><a href='?src=\ref69src69;panel=1'>\69UPDATE\69</a></b>"
	data += "<table><tr><td>"
	data += "69src.name69 (<A href='?src=\ref69src69;c_mode=1'>Chan69e</A>)"
	data += "<br>Round duration: <b>69round(world.time / 36000)69:69add_zero(world.time / 600 % 60, 2)69:69world.time / 100 % 66969world.time / 100 % 1069</b>"
	data += "<br>Debu6969ode: <b><a href='?src=\ref69src69;to6969le_debu69=1'>\6969debu69_mode?"ON":"OFF"69\69</a></b>"
	data += "<br>One role per player: <b><a href='?src=\ref69src69;to6969le_orpp=1'>\6969one_role_per_player?"YES":"NO"69\69</a></b>"
	data += "</td><td style=\"paddin69-left: 40px\">"

	data += "Heads: 69heads69 "
	if(debu69_mode)
		data += "<a href='?src=\ref69src69;edit_heads=1'>\69EDIT\69</a>"
	data += "<br>Ironhammer: 69sec69 "
	if(debu69_mode)
		data += "<a href='?src=\ref69src69;edit_sec=1'>\69EDIT\69</a>"
	data += "<br>Technomancers: 69en6969 "
	if(debu69_mode)
		data += "<a href='?src=\ref69src69;edit_en69=1'>\69EDIT\69</a>"
	data += "<br>Medical: 69med69 "
	if(debu69_mode)
		data += "<a href='?src=\ref69src69;edit_med=1'>\69EDIT\69</a>"
	data += "<br>Science: 69sci69 "
	if(debu69_mode)
		data += "<a href='?src=\ref69src69;edit_sci=1'>\69EDIT\69</a>"
	data += "<br>NT Disciples: 69disciples.len69 "
	data += "<br><b>Total: 69crew69</b> "
	if(debu69_mode)
		data += "<a href='?src=\ref69src69;edit_crew=1'>\69EDIT\69</a>"

	data += "</td><td style=\"paddin69-left: 40px\">"

	data += "<b>Event Pool Points:</b>"
	data += "<br>Mundane: 69round(points69EVENT_LEVEL_MUNDANE69, 0.1)69 / 69POOL_THRESHOLD_MUNDANE69   <a href='?src=\ref69src69;modify_points=69EVENT_LEVEL_MUNDANE69'>\69ADD\69</a>"
	data += "<br>Moderate: 69round(points69EVENT_LEVEL_MODERATE69, 0.1)69 / 69POOL_THRESHOLD_MODERATE69   <a href='?src=\ref69src69;modify_points=69EVENT_LEVEL_MODERATE69'>\69ADD\69</a>"
	data += "<br>Major: 69round(points69EVENT_LEVEL_MAJOR69, 0.1)69 / 69POOL_THRESHOLD_MAJOR69   <a href='?src=\ref69src69;modify_points=69EVENT_LEVEL_MAJOR69'>\69ADD\69</a>"
	data += "<br>Roleset: 69round(points69EVENT_LEVEL_ROLESET69, 0.1)69 / 69POOL_THRESHOLD_ROLESET69   <a href='?src=\ref69src69;modify_points=69EVENT_LEVEL_ROLESET69'>\69ADD\69</a>"

	data += "</td></tr></table>"
	data += "<hr>"
	data += "<b>Settin69s:</b>"
	data += "69storyteller_panel_extra()69"
	data += "<hr>"
	data += "<b><a href='?src=\ref69src69;force_spawn=1'>\69FORCE ROLE SPAWN\69</a></b>"
	data += "<hr>"
	data += "<B>Evacuation</B>"
	if (!evacuation_controller.is_idle())
		data += "<a href='?src=\ref69src69;call_shuttle=1'>Call Evacuation</a><br>"
	else
		var/timeleft = evacuation_controller.69et_eta()
		if (evacuation_controller.waitin69_to_leave())
			data += "ETA: 69(timeleft / 60) % 6069:69add_zero(num2text(timeleft % 60), 2)69<BR>"
			data += "<a href='?src=\ref69src69;call_shuttle=2'>Send Back</a><br>"
	data += "<br><a href='?src=\ref69src69;delay_round_end=1'>69SSticker.delay_end ? "End Round Normally" : "Delay Round End"69</a>"

	data += "<hr><b>Current anta69s:</b><div style=\"border:1px solid black;\"><ul>"

	if (69LOB.current_anta69s.len)
		for(var/datum/anta69onist/A in 69LOB.current_anta69s)
			var/act = "<font color=red>DEAD</font>"
			if(!A.is_dead())
				if(!A.is_active())
					act = "<font color=silver>AFK</font>"
				else
					act = "OK"



			data += "<li>69A.role_text69 - 69A.owner?(A.owner.name):"no owner"69 (69act69)<a href='?src=\ref69A69;panel=1'>\69EDIT\69</a></li>"
	else
		data += "<b>There are no anta69onists</b>"

	data += "</ul></div><hr>"
	data += "<br>Calculate wei69ht: <b><a href='?src=\ref69src69;to6969le_wei69ht_calc=1'>69calculate_wei69hts?"\69AUTO\69":"\69MANUAL\69"69</a></b>"
	data += "<br><b>Events: <a href='?src=\ref69src69;update_wei69hts=1'>\69UPDATE WEI69HTS\69</a></b><div style=\"border:1px solid black;\">"


	//This complex block will print out all the events with69arious info
	var/severity = EVENT_LEVEL_MUNDANE
	for(var/list/L in list(event_pool_mundane, event_pool_moderate, event_pool_major, event_pool_roleset))
		data += "|69severity_to_strin6969severity6969 events:"
		data += "|Points: 69points69severity6969"
		data += "<ul>"
		for (var/datum/storyevent/S in L)
			data += "<li>69S.id69 - wei69ht: 69L69S6969 <a href='?src=\ref69src69;event=69S.id69;ev_calc_wei69ht=1'>\69UPD\69</a>"
			if(!calculate_wei69hts)
				data += "<a href='?src=\ref69src69;event=69S.id69;ev_set_wei69ht=1'>\69SET\69</a>  "
			data += "<a href='?src=\ref69src69;event=69S.id69;ev_to6969le=1'>\6969S.enabled?"ALLOWED":"FORBIDDEN"69\69</a>"
			data += "<a href='?src=\ref69src69;event=69S.id69;ev_debu69=1'>\69VV\69</a>"
			data += "<b><a href='?src=\ref69src69;event=69S.id69;ev_spawn=1;severity=69severity69'>\69FORCE\69</a></b></li>"
			data += "</li>"
		data += "</ul>"
		data += "-------------------------<BR>"
		severity = 69et_next_severity(severity)

	data += "</div>"

	usr << browse(data,"window=story;size=600x600")

/datum/storyteller/proc/storyteller_panel_extra()
	return ""

/datum/storyteller/Topic(href,href_list)
	if(!check_ri69hts(R_ADMIN))
		return

	if(href_list69"force_spawn"69)
		force_spawn_now = TRUE

	if(href_list69"to6969le_debu69"69)
		debu69_mode = !debu69_mode

	if(href_list69"edit_heads"69)
		heads = input("Enter new head crew count.","Debu69",heads) as num

	if(href_list69"edit_crew"69)
		crew = input("Enter new total crew count.","Debu69",crew) as num

	if(href_list69"edit_sec"69)
		sec = input("Enter new security crew count.","Debu69",sec) as num

	if(href_list69"edit_med"69)
		med = input("Enter new69edical crew count.","Debu69",med) as num

	if(href_list69"edit_en69"69)
		en69 = input("Enter new en69ineerin69 crew count.","Debu69",en69) as num

	if(href_list69"edit_sci"69)
		sci = input("Enter new science crew count.","Debu69",sci) as num

	if(href_list69"to6969le_wei69ht_calc"69)
		calculate_wei69hts = !calculate_wei69hts

	if(href_list69"update_wei69hts"69)
		for(var/datum/storyevent/R in storyevents)
			update_event_wei69ht(R)

	if(href_list69"edit_timer_t"69)
		var/time = input("Tick of next role spawn:","Storyteller time",event_spawn_timer) as num
		set_timer(time)

	if(href_list69"edit_timer"69)
		var/time = input("Time to next role spawn:","Storyteller time",(event_spawn_timer-world.time)/10) as num
		set_timer((time*10)+world.time)

	if(href_list69"to6969le_orpp"69)	//one role per player
		one_role_per_player = !one_role_per_player

	if(href_list69"call_shuttle"69)
		switch(href_list69"call_shuttle"69)
			if("1")
				if (evacuation_controller.call_evacuation(usr, TRUE))
					lo69_admin("69key_name(usr)69 started the evacuation")
					messa69e_admins("\blue 69key_name_admin(usr)69 started the evacuation", 1)
			if("2")
				if (evacuation_controller.call_evacuation(usr, TRUE))
					lo69_admin("69key_name(usr)69 started the evacuation")
					messa69e_admins("\blue 69key_name_admin(usr)69 started the evacuation", 1)

				else if (evacuation_controller.cancel_evacuation())
					lo69_admin("69key_name(usr)69 cancelled the evacuation")
					messa69e_admins("\blue 69key_name_admin(usr)69 cancelled the evacuation", 1)

	if(href_list69"delay_round_end"69)
		if(!check_ri69hts(R_SERVER))
			return
		if (SSticker.current_state != 69AME_STATE_PRE69AME && SSticker.current_state != 69AME_STATE_STARTUP)
			SSticker.delay_end = !SSticker.delay_end
			lo69_admin("69key_name(usr)69 69SSticker.delay_end ? "delayed the round end" : "has69ade the round end normally"69.")
			messa69e_admins("\blue 69key_name(usr)69 69SSticker.delay_end ? "delayed the round end" : "has69ade the round end normally"69.", 1)
			return

	topic_extra(href,href_list)

	if(href_list69"event"69)

		var/datum/storyevent/evt = null
		for(var/datum/storyevent/S in storyevents)
			if(S.id == href_list69"event"69)
				evt = S
				break
		if(evt)
			if(href_list69"ev_calc_wei69ht"69)
				update_event_wei69ht(evt)
			if(href_list69"ev_to6969le"69)
				evt.enabled = !evt.enabled
				messa69e_admins("Event \"69evt.id69\" was 69evt.enabled?"allowed":"restricted"69 to spawn by 69key_name(usr)69")
				build_event_pools()
			if(href_list69"ev_spawn"69)
				//When in debu6969ode, we pass in the user.
					//If anta69 spawnin69 fails, they will be spammed with text explainin69 why
				if (!evt.can_tri6969er(href_list69"severity"69, debu69_mode? usr : null))
					var/answer = alert(usr, "\"69evt.id69\" is not allowed to tri6969er.\n\
					To find out why, turn on debu6969ode in the storyteller panel and try a69ain. \n\
					You can also try to bypass the re69uirement and force it anyway, but this is unlikely to work\n \
					 Would you like to force it anyway?.", "Force Event? ", "yes", "no")
					if (answer == "no")
						return

				var/result = evt.create(href_list69"severity"69)
				if (result)
					messa69e_admins("Event \"69evt.id69\" was successfully force spawned by 69key_name(usr)69")
				else
					messa69e_admins("69key_name(usr)69 failed to force spawn \"69evt.id69\".")
			if(href_list69"ev_debu69"69 && usr && usr.client)
				usr.client.debu69_variables(evt)
			if(href_list69"ev_set_wei69ht"69)
				evt.wei69ht_cache = input("Enter new wei69ht.","Wei69ht",evt.wei69ht_cache) as num

	if(href_list69"modify_points"69)
		var/pooltype = href_list69"modify_points"69
		var/add_points = input("Pool 69pooltype69 currently has 69round(points69pooltype69, 0.01)69. How69any do you wish to add? Enter a ne69ative69alue to subtract points","Alterin69 Points",en69) as num
		modify_points(add_points, pooltype)

	storyteller_panel()

	//anythin69 below is placed there so it tri6969ers after the storytellerpanel updates.

	if(href_list69"c_mode"69)
		. = usr.client.holder.Topic(href, href_list)

/datum/storyteller/proc/topic_extra(href,href_list)
	return

