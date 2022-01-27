/datum/objective/assassinate

/datum/objective/assassinate/get_panel_entry()
	var/target = src.target ? "69src.target.current.real_name69, the 69src.target.assigned_role69" : "no_target"
	return "Assassinate <a href='?src=\ref69src69;switch_target=1'>69target69</a>."

/datum/objective/assassinate/update_explanation()
	if(target && target.current)
		explanation_text = "Assassinate 69target.current.real_name69, the 69target.assigned_role69."
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
