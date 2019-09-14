/datum/preferences
	var/list/background

//Named origin because /datum/category_item/player_setup_item/background/background looks awful
/datum/category_item/player_setup_item/background/origin
	name = "Background"
	sort_order = 6
	var/current_category = ""
	var/selected_name = ""

/datum/category_item/player_setup_item/background/origin/load_character(var/savefile/S)
	from_file(S["background"], pref.background)

/datum/category_item/player_setup_item/background/origin/save_character(var/savefile/S)
	to_file(S["background"], pref.background)

/datum/category_item/player_setup_item/background/origin/content(var/mob/user)
	. = list()
	. += "<b>Background</b><br>"
	for(var/bg in all_backgrounds)
		. += "[bg]: <a href='?src=\ref[src];open=[bg]'>[pref.background[bg]]</a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/origin/sanitize_character()
	if(!islist(pref.background))
		pref.background = list()
	else
		for(var/bg in pref.background)
			if(!(bg in all_backgrounds))
				pref.background.Remove(bg)
				continue
	for(var/bg in all_backgrounds)
		if(!pref.background[bg] || !(pref.background[bg] in all_backgrounds[bg]))
			pref.background[bg] = "None"

/datum/category_item/player_setup_item/background/origin/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["open"])
		if(all_backgrounds[href_list["open"]])
			current_category = href_list["open"]
			selected_name = pref.background[current_category]
			show_popup(TRUE)
		return TOPIC_NOACTION

	if(href_list["select"])
		if(all_backgrounds[current_category][href_list["select"]])
			selected_name = href_list["select"]
			show_popup()
		return TOPIC_NOACTION

	if(href_list["background"])
		if(all_backgrounds[current_category][href_list["background"]])
			pref.background[current_category] = href_list["background"]
			show_popup()
			return TOPIC_REFRESH
		return TOPIC_NOACTION

	. =  ..()

/datum/category_item/player_setup_item/background/origin/proc/show_popup(move_to_top=FALSE)
	var/datum/background/selected_background = all_backgrounds[current_category][selected_name]
	var/dat = "<table>"

	dat += "<tr style='vertical-align:top'><td style='padding-right:10px'>"

	for(var/bg in all_backgrounds[current_category])
		if(bg == selected_name)
			dat += "<a class='white'>[bg]</a><br>"
		else
			dat += "<a href='?src=\ref[src];select=[bg]' [bg == pref.background[current_category] ? "class='linkOn'" : null]>[bg]</a><br>"

	dat += "</td><td>"

	dat += "<b>[selected_name]</b><br>"
	dat += "[selected_background.desc]<br>"
	dat += "<br>"

	if(selected_background.stat_modifiers.len)
		dat += "Stats:<br>"
		for(var/stat in selected_background.stat_modifiers)
			dat += "[stat] [selected_background.stat_modifiers[stat]]<br>"
		dat += "<br>"

	if(selected_background.restricted_jobs.len)
		dat += "Restricted jobs:<br>"
		for(var/job in selected_background.restricted_jobs)
			var/datum/job/J = job
			dat += "[initial(J.title)]<br>" //enjoy your byond magic
		dat += "<br>"

	if(selected_background.allowed_jobs.len)
		dat += "Special jobs:<br>"
		for(var/job in selected_background.allowed_jobs)
			var/datum/job/J = job
			dat += "[initial(J.title)]<br>"
		dat += "<br>"

	if(selected_background.perks.len)
		dat += "Perks:<br>"
		for(var/perk in selected_background.perks)
			var/datum/perk/P = perk
			dat += "[initial(P.name)]<br>"
		dat += "<br>"

	if(pref.background[current_category] == selected_name)
		dat += "<a class='linkOff'>Selected</a>"
	else
		dat += "<a href='?src=\ref[src];background=[selected_name]'>Select</a>"

	dat += "</td></tr></table>"
	var/datum/browser/popup = new(preference_mob(), "Background Setup","Background Setup: [current_category]", 640, 480, src)
	popup.set_content(dat)
	//popup.open() does not move the window to top if the window is already open so close it first
	if(move_to_top)
		popup.close()
	popup.open()
