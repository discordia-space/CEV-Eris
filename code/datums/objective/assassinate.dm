/datum/objective/assassinate

/datum/objective/assassinate/get_panel_entry()
	var/target = src.target ? "[src.target.current.real_name], the [src.target.assigned_role]" : "no_target"
	return "Assassinate <a href='?src=\ref[src];switch_target=1'>[target]</a>."

/datum/objective/assassinate/update_explanation()
	if(target && target.current)
		explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Target has not arrived today. Is it a coincidence?"

/datum/objective/assassinate/check_completion()
	if (failed)
		return FALSE

	if(target && target.current)
		if(target.current.stat == DEAD || !ishuman(target.current))
			return TRUE
		return FALSE
	return TRUE
