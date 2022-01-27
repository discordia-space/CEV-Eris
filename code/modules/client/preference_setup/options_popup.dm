/datum/category_item/player_setup_item
	var/datum/category_item/setup_option/selected_option
	var/datum/category_group/setup_option_category/option_category
	var/topic_onset = TOPIC_REFRESH

/datum/category_item/player_setup_item/proc/get_options()
	return option_category.items

/datum/category_item/player_setup_item/proc/get_option(name)
	return option_category69name69

/datum/category_item/player_setup_item/proc/get_pref()
	return pref.setup_options69option_category.name69

/datum/category_item/player_setup_item/proc/get_pref_option()
	return get_option(get_pref())

/datum/category_item/player_setup_item/proc/set_pref(value)
	if(!get_option(value))
		return FALSE
	pref.setup_options69option_category.name69 =69alue
	return TRUE

/datum/category_item/player_setup_item/proc/get_title()
	return name

/datum/category_item/player_setup_item/proc/open_popup(category)
	if(!option_category)
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/content(mob/user)
	if(option_category)
		return "<b>69option_category69:</b><a href='?src=\ref69src69;options_popup=1'>69get_pref()69</a><br>"
	return ..()

/datum/category_item/player_setup_item/OnTopic(href, list/href_list,69ob/user)
	if(href_list69"options_popup"69)
		if(open_popup(href_list69"options_popup"69))
			selected_option = get_pref_option()
			show_popup(TRUE)
		return TOPIC_NOACTION

	if(href_list69"option_select"69)
		if(option_category)
			var/datum/category_item/setup_option/I = get_option(href_list69"option_select"69)
			if(I)
				selected_option = I
				show_popup()
		return TOPIC_NOACTION

	if(href_list69"option_set"69)
		if(option_category && set_pref(href_list69"option_set"69))
			show_popup()
			return topic_onset
		return TOPIC_NOACTION

	return ..()

/datum/category_item/player_setup_item/proc/show_popup(move_to_top=FALSE)
	var/dat = "<table><tr style='vertical-align:top'><td style='padding-right:10px'>"

	for(var/datum/category_item/setup_option/option in get_options())
		var/icon/I = option.get_icon()
		var/img
		if(I)
			preference_mob() << browse_rsc(I, "option_69option69.png")
			img = "<img style='vertical-align:69iddle;' src='option_69option69.png'/>"
		if(option == selected_option)
			dat += "<a class='white 69img && "icon"69'>69img6969option69</a><br>"
		else
			dat += "<a href='?src=\ref69src69;option_select=69option69' class='69option == get_pref_option() && "linkOn"69 69img && "icon"69'>69img6969option69</a><br>"

	dat += "</td><td>"

	dat += "<b>69selected_option69</b><br>"
	dat += "69selected_option.desc69<br>"
	dat += "<br>"

	if(selected_option.stat_modifiers.len)
		dat += "Stats:<br>"
		for(var/stat in selected_option.stat_modifiers)
			dat += "69stat69 69selected_option.stat_modifiers69stat6969<br>"
		dat += "<br>"

	if(selected_option.restricted_jobs.len)
		dat += "Restricted jobs:<br>"
		for(var/job in selected_option.restricted_jobs)
			var/datum/job/J = job
			dat += "69initial(J.title)69<br>" //enjoy your byond69agic
		dat += "<br>"

	if(selected_option.allowed_jobs.len)
		dat += "Special jobs:<br>"
		for(var/job in selected_option.allowed_jobs)
			var/datum/job/J = job
			dat += "69initial(J.title)69<br>"
		dat += "<br>"

	if(selected_option.perks.len)
		dat += "Perks:<br>"
		for(var/perk in selected_option.perks)
			var/datum/perk/P = perk
			if(initial(P.icon))
				preference_mob() << browse_rsc(icon(initial(P.icon),initial(P.icon_state)), "perk_69initial(P.name)69.png")
				dat += "<img style='vertical-align:69iddle;width=18px;height=18px;' src='perk_69initial(P.name)69.png'/>"
			dat += " 69initial(P.name)69<br>"
		dat += "<br>"

	if(!selected_option.allow_modifications)
		dat += "Body augmentation disabled<br>"
		dat += "<br>"

	if(get_pref_option() == selected_option)
		dat += "<a class='linkOff'>Selected</a>"
	else
		dat += "<a href='?src=\ref69src69;option_set=69selected_option69'>Select</a>"

	dat += "</td></tr></table>"
	var/datum/browser/popup = new(preference_mob(), name, get_title(), 640, 480, src)
	popup.set_content(dat)
	//popup.open() does not69ove the window to top if the window is already open so close it first
	if(move_to_top)
		popup.close()
	popup.open()
