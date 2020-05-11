#define JOB_LEVEL_NEVER  4
#define JOB_LEVEL_LOW    3
#define JOB_LEVEL_MEDIUM 2
#define JOB_LEVEL_HIGH   1

/datum/preferences
	//Since there can only be 1 high job.
	var/job_high = null
	var/list/job_medium        //List of all things selected for medium weight
	var/list/job_low           //List of all the things selected for low weight
	var/list/player_alt_titles // the default name of a job like "Medical Doctor"

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 2

/datum/category_item/player_setup_item/occupation
	name = "Occupation"
	sort_order = 1
	//var/datum/browser/panel
	var/job_desc = "Press \[?\] button near job name to show description.<br><br><br><br><br><br>"			//text containing job description
	var/desc_set = FALSE
	var/job_icon_dir = SOUTH
	var/job_info_selected_rank

/datum/category_item/player_setup_item/occupation/load_character(var/savefile/S)
	from_file(S["alternate_option"], 	pref.alternate_option)
	from_file(S["job_high"],			pref.job_high)
	from_file(S["job_medium"],			pref.job_medium)
	from_file(S["job_low"],				pref.job_low)
	from_file(S["player_alt_titles"],	pref.player_alt_titles)

	//from_file(S["skills_saved"],		pref.skills_saved)

	//load_skills()

/datum/category_item/player_setup_item/occupation/save_character(var/savefile/S)
	//save_skills()

	to_file(S["alternate_option"],		pref.alternate_option)
	to_file(S["job_high"],				pref.job_high)
	to_file(S["job_medium"],			pref.job_medium)
	to_file(S["job_low"],				pref.job_low)
	to_file(S["player_alt_titles"],		pref.player_alt_titles)

	//to_file(S["skills_saved"],			pref.skills_saved)

