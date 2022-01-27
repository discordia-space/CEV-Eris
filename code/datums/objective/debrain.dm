/datum/objective/debrain

/datum/objective/debrain/get_panel_entry()
	var/target = src.target ? "69src.target.current.real_name69, the 69src.target.assigned_role69" : "no_target"
	return "Steal the brain of <a href='?src=\ref69src69;switch_target=1'>69target69</a>."

/datum/objective/debrain/update_explanation()
	if(target && target.current)
		explanation_text = "Steal the brain of 69target.current.real_name69."
	else
		explanation_text = "Target has not arrived today. Did he know that I would come?"

/datum/objective/debrain/check_completion()
	if (failed)
		return FALSE
	if(!target) //If it's a free objective.
		return TRUE
	if(owner && (!owner.current || owner.current.stat == DEAD))//If you're otherwise dead.
		return FALSE
	if(!target.current || !isbrain(target.current))
		return FALSE
	var/atom/A = target.current
	var/list/contents = get_owner_inventory()
	if ((A in contents))
		return TRUE
	return FALSE
