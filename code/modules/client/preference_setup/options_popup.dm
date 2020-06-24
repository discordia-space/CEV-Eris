/datum/category_item/player_setup_item
	var/datum/category_item/setup_option/selected_option
	var/datum/category_group/setup_option_category/option_category
	var/topic_onset = TOPIC_REFRESH

/datum/category_item/player_setup_item/proc/get_options()
	return option_category.items

/datum/category_item/player_setup_item/proc/get_option(name)
	return option_category[name]

/datum/category_item/player_setup_item/proc/get_pref()
	return pref.setup_options[option_category.name]

/datum/category_item/player_setup_item/proc/get_pref_option()
	return get_option(get_pref())

/datum/category_item/player_setup_item/proc/set_pref(value)
	if(!get_option(value))
		return FALSE
	pref.setup_options[option_category.name] = value
	return TRUE

/datum/category_item/player_setup_item/proc/get_title()
	return name

/datum/category_item/player_setup_item/proc/open_popup(category)
	if(!option_category)
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/content(mob/user)
	if(option_category)
		return "<b>[option_category]:</b><a href='?src=\ref[src];options_popup=1'>[get_pref()]</a><br>"
	return ..()

/datum/category_item/player_setup_item/OnTopic(href, list/href_list, mob/user)
	if(href_list["options_popup"])
		if(open_popup(href_list["options_popup"]))
			selected_option = get_pref_option()
			show_popup(TRUE)
		return TOPIC_NOACTION

	if(href_list["option_select"])
		if(option_category)
			var/datum/category_item/setup_option/I = get_option(href_list["option_select"])
			if(I)
				selected_option = I
				show_popup()
		return TOPIC_NOACTION

	if(href_list["option_set"])
		if(option_category && set_pref(href_list["option_set"]))
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
			preference_mob() << browse_rsc(I, "option_[option].png")
			img = "<img style='vertical-align: middle;' src='option_[option].png'/>"
		if(option == selected_option)
			dat += "<a class='white [img && "icon"]'>[img][option]</a><br>"
		else
			dat += "<a href='?src=\ref[src];option_select=[option]' class='[option == get_pref_option() && "linkOn"] [img && "icon"]'>[img][option]</a><br>"

	dat += "</td><td>"

	dat += "<b>[selected_option]</b><br>"
	dat += "[selected_option.desc]<br>"
	dat += "<br>"

	if(selected_option.stat_modifiers.len)
		dat += "Stats:<br>"
		for(var/stat in selected_option.stat_modifiers)
			dat += "[stat] [selected_option.stat_modifiers[stat]]<br>"
		dat += "<br>"

	if(selected_option.restricted_jobs.len)
		dat += "Restricted jobs:<br>"
		for(var/job in selected_option.restricted_jobs)
			var/datum/job/J = job
			dat += "[initial(J.title)]<br>" //enjoy your byond magic
		dat += "<br>"

	if(selected_option.allowed_jobs.len)
		dat += "Special jobs:<br>"
		for(var/job in selected_option.allowed_jobs)
			var/datum/job/J = job
			dat += "[initial(J.title)]<br>"
		dat += "<br>"

	if(selected_option.perks.len)
		dat += "Perks:<br>"
		for(var/perk in selected_option.perks)
			var/datum/perk/P = perk
			if(initial(P.icon))
				preference_mob() << browse_rsc(icon(initial(P.icon),initial(P.icon_state)), "perk_[initial(P.name)].png")
				dat += "<img style='vertical-align: middle;width=18px;height=18px;' src='perk_[initial(P.name)].png'/>"
			dat += " [initial(P.name)]<br>"
		dat += "<br>"

	if(!selected_option.allow_modifications)
		dat += "Body augmentation disabled<br>"
		dat += "<br>"

	if(get_pref_option() == selected_option)
		dat += "<a class='linkOff'>Selected</a>"
	else
		dat += "<a href='?src=\ref[src];option_set=[selected_option]'>Select</a>"

	dat += "</td></tr></table>"
	var/datum/browser/popup = new(preference_mob(), name, get_title(), 640, 480, src)
	popup.set_content(dat)
	//popup.open() does not move the window to top if the window is already open so close it first
	if(move_to_top)
		popup.close()
	popup.open()