/datum/category_item/player_setup_item/occupation/sanitize_character()
	if(!istype(pref.job_medium)) 		pref.job_medium = list()
	if(!istype(pref.job_low))    		pref.job_low = list()
	//if(!istype(pref.skills_saved))		pref.skills_saved = list()

	pref.alternate_option	= sanitize_integer(pref.alternate_option, 0, 2, initial(pref.alternate_option))
	pref.job_high	        = sanitize(pref.job_high, null)
	if(pref.job_medium && pref.job_medium.len)
		for(var/i in 1 to pref.job_medium.len)
			pref.job_medium[i]  = sanitize(pref.job_medium[i])
	if(pref.job_low && pref.job_low.len)
		for(var/i in 1 to pref.job_low.len)
			pref.job_low[i]  = sanitize(pref.job_low[i])
	if(!pref.player_alt_titles) pref.player_alt_titles = new()

	// We could have something like Captain set to high while on a non-rank map,
	// so we prune here to make sure we don't spawn as a PFC captain
	prune_occupation_prefs()

	//pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		//this proc also automatically computes and updates points_by_job

	var/jobs_by_type = decls_repository.get_decls(maps_data.allowed_jobs)
	for(var/job_type in jobs_by_type)
		var/datum/job/job = jobs_by_type[job_type]
		var/alt_title = pref.player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			pref.player_alt_titles -= job.title

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 16, list/splitJobs, splitLimit = 1)
	if(!SSjob)
		return


	. = list()
	. += "<style>.Points,a.Points{background: #cc5555;}</style>"
	//. += "<style>a.Points:hover{background: #55cc55;}</style>"

	. += "<tt><center>"

	//Attempts to set job description based on a high ranked or selected job
	if (!desc_set)
		create_job_description(user)
	. += "[job_desc]"
	. += "<b>Choose occupation chances.<br>Unavailable occupations are crossed out.</b>"
	. += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more columns.
	. += "<table width='100%' cellpadding='1' cellspacing='0'>"

	var/index = -1
	if(splitLimit)
		limit = round((SSjob.occupations.len+1)/2)

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob
	for(var/datum/job/job in SSjob.occupations)
		//var/unspent = pref.points_by_job[job]
		var/current_level = JOB_LEVEL_NEVER
		if(pref.job_high == job.title)
			current_level = JOB_LEVEL_HIGH
		else if(job.title in pref.job_medium)
			current_level = JOB_LEVEL_MEDIUM
		else if(job.title in pref.job_low)
			current_level = JOB_LEVEL_LOW

		index += 1
		if((index >= limit) || (job.title in splitJobs))
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i += 1)
					. += "<tr bgcolor='[lastJob.selection_color]'><td width='40%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
			. += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0


		. += "<tr bgcolor='[job.selection_color]'><td width='40%' align='right'>"
		var/rank = job.title
		lastJob = job
		. += "<a href='?src=\ref[src];job_info=[rank]'>\[?\]</a>"
		var/bad_message = ""
		if(job.total_positions == 0 && job.spawn_positions == 0)
			bad_message = "<b> \[UNAVAILABLE]</b>"
		else if(jobban_isbanned(user, rank))
			bad_message = "<b> \[BANNED]</b>"
		/*else if(!job.player_old_enough(user.client))
			var/available_in_days = job.available_in_days(user.client)
			bad_message = "\[IN [(available_in_days)] DAYS]"*/
		else if(job.minimum_character_age && user.client && (user.client.prefs.age < job.minimum_character_age))
			bad_message = "\[MINIMUM CHARACTER AGE: [job.minimum_character_age]]"
		else if(user.client && job.is_setup_restricted(user.client.prefs.setup_options))
			bad_message = "\[SETUP RESTRICTED]"

		if((ASSISTANT_TITLE in pref.job_low) && (rank != ASSISTANT_TITLE))
			. += "<a href='?src=\ref[src];set_skills=[rank]'><font color=grey>[rank]</font></a></td><td></td></tr>"
			continue
		if(bad_message)
			. += "<a href='?src=\ref[src];set_skills=[rank]'><del>[rank]</del></a></td><td><font color=black>[bad_message]</font></td></tr>"
			continue

		//. += (unspent && (current_level != JOB_LEVEL_NEVER) ? "<a class='Points' href='?src=\ref[src];set_skills=[rank]'>" : "<a href='?src=\ref[src];set_skills=[rank]'>")
		. += (current_level != JOB_LEVEL_NEVER ? "<a class='Points' href='?src=\ref[src];set_skills=[rank]'>" : "<a href='?src=\ref[src];set_skills=[rank]'>")
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
			. += "<b>[rank]</b>"
		else
			. += "[rank]"

		. += "</a></td><td width='40%'>"

		if(rank == ASSISTANT_TITLE)//Assistant is special
			. += "<a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_LOW]'>"
			. += "[(rank in pref.job_low) ? "<font color=#55cc55>" : ""]\[Yes\][(rank in pref.job_low) ? "</font>" : ""]"
			//. += "\[Yes\]"
			. += "</a>"
			. += "<a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_NEVER]'>"
			. += "[!(rank in pref.job_low) ? "<font color=black>" : ""]\[No\][!(rank in pref.job_low) ? "</font>" : ""]"
			. += "</a>"
		else
			. += " <a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_HIGH]'>[current_level == JOB_LEVEL_HIGH ? "<font color=55cc55>" : ""]\[High][current_level == JOB_LEVEL_HIGH ? "</font>" : ""]</a>"
			. += " <a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_MEDIUM]'>[current_level == JOB_LEVEL_MEDIUM ? "<font color=eecc22>" : ""]\[Medium][current_level == JOB_LEVEL_MEDIUM ? "</font>" : ""]</a>"
			. += " <a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_LOW]'>[current_level == JOB_LEVEL_LOW ? "<font color=cc5555>" : ""]\[Low][current_level == JOB_LEVEL_LOW ? "</font>" : ""]</a>"
			. += " <a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_NEVER]'>[current_level == JOB_LEVEL_NEVER ? "<font color=black>" : ""]\[NEVER][current_level == JOB_LEVEL_NEVER ? "</font>" : ""]</a>"

		if(job.alt_titles)
			. += "</td></tr><tr bgcolor='[lastJob.selection_color]'><td width='40%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
		. += "</td></tr>"
	. += "</td'></tr></table>"
	. += "</center></table><center>"

	switch(pref.alternate_option)
		if(GET_RANDOM_JOB)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Get random job if preferences unavailable</a></u>"
		if(BE_ASSISTANT)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Be assistant if preference unavailable</a></u>"
		if(RETURN_TO_LOBBY)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Return to lobby if preference unavailable</a></u>"

	. += "<a href='?src=\ref[src];reset_jobs=1'>\[Reset\]</a></center>"
	. += "</tt><br>"
	//. += "Jobs that <span class='Points'>look like this</span> have unspent skill points remaining."
	. = jointext(.,null)

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["reset_jobs"])
		ResetJobs()
		return TOPIC_REFRESH

	else if(href_list["job_alternative"])
		if(pref.alternate_option == GET_RANDOM_JOB || pref.alternate_option == BE_ASSISTANT)
			pref.alternate_option += 1
		else if(pref.alternate_option == RETURN_TO_LOBBY)
			pref.alternate_option = 0
		return TOPIC_REFRESH

	else if(href_list["select_alt_title"])
		var/datum/job/job = locate(href_list["select_alt_title"])
		if (job)
			var/choices = list(job.title) + job.alt_titles
			var/choice = input("Choose an title for [job.title].", "Choose Title", pref.GetPlayerAltTitle(job)) as anything in choices|null
			if(choice && CanUseTopic(user))
				SetPlayerAltTitle(job, choice)
				return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["set_job"] && href_list["set_level"])
		if(SetJob(user, href_list["set_job"], text2num(href_list["set_level"])))
			create_job_description(user)
			return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)
