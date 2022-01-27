/datum/objective/protect

/datum/objective/protect/get_panel_entry()
	var/target = src.target ? "69src.target.current.real_name69, the 69src.target.assigned_role69" : "no_target"
	return "Protect <a href='?src=\ref69src69;switch_target=1'>69target69</a>."

/datum/objective/protect/update_explanation()
	if(target && target.current)
		explanation_text = "Protect 69target.current.real_name69, the 69target.assigned_role69.69ake sure they survive"
	else
		explanation_text = "Target has not arrived today. Lets hope they are alive."

/datum/objective/protect/check_completion()
	if (failed)
		return FALSE
	if(!target)
		return TRUE
	if(target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current))
			return FALSE
		return TRUE
	return FALSE
