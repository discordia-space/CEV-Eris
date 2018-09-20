//used for pref.alternate_option
#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2


#define JOB_LEVEL_NEVER  4
#define JOB_LEVEL_LOW    3
#define JOB_LEVEL_MEDIUM 2
#define JOB_LEVEL_HIGH 1


/datum/preferences
	//Since there can only be 1 high job.
	var/job_high = null
	var/list/job_medium        //List of all things selected for medium weight
	var/list/job_low           //List of all the things selected for low weight

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 2

/datum/category_item/player_setup_item/occupation
	name = "Occupation"
	sort_order = 1

/datum/category_item/player_setup_item/occupation/load_character(var/savefile/S)
	from_file(S["alternate_option"], 	pref.alternate_option)
	from_file(S["job_high"],			pref.job_high)
	from_file(S["job_medium"],			pref.job_medium)
	from_file(S["job_low"],				pref.job_low)
	//from_file(S["player_alt_titles"],	pref.player_alt_titles)

/datum/category_item/player_setup_item/occupation/save_character(var/savefile/S)
	to_file(S["alternate_option"],		pref.alternate_option)
	to_file(S["job_high"],				pref.job_high)
	to_file(S["job_medium"],			pref.job_medium)
	to_file(S["job_low"],				pref.job_low)
	//to_file(S["player_alt_titles"],		pref.player_alt_titles)

/datum/category_item/player_setup_item/occupation/sanitize_character()
	if(!istype(pref.job_medium)) 		pref.job_medium = list()
	if(!istype(pref.job_low))    		pref.job_low = list()

	pref.alternate_option	= sanitize_integer(pref.alternate_option, 0, 2, initial(pref.alternate_option))
	pref.job_high	        = sanitize(pref.job_high, null)
	if(pref.job_medium && pref.job_medium.len)
		for(var/i in 1 to pref.job_medium.len)
			pref.job_medium[i]  = sanitize(pref.job_medium[i])
	if(pref.job_low && pref.job_low.len)
		for(var/i in 1 to pref.job_low.len)
			pref.job_low[i]  = sanitize(pref.job_low[i])
	//if(!pref.player_alt_titles) pref.player_alt_titles = new()


/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 18, list/splitJobs = list("Moebius Biolab Officer"))
	. = list()
	. += "<tt><center>"
	. += "<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br>"
	. += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	. += "<table width='100%' cellpadding='1' cellspacing='0' style='color:black;'>"
	var/index = -1

	for(var/datum/job/job in SSjob.occupations)

		var/current_level = JOB_LEVEL_NEVER
		if(pref.job_high == job.title)
			current_level = JOB_LEVEL_HIGH
		else if(job.title in pref.job_medium)
			current_level = JOB_LEVEL_MEDIUM
		else if(job.title in pref.job_low)
			current_level = JOB_LEVEL_LOW

		index += 1
		if((index >= limit) || (job.title in splitJobs))
			. += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0' style='color:black;'>"
			index = 0

		. += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
		var/rank = job.title
		if(jobban_isbanned(user, rank))
			. += "<del>[rank]</del></td><td><b> \[BANNED]</b></td></tr>"
			continue
		if(("Assistant" in pref.job_low) && (rank != "Assistant"))
			. += "<font color=orange>[rank]</font></td><td></td></tr>"
			continue
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
			. += "<b>[rank]</b>"
		else
			. += "[rank]"

		. += "</td><td width='40%'>"

		if(rank == "Assistant")//Assistant is special
			if("Assistant" in pref.job_low)
				. += "<a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_NEVER]'>"
				. += " <font color=55cc55>\[Yes]</font>"
			else
				. += "<a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_LOW]'>"
				. += " <font color=black>\[No]</font>"
			. += "</a></td></tr>"
			continue

		var/nextJobLevel = current_level
		var/jobButtonColor = "black"
		var/jobButtonText = "bug"
		switch (current_level)
			if (JOB_LEVEL_HIGH)
				nextJobLevel = JOB_LEVEL_NEVER
				jobButtonColor = "55cc55"
				jobButtonText = "High"
			if (JOB_LEVEL_MEDIUM)
				nextJobLevel = JOB_LEVEL_HIGH
				jobButtonColor = "eecc22"
				jobButtonText = "Medium"
			if (JOB_LEVEL_LOW)
				nextJobLevel = JOB_LEVEL_MEDIUM
				jobButtonColor = "cc5555"
				jobButtonText = "Low"
			if (JOB_LEVEL_NEVER)
				nextJobLevel = JOB_LEVEL_LOW
				jobButtonColor = "black"
				jobButtonText = "NEVER"
		. += " <a href='?src=\ref[src];set_job=[rank];set_level=[nextJobLevel]'> <font color=[jobButtonColor]>[jobButtonText]</font>"

		. += "</a></td></tr>"

	. += "</td'></tr></table>"

	. += "</center></table><center>"

	switch(pref.alternate_option)
		if(GET_RANDOM_JOB)
			. += "<u><a href='?src=\ref[src];job_alternative=1'><font color=ca6cca>Get random job if preferences unavailable</font></a></u>"
		if(BE_ASSISTANT)
			. += "<u><a href='?src=\ref[src];job_alternative=1'><font color=red>Be assistant if preference unavailable</font></a></u>"
		if(RETURN_TO_LOBBY)
			. += "<u><a href='?src=\ref[src];job_alternative=1'><font color=purple>Return to lobby if preference unavailable</font></a></u>"

	. += "<a href='?src=\ref[src];reset_jobs=1'>\[Reset\]</a></center>"
	. += "</tt>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["reset_jobs"])
		ResetJobs()
		pref.req_update_icon = 1
		return TOPIC_REFRESH

	else if(href_list["job_alternative"])
		if(pref.alternate_option == GET_RANDOM_JOB || pref.alternate_option == BE_ASSISTANT)
			pref.alternate_option += 1
		else if(pref.alternate_option == RETURN_TO_LOBBY)
			pref.alternate_option = 0
		pref.req_update_icon = 1
		return TOPIC_REFRESH

	else if(href_list["set_job"] && href_list["set_level"])
		SetJob(user, href_list["set_job"], text2num(href_list["set_level"]))
		return TOPIC_REFRESH


	return ..()


/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role, level)
	var/datum/job/job = SSjob.GetJob(role)
	if(!job)
		return 0

	if(role == "Assistant")
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








/datum/category_item/player_setup_item/occupation/proc/ResetJobs()
	pref.job_high = null
	pref.job_medium = list()
	pref.job_low = list()




#undef JOB_LEVEL_NEVER
#undef JOB_LEVEL_LOW
#undef JOB_LEVEL_MEDIUM
#undef JOB_LEVEL_HIGH