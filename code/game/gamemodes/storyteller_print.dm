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
					text += "  "+A.print_success()
			else
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

/datum/storyteller/proc/antagonist_report()
	return "Here might be storyteller antagonist report."

/datum/storyteller/proc/storyteller_panel()
	var/data = "<center><font size='3'><b>STORYTELLER PANEL v0.1</b></font></center>"
	data += "<br>Current storyteller: [src.name] ([src.config_tag])"
	data += "<br><br>Time to next role spawn: <a href='?src=\ref[src];edit_timer=1'>[(role_spawn_timer-world.time)/10]</a> <a href='?src=\ref[src];edit_timer_t=1'>\[as tick\]</a> s"
	data += "<br><b><a href='?src=\ref[src];force_spawn=1'>\[FORCE ROLE SPAWN\]</a></b>"
	data += "<br>Last spawn stage: [role_spawn_stage]."
	data += "<br>Current round weight: [get_round_weight()]"

	data += "<br><br>One role per player: <a href='?src=\ref[src];toggle_orpp=1'>[one_role_per_player?"Yes":"No"]</a>"

	data += "<br><br><b>Current antags:</b>"

	for(var/datum/antagonist/A in current_antags)
		if(!A.owner)
			data += "<br>   [A.role_text] - no owner <a href='?src=\ref[A];panel=1'>\[EDIT\]</a>"
		data += "<br>   [A.role_text] - [A.owner.name] <a href='?src=\ref[A];panel=1'>\[EDIT\]</a>"

	data += "<br>"

	data += "<br><br><a href='?src=\ref[src];panel=1'>UPDATE</a>"

	usr << browse(data,"window=story")

/datum/storyteller/Topic(href,href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list["force_spawn"])
		force_spawn_now = TRUE

	if(href_list["edit_timer_t"])
		var/time = input("Tick of next role spawn:","Storyteller time",role_spawn_timer) as num
		set_role_timer(time)

	if(href_list["edit_timer"])
		var/time = input("Time to next role spawn:","Storyteller time",(role_spawn_timer-world.time)/10) as num
		set_role_timer((time*10)+world.time)

	if(href_list["toggle_orpp"])	//one role per player
		one_role_per_player = !one_role_per_player

	storyteller_panel()



