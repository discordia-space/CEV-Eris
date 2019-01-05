/datum/objective/protect

/datum/objective/protect/get_panel_entry()
	var/target = src.target ? "[src.target.current.real_name], the [src.target.assigned_role]" : "no_target"
	return "Protect <a href='?src=\ref[src];switch_target=1'>[target]</a>."

/datum/objective/protect/update_explanation()
	if(target && target.current)
		explanation_text = "Protect [target.current.real_name], the [target.assigned_role]. Make sure they survive"
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
