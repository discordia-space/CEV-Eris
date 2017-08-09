/datum/objective/protect

/datum/objective/protect/get_panel_entry()
	var/target = src.target ? "[src.target.current.real_name], the [src.target.assigned_role]" : "no_target"
	return "Protect <a href='?src=\ref[src];switch_target=1'>[target]</a>."

/datum/objective/protect/update_exploration()
	if(target && target.current)
		explanation_text = "Protect [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Target has not arrived today. Hope he's alive."
	return target

/datum/objective/protect/check_completion()
	if(!target)
		return TRUE
	if(target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current))
			return FALSE
		return TRUE
	return FALSE