/*
	else if(href_list["set_skills"])
		var/rank = href_list["set_skills"]
		var/datum/job/job = SSjob.GetJob(rank)
		if(job)
			open_skill_setup(user, job)
*/
	//From the skills popup
	/*
	else if(href_list["hit_skill_button"])
		var/decl/hierarchy/skill/S = locate(href_list["hit_skill_button"])
		var/datum/job/J = locate(href_list["at_job"])
		if(!istype(J))
			return
		var/value = text2num(href_list["newvalue"])
		update_skill_value(J, S, value)
		pref.ShowChoices(user) //Manual refresh to allow us to focus the panel, not the main window.
		panel.set_content(generate_skill_content(J))
		panel.open()
		winset(user, panel.window_id, "focus=1") //Focuses the panel.

	else if(href_list["skillinfo"])
		var/decl/hierarchy/skill/S = locate(href_list["skillinfo"])
		if(!istype(S))
			return
		var/HTML = list()
		HTML += "<h2>[S.name]</h2>"
		HTML += "[S.desc]<br>"
		var/i
		for(i=SKILL_MIN, i <= SKILL_MAX, i++)
			var/level_name = S.levels[i]
			HTML +=	"<br><b>[level_name]</b>: [S.levels[level_name]]<br>"
		show_browser(user, jointext(HTML, null), "window=\ref[user]skillinfo")
	*/
	else if(href_list["job_info"])
		job_info_selected_rank = href_list["job_info"]
		create_job_description(user)
		return TOPIC_REFRESH

	else if(href_list["rotate"])
		if(href_list["rotate"] == "right")
			job_icon_dir = turn(job_icon_dir,-90)
		else
			job_icon_dir = turn(job_icon_dir,90)
		create_job_description(user)
		return TOPIC_REFRESH

	else if(href_list["job_wiki"])
		var/rank = href_list["job_wiki"]
		open_link(user,"[config.wikiurl][rank]_Eris[config.language]")

	return ..()



