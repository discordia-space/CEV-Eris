/datum/category_item/player_setup_item/player_global/pai
	name = "pAI"
	sort_order = 3

	var/datum/paiCandidate/candidate

/datum/category_item/player_setup_item/player_global/pai/load_preferences(var/savefile/S)
	if(!candidate)
		candidate = new()

	if(!preference_mob())
		return

	candidate.savefile_load(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/save_preferences(var/savefile/S)
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/content(var/mob/user)
	if(!candidate)
		candidate = new()

	. += "<b>pAI:</b><br>"
	if(!candidate)
		log_debug("69user69 pAI prefs have a null candidate69ar.")
		return .
	. += "Name: <a href='?src=\ref69src69;option=name'>69candidate.name ? candidate.name : "None Set"69</a><br>"
	. += "Description: <a href='?src=\ref69src69;option=desc'>69candidate.description ? TextPreview(candidate.description, 40) : "None Set"69</a><br>"
	. += "Role: <a href='?src=\ref69src69;option=role'>69candidate.role ? TextPreview(candidate.role, 40) : "None Set"69</a><br>"
	. += "OOC Comments: <a href='?src=\ref69src69;option=ooc'>69candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"69</a><br>"

/datum/category_item/player_setup_item/player_global/pai/OnTopic(var/href,var/list/href_list,69ar/mob/user)
	if(href_list69"option"69)
		var/t
		switch(href_list69"option"69)
			if("name")
				t = sanitizeName(input(user, "Enter a name for your pAI", "Global Preference", candidate.name) as text|null,69AX_NAME_LEN, 1)
				if(t && CanUseTopic(user))
					candidate.name = t
			if("desc")
				t = input(user, "Enter a description for your pAI", "Global Preference", html_decode(candidate.description)) as69essage|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.description = sanitize(t)
			if("role")
				t = input(user, "Enter a role for your pAI", "Global Preference", html_decode(candidate.role)) as text|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.role = sanitize(t)
			if("ooc")
				t = input(user, "Enter any OOC comments", "Global Preference", html_decode(candidate.comments)) as69essage
				if(!isnull(t) && CanUseTopic(user))
					candidate.comments = sanitize(t)
		return TOPIC_REFRESH

	return ..()
