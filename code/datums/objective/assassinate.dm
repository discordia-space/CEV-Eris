/datum/objective/assassinate

/datum/objective/assassinate/get_panel_entry()
	var/target = src.target ? "[src.target.current.real_name], the [src.target.assigned_role]" : "\[No target\]"
	return "Assassinate <a href='?src=\ref[src];switch_target=1'>[target]</a>."

/datum/objective/assassinate/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["switch_target"])
		select_human_target(usr)

/datum/objective/assassinate/update_exploration()
	if(target && target.current)
		explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Target has not arrived today. Did he know that I would come?"

/datum/objective/assassinate/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || !ishuman(target.current))
			return TRUE
		return FALSE
	return TRUE