/datum/category_item/player_setup_item/occupation/proc/create_job_description(var/mob/user)
	var/datum/job/job
	//Which job will we show info for?

	//First of all, we check if the user has opted to query any specific job by clicking the ? button
	if(job_info_selected_rank)
		job = SSjob.GetJob(job_info_selected_rank)
	else if(ASSISTANT_TITLE in pref.job_low)
		job = SSjob.GetJob(ASSISTANT_TITLE)
	else
		//If not, then we'll attempt to get the job they have set as high priority, if any
		job = SSjob.GetJob(pref.job_high)

	if (!job)
		return

	desc_set = TRUE

	job_desc = "<div class = 'roleDescription' style = 'height:270px;'>"




	job_desc += "<table style='float:left;  table-layout: fixed;' cellpadding='0' cellspacing='0'>"

	//At the top of the table, there's a coloured stripe
	job_desc += "<tr><td colspan='2'><p style='margin-top: 0px;margin-bottom: 0px; background-color: [job.selection_color];'><br></td></tr>"



	job_desc += "<tr><td style='width: 220px;overflow: hidden;display: inline-block; white-space: nowrap;'>"
	//The mannequin and its buttons are in their own little mini table, within a fixed width 200px cell
	var/mob/living/carbon/human/dummy/mannequin/mannequin = job.get_job_mannequin()
	var/icon/job_icon = getFlatIcon(mannequin, job_icon_dir)
	job_icon.Scale(job_icon.Width() * 2.5, job_icon.Height() * 2.5)
	send_rsc(user, job_icon, "job_icon_[job_icon_dir].png")
	job_desc += "<table style='float:left; height = 270px; table-layout: fixed; vertical-align:top' cellpadding='0' cellspacing='0'><tr><td><img src=job_icon_[job_icon_dir].png width=220 height=220 style='float:left;'></td></tr>"
	job_desc += "<tr><td><center><a href='?src=\ref[src];rotate=right'>&lt;&lt;</a> <a href='?src=\ref[src];rotate=left'>&gt;&gt;</a></center></td></tr></table>"

	job_desc += "</td>"


	//Actual body of description starts here.
	//Width 100% needed otherwise a huge gap is left between this and the previous cell
	job_desc += "<td style = 'width: 100%;'>"

	//Capped at 240px height. I couldn't figure out how to set this height on the table row or cell.
	//It only works when set directly on this div
	job_desc += "<div style = 'overflow: auto;height: 240px;'>"

	//Header job title
	job_desc += "<h1 style='text-align: center; padding-top: 5px;padding-bottom: 0px;'>[job.title]</h1>"
	job_desc += "<hr>"

	//Here we have a right-floating textbox that shows user's stats
	job_desc +="<div style='border: 1px solid grey; float: right; margin-right: 20px; padding: 8px; line-height: 120%;'> <h1 style='padding: 0px;'>Stats:</h1>"
	if(job.title == ASSISTANT_TITLE)
		job_desc += "<ul>"
		for (var/a in ALL_STATS)
			job_desc += "<li>[a]: ???</li>"
		job_desc += "</ul>"
	else if (job.stat_modifiers.len)
		job_desc += "<ul>"
		for (var/a in job.stat_modifiers)
			job_desc += "<li>[a]: [job.stat_modifiers[a]]</li>"
		job_desc += "</ul>"
	else
		job_desc += "None"
	job_desc += "<h1 style='padding: 0px;'>Perks:</h1>"
	if (job.perks.len)
		job_desc += "<ul>"
		for (var/a in job.perks)
			var/datum/perk/P = a
			job_desc += "<li>[initial(P.name)]</li>"
		job_desc += "</ul>"
	else
		job_desc += "None"
	job_desc +="</div>"

	if(job.alt_titles)
		job_desc += "<i><b>Alternative titles:</b> [english_list(job.alt_titles)].</i>"
	if(job.department)
		job_desc += "<b>Department:</b> [job.department]. <br>"
		if(job.head_position)
			job_desc += "You are in charge of this department."
	job_desc += "<br>"
	job_desc += "You answer to <b>[job.supervisors]</b> normally."





	if(config.wikiurl)
		job_desc += "<a href='?src=\ref[src];job_info_selected_rank_wiki=[job_info_selected_rank]'>Open wiki page in browser</a>"
	var/description = job.get_description_blurb()
	/*if(job.required_education)
	description = "[description ? "[description]\n\n" : ""]"*/

	if(description)
		job_desc += description
	job_desc += "</div>"
	job_desc += "</td></tr></table></div>"


/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	pref.player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		pref.player_alt_titles[job.title] = new_title

/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role, level)
	var/datum/job/job = SSjob.GetJob(role)
	if(!job)
		return 0

	if(role == ASSISTANT_TITLE)
		if(level == JOB_LEVEL_NEVER)
			pref.job_low -= job.title
		else
			pref.job_low |= job.title
		return 1

	SetJobDepartment(job, level)

	return 1

/datum/category_item/player_setup_item/occupation/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0

	var/current_level = JOB_LEVEL_NEVER
	if(pref.job_high == job.title)
		current_level = JOB_LEVEL_HIGH
	else if(job.title in pref.job_medium)
		current_level = JOB_LEVEL_MEDIUM
	else if(job.title in pref.job_low)
		current_level = JOB_LEVEL_LOW

	switch(current_level)
		if(JOB_LEVEL_HIGH)
			pref.job_high = null
		if(JOB_LEVEL_MEDIUM)
			pref.job_medium -= job.title
		if(JOB_LEVEL_LOW)
			pref.job_low -= job.title

	switch(level)
		if(JOB_LEVEL_HIGH)
			if(pref.job_high)
				pref.job_medium |= pref.job_high
			pref.job_high = job.title
		if(JOB_LEVEL_MEDIUM)
			pref.job_medium |= job.title
		if(JOB_LEVEL_LOW)
			pref.job_low |= job.title

	return 1

/datum/preferences/proc/CorrectLevel(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(level)
		if(1)
			return job_high == job.title
		if(2)
			return !!(job.title in job_medium)
		if(3)
			return !!(job.title in job_low)
	return 0

/**
 *  Prune a player's job preferences based on current branch, rank and species
 *
 *  This proc goes through all the preferred jobs, and removes the ones incompatible with current rank or branch.
 */
/datum/category_item/player_setup_item/proc/prune_job_prefs()
	var/allowed_titles = list()
	var/jobs_by_type = decls_repository.get_decls(maps_data.allowed_jobs)
	for(var/job_type in jobs_by_type)
		var/datum/job/job = jobs_by_type[job_type]
		allowed_titles += job.title

		if(job.title == pref.job_high)
			if(job.is_restricted(pref))
				pref.job_high = null

		else if(job.title in pref.job_medium)
			if(job.is_restricted(pref))
				pref.job_medium.Remove(job.title)

		else if(job.title in pref.job_low)
			if(job.is_restricted(pref))
				pref.job_low.Remove(job.title)

	if(pref.job_high && !(pref.job_high in allowed_titles))
		pref.job_high = null

	for(var/job_title in pref.job_medium)
		if(!(job_title in allowed_titles))
			pref.job_medium -= job_title

	for(var/job_title in pref.job_low)
		if(!(job_title in allowed_titles))
			pref.job_low -= job_title

/datum/category_item/player_setup_item/proc/prune_occupation_prefs()
	/*
	var/datum/species/S = preference_species()
	if((GLOB.using_map.flags & MAP_HAS_BRANCH)\
	   && (!pref.char_branch || !mil_branches.is_spawn_branch(pref.char_branch, S)))
		pref.char_branch = "None"

	if((GLOB.using_map.flags & MAP_HAS_RANK)\
	   && (!pref.char_rank || !mil_branches.is_spawn_rank(pref.char_branch, pref.char_rank, S)))
		pref.char_rank = "None"
	*/

	prune_job_prefs()

/datum/category_item/player_setup_item/occupation/proc/ResetJobs()
	pref.job_high = null
	pref.job_medium = list()
	pref.job_low = list()

	pref.player_alt_titles.Cut()

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return (job.title in player_alt_titles) ? player_alt_titles[job.title] : job.title

#undef JOB_LEVEL_NEVER
#undef JOB_LEVEL_LOW
#undef JOB_LEVEL_MEDIUM
#undef JOB_LEVEL_HIGH